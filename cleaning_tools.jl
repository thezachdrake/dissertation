using Match

const crimecategories = ["VIOLENCE", "LARCENY", "DRUGS", "BURGLARY"]

map_law_cat(law_cat_cd::String)::String = @match law_cat_cd begin
    "F" => "FELONY"
    "M" => "MISDEMEANOR"
    "V" => "VIOLATION"
    "I" => "VIOLATION"
    _   => ""
end

function filter_crime_types(row::TableTransforms.CTableRow)::Bool
    return row."crime_cat" in crimecategories
end

function map_crime_cat(ofns_desc::String, law_cat::String)::String
    return @match ofns_desc begin
        ofns_desc where {occursin("LARCENY", ofns_desc) && !occursin("VEHICLE", ofns_desc)} => "LARCENY"
        "MURDER & NON-NEGL. MANSLAUGHTE" => "VIOLENCE"
        ofns_desc where {occursin("MURDER & NON-NEGL. MANSLAUGHTER", ofns_desc)} => "VIOLENCE"
        ofns_desc where {occursin("ASSAULT", ofns_desc)} => "VIOLENCE"
        ofns_desc where {occursin("ROBBERY", ofns_desc)} => "VIOLENCE"
        ofns_desc where {occursin("BURGLARY", ofns_desc)} => "BURGLARY"
        ofns_desc where {occursin("DRUGS", ofns_desc)} => "DRUGS"
        ofns_desc where {!(ofns_desc in crimecategories) & (law_cat == "MISDEMEANOR")} => "ALL OTHER MISDEMEANORS"
        ofns_desc where {!(ofns_desc in crimecategories) & (law_cat == "FELONY")} => "ALL OTHER FELONIES"
        ofns_desc where {!(ofns_desc in crimecategories) & (law_cat == "VIOLATION")} => "ALL OTHER VIOLATIONS"
        _ => string(ofns_desc)
    end
end

function filter_streets_manhattan(
    borocode::String, rw_type::String, physicalid::String
)::Bool
    keep::Bool = true
    @debug physicalid

    if borocode != "1"
        @debug "Is Manhattan"
        keep = false
        return keep
    end

    if rw_type != "1"
        @debug "Is Street"
        keep = false
        return keep
    end

    if physicalid == "174150"
        keep = false
        return keep
    end

    return keep
end
