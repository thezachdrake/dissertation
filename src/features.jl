
function create_street_features(
    crime_matched, place_matched, streets_geo, dataset_name::String
)
    @info "Creating street-level feature matrix for $dataset_name..."

    # Get unique street identifiers from both datasets
    crime_streets = unique(crime_matched.street_id)
    place_streets = unique(place_matched.street_id)
    all_streets = unique(vcat(crime_streets, place_streets))

    @info "Found $(length(all_streets)) unique streets in the data"

    # Initialize feature matrix with street identifiers
    features = DataFrame(; street_id = all_streets)

    # Add street names (take first occurrence)
    street_names = Dict()
    for df in [crime_matched, place_matched]
        if "street_name" in names(df)
            for row in eachrow(df)
                street_id_val = row[!, :street_id]
                street_name_val = row[!, :street_name]
                if !haskey(street_names, street_id_val)
                    street_names[street_id_val] = street_name_val
                end
            end
        end
    end

    features[!, :street_name] = [
        get(street_names, id, "Unknown") for id in features[!, :street_id]
    ]

    # === CRIME FEATURES ===
    @info "Creating crime features..."

    # Group crimes by street and type
    crime_by_street = combine(groupby(crime_matched, [:street_id, :crime]), nrow => :count)

    # Pivot to wide format for crimes
    crime_wide = unstack(crime_by_street, :street_id, :crime, :count; fill = 0)

    # Rename crime columns with prefix
    for col in names(crime_wide)
        if col != :street_id
            rename!(crime_wide, col => Symbol("crime_$(col)"))
        end
    end

    # Join crime features
    features = leftjoin(features, crime_wide; on = :street_id)

    # Fill missing crime counts with 0
    for col in names(features)
        if startswith(String(col), "crime_") && eltype(features[!, col]) >: Missing
            features[!, col] = coalesce.(features[!, col], 0)
        end
    end

    # === PLACE FEATURES ===
    @info "Creating place features..."

    # Group places by street and category
    place_by_street = combine(
        groupby(place_matched, [:street_id, :category]), nrow => :count
    )

    # Pivot to wide format for places
    place_wide = unstack(place_by_street, :street_id, :category, :count; fill = 0)

    # Join place features
    features = leftjoin(features, place_wide; on = :street_id)

    # Fill missing place counts with 0
    for col in names(features)
        if col != :street_id && col != :street_name && !startswith(String(col), "crime_")
            if eltype(features[!, col]) >: Missing
                features[!, col] = coalesce.(features[!, col], 0)
            end
        end
    end

    # === DERIVED FEATURES ===
    @info "Creating derived features..."

    # Total crime count per street
    crime_cols = [col for col in names(features) if startswith(String(col), "crime_")]
    if !isempty(crime_cols)
        features[!, :total_crime] = sum(eachcol(features[!, crime_cols]))
    else
        features[!, :total_crime] = zeros(Int, nrow(features))
    end

    # Total place count per street
    place_cols = [
        col for col in names(features) if !startswith(String(col), "crime_") &&
        col != :street_id &&
        col != :street_name &&
        col != :total_crime
    ]
    if !isempty(place_cols)
        features[!, :total_places] = sum(eachcol(features[!, place_cols]))
    else
        features[!, :total_places] = zeros(Int, nrow(features))
    end

    # Crime-to-place ratio (with small constant to avoid division by zero)
    # Crime-to-place ratio
    features[!, :crime_place_ratio] = features.total_crime ./ (features.total_places .+ 1)

    # Street length and place density features
    if !isnothing(streets_geo)
        @info "Adding street length and place density features..."

        # Calculate street lengths
        street_lengths = calculate_street_lengths(streets_geo)

        # Add street length to features
        features[!, :street_length_meters] = [
            get(street_lengths, id, 0.0) for id in features.street_id
        ]

        # Calculate place density (places per 100 meters)
        features[!, :place_density] = zeros(nrow(features))
        for i = 1:nrow(features)
            if features[i, :street_length_meters] > 0
                features[i, :place_density] =
                    (features[i, :total_places] / features[i, :street_length_meters]) * 100
            end
        end

        @info "Added street length and place density features"
    else
        @info "No street geometry provided - skipping length and density calculations"
    end

    # Commercial activity indicator (food, retail, services)
    commercial_cols = []
    for potential_col in [:FOOD_DRINK, :RETAIL, :SERVICES]
        if potential_col in names(features)
            push!(commercial_cols, potential_col)
        end
    end

    if !isempty(commercial_cols)
        features[!, :commercial_activity] = sum(eachcol(features[!, commercial_cols]))
    else
        features[!, :commercial_activity] = zeros(Int, nrow(features))
    end

    @info "Created base feature matrix with $(nrow(features)) streets and $(ncol(features)) features"

    # ALWAYS add interaction terms (routine activities theory)
    @info "Adding place type interactions (routine activities theory)..."
    add_place_type_interactions!(features; standardize = true)

    # Log feature summary
    @info "Feature summary for $dataset_name:"
    @info "  Crime features: $(length(crime_cols))"
    @info "  Place features: $(length(place_cols))"
    @info "  Total features (with interactions): $(ncol(features))"
    @info "  Streets with crimes: $(sum(features.total_crime .> 0))"
    @info "  Streets with places: $(sum(features.total_places .> 0))"
    @info "  Streets with both: $(sum((features.total_crime .> 0) .& (features.total_places .> 0)))"

    # Save feature engineering report
    features_dir = joinpath(OUTPUT_DIR, "features")
    mkpath(features_dir)

    # Save feature matrix
    CSV.write(joinpath(features_dir, "$(dataset_name)_features.csv"), features)
    @info "Saved feature matrix to: $(features_dir)/$(dataset_name)_features.csv"

    return features
end

"""
Create binary target variables for high-crime streets.

The "top25" and "top50" methods find the smallest set of streets containing
25% or 50% of total crime (not the top 25th percentile of streets). This captures
how crime concentrates in just a few places - often 50% of crime happens on
less than 5% of streets.

Example: If one street has 50 robberies out of 126 total, it alone might be
the entire "top25" group since it has 40% of all robberies.
"""
function create_target_variables!(features::DataFrame)::Vector{Symbol}
    # Always create all target methods - this is core to the methodology
    target_methods = ["top25", "top50", "median", "jenks"]
    @info "Creating target variables for all threshold methods: $(join(target_methods, ", "))"

    target_cols = Symbol[]

    for crime_cat in MODELING_CRIME_CATEGORIES
        crime_col = Symbol("crime_$(crime_cat)")

        if crime_col in names(features)
            crime_values = features[!, crime_col]

            # Create targets for each method
            for target_method in target_methods
                # Define target based on method
                if target_method == "top25"
                    # Cumulative proportion: smallest set of streets accounting for 25% of crime
                    sorted_indices = sortperm(crime_values; rev = true)
                    sorted_values = crime_values[sorted_indices]
                    total_crime = sum(sorted_values)

                    if total_crime > 0
                        cumsum_values = cumsum(sorted_values)
                        target_proportion = 0.25 * total_crime

                        # Find threshold: minimum value among streets in top 25% of crime
                        cutoff_idx = findfirst(x -> x >= target_proportion, cumsum_values)
                        if isnothing(cutoff_idx)
                            cutoff_idx = length(sorted_values)
                        end

                        # Threshold is the minimum crime count in the top group
                        threshold = sorted_values[cutoff_idx]

                        @info "Top 25% of $(crime_cat): $(cutoff_idx) streets ($(round(100*cutoff_idx/length(sorted_values), digits=1))% of streets) account for 25% of crime"
                    else
                        threshold = 0
                    end

                    target_col = Symbol("high_$(lowercase(crime_cat))_top25")

                elseif target_method == "top50"
                    # Cumulative proportion: smallest set of streets accounting for 50% of crime
                    sorted_indices = sortperm(crime_values; rev = true)
                    sorted_values = crime_values[sorted_indices]
                    total_crime = sum(sorted_values)

                    if total_crime > 0
                        cumsum_values = cumsum(sorted_values)
                        target_proportion = 0.50 * total_crime

                        # Find threshold: minimum value among streets in top 50% of crime
                        cutoff_idx = findfirst(x -> x >= target_proportion, cumsum_values)
                        if isnothing(cutoff_idx)
                            cutoff_idx = length(sorted_values)
                        end

                        # Threshold is the minimum crime count in the top group
                        threshold = sorted_values[cutoff_idx]

                        @info "Top 50% of $(crime_cat): $(cutoff_idx) streets ($(round(100*cutoff_idx/length(sorted_values), digits=1))% of streets) account for 50% of crime"
                    else
                        threshold = 0
                    end

                    target_col = Symbol("high_$(lowercase(crime_cat))_top50")

                elseif target_method == "median"
                    threshold = median(crime_values)
                    target_col = Symbol("high_$(lowercase(crime_cat))_median")

                elseif target_method == "jenks"
                    target_col = Symbol("high_$(lowercase(crime_cat))_jenks")
                    # Use Jenks natural breaks if enough variation exists
                    unique_vals = sort(unique(crime_values))
                    if length(unique_vals) >= 5
                        breaks = calculate_jenks_breaks(unique_vals, 5)
                        threshold = breaks[end]  # Highest break
                    else
                        # Fall back to top 25% if insufficient variation
                        threshold = quantile(crime_values, 0.75)
                        @warn "Insufficient variation for Jenks breaks in $(crime_cat), using top 25%"
                    end

                else
                    @warn "Unknown target_method: $(target_method). Skipping."
                    continue
                end

                # Create binary target
                features[!, target_col] = crime_values .>= threshold
                push!(target_cols, target_col)

                # Log summary
                n_positive = sum(features[!, target_col])
                pct_positive = round(100 * n_positive / nrow(features); digits = 1)

                # Calculate actual proportion of crime captured
                if target_method in ["top25", "top50"]
                    crime_in_group = sum(crime_values[crime_values .>= threshold])
                    total_crime = sum(crime_values)
                    if total_crime > 0
                        actual_proportion = round(
                            100 * crime_in_group / total_crime; digits = 1
                        )
                        @info "Created $(target_col): $(n_positive) streets ($(pct_positive)%) contain $(actual_proportion)% of crime"
                    else
                        @info "Created $(target_col): $(n_positive) streets ($(pct_positive)%) - no crime to measure"
                    end
                else
                    @info "Created $(target_col): $(n_positive) streets ($(pct_positive)%) above threshold $(round(threshold, digits=1))"
                end
            end

        else
            @warn "Crime column not found: $(crime_col)"
        end
    end

    @info "Created $(length(target_cols)) total target variables across $(length(target_methods)) methods"
    return target_cols
end

"""
Find natural breakpoints in data using Jenks optimization.

This finds the "natural" groupings in crime counts - places where there's a
big jump between groups. We use k=5 classes with the highest class being our
"hot spots". It's more data-driven than arbitrary percentiles.
"""
function calculate_jenks_breaks(values::Vector{Float64}, k::Int)::Vector{Float64}
    n = length(values)

    if n < k
        @warn "Not enough unique values ($(n)) for $(k) classes"
        return values[1:(end - 1)]  # Return all but last value as breaks
    end

    if k == 1
        return Float64[]
    end

    # Initialize matrices for dynamic programming
    # mat[i,j] = minimum sum of squared deviations for values[1:i] split into j classes
    mat = fill(Inf, n, k)

    # mat_breaks[i,j] = index of break point for optimal split of values[1:i] into j classes
    mat_breaks = zeros(Int, n, k)

    # Calculate sum of squared deviations from mean for single class
    for i = 1:n
        segment = values[1:i]
        mat[i, 1] = sum((segment .- mean(segment)) .^ 2)
    end

    # Dynamic programming to find optimal breaks
    for j = 2:k
        for i = j:n
            # Try all possible positions for the last break
            for m = (j - 1):(i - 1)
                # Calculate SSD for the new segment
                segment = values[(m + 1):i]
                cost = sum((segment .- mean(segment)) .^ 2)

                # Total cost is previous optimal + new segment cost
                total_cost = mat[m, j - 1] + cost

                # Update if this is better than current best
                if total_cost < mat[i, j]
                    mat[i, j] = total_cost
                    mat_breaks[i, j] = m
                end
            end
        end
    end

    # Backtrack to find the actual break points
    breaks = Float64[]

    # Start from the end and work backwards
    idx = n
    for j = k:-1:2
        break_idx = mat_breaks[idx, j]
        if break_idx > 0
            # The break value is the minimum of the next class
            pushfirst!(breaks, values[break_idx + 1])
            idx = break_idx
        end
    end

    return breaks
end

# Spatial features function removed - not needed for analysis

"""
    normalize_features!(features, feature_cols)

Normalize specified feature columns to have zero mean and unit variance.
Modifies the DataFrame in-place.

Arguments:

  - features: Feature DataFrame to modify
  - feature_cols: Vector of column names to normalize

Note: Only normalizes numeric columns, skips categorical/string columns
"""
function normalize_features!(features, feature_cols)
    @info "Normalizing $(length(feature_cols)) features..."

    normalized_count = 0

    for col in feature_cols
        if col in names(features) && eltype(features[!, col]) <: Number
            values = features[!, col]

            # Calculate mean and std, avoiding division by zero
            col_mean = mean(values)
            col_std = std(values)

            if col_std > 1e-10  # Only normalize if there's meaningful variation
                features[!, col] = (values .- col_mean) ./ col_std
                normalized_count += 1
            else
                @debug "Skipping normalization for $(col) - insufficient variation"
            end
        end
    end

    @info "Normalized $(normalized_count) features"
end

"""
Add polynomial and interaction terms between variables.

Creates squared terms and cross-products for the most important features.
Limits to max_interactions to avoid feature explosion.
"""
function create_interaction_features!(features, base_cols, max_interactions = 5)
    @info "Creating interaction features from $(length(base_cols)) base columns..."

    interaction_count = 0

    # Add square terms for key variables
    for col in base_cols[1:min(3, length(base_cols))]  # Only first few to avoid explosion
        if col in names(features) && eltype(features[!, col]) <: Number
            new_col = Symbol("$(col)_squared")
            features[!, new_col] = features[!, col] .^ 2
            interaction_count += 1
        end
    end

    # Add selected cross-products
    interactions_added = 0
    for i = 1:min(length(base_cols), 3)
        for j = (i + 1):min(length(base_cols), 3)
            if interactions_added >= max_interactions
                break
            end

            col1, col2 = base_cols[i], base_cols[j]

            if col1 in names(features) &&
                col2 in names(features) &&
                eltype(features[!, col1]) <: Number &&
                eltype(features[!, col2]) <: Number
                new_col = Symbol("$(col1)_x_$(col2)")
                features[!, new_col] = features[!, col1] .* features[!, col2]
                interaction_count += 1
                interactions_added += 1
            end
        end
        if interactions_added >= max_interactions
            break
        end
    end

    @info "Created $(interaction_count) interaction features"
end

# =============================================================================
# PCA Feature Creation - Alternative to category-based features
# =============================================================================

"""
    create_street_features_pca(crime_matched, place_matched)

Create street-level feature matrix using PCA on raw place types.
Parallel implementation to create_street_features() but using PCA.

This preserves all ~300+ raw Google place types and uses PCA for
dimensionality reduction instead of mapping to 12 categories.

Arguments:

  - crime_matched: DataFrame with crimes matched to streets
  - place_matched: DataFrame with places matched to streets (must have raw_type column)

Returns:

  - DataFrame: Feature matrix with PCA components instead of category counts

The function follows the same structure as create_street_features but applies
PCA to raw place types to capture latent patterns without predefined categories.
"""
function create_street_features_pca(
    crime_matched, place_matched, streets_geo, dataset_name::String
)
    @info "Creating PCA-based street feature matrix for $dataset_name..."

    # MultivariateStats is already imported at module level

    # Get unique streets (same as regular function)
    crime_streets = unique(crime_matched.street_id)
    place_streets = unique(place_matched.street_id)
    all_streets = unique(vcat(crime_streets, place_streets))

    @info "Found $(length(all_streets)) unique streets in the data"

    # Initialize feature matrix with street identifiers
    features = DataFrame(; street_id = all_streets)

    # Add street names (same logic as regular function)
    street_names = Dict()
    for df in [crime_matched, place_matched]
        if "street_name" in names(df)
            for row in eachrow(df)
                street_id_val = row[!, :street_id]
                street_name_val = row[!, :street_name]
                if !haskey(street_names, street_id_val)
                    street_names[street_id_val] = street_name_val
                end
            end
        end
    end
    features[!, :street_name] = [
        get(street_names, id, "Unknown") for id in features[!, :street_id]
    ]

    # === CRIME FEATURES (exactly the same as regular function) ===
    @info "Creating crime features..."

    # Group crimes by street and type
    crime_by_street = combine(groupby(crime_matched, [:street_id, :crime]), nrow => :count)

    # Pivot to wide format for crimes
    crime_wide = unstack(crime_by_street, :street_id, :crime, :count; fill = 0)

    # Rename crime columns with prefix
    for col in names(crime_wide)
        if col != :street_id
            rename!(crime_wide, col => Symbol("crime_$(col)"))
        end
    end

    # Join crime features
    features = leftjoin(features, crime_wide; on = :street_id)

    # Fill missing crime counts with 0
    for col in names(features)
        if startswith(String(col), "crime_") && eltype(features[!, col]) >: Missing
            features[!, col] = coalesce.(features[!, col], 0)
        end
    end

    # === RAW PLACE FEATURES WITH PCA ===
    @info "Creating raw place features and applying PCA..."

    # Check for raw_type column
    if !("raw_type" in names(place_matched))
        error(
            "place_matched must have 'raw_type' column. Update process_place_data() first."
        )
    end

    # Group places by street and raw type
    place_by_street = combine(
        groupby(place_matched, [:street_id, :raw_type]), nrow => :count
    )

    # Pivot to wide format for raw place types
    place_wide = unstack(place_by_street, :street_id, :raw_type, :count; fill = 0)

    # Get place type columns (exclude street_id)
    place_cols = [col for col in names(place_wide) if col != :street_id]

    @info "Found $(length(place_cols)) unique raw place types"

    # Apply PCA if we have enough features
    if length(place_cols) > 2
        @info "Applying PCA to reduce dimensions..."

        # Prepare matrix for PCA (features × observations format)
        X = Matrix(place_wide[!, place_cols])'

        # Fit PCA model (keep 95% variance or max 50 components)
        max_components = min(50, size(X, 1) - 1, size(X, 2) - 1)
        pca_model = fit(PCA, X; maxoutdim = max_components, pratio = 0.95)

        # Get number of components retained
        n_components = size(pca_model, 2)

        # Transform data back to observations × components
        X_pca = predict(pca_model, X)'

        @info "PCA retained $(n_components) components ($(round(principalratio(pca_model)*100, digits=1))% variance explained)"

        # Log variance explained by top components
        variances = principalvars(pca_model)
        total_var = var(pca_model)
        for i = 1:min(5, n_components)
            pct_var = round(100 * variances[i] / total_var; digits = 1)
            @info "  PC_$i explains $(pct_var)% of variance"
        end

        # Create DataFrame with PCA components
        pca_df = DataFrame(; street_id = place_wide.street_id)
        for i = 1:n_components
            pca_df[!, Symbol("PC_$i")] = X_pca[:, i]
        end

        # Replace place_wide with PCA results
        place_wide = pca_df
    else
        @warn "Not enough place types for PCA ($(length(place_cols))), using raw counts"
    end

    # Join PCA features to main feature matrix
    features = leftjoin(features, place_wide; on = :street_id)

    # Fill missing PC values with 0
    for col in names(features)
        if startswith(String(col), "PC_") && eltype(features[!, col]) >: Missing
            features[!, col] = coalesce.(features[!, col], 0)
        end
    end

    # === DERIVED FEATURES ===
    @info "Creating derived features..."

    # Total crime count per street (same as regular function)
    crime_cols = [col for col in names(features) if startswith(String(col), "crime_")]
    if !isempty(crime_cols)
        features[!, :total_crime] = sum(eachcol(features[!, crime_cols]))
    else
        features[!, :total_crime] = zeros(Int, nrow(features))
    end

    # Crime-to-PC1 ratio (PC1 often captures overall place density)
    if :PC_1 in names(features)
        features[!, :crime_pc1_ratio] = features.total_crime ./ (abs.(features.PC_1) .+ 1)
    end

    # Crime-to-place ratio (same as regular function)
    features[!, :crime_place_ratio] = features.total_crime ./ (features.total_places .+ 1)

    # Street length and place density features (same as regular function)
    if !isnothing(streets_geo)
        @info "Adding street length and place density features..."

        # Calculate street lengths
        street_lengths = calculate_street_lengths(streets_geo)

        # Add street length to features
        features[!, :street_length_meters] = [
            get(street_lengths, id, 0.0) for id in features.street_id
        ]

        # Calculate place density (places per 100 meters)
        features[!, :place_density] = zeros(nrow(features))
        for i = 1:nrow(features)
            if features[i, :street_length_meters] > 0
                features[i, :place_density] =
                    (features[i, :total_places] / features[i, :street_length_meters]) * 100
            end
        end

        @info "Added street length and place density features"
    else
        @info "No street geometry provided - skipping length and density calculations"
    end

    @info "Created PCA feature matrix with $(nrow(features)) streets and $(ncol(features)) features"

    # Log feature summary
    pc_cols = [col for col in names(features) if startswith(String(col), "PC_")]
    @info "Feature summary:"
    @info "  Crime features: $(length(crime_cols))"
    @info "  PCA components: $(length(pc_cols))"
    @info "  Streets with crimes: $(sum(features.total_crime .> 0))"

    return features
end

# =============================================================================
# Place Type Interactions - Routine Activities Theory Analysis
# =============================================================================

"""
Add interaction terms between place types (e.g., bars × restaurants).

Tests routine activities theory - crime happens when the right (wrong?) mix of
places come together. Creates all pairwise combinations of the 12 place categories
to see if certain combos predict crime better than individual counts.

Examples:

  - Bars × entertainment = nightlife districts
  - Shopping × transit = pickpocket paradise
  - Government × anything = more guardianship

Standardizes by default to help with interpretation.
"""
function add_place_type_interactions!(features::DataFrame; standardize::Bool = true)
    @info "Creating place type interactions for routine activities analysis..."

    # Identify place type columns (exclude crime, metadata, and derived features)
    place_cols = Symbol[]
    for col in names(features)
        col_str = String(col)
        # Skip non-place columns
        if startswith(col_str, "crime_") ||
            startswith(col_str, "high_") ||
            startswith(col_str, "interact_") ||
            col in [
                :street_id,
                :street_name,
                :total_crime,
                :total_places,
                :crime_place_ratio,
                :commercial_activity
            ]
            continue
        end
        # Include only the 12 mapped place categories (excluding OTHER)
        # These are direct column names from the pivoted place data
        if col in [
            :AUTOMOTIVE,
            :BUSINESS,
            :CULTURE,
            :EDUCATION,
            :ENTERTAINMENT_RECREATION,
            :FACILITIES,
            :FINANCE,
            :FOOD_DRINK,
            :GOVERNMENT,
            :HEALTH_WELLNESS,
            :LODGING,
            :NATURAL_FEATURE,
            :PLACE_OF_WORSHIP,
            :RESIDENTIAL,
            :SERVICES,
            :SHOPPING,
            :SPORTS,
            :TRANSPORTATION
        ]
            push!(place_cols, col)
        end
    end

    @info "Found $(length(place_cols)) place type categories for interaction analysis"

    if length(place_cols) < 2
        @warn "Insufficient place type columns for interactions (need at least 2)"
        return nothing
    end

    # Standardize place counts if requested (helps interpretation and reduces multicollinearity)
    working_cols = Symbol[]
    if standardize
        @info "Standardizing place counts before creating interactions..."
        for col in place_cols
            if col in names(features) && eltype(features[!, col]) <: Number
                # Calculate standardized version (z-score)
                col_mean = mean(features[!, col])
                col_std = std(features[!, col])
                # Add small constant to avoid division by zero for constant columns
                std_col = Symbol("$(col)_std")
                features[!, std_col] = (features[!, col] .- col_mean) ./ (col_std + 1e-8)
                push!(working_cols, std_col)
            end
        end
    else
        working_cols = place_cols
    end

    # Create pairwise interactions (excluding self-interactions)
    interaction_count = 0
    interactions_created = String[]

    for i = 1:length(place_cols)
        for j = (i + 1):length(place_cols)
            col1_name = place_cols[i]
            col2_name = place_cols[j]

            # Use standardized columns if available
            col1 = standardize ? Symbol("$(col1_name)_std") : col1_name
            col2 = standardize ? Symbol("$(col2_name)_std") : col2_name

            # Check both columns exist and are numeric
            if col1 in names(features) &&
                col2 in names(features) &&
                eltype(features[!, col1]) <: Number &&
                eltype(features[!, col2]) <: Number

                # Create interaction name (use original names for clarity)
                interaction_name = Symbol("interact_$(col1_name)_x_$(col2_name)")

                # Calculate interaction as element-wise product
                features[!, interaction_name] = features[!, col1] .* features[!, col2]

                interaction_count += 1
                push!(interactions_created, String(interaction_name))
            end
        end
    end

    # Clean up temporary standardized columns if created
    if standardize
        for col in working_cols
            if String(col)[(end - 3):end] == "_std"
                select!(features, Not(col))
            end
        end
    end

    @info "Created $(interaction_count) place type interaction features"

    # Log some example interactions for verification
    if length(interactions_created) > 0
        @info "Example interactions created:"
        for i = 1:min(5, length(interactions_created))
            @info "  - $(interactions_created[i])"
        end
        if length(interactions_created) > 5
            @info "  ... and $(length(interactions_created) - 5) more"
        end
    end

    # Log theoretical groupings found
    guardian_interactions = filter(
        x ->
            occursin("GOVERNMENT", x) ||
                occursin("EDUCATION", x) ||
                occursin("PLACE_OF_WORSHIP", x),
        interactions_created
    )

    target_interactions = filter(
        x -> occursin("SHOPPING", x) || occursin("FINANCE", x) || occursin("AUTOMOTIVE", x),
        interactions_created
    )

    convergence_interactions = filter(
        x ->
            occursin("FOOD_DRINK", x) && occursin("ENTERTAINMENT", x) ||
                occursin("LODGING", x) && occursin("ENTERTAINMENT", x),
        interactions_created
    )

    @info "Routine activities theory groupings:"
    @info "  Guardian-present interactions: $(length(guardian_interactions))"
    @info "  Target-rich interactions: $(length(target_interactions))"
    @info "  Convergence zone interactions: $(length(convergence_interactions))"
end
