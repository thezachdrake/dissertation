module PlaceDetailsSearch
using Base: length_continued
include("placeTypes.jl")

export placedetails, GoogleAPI, SearchPoint

import HTTP, JSON, DataFrames, Missings, GeoIO, Meshes, Base.Threads

@kwdef struct GoogleAPI
    base::String
    key::String
end

function _createsearchpoints(area::Meshes.MultiPolygon,
    api_limit::Integer=4000)::Vector{Meshes.Point2}

    sample_rate::Float64 = 0.0003
    points::Vector{Any} = zeros(api_limit + 1)


    while length(points) > api_limit
        if length(points) == api_limit + 1
            println("Building search grid...")
        else
            println("Search grid has $(length(points)) points. Building with smaller sample rate.")
        end

        sampler::Meshes.MinDistanceSampling = Meshes.MinDistanceSampling(sample_rate)
        points = Meshes.sample(area, sampler) |> collect
        sample_rate += 0.0001
    end

    println("Search grid has $(length(points)) points.")
    return points
end

function placedetails(api::GoogleAPI,
    area::Meshes.MultiPolygon,
    api_limit::Integer=nothing)::DataFrames.DataFrame

    search_grid_points::Vector{Meshes.Point2} = []
    if api_limit == nothing
        search_grid_points = _createsearchpoints(area)
    else
        search_grid_points = _createsearchpoints(area, api_limit)
    end


    place_ids::Vector{Dict{String,Any}} = []
    println("Running nearby search for each grid point.")
    for search_point in search_grid_points
        for i in _nearbysearch(api=api, search_point=search_point)
            push!(place_ids, i)
        end
    end

    flat_places::Vector{Any} = []
    println("Extracting data.")
    for place in place_ids
        push!(flat_places, _flattenplace(place))
    end

    return DataFrames.DataFrame(flat_places)

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

# modfiy place dictionary into single level
function _flattenplace(rawplace::Dict{String,Any})::Dict{String,Any}
    if length(rawplace) > 0
        place::Dict{String,Any} = Dict{String,Any}()
        place["place_id"] = rawplace["id"]
        place["lat"] = rawplace["location"]["latitude"]
        place["lon"] = rawplace["location"]["longitude"]
        typesdict::Dict{String,Bool} = _extracttypes(place_types=rawplace["types"])
        place = merge(place, typesdict)

        return place
    else
        return rawplace
    end

end

# separate place types into boolean indicators
function _extracttypes(; place_types::Vector{Any})::Dict{String,Bool}

    output::Dict{String,Any} = Dict{String,Any}()
    for type in all_types
        if type in place_types
            output[type] = true
        else
            output[type] = false
        end

    end

    return output
end

end