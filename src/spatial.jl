"""
    match_points_to_streets(points_geo::GeoTable, streets_geo::GeoTable)::DataFrame

Match crime incidents, arrests, or places to their nearest street segments using
K-nearest neighbors spatial matching.

This function implements the spatial matching methodology described in the Methods
section of the paper. As noted, crimes are pre-geocoded by NYC to street segment
centers, so the nearest street should be the intended street. The use of Manhattan
distance (CityBlock) is appropriate given Manhattan's grid layout.

The matching process is critical for aggregating crimes and facilities to street
segments, which serves as the unit of analysis following crime and place literature
(Weisburd et al., 2012; Bernasco and Steenbeek, 2017).

Arguments:

  - points_geo: GeoTable containing point geometries (crimes or places)
  - streets_geo: GeoTable containing street segment line geometries

Returns:

  - DataFrame: Matched data with columns:

      + All original point data columns
      + street_id: Matched street segment identifier
      + street_name: Human-readable street name
      + distance_to_street: Distance in meters for quality assessment

Notes:

  - Uses KDTree with CityBlock distance for efficient matching in Manhattan grid
  - Distance is converted from degrees to approximate meters (111,320m per degree)
  - Average matching distance is logged for quality control
"""
function match_points_to_streets(points_geo::GeoTable, streets_geo::GeoTable)::DataFrame
    @info "Matching $(nrow(points_geo)) points to $(nrow(streets_geo)) streets..."

    # Convert point geometries to coordinates
    point_coords = [coords(geom) for geom in points_geo.geometry]

    # For streets, use centroid of each segment for matching
    street_centroids = [coords(centroid(geom)) for geom in streets_geo.geometry]

    # Build spatial index for efficient nearest neighbor search
    # Convert to [lon, lat] format expected by NearestNeighbors.jl
    street_points = [[ustrip(c.lon), ustrip(c.lat)] for c in street_centroids]
    tree = KDTree(reduce(hcat, street_points), Cityblock())

    # Prepare output DataFrame
    points_df = DataFrame(points_geo)
    streets_df = DataFrame(streets_geo)

    matched_data = DataFrame()

    @info "Performing spatial matching..."

    for (i, point_coord) in enumerate(point_coords)
        # Convert point to search format
        query_point = [ustrip(point_coord.lon), ustrip(point_coord.lat)]

        # Find nearest street
        nearest_idx, distance_squared = nn(tree, query_point)
        distance_meters = sqrt(distance_squared) * 111320  # Approximate conversion to meters

        # Get original point data
        point_row = points_df[i, :]

        # Get matched street data
        street_row = streets_df[nearest_idx, :]

        # Create combined row
        matched_row = copy(point_row)
        matched_row[!, :street_id] = street_row.street_id
        matched_row[!, :street_name] = street_row.street_name
        matched_row[!, :distance_to_street] = distance_meters

        # Add to results
        push!(matched_data, matched_row)
    end

    @info "Successfully matched $(nrow(matched_data)) points to streets"
    @info "Average distance to street: $(round(mean(matched_data[!, :distance_to_street]), digits=1)) meters"

    return matched_data
end

"""
    calculate_street_centroids(streets_geo::GeoTable)::Vector{<:Geometry}

Calculate geometric centroids for all street segments.

This utility function computes the center point of each street segment, which is
used for spatial matching operations. The centroids approximate the street segment
locations for distance calculations.

Arguments:

  - streets_geo: GeoTable containing street segment line geometries

Returns:

  - Vector of Point geometries representing street segment centroids
"""
function calculate_street_centroids(streets_geo::GeoTable)::Vector{<:Geometry}
    @info "Calculating centroids for $(nrow(streets_geo)) street segments..."

    centroids = [centroid(geom) for geom in streets_geo.geometry]

    @info "Calculated $(length(centroids)) street centroids"
    return centroids
end

"""
    calculate_street_lengths(streets_geo::GeoTable)::Dict{Any, Float64}

Calculate the length of each street segment in meters.

Arguments:

  - streets_geo: GeoTable containing street segment line geometries

Returns:

  - Dict: Dictionary mapping street_id to length in meters

The function calculates the geodesic length of each street segment,
which is important for normalizing place counts by street size.
"""
function calculate_street_lengths(streets_geo::GeoTable)::Dict{Any, Float64}
    @info "Calculating lengths for $(nrow(streets_geo)) street segments..."

    street_lengths = Dict{Any, Float64}()
    streets_df = DataFrame(streets_geo)

    for (i, row) in enumerate(eachrow(streets_df))
        street_id = row.street_id
        geom = streets_geo.geometry[i]

        # Calculate length based on geometry type
        try
            # Get coordinates of the line string
            line_coords = coords.(vertices(geom))

            # Calculate total length by summing distances between consecutive points
            total_length = 0.0
            for j = 2:length(line_coords)
                # Extract coordinates
                p1 = line_coords[j - 1]
                p2 = line_coords[j]

                # Calculate distance using Haversine formula (approximate)
                lat1, lon1 = ustrip(p1.lat), ustrip(p1.lon)
                lat2, lon2 = ustrip(p2.lat), ustrip(p2.lon)

                # Simplified distance calculation in meters
                dlat = lat2 - lat1
                dlon = lon2 - lon1

                # Approximate conversion to meters (good enough for Manhattan's small area)
                lat_meters = dlat * 111320.0
                lon_meters = dlon * 111320.0 * cos(deg2rad((lat1 + lat2) / 2))

                segment_length = sqrt(lat_meters^2 + lon_meters^2)
                total_length += segment_length
            end

            street_lengths[street_id] = total_length

        catch e
            @warn "Could not calculate length for street $street_id: $e"
            street_lengths[street_id] = 0.0
        end
    end

    # Log summary statistics
    lengths_array = collect(values(street_lengths))
    valid_lengths = filter(x -> x > 0, lengths_array)

    if !isempty(valid_lengths)
        @info "Street length statistics:"
        @info "  Mean: $(round(mean(valid_lengths), digits=1)) meters"
        @info "  Median: $(round(median(valid_lengths), digits=1)) meters"
        @info "  Min: $(round(minimum(valid_lengths), digits=1)) meters"
        @info "  Max: $(round(maximum(valid_lengths), digits=1)) meters"
        @info "  Streets with valid lengths: $(length(valid_lengths))/$(length(lengths_array))"
    end

    return street_lengths
end

"""
    filter_points_by_distance(matched_data::DataFrame, max_distance_meters::Real = 10)::DataFrame

Filter matched points to remove poor matches and intersection crimes.

This function implements the intersection filtering described in the Methods section.
As noted in the paper, crimes at intersections are dropped following prior research
(Bernasco and Steenbeek, 2017; Weisburd et al., 2012) because it's difficult to
attribute intersection crimes to specific street segments.

The default 10-meter threshold removes intersection crimes (which are geocoded to
intersection centers) while retaining validly matched street segment crimes. The
paper reports an average distance of 0.11 feet for properly matched crimes.

Arguments:

  - matched_data: DataFrame with matched points and distance_to_street column
  - max_distance_meters: Maximum allowable distance (default: 10m)

Returns:

  - DataFrame: Filtered data excluding points beyond the distance threshold

Impact:

  - Removes intersection crimes as per methodological requirements
  - Ensures spatial precision for crime concentration analysis
  - Maintains data quality for logistic regression models
"""
function filter_points_by_distance(
    matched_data::DataFrame, max_distance_meters::Real = 10
)::DataFrame
    initial_count = nrow(matched_data)

    filtered_data = filter(
        row -> row[!, :distance_to_street] <= max_distance_meters, matched_data
    )

    removed_count = initial_count - nrow(filtered_data)

    @info "Filtered points by distance (≤ $(max_distance_meters)m): kept $(nrow(filtered_data)), removed $(removed_count)"

    return filtered_data
end

"""
    calculate_spatial_statistics(matched_data::DataFrame)::Dict{Symbol, Any}

Calculate comprehensive spatial matching quality statistics.

This function generates quality metrics for the spatial matching process, which is
essential for validating the methodology described in the paper. The statistics
help verify that the matching achieves the required precision for analyzing crime
concentration at the micro-place level.

The paper emphasizes the importance of precise spatial matching given the small
geographic scale of street segments and the need to accurately attribute crimes
and facilities to specific segments for the logistic regression analysis.

Arguments:

  - matched_data: DataFrame with matched points and distance_to_street column

Returns:

  - Dict with statistics:

      + total_points: Number of matched points
      + mean_distance: Average matching distance in meters
      + median_distance: Median matching distance in meters
      + std_distance: Standard deviation of distances
      + min_distance: Minimum observed distance
      + max_distance: Maximum observed distance
      + points_within_50m: Count of well-matched points
      + points_within_100m: Count of reasonably matched points
      + points_within_200m: Count of loosely matched points

Quality Indicators:

  - Low mean/median distance indicates good geocoding quality
  - High percentage within 50m suggests accurate street assignment
  - Statistics are logged for methodological transparency
"""
function calculate_spatial_statistics(
    matched_data::DataFrame, dataset_name::String
)::Dict{Symbol, Any}
    @info "Calculating spatial statistics for $dataset_name..."

    distances = matched_data[!, :distance_to_street]

    stats = Dict(
        :total_points => nrow(matched_data),
        :mean_distance => mean(distances),
        :median_distance => median(distances),
        :std_distance => std(distances),
        :min_distance => minimum(distances),
        :max_distance => maximum(distances),
        :points_within_50m => sum(distances .<= 50),
        :points_within_100m => sum(distances .<= 100),
        :points_within_200m => sum(distances .<= 200)
    )

    @info "Spatial matching statistics for $dataset_name:"
    @info "  Total points: $(stats[:total_points])"
    @info "  Mean distance: $(round(stats[:mean_distance], digits=1))m"
    @info "  Median distance: $(round(stats[:median_distance], digits=1))m"
    @info "  Points within 50m: $(stats[:points_within_50m]) ($(round(100*stats[:points_within_50m]/stats[:total_points], digits=1))%)"
    @info "  Points within 100m: $(stats[:points_within_100m]) ($(round(100*stats[:points_within_100m]/stats[:total_points], digits=1))%)"

    # Save spatial analysis report
    spatial_dir = joinpath(OUTPUT_DIR, "spatial_analysis")
    mkpath(spatial_dir)

    # Save statistics as CSV
    stats_df = DataFrame(;
        metric = [
            "Total Points",
            "Mean Distance (m)",
            "Median Distance (m)",
            "Std Distance (m)",
            "Min Distance (m)",
            "Max Distance (m)",
            "Points within 50m",
            "Points within 100m",
            "Points within 200m"
        ],
        value = [
            stats[:total_points],
            round(stats[:mean_distance]; digits = 2),
            round(stats[:median_distance]; digits = 2),
            round(stats[:std_distance]; digits = 2),
            round(stats[:min_distance]; digits = 2),
            round(stats[:max_distance]; digits = 2),
            stats[:points_within_50m],
            stats[:points_within_100m],
            stats[:points_within_200m]
        ]
    )
    CSV.write(joinpath(spatial_dir, "$(dataset_name)_spatial_stats.csv"), stats_df)
    @info "Saved spatial statistics to: $(spatial_dir)/$(dataset_name)_spatial_stats.csv"

    return stats
end
