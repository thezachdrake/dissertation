using HTTP
using JSON
using GeoIO
using GeoTables
using DataFrames
import Dates: DateTime3

crime_list = ["BURGLARY", "GRAND LARCENY",
    "MURDER & NON-NEGL. MANSLAUGHTE", "MURDER & NON-NEGL. MANSLAUGHTER",
    "PETIT LARCENY", "ROBBERY", "DANGEROUS DRUGS",
    "ALL OTHER MISDEMEANORS", "ALL OTHER FELONIES", "ALL OTHER VIOLATIONS", "ASSAULT"]

function fetch_data(url::String)
    apidata::Vector{Dict{String,Any}} = []

    offset::Int128 = 0

    while offset <= length(apidata)

        response::HTTP.Response = HTTP.get(
            url,
            query=[
                "\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp",
                "\$limit" => 5000,
                "\$offset" => offset,
                "\$where" => "cmplnt_fr_dt >= '$(DateTime(2023, 1, 1))'"]
        )


        stringbody::String = String(response.body)
        jsonbody::Vector{Dict{String,Any}} = JSON.parse(stringbody)
        append!(apidata, jsonbody)
        offset += 5000
    end

    open("data/test.json", "w") do f
        JSON.print(f, apidata)
    end
end

street_line = fetch_data("https://data.cityofnewyork.us/resource/8rma-cm9c.geojson")

service_calls = fetch_data("https://data.cityofnewyork.us/resource/n2zq-pubd.json")

incidents = fetch_data("https://data.cityofnewyork.us/resource/5uac-w243.json")

mapcols!(x -> replace(x, "(null)" => missing), incidents)
dropmissing!(incidents)

arrests = fetch_data("https://data.cityofnewyork.us/resource/uip8-fykc.geojson")

mapcols!(x -> replace(x, "(null)" => missing), arrests)
dropmissing!(arrests)

function fixlawcd(LAW_CAT_CD)
    mappings = Dict{String,String}(
        "F" => "FELONY",
        "M" => "MISDEMEANOR",
        "V" => "VIOLATION",
        "I" => "VIOLATION",
        "9" => missing,
        missing => missing
    )

    return mappings[LAW_CAT_CD]

end

function map_offense_desc(OFNS_DESC, LAW_CAT_CD)
    if OFNS_DESC == "MURDER & NON-NEGL. MANSLAUGHTE"
        type = "ASSAULT & MURDER"
    elseif occursin("LARCENY", OFNS_DESC) & !occursin("VEHICLE", OFNS_DESC)
        type = "LARCENY"
    elseif occursin("MURDER & NON-NEGL. MANSLAUGHTER", OFNS_DESC)
        type = "ASSAULT & MURDER"
    elseif occursin("ASSAULT", OFNS_DESC)
        type = "ASSAULT & MURDER"
    elseif !(OFNS_DESC in crime_list) & (LAW_CAT_CD == "MISDEMEANOR")
        type = "ALL OTHER MISDEMEANORS"
    elseif !(OFNS_DESC in crime_list) & (LAW_CAT_CD == "FELONY")
        type = "ALL OTHER FELONIES"
    elseif !(OFNS_DESC in crime_list) & (LAW_CAT_CD == "VIOLATION")
        type = "ALL OTHER VIOLATIONS"
    else
        type = string(OFNS_DESC)
    end

    return type
end

incidents.TYPE = map_offense_desc.(incidents.OFNS_DESC, incidents.LAW_CAT_CD)
arrests.LAW_CAT_CD = fix_law_cd.(arrests.LAW_CAT_CD)
dropmissing!(arrests)
arrests.TYPE = map_offense_desc.(arrests.OFNS_DESC, arrests.LAW_CAT_CD)

arrest_count = combine(groupby(arrests, [:TYPE]), nrow => :count)
inc_count = combine(groupby(incidents, [:TYPE]), nrow => :count)


generate_clean_dataset("data/incidents_ytd.csv")