import Unitful: ustrip

function filter_streets_manhattan(row)::Bool
    if row.boroughcode != "1"
        return false
    end

    if row.rw_type != "1"
        return false
    end

    if row.physicalid == "174150"
        return false
    end

    return true
end

function calc_median_street_dist_center(streets_geom::Domain)::Float64
    streets_no_units = []
    for geom in streets_geom
        push!(streets_no_units, ustrip(length(geom)))
    end

    return median(streets_no_units) / 2
end