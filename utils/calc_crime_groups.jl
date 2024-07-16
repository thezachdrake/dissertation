import DataFrames: sort!, select, leftjoin!

function calc_decile(
    data::DataFrame,
    street_ids::Symbol,
    crimes::Symbol;
    index::Float64,
)::DataFrame
    df = select(data, street_ids, crimes)
    df[!, :is_top_crimes] = Vector{Bool}(undef, length(df[!, crimes])) .= false
    sort!(df, crimes, rev = true)
    total_crimes = sum(df[!, crimes])
    cum_perc = cumsum(df[!, crimes]) ./ total_crimes
    streets_to_index = filter(x -> x <= (index), cum_perc)
    df[1:length(streets_to_index), :is_top_crimes] .= true
    return select(df, street_ids, :is_top_crimes)
end

function calc_top_crime_cols!(data::DataFrame, crime_cols::Vector{Symbol})
    for crime_col in crime_cols
        col_name = String(crime_col)
        col_name = SubString(col_name, findfirst("_", col_name)[1] + 1, length(col_name))
        top_25 = calc_decile(data, :street_id, crime_col, index = 0.25)
        rename!(top_25, :is_top_crimes => ("top_25_" * col_name))
        leftjoin!(data, top_25, on = :street_id)

        top_50 = calc_decile(data, :street_id, crime_col, index = 0.50)
        rename!(top_50, :is_top_crimes => ("top_50_" * col_name))
        leftjoin!(data, top_50, on = :street_id)
    end
end
