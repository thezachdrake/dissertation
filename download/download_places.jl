import GeoIO: load, save
import Meshes: Point, Vec, MultiPolygon, sample, HomogeneousSampling, coords
import JSON: json, parse, print
import HTTP: Response, get, post
import Base.Threads: @spawn
using Logging
using Unitful # Import Unitful

function DownloadManhattan()::MultiPolygon
    @info "Downloading Manhattan GeoJSON..."
    response::Response = get(
        "https://data.cityofnewyork.us/resource/gthc-hcne.geojson";
        query=["\$\$app_token" => ENV["SODA_KEY"]],
    )
    @debug "Received Manhattan GeoJSON response" status = response.status size = length(response.body)

    nyc_geotable = load(String(response.body))
    return nyc_geotable[2, :geometry]
end

function NearbySearch(search_point::Point)::Vector
    # Extract coordinates and strip units to get Float64
    search_coords_raw = coords(search_point)
    lon_float = ustrip(search_coords_raw.lon) # Remove the type argument
    lat_float = ustrip(search_coords_raw.lat) # Remove the type argument
    @info "Performing Nearby Search" longitude = lon_float latitude = lat_float

    api_headers::Vector{Pair{String,String}} = [
        "Content-Type" => "application/json",
        "X-Goog-Api-Key" => ENV["GOOGLE_MAPS_KEY"],
        "X-Goog-FieldMask" => "*",
    ]

    body::Dict{String,Any} = Dict(
        "rankPreference" => "DISTANCE",
        "locationRestriction" => Dict{String,Dict}(
            "circle" => Dict(
                "center" => Dict{String,Float64}(
                    "longitude" => lon_float, "latitude" => lat_float
                ),
                "radius" => 500,
            ),
        ),
    )

    response::Response = post(
        "https://places.googleapis.com/v1/places:searchNearby", api_headers, json(body)
    )
    @debug "Received Nearby Search response" status = response.status size = length(response.body)
    data::Dict{String,Any} = parse(String(response.body))

    if haskey(data, "places") && length(data["places"]) > 0
        @debug "Found places" count = length(data["places"])
        return data["places"]
    else
        @debug "No places found for this location."
        return []
    end
end

function SampleSearchPoints(area::MultiPolygon, api_limit::Integer=4000)::Vector{Point}
    points::Vector{Any} = zeros(api_limit + 1)

    sampler::HomogeneousSampling = HomogeneousSampling(api_limit)
    points = sample(area, sampler) |> collect
    @debug "Generated sample points" count = length(points)

    return points
end

function SavePlaceFile(place::Dict{String,Any}, path::String)
    filename::String = path * place["id"] * ".json"
    @debug "Saving place data" filename
    open(filename, "w") do f
        print(f, place)
    end
end

function GetPlaceData()
    @info "Downloading Manhattan Shapefile."
    area::MultiPolygon = DownloadManhattan()
    @info "Sampling area for search points."
    search_grid_points::Vector{Point} = SampleSearchPoints(area)

    @info "Running nearby search for each grid point."
    # Consider adding progress logging here if the loop takes a long time

    counter = 0
    for search_point in search_grid_points
        try
            sleep(0.25)
            places_found = NearbySearch(search_point)
            for i in places_found
                SavePlaceFile(i, "data/places/")
            end
            counter = counter + 1
            @info "Completed $(counter) calls "
        catch e
            # @error "Error during nearby search or saving for point $(coords(search_point))" exception = (e, catch_backtrace())
        end
    end

    @info "Finished place data download."
end
