"""
download.jl

Data download functions for the dissertation analysis.
These functions fetch data from NYC Open Data and Google Places API.
"""

"""
    download_crime_data()::Nothing

Download crime incident and arrest data from NYC Open Data SODA API.

This function retrieves the crime data described in the Methods section of the paper.
The data comes from NYC Open Data's publicly available datasets, which are updated
quarterly. As noted in the paper, these datasets are used because they are "rich in
detail and classification" and "incredibly large," providing the statistical power
needed to detect relationships between facility types and crime concentration.

The function downloads both incidents (reported crimes) and arrests to enable
comparison for Research Question 3 about law enforcement activity patterns.
All data is filtered to Manhattan borough to leverage its high crime-to-street-segment
ratio (almost 7:1) mentioned in the paper.

Requires:

  - SODA_KEY_ID environment variable for NYC Open Data API Key ID
  - SODA_KEY_SECRET environment variable for NYC Open Data API Key Secret

Downloads:

  - incidents.geojson: Crime complaints/incidents in Manhattan
  - arrests.geojson: Arrest records in Manhattan

Data Fields Retrieved:

  - Incidents: complaint number, offense description, law category, borough,
    location type, premise type, geocoded coordinates
  - Arrests: arrest key, offense description, law category, borough, geocoded coordinates

Notes:

  - Data is pre-geocoded by NYC to street segment centers
  - Only records with valid geocoding are retrieved
  - Manhattan filter applied at API level for efficiency
"""
function download_crime_data()::Nothing
    @info "Downloading crime data from NYC Open Data..."

    # Create data directory
    mkpath(DATA_DIR)

    # Download incidents data
    @info "Fetching crime incidents..."
    incidents_response = HTTP.get(
        "https://data.cityofnewyork.us/api/v3/views/5uac-w243/query.geojson";
        basicauth = (ENV["SODA_KEY_ID"], ENV["SODA_KEY_SECRET"]),
        query = [
            "\$limit" => 10000000,
            "\$select" => "cmplnt_num,ofns_desc,law_cat_cd,boro_nm,loc_of_occur_desc,prem_typ_desc,geocoded_column",
            "\$where" => "boro_nm == 'MANHATTAN' AND geocoded_column IS NOT NULL"
        ]
    )

    incidents_path = joinpath(DATA_DIR, "incidents.geojson")
    write(incidents_path, incidents_response.body)
    @info "Saved $(length(incidents_response.body)) bytes of incidents data to $incidents_path"

    # Download arrests data
    @info "Fetching arrest data..."
    arrests_response = HTTP.get(
        "https://data.cityofnewyork.us/api/v3/views/uip8-fykc/query.geojson";
        basicauth = (ENV["SODA_KEY_ID"], ENV["SODA_KEY_SECRET"]),
        query = [
            "\$limit" => 10000000,
            "\$select" => "arrest_key,ofns_desc,law_cat_cd,arrest_boro,geocoded_column",
            "\$where" => "arrest_boro == 'M' AND geocoded_column IS NOT NULL"
        ]
    )

    arrests_path = joinpath(DATA_DIR, "arrests.geojson")
    write(arrests_path, arrests_response.body)
    @info "Saved $(length(arrests_response.body)) bytes of arrests data to $arrests_path"

    @info "Crime data download complete"
end

"""
    download_street_data()::Nothing

Download NYC street centerline data from NYC Open Data SODA API.

This function retrieves the street segment data that serves as the unit of analysis
for the dissertation. As described in the Methods section, street segments are
defined as "both sides of a street between two intersections," following the
standard definition in crime and place literature (Weisburd et al., 2012).

The street centerlines provide the spatial framework for aggregating crimes and
facilities. Manhattan contains 9,347 street segments after filtering, which forms
the analytical dataset. Each segment has a unique identifier and geometry for
spatial matching operations.

Requires:

  - SODA_KEY_ID environment variable for NYC Open Data API Key ID
  - SODA_KEY_SECRET environment variable for NYC Open Data API Key Secret

Downloads:

  - streets.geojson: Street centerlines for all NYC boroughs

Data Characteristics:

  - Contains unique record for each street segment
  - Includes PHYSICALID as unique identifier
  - Provides FULL_STREE as human-readable street name
  - Geometry encoded as LineString features
  - Classification field distinguishes streets from highways, alleys, etc.

Processing Notes:

  - Raw data includes all boroughs (filtered to Manhattan later)
  - Street type filtering removes non-street features
  - Used for K-nearest neighbor matching with crime/place data
"""
function download_street_data()::Nothing
    @info "Downloading street data from NYC Open Data..."

    mkpath(DATA_DIR)

    response = HTTP.get(
        "https://data.cityofnewyork.us/api/v3/views/inkn-q76z/query.geojson";
        basicauth = (ENV["SODA_KEY_ID"], ENV["SODA_KEY_SECRET"]),
        query = ["\$limit" => 100000000]
    )

    filepath = joinpath(DATA_DIR, "streets.geojson")
    write(filepath, response.body)
    @info "Saved $(length(response.body)) bytes of street data to $filepath"

    @info "Street data download complete"
end

"""
    download_place_data()

Download place data using Google Places API with systematic spatial sampling.
Creates a grid of search points across Manhattan and queries nearby places.

Requires:

  - GOOGLE_MAPS_KEY environment variable for Google Places API access
  - SODA_KEY_ID environment variable for NYC Open Data API Key ID
  - SODA_KEY_SECRET environment variable for NYC Open Data API Key Secret

Downloads:

  - places/*.json: Individual JSON files for each place found

Process:

 1. Download Manhattan boundary from NYC Open Data
 2. Generate systematic sampling grid across Manhattan
 3. Query Google Places API for each grid point
 4. Save each unique place as a separate JSON file

Note: This function implements rate limiting (250ms delay) to respect API limits.
"""
function download_place_data(n_samples::Int = Nothing)
    @info "Downloading place data using Google Places API..."

    # Download Manhattan boundary first
    @info "Getting Manhattan boundary from NYC Open Data..."
    manhattan_response = HTTP.get(
        "https://data.cityofnewyork.us/api/v3/views/gthc-hcne/query.geojson";
        basicauth = (ENV["SODA_KEY_ID"], ENV["SODA_KEY_SECRET"])
    )

    manhattan_geotable = GeoIO.load(String(manhattan_response.body))
    manhattan_polygon = manhattan_geotable[2, :geometry]  # Manhattan is row 2 in the borough data

    # Create systematic sampling grid
    @info "Creating spatial sampling grid across Manhattan..."
    if n_samples == Nothing
        # Get sample size from environment, default to 4000 if not set
        n_samples = parse(Int, get(ENV, "PLACES_SAMPLE_SIZE", "4000"))
    end
    @info "Using $n_samples sample points (configured via PLACES_SAMPLE_SIZE)"
    sampler = Meshes.HomogeneousSampling(n_samples)
    sample_points = collect(Meshes.sample(manhattan_polygon, sampler))

    # Create places directory
    places_dir = joinpath(DATA_DIR, "places")
    mkpath(places_dir)

    # Set up API headers for Google Places
    api_headers = [
        "Content-Type" => "application/json",
        "X-Goog-Api-Key" => ENV["GOOGLE_MAPS_KEY"],
        "X-Goog-FieldMask" => "*"  # Get all available fields
    ]

    @info "Querying $(length(sample_points)) grid points for nearby places..."

    completed_calls = 0
    places_found = 0

    for (i, point) in enumerate(sample_points)
        try
            # Rate limiting - 250ms delay between calls
            sleep(0.25)

            # Extract coordinates from the point
            coords_raw = Meshes.coords(point)
            lon = ustrip(coords_raw.lon)
            lat = ustrip(coords_raw.lat)

            # Create API request body
            body = Dict(
                "rankPreference" => "DISTANCE",
                "locationRestriction" => Dict(
                    "circle" => Dict(
                        "center" => Dict("longitude" => lon, "latitude" => lat),
                        "radius" => 500  # 500 meter search radius
                    )
                )
            )

            # Make API call
            response = HTTP.post(
                "https://places.googleapis.com/v1/places:searchNearby",
                api_headers,
                JSON.json(body)
            )

            # Parse response
            data = JSON.parse(String(response.body))

            # Save each place found
            if haskey(data, "places") && !isempty(data["places"])
                for place in data["places"]
                    # Use place ID as filename to avoid duplicates
                    filename = joinpath(places_dir, "$(place["id"]).json")

                    # Only save if we haven't seen this place before
                    if !isfile(filename)
                        open(filename, "w") do f
                            JSON.print(f, place)
                        end
                        places_found += 1
                    end
                end
            end

            completed_calls += 1

            # Progress logging
            if completed_calls % 100 == 0
                @info "Progress: $completed_calls/$n_samples API calls completed, $places_found unique places found"
            end

        catch e
            @debug "Error processing sample point $i: $e"
            continue  # Skip this point and continue with the next
        end
    end

    @info "Place data download complete: $completed_calls API calls made, $places_found unique places saved to $places_dir"
end
