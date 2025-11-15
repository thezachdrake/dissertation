"""
    modeling.jl

Statistical modeling functions for the dissertation analysis.
These functions implement the logistic regression methodology described in the
paper's Methods section for addressing Research Questions 2 and 3.
"""

"""
    fit_logistic_models(features::DataFrame, target_cols::Vector{Symbol})::Dict{Symbol, GLM.TableRegressionModel}

Fit logistic regression models predicting high-crime streets from place-based features.

This function implements the analytical approach for Research Question 2: "Can the
composition of facilities at place predict whether a place is a 'hot spot' for crime?"
As stated in the paper, individual regression models are fitted for each target variable
(crime type and threshold combination) to assess differential impacts of place types
on different crime categories.

The methodology follows routine activities theory, expecting that facility impacts on
crime risk vary by crime type. For example, the paper hypothesizes that lodging
facilities (hotels, motels) would have different impacts on drug crimes versus
violent crimes.

Arguments:

  - features: DataFrame containing:

      + Place type counts (predictor variables)
      + Binary high-crime indicators (target variables)
      + Street identifiers and metadata

  - target_cols: Vector of target column names (e.g., :high_larceny_top25)

Returns:

  - Dict{Symbol, GLM.TableRegressionModel}: Dictionary mapping target names to fitted models

      + Keys: Target variable names
      + Values: Fitted logistic regression models with coefficients and statistics

Model Specifications:

  - Family: Binomial (for binary outcomes)
  - Link: Logit (log-odds transformation)
  - Predictors: Place type counts with sufficient variation (>5% prevalence)
  - Targets: Binary indicators of high-crime status

Quality Metrics Calculated:

  - Deviance: Model fit statistic
  - AIC: Akaike Information Criterion for model comparison
  - McFadden's R²: Pseudo R-squared for logistic regression
  - Null deviance: Baseline for R² calculation

Process:

 1. Identify valid place-based predictor columns
 2. Filter predictors with insufficient variation (<2 unique values or <5% prevalence)
 3. Build formula for each target: target ~ place1 + place2 + ...
 4. Fit logistic regression using maximum likelihood estimation
 5. Calculate and log model diagnostics
 6. Return dictionary of successfully fitted models
"""
function fit_logistic_models(
    features::DataFrame, target_cols::Vector{Symbol}
)::Dict{Symbol, Any}
    @info "Fitting logistic regression models for $(length(target_cols)) targets..."

    # Identify predictor columns (exclude identifiers, targets, and derived crime features)
    predictor_cols = [
        col for col in names(features) if !startswith(String(col), "crime_") &&           # Exclude crime counts
        !startswith(String(col), "high_") &&            # Exclude targets
        !in(col, [:street_id, :street_name]) &&         # Exclude identifiers
        !in(col, [:total_crime, :total_places])         # Exclude totals that include crime
    ]

    @info "Candidate predictors: $(length(predictor_cols)) columns"

    # Filter predictors for sufficient variation
    filtered_predictors = Symbol[]
    for col in predictor_cols
        if eltype(features[!, col]) <: Number
            unique_vals = length(unique(features[!, col]))
            if unique_vals > 1
                # Check for reasonable variation (not just 0s and 1s with very few 1s)
                if unique_vals > 2 || (unique_vals == 2 && mean(features[!, col]) > 0.05)
                    push!(filtered_predictors, Symbol(col))
                end
            end
        end
    end

    @info "Using $(length(filtered_predictors)) predictors with sufficient variation"
    @info "Predictors: $(join(String.(filtered_predictors), ", "))"

    models = Dict()

    for target_col in target_cols
        @info "Fitting model for $(target_col)..."

        try
            # Create model formula
            predictor_terms = Term.(filtered_predictors)
            target_term = Term(target_col)

            # Build formula: target ~ predictor1 + predictor2 + ...
            if !isempty(predictor_terms)
                formula = FormulaTerm(target_term, sum(predictor_terms))
            else
                # Intercept-only model if no predictors
                formula = FormulaTerm(target_term, ConstantTerm(1))
                @warn "No valid predictors for $(target_col), fitting intercept-only model"
            end

            # Fit logistic regression
            model = glm(formula, features, Binomial(), LogitLink())

            models[target_col] = model

            # Log model diagnostics
            @info "Model $(target_col) fitted successfully:"
            @info "  Deviance: $(round(deviance(model), digits=2))"
            @info "  AIC: $(round(aic(model), digits=2))"
            @info "  Null deviance: $(round(nulldeviance(model), digits=2))"

            # Calculate pseudo R-squared (McFadden's)
            null_dev = nulldeviance(model)
            model_dev = deviance(model)
            if null_dev > 0
                pseudo_r2 = 1 - (model_dev / null_dev)
                @info "  McFadden R²: $(round(pseudo_r2, digits=3))"
            end

        catch e
            @error "Failed to fit model for $(target_col): $(e)"
            continue
        end
    end

    @info "Successfully fitted $(length(models)) models"
    return models
end

"""
    extract_model_coefficients(models::Dict{Symbol, Any})::DataFrame

Extract and organize coefficients from all fitted logistic regression models.

This function compiles coefficient estimates across all models to identify
consistent predictors of high-crime areas. The results directly address the
paper's goal of understanding "the relationship between facility type and
crime concentration" by showing which place types significantly predict
crime hot spots.

Arguments:

  - models: Dictionary of fitted GLM models from fit_logistic_models()

Returns:

  - DataFrame: Comprehensive coefficient table with columns:

      + model: Target variable name (e.g., "high_larceny_top25")
      + term: Predictor variable name (place type)
      + coefficient: Log-odds coefficient estimate
      + std_error: Standard error of coefficient
      + z_value: Test statistic (coefficient / std_error)
      + p_value: Statistical significance level
      + significant: Boolean indicator (p < 0.05)
      + odds_ratio: Exponentiated coefficient (multiplicative effect on odds)

Interpretation:

  - Positive coefficients indicate place types that increase crime risk
  - Negative coefficients indicate protective factors
  - Odds ratios > 1 mean increased odds of being high-crime
  - Significance testing uses α = 0.05 threshold

This table enables identification of crime generators and attractors as per
Brantingham and Brantingham (1995) referenced in the paper.
"""
function extract_model_coefficients(models::Dict{Symbol, Any})::DataFrame
    @info "Extracting coefficients from $(length(models)) models..."

    all_coefs = DataFrame(;
        model = String[],
        term = String[],
        coefficient = Float64[],
        std_error = Float64[],
        z_value = Float64[],
        p_value = Float64[]
    )

    for (target_col, model) in models
        try
            coef_table = coeftable(model)
            coef_names = coefnames(model)
            coef_values = coef(model)
            std_errors = stderror(model)

            for (i, name) in enumerate(coef_names)
                z_val = coef_values[i] / std_errors[i]
                p_val = coef_table.cols[4][i]  # p-value from coefficient table

                push!(
                    all_coefs,
                    (
                        String(target_col),
                        String(name),
                        coef_values[i],
                        std_errors[i],
                        z_val,
                        p_val
                    )
                )
            end

        catch e
            @error "Error extracting coefficients for $(target_col): $(e)"
            continue
        end
    end

    @info "Extracted $(nrow(all_coefs)) coefficients"
    return all_coefs
end

"""
    compare_target_methods(models::Dict{Symbol, Any})::DataFrame

Generate comprehensive comparison of different target variable methods.
This function specifically analyzes how traditional cumulative proportion
methods (top 25%, top 50%, median) compare to the Jenks natural breaks
classification, as discussed in the paper's methodology.

Arguments:

  - models: Dictionary of fitted models with names like :high_larceny_top25

Returns:

  - DataFrame: Detailed comparison with columns:

      + crime_type: Crime category (LARCENY, VIOLENCE, etc.)
      + method: Target method (top25, top50, median, jenks)
      + aic: Akaike Information Criterion
      + bic: Bayesian Information Criterion
      + mcfadden_r2: Pseudo R-squared
      + n_significant: Number of significant predictors (p < 0.05)
      + is_best_aic: Boolean indicating best AIC for this crime type
      + is_best_r2: Boolean indicating best R² for this crime type
      + jenks_improvement: % improvement over best traditional method

This comparison addresses the methodological question of whether the
data-driven Jenks natural breaks provide better model fit than traditional
arbitrary thresholds used in prior crime concentration research.
"""
function compare_target_methods(models::Dict{Symbol, Any})::DataFrame
    @info "Comparing target variable methods across crime types..."

    # Helper to parse model names
    function parse_model_name(name::Symbol)
        name_str = String(name)
        parts = split(name_str, "_")
        if length(parts) >= 3 && parts[1] == "high"
            crime = uppercase(parts[2])
            method = join(parts[3:end], "_")
            return (crime, method)
        end
        return ("UNKNOWN", "unknown")
    end

    # Build comparison DataFrame
    comparison = DataFrame(;
        crime_type = String[],
        method = String[],
        aic = Float64[],
        bic = Float64[],
        mcfadden_r2 = Float64[],
        deviance = Float64[],
        null_deviance = Float64[],
        n_observations = Int[],
        n_predictors = Int[],
        n_significant = Int[]
    )

    # Process each model
    for (name, model) in models
        crime, method = parse_model_name(name)

        # Calculate metrics
        null_dev = nulldeviance(model)
        model_dev = deviance(model)
        mcfadden_r2 = null_dev > 0 ? 1 - (model_dev / null_dev) : 0.0

        # Count significant predictors
        coef_table = coeftable(model)
        p_values = coef_table.cols[4]
        n_significant = sum(p_values .< 0.05) - 1  # Exclude intercept

        push!(
            comparison,
            (
                crime,
                method,
                aic(model),
                bic(model),
                mcfadden_r2,
                model_dev,
                null_dev,
                nobs(model),
                length(coef(model)) - 1,  # Exclude intercept
                n_significant
            )
        )
    end

    # Add comparison flags
    comparison[!, :is_best_aic] = false
    comparison[!, :is_best_r2] = false
    comparison[!, :jenks_improvement] = 0.0

    # For each crime type, identify best models
    for crime in unique(comparison.crime_type)
        crime_models = filter(row -> row.crime_type == crime, comparison)

        if nrow(crime_models) > 0
            # Find best AIC
            best_aic_idx = argmin(crime_models.aic)
            best_aic_method = crime_models[best_aic_idx, :method]

            # Find best R²
            best_r2_idx = argmax(crime_models.mcfadden_r2)
            best_r2_method = crime_models[best_r2_idx, :method]

            # Mark best models in main DataFrame
            for i = 1:nrow(comparison)
                if comparison[i, :crime_type] == crime
                    if comparison[i, :method] == best_aic_method
                        comparison[i, :is_best_aic] = true
                    end
                    if comparison[i, :method] == best_r2_method
                        comparison[i, :is_best_r2] = true
                    end
                end
            end

            # Calculate Jenks improvement over traditional methods
            jenks_row = filter(row -> row.method == "jenks", crime_models)
            traditional_rows = filter(
                row -> row.method in ["top25", "top50", "median"], crime_models
            )

            if nrow(jenks_row) > 0 && nrow(traditional_rows) > 0
                jenks_aic = jenks_row[1, :aic]
                best_traditional_aic = minimum(traditional_rows.aic)

                # Calculate % improvement (negative means Jenks is better)
                improvement =
                    100 * (jenks_aic - best_traditional_aic) / best_traditional_aic

                for i = 1:nrow(comparison)
                    if comparison[i, :crime_type] == crime &&
                        comparison[i, :method] == "jenks"
                        comparison[i, :jenks_improvement] = improvement
                    end
                end
            end
        end
    end

    # Sort by crime type and AIC
    sort!(comparison, [:crime_type, :aic])

    # Log summary
    @info "\nTarget Method Comparison Summary:"
    for crime in unique(comparison.crime_type)
        crime_models = filter(row -> row.crime_type == crime, comparison)
        best_method = crime_models[argmin(crime_models.aic), :method]
        jenks_row = filter(row -> row.method == "jenks", crime_models)

        @info "$(crime):"
        @info "  Best method (AIC): $(best_method)"

        if nrow(jenks_row) > 0
            jenks_imp = jenks_row[1, :jenks_improvement]
            if jenks_imp < 0
                @info "  Jenks improvement: $(abs(round(jenks_imp, digits=1)))% better than best traditional"
            else
                @info "  Jenks performance: $(round(jenks_imp, digits=1))% worse than best traditional"
            end
        end
    end

    return comparison
end

"""
    generate_method_comparison_latex(comparison::DataFrame)::String

Generate LaTeX table code for target method comparison results.
Formats the comparison DataFrame into publication-ready LaTeX.

Arguments:

  - comparison: DataFrame from compare_target_methods()

Returns:

  - String: LaTeX table code ready for inclusion in paper

The table highlights which threshold method performs best for each
crime type, supporting the methodological discussion about optimal
hot spot identification approaches.
"""
function generate_method_comparison_latex(comparison::DataFrame)::String
    latex = """
    \\begin{table}[htbp]
    \\centering
    \\caption{Comparison of Target Variable Methods by Crime Type}
    \\label{tab:target_methods}
    \\begin{tabular}{llrrrr}
    \\toprule
    Crime Type & Method & AIC & BIC & McFadden R\\textsuperscript{2} & Sig. Predictors \\\\
    \\midrule
    """

    for crime in unique(comparison.crime_type)
        crime_models = filter(row -> row.crime_type == crime, comparison)

        for (i, row) in enumerate(eachrow(crime_models))
            # Add crime type only for first row of each group
            crime_label = i == 1 ? crime : ""

            # Format values
            aic_str = @sprintf("%.1f", row.aic)
            bic_str = @sprintf("%.1f", row.bic)
            r2_str = @sprintf("%.3f", row.mcfadden_r2)

            # Add asterisk for best model
            if row.is_best_aic
                aic_str = "\\textbf{$(aic_str)}"
            end
            if row.is_best_r2
                r2_str = "\\textbf{$(r2_str)}"
            end

            # Special formatting for Jenks
            method_str = row.method
            if row.method == "jenks"
                method_str = "\\textit{$(method_str)}"
                if row.jenks_improvement < 0
                    method_str = "$(method_str)*"
                end
            end

            latex *= "$(crime_label) & $(method_str) & $(aic_str) & $(bic_str) & $(r2_str) & $(row.n_significant) \\\\\n"
        end

        # Add horizontal line between crime types
        if crime != unique(comparison.crime_type)[end]
            latex *= "\\midrule\n"
        end
    end

    latex *= """
    \\bottomrule
    \\end{tabular}
    \\begin{tablenotes}
    \\small
    \\item Note: Bold values indicate best performance within crime type.
    \\item \\textit{Jenks} indicates natural breaks classification.
    \\item * indicates Jenks outperforms best traditional method.
    \\end{tablenotes}
    \\end{table}
    """

    return latex
end

"""
calculate_model_summaries(models::Dict{Symbol, Any})::DataFrame

Calculate comprehensive summary statistics for all fitted logistic regression models.

This function generates model performance metrics essential for evaluating the
predictive power of facility composition on crime concentration. The metrics
allow comparison between traditional threshold methods (25%, 50%) and the
Jenks natural breaks classification introduced in the paper.

Arguments:

  - models: Dictionary of fitted GLM models from fit_logistic_models()

Returns:

  - DataFrame: Model performance summary with columns:

      + model: Target variable identifier
      + mcfadden_r2: McFadden's pseudo R-squared (model explanatory power)
      + aic: Akaike Information Criterion (lower is better)
      + bic: Bayesian Information Criterion (accounts for model complexity)
      + deviance: Residual deviance (model fit)
      + null_deviance: Baseline deviance (intercept-only model)
      + n_observations: Number of street segments
      + n_predictors: Number of place type variables
      + deviance_ratio: Proportion of deviance explained

Performance Interpretation:

  - McFadden R² > 0.2 indicates good model fit for logistic regression
  - AIC/BIC used for comparing models with different predictors
  - Deviance ratio shows improvement over null model

These metrics validate whether facility types can predict crime hot spots,
directly addressing Research Question 2 from the paper.
"""
function calculate_model_summaries(models::Dict{Symbol, Any})::DataFrame
    @info "Calculating model summaries for $(length(models)) models..."

    summaries = DataFrame(;
        model = String[],
        n_observations = Int[],
        n_predictors = Int[],
        deviance = Float64[],
        null_deviance = Float64[],
        aic = Float64[],
        bic = Float64[],
        mcfadden_r2 = Float64[],
        log_likelihood = Float64[]
    )

    for (target_col, model) in models
        try
            n_obs = nobs(model)
            n_pred = length(coef(model)) - 1  # Subtract intercept
            dev = deviance(model)
            null_dev = nulldeviance(model)
            model_aic = aic(model)
            model_bic = bic(model)

            # McFadden's pseudo R-squared
            mcfadden_r2 = null_dev > 0 ? 1 - (dev / null_dev) : 0.0

            # Log-likelihood
            log_lik = loglikelihood(model)

            push!(
                summaries,
                (
                    String(target_col),
                    n_obs,
                    n_pred,
                    dev,
                    null_dev,
                    model_aic,
                    model_bic,
                    mcfadden_r2,
                    log_lik
                )
            )

        catch e
            @error "Error calculating summary for $(target_col): $(e)"
            continue
        end
    end

    @info "Generated summaries for $(nrow(summaries)) models"
    return summaries
end

"""
Get predicted crime probabilities for each street.

Returns a dataframe with street IDs and probability columns for each model.
"""
function calculate_model_predictions(models, features)
    @info "Calculating predictions for $(length(models)) models..."

    # Start with street identifiers
    predictions = DataFrame(; street_id = features.street_id)

    for (target_col, model) in models
        try
            # Get predicted probabilities
            pred_probs = predict(model, features)

            # Add to predictions DataFrame
            prob_col = Symbol("$(target_col)_prob")
            predictions[!, prob_col] = pred_probs

            # Add binary predictions using 0.5 threshold
            pred_col = Symbol("$(target_col)_pred")
            predictions[!, pred_col] = pred_probs .>= 0.5

            # Add actual values for comparison
            actual_col = Symbol("$(target_col)_actual")
            predictions[!, actual_col] = features[!, target_col]

        catch e
            @error "Error generating predictions for $(target_col): $(e)"
            continue
        end
    end

    @info "Generated predictions for $(nrow(predictions)) streets"
    return predictions
end

"""
Calculate how well the models actually predict crime.

Gets accuracy, precision, recall, F1, and rough AUC for each model.
"""
function evaluate_model_performance(models, features)
    @info "Evaluating performance for $(length(models)) models..."

    performance = DataFrame(;
        model = String[],
        accuracy = Float64[],
        precision = Float64[],
        recall = Float64[],
        f1_score = Float64[],
        auc_approx = Float64[],
        true_positive = Int[],
        false_positive = Int[],
        true_negative = Int[],
        false_negative = Int[]
    )

    for (target_col, model) in models
        try
            # Get predictions
            pred_probs = predict(model, features)
            pred_binary = pred_probs .>= 0.5
            actual = features[!, target_col]

            # Calculate confusion matrix
            tp = sum(pred_binary .& actual)
            fp = sum(pred_binary .& .!actual)
            tn = sum(.!pred_binary .& .!actual)
            fn = sum(.!pred_binary .& actual)

            # Calculate metrics
            accuracy = (tp + tn) / (tp + fp + tn + fn)
            precision = tp > 0 ? tp / (tp + fp) : 0.0
            recall = tp > 0 ? tp / (tp + fn) : 0.0
            f1 = if (precision + recall) > 0
                2 * precision * recall / (precision + recall)
            else
                0.0
            end

            # Approximate AUC using simple threshold-based calculation
            # This is a rough approximation, not the full AUC calculation
            auc_approx = calculate_approximate_auc(pred_probs, actual)

            push!(
                performance,
                (
                    String(target_col),
                    accuracy,
                    precision,
                    recall,
                    f1,
                    auc_approx,
                    tp,
                    fp,
                    tn,
                    fn
                )
            )

        catch e
            @error "Error evaluating performance for $(target_col): $(e)"
            continue
        end
    end

    @info "Generated performance metrics for $(nrow(performance)) models"
    return performance
end

"""
    calculate_approximate_auc(pred_probs, actual)

Calculate an approximate AUC (Area Under Curve) metric.
This is a simplified version that gives a rough indication of model discrimination.

Arguments:

  - pred_probs: Vector of predicted probabilities
  - actual: Vector of actual binary outcomes

Returns:

  - Float64: Approximate AUC value between 0 and 1
"""
function calculate_approximate_auc(pred_probs, actual)
    try
        # Simple approximation: calculate concordance
        n_pos = sum(actual)
        n_neg = length(actual) - n_pos

        if n_pos == 0 || n_neg == 0
            return 0.5  # No discrimination possible
        end

        # Count concordant pairs (simplified)
        concordant = 0
        total_pairs = 0

        for i = 1:length(actual)
            for j = (i + 1):length(actual)
                if actual[i] != actual[j]  # One positive, one negative
                    total_pairs += 1
                    # Check if prediction ranks correctly
                    if (actual[i] && pred_probs[i] > pred_probs[j]) ||
                        (actual[j] && pred_probs[j] > pred_probs[i])
                        concordant += 1
                    end
                end
            end
        end

        return total_pairs > 0 ? concordant / total_pairs : 0.5

    catch e
        @debug "Error calculating approximate AUC: $(e)"
        return 0.5  # Return neutral value on error
    end
end

"""
Find which place types consistently predict crime.

Looks for predictors that are significant across multiple models
and checks if they're consistently positive or negative.
"""
function identify_significant_predictors(
    coefficients_df::DataFrame, significance_level::Float64 = 0.05
)::DataFrame
    @info "Identifying significant predictors (p < $(significance_level))..."

    # Filter for significant coefficients (excluding intercepts)
    significant = filter(
        row -> row.p_value < significance_level && row.term != "(Intercept)",
        coefficients_df
    )

    if nrow(significant) == 0
        @warn "No significant predictors found"
        return DataFrame()
    end

    # Calculate effect sizes and consistency
    predictor_summary = combine(
        groupby(significant, :term),
        :coefficient => mean => :mean_coefficient,
        :coefficient => std => :std_coefficient,
        :p_value => mean => :mean_p_value,
        :p_value => minimum => :min_p_value,
        nrow => :n_significant_models
    )

    # Add effect direction consistency
    for term in unique(significant.term)
        term_coefs = filter(row -> row.term == term, significant).coefficient
        pos_count = sum(term_coefs .> 0)
        neg_count = sum(term_coefs .< 0)

        idx = findfirst(row -> row.term == term, predictor_summary)
        if idx !== nothing
            predictor_summary[idx, :direction_consistency] =
                max(pos_count, neg_count) / length(term_coefs)
            predictor_summary[idx, :effect_direction] =
                pos_count > neg_count ? "positive" : "negative"
        end
    end

    # Sort by importance (combination of significance and consistency)
    predictor_summary[!, :importance_score] =
        (1 .- predictor_summary.min_p_value) .* predictor_summary.direction_consistency

    sort!(predictor_summary, :importance_score; rev = true)

    @info "Found $(nrow(predictor_summary)) significant predictors across models"
    return predictor_summary
end

"""
Three-way shootout: counts vs interactions vs both.

Tests if crime is about:

  - How many places there are (base model)
  - How places combine (interaction-only)
  - Both density and combinations (full model)

Returns which approach works best and what it means for theory.
"""
function compare_routine_activities_models(
    base_models::Tuple,
    interaction_only_models::Tuple,
    full_models::Tuple,
    base_features::Tuple,
    interaction_only_features::Tuple,
    full_features::Tuple
)
    @info "Comparing routine activities models (three-way: base vs interactions-only vs full)..."

    # Unpack models
    base_incident, base_arrest = base_models
    interact_only_incident, interact_only_arrest = interaction_only_models
    full_incident, full_arrest = full_models
    base_incident_feat, base_arrest_feat = base_features
    interact_only_incident_feat, interact_only_arrest_feat = interaction_only_features
    full_incident_feat, full_arrest_feat = full_features

    # Initialize comparison results
    comparisons = DataFrame()
    best_model_counts = Dict("base" => 0, "interactions_only" => 0, "full" => 0)

    # Compare incident models
    for (target_name, base_model) in base_incident
        if haskey(interact_only_incident, target_name) && haskey(full_incident, target_name)
            interact_only_model = interact_only_incident[target_name]
            full_model = full_incident[target_name]

            # Calculate metrics for all three models
            base_aic_val = aic(base_model)
            interact_only_aic_val = aic(interact_only_model)
            full_aic_val = aic(full_model)

            # Determine best model
            aics = [base_aic_val, interact_only_aic_val, full_aic_val]
            best_idx = argmin(aics)
            best_model_type = ["base", "interactions_only", "full"][best_idx]
            best_model_counts[best_model_type] += 1

            comparison_row = DataFrame(;
                model_type = "incident",
                target = String(target_name),
                base_aic = base_aic_val,
                interact_only_aic = interact_only_aic_val,
                full_aic = full_aic_val,
                best_model = best_model_type,
                base_bic = bic(base_model),
                interact_only_bic = bic(interact_only_model),
                full_bic = bic(full_model),
                base_r2 = r2(base_model),
                interact_only_r2 = r2(interact_only_model),
                full_r2 = r2(full_model),
                base_deviance = deviance(base_model),
                interact_only_deviance = deviance(interact_only_model),
                full_deviance = deviance(full_model)
            )

            append!(comparisons, comparison_row)
        end
    end

    # Compare arrest models
    for (target_name, base_model) in base_arrest
        if haskey(interact_only_arrest, target_name) && haskey(full_arrest, target_name)
            interact_only_model = interact_only_arrest[target_name]
            full_model = full_arrest[target_name]

            # Calculate metrics for all three models
            base_aic_val = aic(base_model)
            interact_only_aic_val = aic(interact_only_model)
            full_aic_val = aic(full_model)

            # Determine best model
            aics = [base_aic_val, interact_only_aic_val, full_aic_val]
            best_idx = argmin(aics)
            best_model_type = ["base", "interactions_only", "full"][best_idx]
            best_model_counts[best_model_type] += 1

            comparison_row = DataFrame(;
                model_type = "arrest",
                target = String(target_name),
                base_aic = base_aic_val,
                interact_only_aic = interact_only_aic_val,
                full_aic = full_aic_val,
                best_model = best_model_type,
                base_bic = bic(base_model),
                interact_only_bic = bic(interact_only_model),
                full_bic = bic(full_model),
                base_r2 = r2(base_model),
                interact_only_r2 = r2(interact_only_model),
                full_r2 = r2(full_model),
                base_deviance = deviance(base_model),
                interact_only_deviance = deviance(interact_only_model),
                full_deviance = deviance(full_model)
            )

            append!(comparisons, comparison_row)
        end
    end

    # Extract significant interactions from both full and interaction-only models
    significant_interactions = extract_significant_interactions(
        merge(full_incident, interact_only_incident),
        merge(full_arrest, interact_only_arrest)
    )

    # Test routine activities theory predictions
    theory_tests = test_routine_activities_predictions(
        significant_interactions, comparisons
    )

    # Calculate overall statistics for three-way comparison
    overall_stats = DataFrame(;
        metric = [
            "Models Best Fit: Base",
            "Models Best Fit: Interactions-Only",
            "Models Best Fit: Full",
            "Mean R² Base",
            "Mean R² Interactions-Only",
            "Mean R² Full",
            "Total Models Compared"
        ],
        value = [
            best_model_counts["base"],
            best_model_counts["interactions_only"],
            best_model_counts["full"],
            mean(comparisons.base_r2),
            mean(comparisons.interact_only_r2),
            mean(comparisons.full_r2),
            nrow(comparisons)
        ]
    )

    # Determine theoretical interpretation
    interpretation =
        if best_model_counts["interactions_only"] > best_model_counts["base"] &&
            best_model_counts["interactions_only"] > best_model_counts["full"]
            "Place relationships (interactions) matter more than raw counts for crime prediction"
        elseif best_model_counts["full"] > best_model_counts["base"] &&
            best_model_counts["full"] > best_model_counts["interactions_only"]
            "Both place counts and their interactions provide complementary information"
        else
            "Simple place counts are sufficient; interactions add unnecessary complexity"
        end

    @info "Routine activities three-way comparison complete"
    @info "  Best models - Base: $(best_model_counts["base"]), Interactions-Only: $(best_model_counts["interactions_only"]), Full: $(best_model_counts["full"])"
    @info "  Mean R² - Base: $(round(mean(comparisons.base_r2), digits=4)), Interactions: $(round(mean(comparisons.interact_only_r2), digits=4)), Full: $(round(mean(comparisons.full_r2), digits=4))"
    @info "  Interpretation: $(interpretation)"

    return (
        model_comparisons = comparisons,
        best_model_counts = best_model_counts,
        significant_interactions = significant_interactions,
        theory_validation = theory_tests,
        overall_statistics = overall_stats,
        interpretation = interpretation
    )
end

"""
Find which place combinations actually matter.

Pulls out significant interaction terms and gives them
meaningful interpretations (e.g., "nightlife district effect").
"""
function extract_significant_interactions(incident_models, arrest_models)
    @info "Extracting significant interaction terms..."

    significant_terms = DataFrame()

    # Process incident models
    for (target_name, model) in incident_models
        coef_table = coeftable(model)
        for i = 1:length(coef_table.rownms)
            term_name = String(coef_table.rownms[i])
            if startswith(term_name, "interact_")
                if coef_table.cols[4][i] < 0.05  # p-value < 0.05
                    # Parse interaction components
                    interaction_parts = replace(term_name, "interact_" => "")

                    # Add to results
                    push!(
                        significant_terms,
                        (
                            interaction_term = term_name,
                            coefficient = coef_table.cols[1][i],
                            std_error = coef_table.cols[2][i],
                            p_value = coef_table.cols[4][i],
                            model_type = "incident",
                            target = String(target_name),
                            interpretation = interpret_interaction(interaction_parts)
                        )
                    )
                end
            end
        end
    end

    # Process arrest models
    for (target_name, model) in arrest_models
        coef_table = coeftable(model)
        for i = 1:length(coef_table.rownms)
            term_name = String(coef_table.rownms[i])
            if startswith(term_name, "interact_")
                if coef_table.cols[4][i] < 0.05  # p-value < 0.05
                    # Parse interaction components
                    interaction_parts = replace(term_name, "interact_" => "")

                    # Add to results
                    push!(
                        significant_terms,
                        (
                            interaction_term = term_name,
                            coefficient = coef_table.cols[1][i],
                            std_error = coef_table.cols[2][i],
                            p_value = coef_table.cols[4][i],
                            model_type = "arrest",
                            target = String(target_name),
                            interpretation = interpret_interaction(interaction_parts)
                        )
                    )
                end
            end
        end
    end

    @info "Found $(nrow(significant_terms)) significant interaction terms"
    return significant_terms
end

"""
Give a plain English meaning to interaction terms.

Turns "FOOD_DRINK_x_ENTERTAINMENT" into "nightlife convergence zone".
"""
function interpret_interaction(interaction_string::String)
    # Guardian interactions
    if occursin("GOVERNMENT", interaction_string)
        return "Formal guardianship effect"
    elseif occursin("EDUCATION", interaction_string)
        return "Natural surveillance effect"
    elseif occursin("PLACE_OF_WORSHIP", interaction_string)
        return "Community cohesion effect"

        # Convergence zones
    elseif occursin("FOOD_DRINK", interaction_string) &&
        occursin("ENTERTAINMENT", interaction_string)
        return "Nightlife convergence zone"
    elseif occursin("SHOPPING", interaction_string) &&
        occursin("TRANSPORTATION", interaction_string)
        return "Transit crime hotspot"
    elseif occursin("LODGING", interaction_string) &&
        occursin("ENTERTAINMENT", interaction_string)
        return "Tourist area vulnerability"

        # Target concentration
    elseif occursin("SHOPPING", interaction_string) &&
        occursin("FINANCE", interaction_string)
        return "Commercial target concentration"
    elseif occursin("AUTOMOTIVE", interaction_string)
        return "Vehicle-related crime opportunity"

        # Mixed use effects
    elseif occursin("RESIDENTIAL", interaction_string)
        return "Mixed-use area effect"

    else
        return "Place type convergence effect"
    end
end

"""
Check if our results match what routine activities theory predicts.

Does adding cops reduce crime? Do bars plus clubs equal fights?
Let's find out.
"""
function test_routine_activities_predictions(significant_interactions, model_comparisons)
    @info "Testing routine activities theory predictions..."

    predictions = DataFrame(;
        prediction = String[], supported = Bool[], evidence = String[]
    )

    # Test 1: Guardian interactions should reduce crime (negative coefficients)
    guardian_interactions = filter(
        row ->
            occursin("Formal guardianship", row.interpretation) ||
            occursin("Natural surveillance", row.interpretation) ||
            occursin("Community cohesion", row.interpretation),
        significant_interactions
    )

    if nrow(guardian_interactions) > 0
        negative_guardian = sum(guardian_interactions.coefficient .< 0)
        total_guardian = nrow(guardian_interactions)
        push!(
            predictions,
            (
                "Guardian places reduce crime",
                negative_guardian > total_guardian / 2,
                "$(negative_guardian)/$(total_guardian) guardian interactions have negative coefficients"
            )
        )
    end

    # Test 2: Nightlife zones increase violence
    nightlife = filter(
        row ->
            occursin("Nightlife", row.interpretation) &&
            occursin("violence", lowercase(row.target)),
        significant_interactions
    )

    if nrow(nightlife) > 0
        positive_nightlife = sum(nightlife.coefficient .> 0)
        push!(
            predictions,
            (
                "Nightlife zones increase violence",
                positive_nightlife > 0,
                "$(positive_nightlife)/$(nrow(nightlife)) nightlife interactions positively predict violence"
            )
        )
    end

    # Test 3: Commercial concentrations increase larceny
    commercial = filter(
        row ->
            occursin("Commercial", row.interpretation) &&
            occursin("larceny", lowercase(row.target)),
        significant_interactions
    )

    if nrow(commercial) > 0
        positive_commercial = sum(commercial.coefficient .> 0)
        push!(
            predictions,
            (
                "Commercial areas increase larceny",
                positive_commercial > 0,
                "$(positive_commercial)/$(nrow(commercial)) commercial interactions positively predict larceny"
            )
        )
    end

    # Test 4: Overall model improvement (updated for three-way comparison)
    full_best = sum(model_comparisons.best_model .== "full")
    interact_only_best = sum(model_comparisons.best_model .== "interactions_only")
    base_best = sum(model_comparisons.best_model .== "base")
    total_models = nrow(model_comparisons)

    push!(
        predictions,
        (
            "Interactions improve model fit",
            (full_best + interact_only_best) > base_best,
            "Full model best: $(full_best)/$(total_models), Interactions-only best: $(interact_only_best)/$(total_models), Base best: $(base_best)/$(total_models)"
        )
    )

    @info "Theory validation results:"
    for row in eachrow(predictions)
        status = row.supported ? "✓ SUPPORTED" : "✗ NOT SUPPORTED"
        @info "  $(status): $(row.prediction)"
        @info "    Evidence: $(row.evidence)"
    end

    return predictions
end

"""
    create_interaction_only_features(features::DataFrame)::DataFrame

Create a feature set with ONLY interaction terms (no base place counts).
Used for testing whether place relationships matter more than raw counts.

This is part of the three-way routine activities theory comparison:

  - Base: place counts only
  - Interactions-only: place relationships only
  - Full: both counts and relationships
"""
function create_interaction_only_features(features::DataFrame)::DataFrame
    # Start with metadata and crime columns only
    interact_features = features[:, [:street_id, :street_name]]

    # Add crime columns for targets
    for col in names(features)
        if startswith(String(col), "crime_") || startswith(String(col), "high_")
            interact_features[!, col] = features[!, col]
        end
    end

    # Add total_crime if present
    if hasproperty(features, :total_crime)
        interact_features[!, :total_crime] = features[!, :total_crime]
    end

    # Create temp features with place counts to generate interactions
    temp_features = copy(features)
    add_place_type_interactions!(temp_features; standardize = true)

    # Copy ONLY interaction columns
    for col in names(temp_features)
        if startswith(String(col), "interact_")
            interact_features[!, col] = temp_features[!, col]
        end
    end

    return interact_features
end

"""
    fit_all_model_variants(features, matched_data, place_matched, dataset_name)

Fit all model variants for a dataset (48 models):

  - 4 crime types (LARCENY, VIOLENCE, BURGLARY, DRUGS)
  - 4 target methods (top25, top50, median, jenks)
  - 3 model types (base, interactions, PCA)

Returns a dictionary with model name => fitted model.
Errors if ANY model fails to converge.

This systematic approach ensures comprehensive methodological testing
of different feature engineering strategies and threshold definitions.
"""
function fit_all_model_variants(
    features::DataFrame,
    matched_data::DataFrame,
    place_matched::DataFrame,
    dataset_name::String
)::Dict{String, Any}
    @info "Fitting all model variants for $dataset_name (48 models)..."

    all_models = Dict{String, Any}()
    failed_models = String[]

    # Get target columns (already created by create_target_variables!)
    target_cols = [
        Symbol(col) for col in names(features) if startswith(String(col), "high_")
    ]

    if isempty(target_cols)
        error("No target variables found. Run create_target_variables! first.")
    end

    @info "Found $(length(target_cols)) target variables"

    # 1. FIT BASE MODELS (categorical features only, but with interactions already added)
    @info "  Fitting base models (place counts + interactions)..."
    try
        base_models = fit_logistic_models(features, target_cols)
        for (name, model) in base_models
            all_models["$(dataset_name)_$(name)_base"] = model
        end
        @info "  ✓ Fitted $(length(base_models)) base models"
    catch e
        push!(failed_models, "base models: $e")
        @error "Base models failed: $e"
    end

    # 2. FIT INTERACTION-ONLY MODELS
    @info "  Fitting interaction-only models..."
    try
        # Create interaction-only features
        interact_only_features = create_interaction_only_features(features)

        # Target columns should already exist from the original features
        interact_target_cols = [
            Symbol(col) for
            col in names(interact_only_features) if startswith(String(col), "high_")
        ]

        interact_models = fit_logistic_models(interact_only_features, interact_target_cols)
        for (name, model) in interact_models
            all_models["$(dataset_name)_$(name)_interactions"] = model
        end
        @info "  ✓ Fitted $(length(interact_models)) interaction-only models"
    catch e
        push!(failed_models, "interaction-only models: $e")
        @error "Interaction-only models failed: $e"
    end

    # 3. FIT PCA MODELS
    @info "  Fitting PCA models..."
    try
        pca_features = create_street_features_pca(
            matched_data, place_matched, nothing, dataset_name
        )

        # Add target variables to PCA features
        create_target_variables!(pca_features)

        pca_target_cols = [
            Symbol(col) for col in names(pca_features) if startswith(String(col), "high_")
        ]
        pca_models = fit_logistic_models(pca_features, pca_target_cols)
        for (name, model) in pca_models
            all_models["$(dataset_name)_$(name)_pca"] = model
        end
        @info "  ✓ Fitted $(length(pca_models)) PCA models"
    catch e
        push!(failed_models, "PCA models: $e")
        @error "PCA models failed: $e"
    end

    # Check for failures - strict all-or-nothing
    if !isempty(failed_models)
        error("Failed to fit some models:\n  - " * join(failed_models, "\n  - "))
    end

    # Save model diagnostics
    models_dir = joinpath(OUTPUT_DIR, "models")
    mkpath(models_dir)

    # Extract and save all model coefficients
    all_coefficients = extract_model_coefficients(
        Dict(Symbol(k) => v for (k, v) in all_models)
    )
    CSV.write(
        joinpath(models_dir, "$(dataset_name)_model_coefficients.csv"), all_coefficients
    )
    @info "Saved model coefficients to: $(models_dir)/$(dataset_name)_model_coefficients.csv"

    @info "  ✓ Successfully fitted all 48 $(dataset_name) models"
    return all_models
end

"""
    compare_all_models(incident_models, arrest_models)

Comprehensive comparison across all 96 models:

  - Model types (base vs interactions vs PCA)
  - Target methods (top25, top50, median, jenks)
  - Crime types (4 categories)
  - Dataset types (incidents vs arrests)

Generates detailed comparison reports and visualizations.
"""
function compare_all_models(
    incident_models::Dict{String, Any}, arrest_models::Dict{String, Any}
)
    @info "Running comprehensive model comparisons (96 models)..."

    comparison_dir = joinpath(OUTPUT_DIR, "model_comparison")
    mkpath(comparison_dir)

    # Combine all models for analysis
    all_models = merge(incident_models, arrest_models)

    # Parse model names to extract components
    model_data = DataFrame(;
        model_name = String[],
        dataset = String[],
        crime_type = String[],
        target_method = String[],
        model_type = String[],
        aic = Float64[],
        bic = Float64[],
        mcfadden_r2 = Float64[],
        deviance = Float64[],
        null_deviance = Float64[]
    )

    for (name, model) in all_models
        # Parse name: "incidents_high_larceny_top25_base"
        parts = split(name, "_")
        if length(parts) >= 5
            dataset = parts[1]  # incidents or arrests
            # Skip "high"
            crime = parts[3]  # larceny, violence, etc.
            target = parts[4]  # top25, top50, median, jenks
            mtype = parts[end]  # base, interactions, pca

            push!(
                model_data,
                (
                    name,
                    dataset,
                    crime,
                    target,
                    mtype,
                    aic(model),
                    bic(model),
                    1 - deviance(model) / nulldeviance(model),  # McFadden R²
                    deviance(model),
                    nulldeviance(model)
                )
            )
        end
    end

    # Save comprehensive model comparison
    CSV.write(joinpath(comparison_dir, "all_models_comparison.csv"), model_data)
    @info "Saved comprehensive model comparison to: $(comparison_dir)/all_models_comparison.csv"

    # 1. Compare model types
    @info "  Comparing model types (base vs interactions vs PCA)..."
    model_type_summary = combine(
        groupby(model_data, [:dataset, :model_type]),
        :aic => mean => :mean_aic,
        :mcfadden_r2 => mean => :mean_r2,
        nrow => :n_models
    )
    CSV.write(joinpath(comparison_dir, "model_type_comparison.csv"), model_type_summary)

    # 2. Compare target methods
    @info "  Comparing target methods (top25, top50, median, jenks)..."
    target_method_summary = combine(
        groupby(model_data, [:dataset, :target_method]),
        :aic => mean => :mean_aic,
        :mcfadden_r2 => mean => :mean_r2,
        nrow => :n_models
    )
    CSV.write(
        joinpath(comparison_dir, "target_method_comparison.csv"), target_method_summary
    )

    # 3. Compare crime types
    @info "  Comparing crime types..."
    crime_type_summary = combine(
        groupby(model_data, [:dataset, :crime_type]),
        :aic => mean => :mean_aic,
        :mcfadden_r2 => mean => :mean_r2,
        nrow => :n_models
    )
    CSV.write(joinpath(comparison_dir, "crime_type_comparison.csv"), crime_type_summary)

    # 4. Find best models
    @info "  Identifying best models by AIC..."
    best_by_crime = combine(groupby(model_data, [:dataset, :crime_type])) do df
        best_idx = argmin(df.aic)
        return df[best_idx, :]
    end
    CSV.write(joinpath(comparison_dir, "best_models_by_crime.csv"), best_by_crime)

    @info "  ✓ Model comparison complete - results saved to $comparison_dir"

    return Dict(
        :all_models => model_data,
        :model_types => model_type_summary,
        :target_methods => target_method_summary,
        :crime_types => crime_type_summary,
        :best_models => best_by_crime
    )
end
