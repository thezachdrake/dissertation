
function match_points_to_streets(points_geo::GeoTable, streets_geo::GeoTable)::DataFrame
    @info "Matching $(nrow(points_geo)) points to $(nrow(streets_geo)) streets..."

    # Convert point geometries to coordinates
    point_coords = [coords(geom) for geom in points_geo.geometry]

    # Filter out invalid (0,0) coordinates
    valid_indices = [
        i for (i, coord) in enumerate(point_coords) if
        !(abs(ustrip(coord.lat)) < 0.001 && abs(ustrip(coord.lon)) < 0.001)
    ]

    initial_count = length(point_coords)
    valid_count = length(valid_indices)
    invalid_count = initial_count - valid_count

    if invalid_count > 0
        @warn "Filtered out $invalid_count points with invalid (0,0) coordinates"
        @info "Data quality: $(round(100 * valid_count / initial_count, digits=2))% of points have valid coordinates"
    end

    # For streets, use centroid of each segment for matching
    street_centroids = [coords(centroid(geom)) for geom in streets_geo.geometry]

    # Reference latitude for NYC (used for lon->meters conversion)
    lat_ref = 40.75  # Manhattan is roughly centered at 40.75°N
    meters_per_degree_lat = 111320.0
    meters_per_degree_lon = meters_per_degree_lat * cos(deg2rad(lat_ref))

    # Build spatial index for efficient nearest neighbor search
    # Convert coordinates to meters using local projection
    street_points_meters = [
        [
            ustrip(c.lon) * meters_per_degree_lon,  # x in meters
            ustrip(c.lat) * meters_per_degree_lat    # y in meters
        ] for c in street_centroids
    ]
    tree = KDTree(reduce(hcat, street_points_meters), Cityblock())

    # Prepare output DataFrame
    points_df = DataFrame(points_geo)
    streets_df = DataFrame(streets_geo)

    matched_rows = []

    @info "Performing spatial matching on $(length(valid_indices)) valid points..."

    for i in valid_indices
        point_coord = point_coords[i]

        # Convert point to meters using same projection
        query_point_meters = [
            ustrip(point_coord.lon) * meters_per_degree_lon,
            ustrip(point_coord.lat) * meters_per_degree_lat
        ]

        # Find nearest street (distance is already in meters with Cityblock metric)
        nearest_idx, distance_meters = nn(tree, query_point_meters)

        # Get original point data
        point_row = points_df[i, :]

        # Get matched street data
        street_row = streets_df[nearest_idx, :]

        # Convert DataFrameRow to dict and extend with street matching data
        row_data = Dict(names(points_df) .=> [point_row[name] for name in names(points_df)])
        row_data["street_id"] = street_row.street_id
        row_data["street_name"] = street_row.street_name
        row_data["distance_to_street"] = distance_meters

        # Add to results
        push!(matched_rows, row_data)
    end

    # Convert collected rows to DataFrame
    matched_data = DataFrame(matched_rows)

    @info "Successfully matched $(nrow(matched_data)) points to streets"
    @info "Average distance to street: $(round(mean(matched_data[!, :distance_to_street]), digits=1)) meters"

    # Save comprehensive matching statistics (function in output.jl)
    save_spatial_matching_statistics(
        initial_count, invalid_count, valid_count, matched_data
    )

    return matched_data
end

function calculate_street_centroids(streets_geo::GeoTable)::Vector{<:Geometry}
    @info "Calculating centroids for $(nrow(streets_geo)) street segments..."

    centroids = [centroid(geom) for geom in streets_geo.geometry]

    @info "Calculated $(length(centroids)) street centroids"
    return centroids
end

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

function filter_points_by_distance(
    matched_data::DataFrame, max_distance_meters::Real = 10
)::DataFrame
    initial_count = nrow(matched_data)

    filtered_data = filter(
        row -> row.distance_to_street <= max_distance_meters, matched_data
    )

    removed_count = initial_count - nrow(filtered_data)

    @info "Filtered points by distance (≤ $(max_distance_meters)m): kept $(nrow(filtered_data)), removed $(removed_count)"

    return filtered_data
end

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
