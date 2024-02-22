using GeoTables
using GeoIO
using HTTP
using JSON

const BASEURL::String = "https://data.cityofnewyork.us/resource/8rma-cm9c.json"


offset::Int64 = 0
datalen::Int64 = 0

while offset == datalen
    response::HTTP.Response = HTTP.get(
        BASEURL,
        query=[
            "\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp",
            "\$limit" => 1000,
            "\$offset" => offset
        ]
    )

    apidata::Vector{Dict{String,Any}} = JSON.parse(String(response.body))

    open("data/streets/" * string(offset) * ".json", "w") do f
        JSON.print(f, apidata)
    end

    offset += 1000
    datalen += length(apidata)
end