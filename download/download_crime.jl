using HTTP
using GeoIO
using GeoTables
using JSON
using Logging

function QueryNYCSODA(url::String, fields::Vector{String}, query::String, name::String)
    @info "Querying SODA API for '$name'" url query
    response::HTTP.Response = HTTP.get(
        url;
        query=[
            "\$\$app_token" => ENV["SODA_KEY"],
            "\$limit" => 10000000,
            "\$select" => join(fields, ","),
            "\$where" => query,
        ],
    )
    @debug "Received response" status = response.status size = length(response.body)

    table::GeoTable = GeoIO.load(String(response.body))

    filepath = "data/$name.geojson"
    GeoIO.save(filepath, table)
    @info "Saved data to '$filepath'"
    return nothing
end

function GetCrimeData()
    @info "Starting crime data download..."
    @info "Fetching incidents data..."
    QueryNYCSODA(
        "https://data.cityofnewyork.us/resource/5uac-w243.geojson",
        [
            "cmplnt_num",
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

    @info "Fetching arrests data..."
    QueryNYCSODA(
        "https://data.cityofnewyork.us/resource/uip8-fykc.geojson",
        ["arrest_key", "ofns_desc", "law_cat_cd", "arrest_boro", "geocoded_column",],
        "arrest_boro == 'M' AND geocoded_column IS NOT NULL",
        "arrests",
    )

    # fetch_geo(
    #     "https://data.cityofnewyork.us/resource/n2zq-pubd.json",
    #     ["typ_desc", "boro_nm", "latitude", "longitude"],
    #     "boro_nm == 'MANHATTAN'",
    #     "services",
    # )

    @info "Finished crime data download."
    return nothing
end

# fetch_geo(
#     "https://data.cityofnewyork.us/resource/n2zq-pubd.json",
#     ["typ_desc", "boro_nm", "latitude", "longitude"],
#     "boro_nm == 'MANHATTAN'",
#     "services",
# )
