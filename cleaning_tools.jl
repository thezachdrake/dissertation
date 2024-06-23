crimecategories = ["VIOLENCE", "LARCENY", "DRUGS", "BURGLARY"]

function fix_law_cd(law_cat_cd)::String
    if typeof(law_cat_cd) == Missing
        return ""
    else
        mappings = Dict{String,String}(
            "F" => "FELONY",
            "M" => "MISDEMEANOR",
            "V" => "VIOLATION",
            "I" => "VIOLATION",
            "9" => "",
        )
        return get(mappings, String(law_cat_cd), String(law_cat_cd))
    end
end

function filter_types(type::String)::Bool
    return type in crimecategories
end

function map_offense_desc(ofns_desc, law_cat_cd)::String
    if typeof(ofns_desc) == Missing
        return ""
    elseif ofns_desc == "MURDER & NON-NEGL. MANSLAUGHTE"
        return "VIOLNCE"
    elseif occursin("LARCENY", ofns_desc) & !occursin("VEHICLE", ofns_desc)
        return "LARCENY"
    elseif occursin("LARCENY", ofns_desc)
        return "LARCENY"
    elseif occursin("MURDER & NON-NEGL. MANSLAUGHTER", ofns_desc)
        return "VIOLENCE"
    elseif occursin("BURGLARY", ofns_desc)
        return "BURGLARY"
    elseif occursin("ASSAULT", ofns_desc)
        return "VIOLENCE"
    elseif occursin("ROBBERY", ofns_desc)
        return "VIOLENCE"
    elseif occursin("DRUGS", ofns_desc)
        return "DRUGS"
    elseif !(ofns_desc in crimecategories) & (law_cat_cd == "MISDEMEANOR")
        return "ALL OTHER MISDEMEANORS"
    elseif !(ofns_desc in crimecategories) & (law_cat_cd == "FELONY")
        return "ALL OTHER FELONIES"
    elseif !(ofns_desc in crimecategories) & (law_cat_cd == "VIOLATION")
        return "ALL OTHER VIOLATIONS"
    else
        return string(ofns_desc)
    end

end