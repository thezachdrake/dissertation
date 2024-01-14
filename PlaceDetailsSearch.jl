module PlaceDetailsSearch

export get_place_ids

import HTTP
import JSON

API_KEY::String = "AIzaSyB7lJ3rfPvqYp8xbHGUEkoSEBx86Qy1lls"
const BASE_URL::String = "https://places.googleapis.com/v1/"

places::Vector{Dict{String,Any}} = []


function get_place_details()

    if length(API_KEY) == 0
        throw(UndefVarError(:API_KEY))
    end

    api_headers::Vector{Pair{String,String}} = [
        "Content-Type" => "application/json",
        "X-Goog-Api-Key" => API_KEY,
        "X-Goog-FieldMask" => "*",
    ]

    home_latlon::Dict{String,Float64} =
        Dict("latitude" => 39.27538320472095, "longitude" => -76.61034813442848)

    search_circle::Dict{String,Any} = Dict("center" => home_latlon, "radius" => 50)

    body::Dict{String,Any} =
        Dict("locationRestriction" => Dict{String,Dict}("circle" => search_circle))

    response::HTTP.Messages.Response =
        HTTP.request(:POST, BASE_URL * "places:searchNearby", api_headers, JSON.json(body))

    data = JSON.parse(String(response.body))["places"]

    append!(places, data)

end

end