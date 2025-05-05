import DataFrames: sort!, select, leftjoin!, rename!, Not, select!
using Statistics: sum, mean

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
        # Keep the full original column name string for generating output names
        col_name_str = String(crime_col)
        # Example: col_name_str = "incidents_LARCENY"

        # Calculate and join top 25%
        top_25 = calc_decile(data, :street_id, crime_col, index=0.25)
        # Create new name like :top_25_incidents_LARCENY
        new_col_sym_25 = Symbol("top_25_" * col_name_str)
        rename!(top_25, :is_top_crimes => new_col_sym_25)
        leftjoin!(data, top_25, on=:street_id)
        # Ensure Bool type and handle potential missings from join
        data[!, new_col_sym_25] = coalesce.(data[!, new_col_sym_25], false)

        # Calculate and join top 50%
        top_50 = calc_decile(data, :street_id, crime_col, index=0.50)
        # Create new name like :top_50_incidents_LARCENY
        new_col_sym_50 = Symbol("top_50_" * col_name_str)
        rename!(top_50, :is_top_crimes => new_col_sym_50)
        leftjoin!(data, top_50, on=:street_id)
        # Ensure Bool type and handle potential missings from join
        data[!, new_col_sym_50] = coalesce.(data[!, new_col_sym_50], false)
    end
end

# --- Jenks Natural Breaks Implementation (for general k) ---

# Helper to calculate sum of squared deviations (variance measure)
function sum_sq_dev(vals::AbstractVector{<:Number})
    n = length(vals)
    if n <= 1
        return 0.0
    end
    m = mean(vals)
    # Use Float64 for sum to avoid potential overflow with large counts/deviations
    ssdev = sum(Float64(x - m)^2 for x in vals)
    return ssdev
end

# Finds the optimal breaks for k classes using dynamic programming
# Based on the description from https://en.wikipedia.org/wiki/Jenks_natural_breaks_optimization
# Returns a vector of the break *values* (the lower bound of each class except the first)
function find_jenks_breaks(sorted_unique_data::AbstractVector{<:Number}, k::Int)
    n = length(sorted_unique_data)

    if k <= 0
        error("Number of classes (k) must be positive.")
    end
    if k > n
        @warn "k ($k) is greater than the number of unique data points ($n). Returning all unique data points as breaks."
        # Return all values except the first as nominal 'breaks' if k > n
        return n > 1 ? sorted_unique_data[2:end] : Float64[]
    end
    if k == 1
        # No breaks needed for a single class
        return Float64[]
    end

    # Precompute sum of squared deviations for all possible contiguous sub-sequences
    # ssm[i, j] stores the sum_sq_dev for data[i:j]
    ssm = zeros(Float64, n, n)
    for i in 1:n
        running_sum = 0.0
        running_sum_sq = 0.0
        for j in i:n
            val = Float64(sorted_unique_data[j])
            running_sum += val
            running_sum_sq += val * val
            count = j - i + 1
            if count > 0
                mean_val = running_sum / count
                # Variance = E[X^2] - (E[X])^2. Sum Sq Dev = Variance * N
                variance = (running_sum_sq / count) - (mean_val * mean_val)
                ssm[i, j] = variance * count
            else
                ssm[i, j] = 0.0 # Should not happen with count > 0 check, but safe
            end
        end
    end

    # Initialize dynamic programming matrices
    # dp[i, j] = minimum sum of squared deviations for first j data points using i classes
    # backtrack[i, j] = index of the last break for the optimal solution dp[i, j]
    dp = fill(Inf, k, n)
    backtrack = zeros(Int, k, n)

    # Initialize for the first class (i=1)
    for j in 1:n
        dp[1, j] = ssm[1, j]
        # No breaks needed for the first class, backtrack index is not meaningful here (or set to 0)
    end

    # Fill the DP table for classes 2 to k
    for i in 2:k
        for j in i:n # Need at least i points for i classes
            min_ssdev = Inf
            best_break_idx = -1
            # Consider all possible last breaks (index l) for class i ending at j
            # The previous i-1 classes must end at index l, where i-1 <= l < j
            for l in (i-1):(j-1)
                # Cost = cost of first i-1 classes ending at l + cost of class i from l+1 to j
                current_ssdev = dp[i-1, l] + ssm[l+1, j]
                if current_ssdev < min_ssdev
                    min_ssdev = current_ssdev
                    best_break_idx = l # Store the end index of the previous class
                end
            end
            dp[i, j] = min_ssdev
            backtrack[i, j] = best_break_idx
        end
    end

    # Reconstruct the breaks from the backtrack matrix
    breaks = zeros(Float64, k - 1)
    last_break_idx = n # Start from the end of the optimal solution for k classes, n points
    for i in k:-1:2
        break_point_idx = backtrack[i, last_break_idx]
        # The break value is the first element of the next class
        breaks[i-1] = sorted_unique_data[break_point_idx+1]
        last_break_idx = break_point_idx # Move to the end of the previous class partition
    end

    return breaks # Returns k-1 break values
end


# Main function to add Jenks classification columns (k=5, flagging top class)
function calc_top_crime_cols_jenks_manual!(data::DataFrame, crime_cols::Vector{Symbol}; k::Int=5)
    println("Calculating top crime groups using Manual Jenks (k=$k, flagging top class)...")
    for crime_col in crime_cols
        col_name_str = String(crime_col)
        println("  Processing column: $(col_name_str)")
        new_col_sym = Symbol("top_jenks_manual_" * col_name_str)

        counts = data[!, crime_col]
        # Ensure counts are numeric, handle potential non-numeric if necessary (though unlikely based on context)
        if !(eltype(counts) <: Number)
            @error "Column $(col_name_str) is not numeric. Skipping Jenks calculation."
            continue
        end
        unique_counts = sort(unique(filter(isfinite, counts))) # Get unique, finite values and sort

        # Handle edge cases
        if length(unique_counts) < k
            @warn "Skipping Jenks k=$k for $(col_name_str): Fewer than $k unique values ($(length(unique_counts)) unique). Setting all '$(new_col_sym)' to false."
            data[!, new_col_sym] .= false
            continue
        end

        try
            # Find the k-1 break points separating the k classes
            breaks = find_jenks_breaks(unique_counts, k)

            if isempty(breaks) && k > 1 # Check if find_jenks_breaks failed or k=1
                data[!, new_col_sym] .= false # Default to false
                @warn "Jenks threshold calculation failed or k=1 for $(col_name_str), setting all '$(new_col_sym)' to false."
            else
                # The threshold for the top (k-th) class is the last break value found
                # (which is the lower bound of the highest class)
                top_class_threshold = breaks[end]

                # Assign boolean based on count being >= threshold for the top class
                data[!, new_col_sym] = (counts .>= top_class_threshold)
                println("    Created column: $(new_col_sym) flagging top class (>= $(top_class_threshold))")
            end
        catch e
            @error "Error calculating Manual Jenks (k=$k) for column $(col_name_str): $e"
            data[!, new_col_sym] .= false # Default to false on error
            println("    Failed to create column $(new_col_sym) due to error, defaulting to false.")
        end
    end
    println("Finished calculating Manual Jenks (k=$k) based top crime groups.")
end
