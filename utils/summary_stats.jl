module SummaryStats

using DataFrames, Statistics, Printf, CSV

export calculate_boolean_column_distributions, calculate_place_category_stats

"""
    calculate_boolean_column_distributions(df::DataFrame, cols::Vector{Symbol})

Calculates the count and ratio of true/false values for specified boolean-like columns.
Ensures both true and false categories are present in the output, even if one has zero count.

# Arguments
- `df::DataFrame`: The input DataFrame.
- `cols::Vector{Symbol}`: A vector of Symbols representing the boolean columns to summarize.

# Returns
- `DataFrame`: A DataFrame with columns :category (String), :value (Bool), :count (Int), :ratio (Float64).
"""
function calculate_boolean_column_distributions(df::DataFrame, cols::Vector{Symbol})::DataFrame
    distributions = DataFrame(category=String[], value=Bool[], count=Int[], ratio=Float64[])

    for col_sym in cols
        # Check if column exists using hasproperty
        if !hasproperty(df, col_sym)
            @warn "Column '$col_sym' not found in DataFrame. Skipping."
            continue
        end
        # Check if column type is suitable (Bool or 0/1 Integer)
        if !(eltype(df[!, col_sym]) <: Union{Bool, Integer})
             @warn "Column '$col_sym' is not Boolean or Integer type. Skipping."
             continue
        end

        col_str = String(col_sym)
        # Perform the group by and count
        dist = combine(groupby(df, col_sym), nrow => :count)
        total = sum(dist.count)

        # Ensure both true and false rows exist in the output for this category
        for expected_value in [true, false]
            row_idx = findfirst(==(expected_value), dist[!, col_sym])
            if isnothing(row_idx)
                # If the value (true or false) doesn't exist in the grouped data, add a zero count row
                 push!(distributions, (
                    category=col_str,
                    value=expected_value,
                    count=0,
                    ratio=0.0
                ))
            else
                # If the value exists, use its count
                 push!(distributions, (
                    category=col_str,
                    value=expected_value, # Use the actual value
                    count=dist[row_idx, :count],
                    ratio= total > 0 ? dist[row_idx, :count] / total : 0.0 # Avoid division by zero
                ))
            end
        end
    end
    sort!(distributions, [:category, :value]) # Sort for consistent output
    return distributions
end

"""
    calculate_place_category_stats(df::DataFrame)

Calculates distributions for individual place categories (columns starting with 'category_'),
their co-occurrence count matrix, and their correlation matrix.

# Arguments
- `df::DataFrame`: The input DataFrame containing boolean place category columns.

# Returns
- `Tuple{DataFrame, DataFrame, DataFrame}`: A tuple containing:
    - `place_distributions::DataFrame`: DataFrame with columns :category, :count, :ratio.
    - `cooccurrence_df::DataFrame`: DataFrame representing the co-occurrence matrix,
      with category names as both row and column headers.
    - `correlation_df::DataFrame`: DataFrame representing the Pearson correlation matrix
      between place categories, with category names as both row and column headers.
"""
function calculate_place_category_stats(df::DataFrame)::Tuple{DataFrame,DataFrame,DataFrame}
    println("Calculating place category distributions...")
    place_cat_cols = Symbol.(filter(x -> startswith(x, "category_"), names(df)))
    place_distributions = DataFrame(category=Symbol[], count=Int[], ratio=Float64[])
    total_rows = nrow(df)

    valid_place_cat_cols = Symbol[] # Store columns that are valid (boolean/integer)

    if isempty(place_cat_cols)
        @warn "No columns starting with 'category_' found."
        # Return empty DataFrames if no category columns exist
        return (DataFrame(category=Symbol[], count=Int[], ratio=Float64[]),
                DataFrame(),
                DataFrame())
    end

    # First pass: calculate distributions and identify valid columns
    for cat_sym in place_cat_cols
        if !hasproperty(df, cat_sym) || !(eltype(df[!, cat_sym]) <: Union{Bool, Integer})
             @warn "Column '$cat_sym' not found or not boolean/integer. Skipping calculations involving it."
             continue
        end
        push!(valid_place_cat_cols, cat_sym) # Add to list for matrix calculations
        count = sum(df[!, cat_sym]) # Summing boolean/0-1 counts true as 1
        ratio = count / total_rows
        push!(place_distributions, (category=cat_sym, count=count, ratio=ratio))
    end

    # Check if any valid columns were found before proceeding
    if isempty(valid_place_cat_cols)
        @warn "No valid place category columns found for matrix calculations."
        return (place_distributions, DataFrame(), DataFrame())
    end

    # Select only the valid boolean place category columns for matrices
    place_data_matrix = Matrix{Float64}(df[!, valid_place_cat_cols]) # Use Float64 for correlation
    n_cats = length(valid_place_cat_cols)

    # --- Calculate Co-occurrence Matrix ---
    println("Calculating place category co-occurrence matrix...")
    cooccurrence_matrix = zeros(Int, n_cats, n_cats)
    for i in 1:n_cats
        cat1 = valid_place_cat_cols[i]
        for j in i:n_cats # Calculate upper triangle + diagonal
            cat2 = valid_place_cat_cols[j]
            # Count rows where both columns are true using broadcasted AND (.&)
            # Note: df[!, col] directly accesses the valid columns identified earlier
            cooccurrence = sum(df[!, cat1] .& df[!, cat2])
            cooccurrence_matrix[i, j] = cooccurrence
            if i != j
                cooccurrence_matrix[j, i] = cooccurrence # Mirror to lower triangle
            end
        end
    end
    cooccurrence_df = DataFrame(cooccurrence_matrix, valid_place_cat_cols)
    insertcols!(cooccurrence_df, 1, :category => valid_place_cat_cols)

    # --- Calculate Correlation Matrix ---
    println("Calculating place category correlation matrix...")
    # Calculate Pearson correlation matrix using the Float64 matrix
    correlation_matrix = cor(place_data_matrix)
    correlation_df = DataFrame(correlation_matrix, valid_place_cat_cols)
    insertcols!(correlation_df, 1, :category => valid_place_cat_cols)

    return (place_distributions, cooccurrence_df, correlation_df) # Return all three
end

end # end module
