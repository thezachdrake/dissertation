import Match: @match

const CRIME_CATEGORIES = ["VIOLENCE", "LARCENY", "DRUGS", "BURGLARY"]

map_law_cat(law_cat_cd::String)::String = @match law_cat_cd begin
    "F" => "FELONY"
    "M" => "MISDEMEANOR"
    "V" => "VIOLATION"
    "I" => "VIOLATION"
    _ => ""
end

function filter_crime_types(row::TableTransforms.CTableRow)::Bool
    return row."crime" in CRIME_CATEGORIES
end

function filter_bad_locations(row::TableTransforms.CTableRow)::Bool
    return row."geometry".x != 0.0f0u"°" & row."geometry".y != 0.0f0u"°"
end

function map_crime_cat(ofns_desc::String, law_cat::String)::String
    return @match ofns_desc begin
        ofns_desc where {occursin("LARCENY", ofns_desc)&&!occursin("VEHICLE", ofns_desc)} => "LARCENY"
        "MURDER & NON-NEGL. MANSLAUGHTE" => "VIOLENCE"
        ofns_desc where {occursin("MURDER & NON-NEGL. MANSLAUGHTER", ofns_desc)} => "VIOLENCE"
        ofns_desc where {occursin("ASSAULT", ofns_desc)} => "VIOLENCE"
        ofns_desc where {occursin("ROBBERY", ofns_desc)} => "VIOLENCE"
        ofns_desc where {occursin("BURGLARY", ofns_desc)} => "BURGLARY"
        ofns_desc where {occursin("DRUGS", ofns_desc)} => "DRUGS"
        ofns_desc where {!(ofns_desc in CRIME_CATEGORIES)&(law_cat=="MISDEMEANOR")} => "ALL OTHER MISDEMEANORS"
        ofns_desc where {!(ofns_desc in CRIME_CATEGORIES)&(law_cat=="FELONY")} => "ALL OTHER FELONIES"
        ofns_desc where {!(ofns_desc in CRIME_CATEGORIES)&(law_cat=="VIOLATION")} => "ALL OTHER VIOLATIONS"
        _ => string(ofns_desc)
    end
end
