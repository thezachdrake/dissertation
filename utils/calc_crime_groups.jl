import DataFrames: sort!, select, leftjoin!

function calc_decile(
    data::DataFrame,
    street_ids::Symbol,
    crimes::Symbol;
    index::Float64,
)::DataFrame
    df = select(data, street_ids, crimes)
    df[!, :is_top_crimes] = Vector{Bool}(undef, length(df[!, crimes])) .= false
    sort!(df, crimes, rev=true)
    total_crimes = sum(df[!, crimes])
    # Handle cases with zero total crimes to avoid division by zero
    if total_crimes == 0
        # All streets have 0 crimes, none are 'top'. Return df with all false.
        return select(df, street_ids, :is_top_crimes)
    end
    cum_perc = cumsum(df[!, crimes]) ./ total_crimes

    # Find the index of the first street where cumulative percentage meets or exceeds the target index
    first_index_over_threshold = findfirst(x -> x >= index, cum_perc)

    # If no single street meets the threshold (can happen if index is very small or data issues),
    # or if total_crimes was zero, first_index_over_threshold might be nothing or invalid.
    # In typical cases (like index=0.25 or 0.50 and non-zero crimes), this should find a valid index.
    if isnothing(first_index_over_threshold)
        # This case is unlikely for index 0.25/0.50 unless all crimes are 0 (handled above)
        # or index is > 1.0. Could warn or decide policy. For now, assume it doesn't happen.
        @warn "Could not find streets meeting the threshold index $index for $crimes. Check data or index."
    else
        # Mark rows from 1 up to and including the found index as true
        df[1:first_index_over_threshold, :is_top_crimes] .= true
    end

    return select(df, street_ids, :is_top_crimes)
end

function calc_top_crime_cols!(data::DataFrame, crime_cols::Vector{Symbol})
    for crime_col in crime_cols
        col_name = String(crime_col)
        col_name = SubString(col_name, findfirst("_", col_name)[1] + 1, length(col_name))

        # Calculate and join top 25%
        top_25 = calc_decile(data, :street_id, crime_col, index=0.25)
        new_col_sym_25 = Symbol("top_25_" * col_name)
        rename!(top_25, :is_top_crimes => new_col_sym_25)
        leftjoin!(data, top_25, on=:street_id)
        # Ensure Bool type and handle potential missings from join
        data[!, new_col_sym_25] = coalesce.(data[!, new_col_sym_25], false)

        # Calculate and join top 50%
        top_50 = calc_decile(data, :street_id, crime_col, index=0.50)
        new_col_sym_50 = Symbol("top_50_" * col_name)
        rename!(top_50, :is_top_crimes => new_col_sym_50)
        leftjoin!(data, top_50, on=:street_id)
        # Ensure Bool type and handle potential missings from join
        data[!, new_col_sym_50] = coalesce.(data[!, new_col_sym_50], false)
    end
end
