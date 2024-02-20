module GoogleMapsPlaceSearch
include("placeTypes.jl")

export GoogleAPI

import HTTP, JSON, DataFrames, Missings, GeoIO, Meshes, Base.Threads

@kwdef struct GoogleAPI
    base::String
    key::String
end

function _createsearchpoints(area::Meshes.MultiPolygon,
    api_limit::Integer)::Vector{Meshes.Point2}

    sample_rate::Float64 = 0.1
    points::Vector{Any} = zeros(api_limit + 1)

    sampler::Meshes.HomogeneousSampling = Meshes.HomogeneousSampling(api_limit)
    points = Meshes.sample(area, sampler) |> collect

    return points
end

function placedetails(api::GoogleAPI,
    area::Meshes.MultiPolygon, api_limit::Integer=4000)

    search_grid_points::Vector{Meshes.Point2} = _createsearchpoints(area, api_limit)

    println("Running nearby search for each grid point.")
    for search_point in search_grid_points
        for i in _nearbysearch(api=api, search_point=search_point)
            _saveplacefile(i, "data/")
        end
    end

end

function _nearbysearch(; api::GoogleAPI, search_point::Meshes.Point)::Vector{Any}
    coords::Meshes.Vec{2,Float64} = Meshes.coordinates(search_point)

    if length(api.key) == 0
        throw(UndefVarError(:apikey))
    end

    api_headers::Vector{Pair{String,String}} = [
        "Content-Type" => "application/json",
        "X-Goog-Api-Key" => api.key,
        "X-Goog-FieldMask" => "*",
    ]

    search_circle::Dict{String,Any} = Dict(
        "center" => Dict{String,Float64}(
            "latitude" => coords[2],
            "longitude" => coords[1],
        ),
        "radius" => 500)

    body::Dict{String,Any} =
        Dict("rankPreference" => "DISTANCE",
            "locationRestriction" => Dict{String,Dict}(
                "circle" => search_circle),
        )

    response::HTTP.Messages.Response =
        HTTP.request(:POST, api.base * "places:searchNearby", api_headers, JSON.json(body))

    data::Dict{String,Any} = JSON.parse(String(response.body))

    if length(data) > 0
        return data["places"]
    else
        return []

    end
end

function _saveplacefile(place::Dict{String,Any}, path::String)
    filename::String = path * place["id"] * ".json"
    open(filename, "w") do f
        JSON.print(f, place)
    end
end

function flattenplace(rawplace::Dict{String,Any})::Dict{String,Any}
    if length(rawplace) > 0
        place::Dict{String,Any} = Dict{String,Any}()
        place["place_id"] = rawplace["id"]
        place["lat"] = rawplace["location"]["latitude"]
        place["lon"] = rawplace["location"]["longitude"]
        if haskey(rawplace, "primaryType") && haskey(alltypes, rawplace["primaryType"])
            place["primaryA"] = alltypes[rawplace["primaryType"]]
        else
            place["primaryA"] = nothing
        end
        typesdict::Dict{String,Bool} = extracttypes(place_types=rawplace["types"])
        place = merge(place, typesdict)

        return place
    else
        return rawplace
    end

end

function extracttypes(; place_types::Vector{Any})::Dict{String,Bool}


    output::Dict{String,Int64} = Dict(
        "automotive" => false,
        "business" => false,
        "culture" => false,
        "education" => false,
        "recreation" => false,
        "finance" => false,
        "foodbev" => false,
        "geographic" => false,
        "government" => false,
        "health" => false,
        "lodging" => false,
        "worship" => false,
        "services" => false,
        "shopping" => false,
        "sports" => false,
        "transportation" => false,
        "typeb" => false
    )

    for type in typeslist
        type_cat::String = alltypes[type]
        if type in place_types
            # output[type] = 1
            output[type_cat] = true
        end
    end

    return output
end

end