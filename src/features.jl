
function create_street_features(
    crime_matched,
    place_matched,
    streets_geo,
    dataset_name::String;
    cooccurrence_pairs::Union{DataFrame,Nothing} = nothing,
    jaccard_threshold::Float64 = 0.80
)
    @info "Creating street-level feature matrix for $dataset_name..."

    # Get unique street identifiers
    all_streets = unique(streets_geo.street_id)

    @info "Found $(length(all_streets)) unique streets in the data"

    # Initialize feature matrix with street identifiers
    features = DataFrame(; street_id = all_streets)

    @info "Creating crime features..."

    # Group crimes by street and type
    crime_by_street = combine(groupby(crime_matched, [:street_id, :crime]), nrow => :count)

    # Pivot to wide format for crimes
    crime_wide = unstack(crime_by_street, :street_id, :crime, :count; fill = 0)

    # Rename crime columns with prefix
    for col in names(crime_wide)
        if col != "street_id"
            rename!(crime_wide, col => "crime_$(col)")
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
        if col != "street_id" && col != "street_name" && !startswith(String(col), "crime_")
            if eltype(features[!, col]) >: Missing
                features[!, col] = coalesce.(features[!, col], 0)
            end
        end
    end

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
        col != "street_id" &&
        col != "street_name" &&
        col != "total_crime"
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

    @info "Created base feature matrix with $(nrow(features)) streets and $(ncol(features)) features"

    # Add interaction terms (routine activities theory)
    @info "Adding place type interactions (routine activities theory)..."
    add_place_type_interactions!(
        features;
        standardize = true,
        cooccurrence_pairs = cooccurrence_pairs,
        jaccard_threshold = jaccard_threshold
    )

    # Log feature summary
    @info "Feature summary for $dataset_name:"
    @info "  Crime features: $(length(crime_cols))"
    @info "  Place features: $(length(place_cols))"
    @info "  Total features (with interactions): $(ncol(features))"
    @info "  Streets with crimes: $(sum(features.total_crime .> 0))"
    @info "  Streets with places: $(sum(features.total_places .> 0))"
    @info "  Streets with both: $(sum((features.total_crime .> 0) .& (features.total_places .> 0)))"

    # Add PCA components from raw place types BEFORE saving
    @info "Adding PCA components from raw place types..."
    pca_result = add_pca_components!(features, place_matched)

    # Save feature engineering report (now includes PC columns!)
    features_dir = joinpath(OUTPUT_DIR, "features")
    mkpath(features_dir)

    # Save feature matrix - now has complete features with PC components
    CSV.write(joinpath(features_dir, "$(dataset_name)_features.csv"), features)
    @info "Saved feature matrix to: $(features_dir)/$(dataset_name)_features.csv"

    # Return both features and PCA result for downstream use
    return (features = features, pca_result = pca_result)
end

"""
    fit_pca_model(place_matched::DataFrame; max_components=10, variance_threshold=0.99)

Fit PCA model on place type counts. This is the SINGLE SOURCE OF TRUTH for PCA.

Used by both:
- Feature engineering (create_street_features)
- Sensitivity analysis (diagnose_pca_components, jaccard sensitivity)

Returns a named tuple with:
- pca_model: Fitted MultivariateStats.PCA object
- transformed_components: PCA scores (n_streets × n_components)
- raw_type_columns: Place type names (for loading interpretation)
- place_type_matrix: Input matrix for debugging (standardized)
"""
function fit_pca_model(
    place_matched::DataFrame;
    max_components::Int = 10,
    variance_threshold::Float64 = 0.99
)
    if !("raw_type" in names(place_matched))
        @warn "No raw_type column in place_matched - skipping PCA"
        return nothing
    end

    raw_place_by_street = combine(
        groupby(place_matched, [:street_id, :raw_type]), nrow => :count
    )

    raw_place_types_wide = unstack(
        raw_place_by_street, :street_id, :raw_type, :count; fill = 0
    )

    raw_type_columns = [col for col in names(raw_place_types_wide) if col != "street_id"]

    @info "Found $(length(raw_type_columns)) unique raw place types for PCA"

    if length(raw_type_columns) < 3
        @warn "Insufficient raw place types for PCA (need at least 3) - skipping"
        return nothing
    end

    # Convert to Float64 matrix for standardization (StatsBase requires Float type)
    place_type_matrix = Float64.(Matrix(raw_place_types_wide[!, raw_type_columns])')

    # Standardize place type counts before PCA (z-score normalization)
    # This ensures all place types contribute equally regardless of their frequency
    # Without standardization, high-count types (e.g., max 1,217) dominate low-count types
    @info "Standardizing place type counts before PCA (z-score transformation)..."
    standardized_matrix = StatsBase.standardize(StatsBase.ZScoreTransform, place_type_matrix; dims=2)

    # Log standardization impact
    original_variances = [var(place_type_matrix[i, :]) for i in 1:size(place_type_matrix, 1)]
    standardized_variances = [var(standardized_matrix[i, :]) for i in 1:size(standardized_matrix, 1)]
    @info "Standardization complete:"
    @info "  Original variance range: $(round(minimum(original_variances), digits=2)) to $(round(maximum(original_variances), digits=2))"
    @info "  Standardized variance range: $(round(minimum(standardized_variances), digits=2)) to $(round(maximum(standardized_variances), digits=2))"

    components_limit = min(
        max_components, size(standardized_matrix, 1) - 1, size(standardized_matrix, 2) - 1
    )

    pca_model = fit(
        MultivariateStats.PCA,
        standardized_matrix;
        maxoutdim = components_limit,
        pratio = variance_threshold
    )

    components_retained = size(pca_model, 2)
    transformed_components = predict(pca_model, standardized_matrix)'

    @info "PCA retained $(components_retained) components explaining $(round(principalratio(pca_model)*100, digits=1))% of variance"

    component_variances = principalvars(pca_model)
    total_variance = var(pca_model)

    for component_index = 1:min(5, components_retained)
        variance_percent = round(
            100 * component_variances[component_index] / total_variance; digits = 1
        )
        @info "  PC_$(component_index) explains $(variance_percent)% of variance"
    end

    # Return all information needed for reuse
    return (
        pca_model = pca_model,
        transformed_components = transformed_components,
        raw_type_columns = raw_type_columns,
        place_type_matrix = standardized_matrix,
        street_ids = raw_place_types_wide.street_id
    )
end

function add_pca_components!(
    features::DataFrame,
    place_matched::DataFrame,
    max_components::Int = 10,
    variance_threshold::Float64 = 0.99
)::Union{Nothing, NamedTuple}
    # Use shared function to fit PCA (single source of truth)
    pca_result = fit_pca_model(
        place_matched;
        max_components = max_components,
        variance_threshold = variance_threshold
    )

    if pca_result === nothing
        return nothing
    end

    # Extract results from shared function
    transformed_components = pca_result.transformed_components
    street_ids = pca_result.street_ids
    components_retained = size(transformed_components, 2)

    # Build DataFrame with PC components and street IDs
    pca_components_df = DataFrame(; street_id = street_ids)
    for component_index = 1:components_retained
        pca_components_df[!, "PC_$(component_index)"] = transformed_components[:, component_index]
    end

    # Add PCA components directly to features DataFrame (in-place modification)
    for col in names(pca_components_df)
        if col != "street_id"
            # Create lookup dictionary for this component
            street_id_map = Dict(
                pca_components_df[i, :street_id] => pca_components_df[i, col]
                for i in 1:nrow(pca_components_df)
            )

            # Add column to features by looking up values
            features[!, col] = [
                get(street_id_map, street_id, missing) for street_id in features.street_id
            ]
        end
    end

    # Handle missing values (streets with no places get 0.0 for all components)
    for col in names(features)
        if startswith(String(col), "PC_") && eltype(features[!, col]) >: Missing
            features[!, col] = coalesce.(features[!, col], 0.0)
        end
    end

    @info "Added $(components_retained) PCA components to feature matrix"

    # Return pca_result for downstream use (diagnostics, etc.)
    return pca_result
end

function create_target_variables!(
    features::DataFrame;
    target_methods::Vector{String} = ["top25", "top50", "jenks"]
)::Vector{Symbol}
    @info "Creating target variables for all threshold methods: $(join(target_methods, ", "))"

    target_cols = Symbol[]

    for crime_cat in CRIME_CATEGORIES
        crime_col = "crime_$(crime_cat)"

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

                    # Filter to streets with crime to avoid zero-inflation effects
                    crime_streets = crime_values[crime_values .> 0]

                    if length(crime_streets) >= 3
                        # Use Jenks with k=3 classes (low, medium, high) on crime-experiencing streets
                        unique_vals = sort(unique(crime_streets))

                        if length(unique_vals) >= 3
                            breaks = calculate_jenks_breaks(unique_vals, 3)
                            threshold = breaks[end-1]  # Second break = medium + high tiers combined

                            # Log the natural groupings
                            n_elevated = sum(crime_streets .>= threshold)
                            pct_elevated = round(100 * n_elevated / length(crime_streets); digits=1)
                            @info "Jenks $(crime_cat): $(n_elevated) elevated crime streets (high + extreme tiers) out of $(length(crime_streets)) crime-experiencing streets ($(pct_elevated)%)"
                        else
                            # Fall back to top quartile if insufficient unique values
                            threshold = quantile(crime_streets, 0.75)
                            @warn "Insufficient unique values for Jenks in $(crime_cat) (only $(length(unique_vals))), using top 25% of crime streets"
                        end
                    else
                        # Fall back to top 25% if very few crime streets
                        threshold = quantile(crime_values, 0.75)
                        @warn "Too few crime-experiencing streets for Jenks in $(crime_cat) (only $(length(crime_streets))), using top 25% of all streets"
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

function calculate_jenks_breaks(values::Vector{Int64}, k::Int)::Vector{Int64}
    n = length(values)

    if n < k
        @warn "Not enough unique values ($(n)) for $(k) classes"
        return values[1:(end - 1)]  # Return all but last value as breaks
    end

    if k == 1
        return Int64[]
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
    breaks = Int64[]

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

function create_interaction_features!(features, base_cols, max_interactions = 5)
    @info "Creating interaction features from $(length(base_cols)) base columns..."

    interaction_count = 0

    for col in base_cols[1:min(3, length(base_cols))]  # Only first few to avoid explosion
        if col in names(features) && eltype(features[!, col]) <: Number
            new_col = Symbol("$(col)_squared")
            features[!, new_col] = features[!, col] .^ 2
            interaction_count += 1
        end
    end

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

function add_place_type_interactions!(
    features::DataFrame;
    standardize::Bool = true,
    cooccurrence_pairs::Union{DataFrame,Nothing} = nothing,
    jaccard_threshold::Float64 = 0.80
)
    @info "Creating place type interactions ..."

    # Identify place type columns (exclude crime, metadata, and derived features)
    place_cols = String[]
    for col in names(features)
        col_str = String(col)
        # Skip non-place columns
        if startswith(col_str, "crime_") ||
            startswith(col_str, "high_") ||
            startswith(col_str, "interact_") ||
            col in [
                "street_id",
                "street_name",
                "total_crime",
                "total_places",
                "crime_place_ratio",
                "commercial_activity"
            ]
            continue
        end
        # Include only the 12 mapped place categories (excluding OTHER)
        # These are direct column names from the pivoted place data
        if col in [
            "AUTOMOTIVE",
            "BUSINESS",
            "CULTURE",
            "EDUCATION",
            "ENTERTAINMENT_RECREATION",
            "FACILITIES",
            "FINANCE",
            "FOOD_DRINK",
            "GOVERNMENT",
            "HEALTH_WELLNESS",
            "LODGING",
            "NATURAL_FEATURE",
            "PLACE_OF_WORSHIP",
            "RESIDENTIAL",
            "SERVICES",
            "SHOPPING",
            "SPORTS",
            "TRANSPORTATION"
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
    working_cols = String[]
    if standardize
        @info "Standardizing place counts before creating interactions..."
        for col in place_cols
            if col in names(features) && eltype(features[!, col]) <: Number
                # Calculate standardized version (z-score)
                col_mean = mean(features[!, col])
                col_std = std(features[!, col])
                # Add small constant to avoid division by zero for constant columns
                std_col = "$(col)_std"
                features[!, std_col] = (features[!, col] .- col_mean) ./ (col_std + 1e-8)
                push!(working_cols, std_col)
            end
        end
    else
        working_cols = place_cols
    end

    # Determine which pairs to create based on selection method
    valid_pairs = Set{Tuple{String,String}}()

    if cooccurrence_pairs !== nothing
        # Use co-occurrence analysis (RQ2: empirically-grounded pairs)
        @info "Using co-occurrence analysis to select interaction pairs (Jaccard ≥ $jaccard_threshold)..."

        # Filter to high co-occurrence pairs, excluding non-place columns
        excluded_cols = [
            "total_crime",
            "street_length_meters",
            "place_density",
            "total_places",
            "crime_place_ratio",
            "commercial_activity"
        ]

        high_cooc = filter(
            row -> row.jaccard_similarity >= jaccard_threshold &&
                   !in(row.place1, excluded_cols) &&
                   !in(row.place2, excluded_cols),
            cooccurrence_pairs
        )

        # Create set of valid pairs (order doesn't matter)
        for row in eachrow(high_cooc)
            push!(valid_pairs, (row.place1, row.place2))
            push!(valid_pairs, (row.place2, row.place1))  # Add reverse for lookup
        end

        @info "Found $(length(valid_pairs)÷2) high co-occurrence pairs to test"
    else
        # Fallback: use prevalence threshold (old behavior)
        MIN_STREETS_FOR_INTERACTION = 50
        @info "No co-occurrence data provided, using prevalence threshold (≥$MIN_STREETS_FOR_INTERACTION streets)..."

        # Build valid_pairs set based on prevalence
        for i = 1:length(place_cols)
            for j = (i + 1):length(place_cols)
                col1_name = place_cols[i]
                col2_name = place_cols[j]

                col1_present = sum(features[!, col1_name] .> 0)
                col2_present = sum(features[!, col2_name] .> 0)

                if col1_present >= MIN_STREETS_FOR_INTERACTION &&
                   col2_present >= MIN_STREETS_FOR_INTERACTION
                    push!(valid_pairs, (col1_name, col2_name))
                    push!(valid_pairs, (col2_name, col1_name))
                end
            end
        end
    end

    # Create interactions for valid pairs
    interaction_count = 0
    interactions_created = String[]
    interactions_skipped = 0

    for i = 1:length(place_cols)
        for j = (i + 1):length(place_cols)
            col1_name = place_cols[i]
            col2_name = place_cols[j]

            # Use standardized columns if available
            col1 = standardize ? "$(col1_name)_std" : col1_name
            col2 = standardize ? "$(col2_name)_std" : col2_name

            # Check both columns exist and are numeric
            if col1 in names(features) &&
                col2 in names(features) &&
                eltype(features[!, col1]) <: Number &&
                eltype(features[!, col2]) <: Number

                # FEATURE SELECTION: Check if this pair should be created
                should_create = (col1_name, col2_name) in valid_pairs

                if should_create
                    # Create interaction name (use original names for clarity)
                    interaction_name = "interact_$(col1_name)_x_$(col2_name)"

                    # Calculate interaction as element-wise product
                    features[!, interaction_name] = features[!, col1] .* features[!, col2]

                    interaction_count += 1
                    push!(interactions_created, interaction_name)
                else
                    interactions_skipped += 1
                end
            end
        end
    end

    if interactions_skipped > 0
        @info "Skipped $interactions_skipped low co-occurrence or sparse interactions"
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
end
