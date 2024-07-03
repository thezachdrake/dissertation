function filter_streets_manhattan(row)::Bool
    if row.borocode != "1"
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