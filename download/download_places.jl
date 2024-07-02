import GeoIO: load, save
import Meshes: Point, Vec, MultiPolygon, sample, HomogeneousSampling, coords
import JSON: json, parse, print
import HTTP: Response, get, post
import DotEnv: load!
import Base.Threads: @spawn

load!()

function DownloadManhattan()::MultiPolygon
    response::Response = get(
        "https://data.cityofnewyork.us/resource/7t3b-ywvw.geojson";
        query = ["\$\$app_token" => ENV["SODA_KEY"]],
    )

    nyc_geotable = load(String(response.body))
    return nyc_geotable[2, :geometry]
end

function NearbySearch(search_point::Point)::Vector
    lon_lat = coords(search_point)

    api_headers::Vector{Pair{String, String}} = [
        "Content-Type" => "application/json",
        "X-Goog-Api-Key" => ENV["GOOGLE_MAPS_KEY"],
        "X-Goog-FieldMask" => "*",
    ]

    body::Dict{String, Any} = Dict(
        "rankPreference" => "DISTANCE",
        "locationRestriction" => Dict{String, Dict}(
            "circle" => Dict(
                "center" => Dict{String, Float64}(
                    "longitude" => lon_lat.x, "latitude" => lon_lat.y
                ),
                "radius" => 500,
            ),
        ),
    )

    response::Response = post(
        "https://places.googleapis.com/v1/places:searchNearby", api_headers, json(body)
    )
    data::Dict{String, Any} = parse(String(response.body))

    if length(data) > 0
        return data["places"]
    else
        return []
    end
end

function SampleSearchPoints(area::MultiPolygon, api_limit::Integer = 4000)::Vector{Point}
    points::Vector{Any} = zeros(api_limit + 1)

    sampler::HomogeneousSampling = HomogeneousSampling(api_limit)
    points = sample(area, sampler) |> collect

    return points
end

function SavePlaceFile(place::Dict{String, Any}, path::String)
    filename::String = path * place["id"] * ".json"
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
    @sync begin
        @spawn for search_point in search_grid_points
            @spawn for i in NearbySearch(search_point)
                SavePlaceFile(i, "data/")
            end
        end
    end
end
