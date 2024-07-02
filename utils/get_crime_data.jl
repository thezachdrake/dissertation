using HTTP
using GeoIO
using GeoTables
using JSON

function fetch_geo(url::String, fields::Vector{String}, query::String, name::String)
    response::HTTP.Response = HTTP.get(
        url;
        query = [
            "\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp",
            "\$limit" => 10000000,
            "\$select" => join(fields, ","),
            "\$where" => query,
        ],
    )

    table::GeoTable = GeoIO.load(String(response.body))

    return GeoIO.save("data/$name.geojson", table)
end

fetch_geo(
    "https://data.cityofnewyork.us/resource/5uac-w243.geojson",
    [
        "ofns_desc",
        "law_cat_cd",
        "boro_nm",
        "loc_of_occur_desc",
        "prem_typ_desc",
        "geocoded_column",
    ],
    "boro_nm == 'MANHATTAN' AND geocoded_column IS NOT NULL",
    "incidents",
)

fetch_geo(
    "https://data.cityofnewyork.us/resource/uip8-fykc.geojson",
    ["ofns_desc", "law_cat_cd", "arrest_boro", "geocoded_column"],
    "arrest_boro == 'M' AND geocoded_column IS NOT NULL",
    "arrests",
)

# fetch_geo(
#     "https://data.cityofnewyork.us/resource/n2zq-pubd.json",
#     ["typ_desc", "boro_nm", "latitude", "longitude"],
#     "boro_nm == 'MANHATTAN'",
#     "services",
# )
