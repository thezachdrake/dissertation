#set up environment
using DataFrames 
using GeoDataFrames
using GeoJSON
using Pipe
using HTTP
using JSON
ENV["COLUMNS"] = 250000
ENV["ROWS"] = 250000


crime_list = ["BURGLARY", "GRAND LARCENY",
        "MURDER & NON-NEGL. MANSLAUGHTE", "MURDER & NON-NEGL. MANSLAUGHTER",
        "PETIT LARCENY", "ROBBERY", "DANGEROUS DRUGS", 
        "ALL OTHER MISDEMEANORS", "ALL OTHER FELONIES", "ALL OTHER VIOLATIONS", "ASSAULT"]



function get_data_from_api(url:: AbstractString, keep_cols:: AbstractArray, filter_cols::AbstractArray, )
    select_statement = join(["SELECT", join(keep_cols, ",")], " ")
    where_statement = join(["WHERE (", join(filter_cols, " AND "),")"]," ")
    query_statement = join([select_statement, where_statement, "LIMIT 100000000"], " ",)

    result = HTTP.get(
            url,
            query = [
                "\$\$app_token" => "PoXtpm9UpT6UnvUOK8F0lp3Sp", 
                "\$query" => query_statement
            ]
            ).body
    result = GeoJSON.read(result)
    return result
end

street_line = get_data_from_api("https://data.cityofnewyork.us/resource/8rma-cm9c.geojson",
                                ["full_stree", "rw_type", "physicalid","status"],
                                ["borocode='1'", "rw_type='1'"])

service_calls = get_data_from_api("https://data.cityofnewyork.us/resource/n2zq-pubd.geojson", 
                                ["BORO_NM", "GEO_CD_X", "GEO_CD_Y", "TYP_DESC"], 
                                "boro_nm" => "MANHATTAN")

incidents = get_data_from_api("https://data.cityofnewyork.us/resource/5uac-w243.geojson", 
                                ["OFNS_DESC", "LAW_CAT_CD", "Latitude", "Longitude"], 
                                "boro_nm" => "MANHATTAN")

mapcols!(x -> replace(x, "(null)" => missing), incidents)
dropmissing!(incidents)

arrests = get_data_from_api("https://data.cityofnewyork.us/resource/uip8-fykc.geojson",
                            ["OFNS_DESC", "LAW_CAT_CD", "Latitude", "Longitude"], 
                            "arrest_boro" => "M")

mapcols!(x -> replace(x, "(null)" => missing), arrests)
dropmissing!(arrests)

function fix_law_cd(LAW_CAT_CD)
    mappings = Dict(
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
    elseif !(OFNS_DESC in crime_list)  & (LAW_CAT_CD == "FELONY")
        type = "ALL OTHER FELONIES" 
    elseif !(OFNS_DESC in crime_list)  & (LAW_CAT_CD == "VIOLATION")
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