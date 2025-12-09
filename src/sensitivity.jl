"""
Sensitivity Analysis Functions for Crime Hot Spot Prediction

This module provides functions for testing the robustness of findings across
different parameter specifications, with focus on:
1. Jaccard threshold sensitivity for interaction selection
2. PCA component diagnostics and alternative approaches
"""

using DataFrames
using CSV
using Statistics
using StatsBase
using GLM
using LinearAlgebra

"""
    sensitivity_jaccard_analysis(
        incidents_matched, places_matched, streets, dataset_name;
        thresholds = [0.60, 0.70, 0.75, 0.80, 0.85, 0.90]
    )

Run sensitivity analysis across different Jaccard similarity thresholds for
interaction selection.

For each threshold, creates features, fits models, and tracks:
- Number of interactions selected
- Model convergence rates
- Predictive performance (R², AIC)
- Multicollinearity diagnostics

Returns a DataFrame with comparative results across all thresholds.
"""
function sensitivity_jaccard_analysis(
    incidents_matched,
    places_matched,
    streets,
    dataset_name::String;
    thresholds::Vector{Float64} = [0.60, 0.70, 0.75, 0.80, 0.85, 0.90]
)
    @info "="^80
    @info "JACCARD THRESHOLD SENSITIVITY ANALYSIS: $dataset_name"
    @info "Testing thresholds: $(join(thresholds, ", "))"
    @info "="^80

    results = DataFrame(
        threshold = Float64[],
        n_interactions = Int[],
        crime_type = String[],
        target_method = String[],
        converged = Bool[],
        aic = Float64[],
        r2 = Float64[],
        n_significant_predictors = Int[],
        mean_vif = Float64[],
        max_vif = Float64[]
    )

    # Run co-occurrence analysis once
    @info "Running co-occurrence analysis..."
    temp_features = DataFrame(; street_id = unique(streets.street_id))
    place_by_street = combine(
        groupby(places_matched, [:street_id, :category]), nrow => :count
    )
    place_wide = unstack(place_by_street, :street_id, :category, :count; fill = 0)
    temp_features = leftjoin(temp_features, place_wide; on = :street_id)

    # Fill missing values
    for col in names(temp_features)
        if col != :street_id && eltype(temp_features[!, col]) >: Missing
            temp_features[!, col] = coalesce.(temp_features[!, col], 0)
        end
    end

    cooccurrence_results = run_cooccurrence_analysis(temp_features)
    pairs_df = cooccurrence_results[:pairs_analysis]

    # Test each threshold
    for threshold in thresholds
        @info "\n" * "─"^80
        @info "Testing Jaccard threshold: $threshold"
        @info "─"^80

        # Create features with this threshold
        result = create_street_features(
            incidents_matched,
            places_matched,
            streets,
            dataset_name;
            cooccurrence_pairs = pairs_df,
            jaccard_threshold = threshold
        )
        features = result.features
        # Note: pca_result is also returned but we reuse the same PCA for all thresholds

        # Count interactions created (need to pass threshold through)
        n_interactions = count(startswith("interact_"), names(features))
        @info "Created $n_interactions interaction features"

        # Create targets
        targets = create_target_variables!(features)

        # Fit interaction models for this threshold
        threshold_results = fit_interactions_sensitivity(
            features, targets, dataset_name, threshold
        )

        # Append to results
        append!(results, threshold_results)
    end

    # Save sensitivity results
    output_dir = joinpath(OUTPUT_DIR, "sensitivity")
    mkpath(output_dir)
    output_file = joinpath(
        output_dir, "$(dataset_name)_jaccard_sensitivity.csv"
    )
    CSV.write(output_file, results)
    @info "Saved sensitivity results to: $output_file"

    # Generate summary report
    generate_jaccard_sensitivity_report(results, dataset_name)

    return results
end

"""
    fit_interactions_sensitivity(features, targets, dataset_name, threshold)

Fit interaction models for a specific Jaccard threshold.
Returns DataFrame with model performance metrics.
"""
function fit_interactions_sensitivity(
    features::DataFrame, targets::Vector{Symbol}, dataset_name::String, threshold::Float64
)
    results = DataFrame(
        threshold = Float64[],
        n_interactions = Int[],
        crime_type = String[],
        target_method = String[],
        converged = Bool[],
        aic = Float64[],
        r2 = Float64[],
        n_significant_predictors = Int[],
        mean_vif = Float64[],
        max_vif = Float64[]
    )

    # Select interaction predictors
    predictor_cols = [
        Symbol(col) for col in names(features) if startswith(String(col), "interact_")
    ]

    if isempty(predictor_cols)
        @warn "No interaction predictors found at threshold $threshold"
        return results
    end

    n_interactions = length(predictor_cols)

    # Fit models for each target
    for target_col in targets
        target_str = String(target_col)

        # Extract crime type and method
        parts = split(target_str, "_")
        crime_type = join(parts[2:(end - 1)], "_")
        target_method = parts[end]

        @info "  Fitting: $target_col"

        # Prepare data
        model_data = features[:, vcat([:street_id], predictor_cols, [target_col])]
        dropmissing!(model_data)

        # Check if target has variation
        if length(unique(model_data[!, target_col])) < 2
            @warn "    Target $target_col has no variation, skipping"
            continue
        end

        # Calculate VIF for multicollinearity diagnostics
        vif_scores = calculate_vif(model_data, predictor_cols)
        valid_vifs = filter(!isinf, collect(values(vif_scores)))
        mean_vif = isempty(valid_vifs) ? Inf : mean(valid_vifs)
        max_vif = isempty(valid_vifs) ? Inf : maximum(valid_vifs)

        @info "    VIF: Mean=$(round(mean_vif, digits=2)), Max=$(round(max_vif, digits=2))"

        # Fit model
        try
            formula_str = "$target_col ~ 1 + " * join(String.(predictor_cols), " + ")
            formula = Meta.parse("@formula(" * formula_str * ")")
            model = glm(eval(formula), model_data, Binomial(), LogitLink())

            # Extract metrics
            converged = model.model.fit
            aic_value = aic(model)
            r2_value = 1 - (deviance(model) / nulldeviance(model))

            # Count significant predictors
            coef_table = coeftable(model)
            n_sig = count(<(0.05), coef_table.cols[4][2:end])  # Skip intercept

            push!(
                results,
                (
                    threshold,
                    n_interactions,
                    crime_type,
                    target_method,
                    converged,
                    aic_value,
                    r2_value,
                    n_sig,
                    mean_vif,
                    max_vif
                )
            )

            @info "    Converged: $converged, AIC: $(round(aic_value, digits=2)), R²: $(round(r2_value, digits=4))"
        catch e
            @warn "    Model failed: $e"
            push!(
                results,
                (
                    threshold,
                    n_interactions,
                    crime_type,
                    target_method,
                    false,
                    Inf,
                    -Inf,
                    0,
                    mean_vif,
                    max_vif
                )
            )
        end
    end

    return results
end

"""
    generate_jaccard_sensitivity_report(results, dataset_name)

Generate markdown report summarizing Jaccard threshold sensitivity analysis.
"""
function generate_jaccard_sensitivity_report(results::DataFrame, dataset_name::String)
    output_dir = joinpath(OUTPUT_DIR, "sensitivity")
    report_file = joinpath(output_dir, "$(dataset_name)_jaccard_sensitivity_report.md")

    open(report_file, "w") do io
        println(io, "# Jaccard Threshold Sensitivity Analysis: $(uppercase(dataset_name))")
        println(io, "\nGenerated: $(now())")
        println(io, "\n---\n")

        println(io, "## Research Question")
        println(io, "\nDo place type interactions predict crime hot spots, and if so,")
        println(io, "at what spatial co-location threshold (Jaccard similarity)?")
        println(io, "\n---\n")

        println(io, "## Summary Statistics by Threshold")
        println(io, "")
        println(io, "| Threshold | N Interactions | Converged | Mean R² | Best R² |")
        println(io, "|-----------|----------------|-----------|---------|---------|")

        for threshold in sort(unique(results.threshold))
            threshold_data = filter(row -> row.threshold == threshold, results)
            n_int = first(threshold_data.n_interactions)
            n_converged = count(threshold_data.converged)
            n_total = nrow(threshold_data)

            # Filter valid R² values
            valid_r2 = filter(!isinf, filter(!isnan, threshold_data.r2))

            # Handle empty case (all models failed)
            mean_r2 = isempty(valid_r2) ? 0.0 : mean(valid_r2)
            best_r2 = isempty(valid_r2) ? 0.0 : maximum(valid_r2)

            println(
                io,
                "| $threshold | $n_int | $n_converged/$n_total | $(round(mean_r2, digits=4)) | $(round(best_r2, digits=4)) |"
            )
        end

        println(io, "\n---\n")

        println(io, "## Interpretation")
        println(io, "")
        println(io, "**Key Findings:**")
        println(io, "")
        println(io, "- As Jaccard threshold increases, fewer interaction pairs are selected")
        println(io, "- Model convergence rates and predictive performance across thresholds")
        println(io, "  indicate whether interaction effects are robust to operationalization")
        println(io, "")
        println(io, "**Theoretical Implications:**")
        println(io, "")
        println(io, "If interactions fail across all thresholds, this suggests that combined")
        println(io, "routine activities at co-located place types do not modify crime risk")
        println(io, "beyond individual place type effects. If a specific threshold shows strong")
        println(io, "performance, this identifies the optimal spatial co-location scale for")
        println(io, "detecting place interaction effects.")
        println(io, "")
    end

    @info "Saved sensitivity report to: $report_file"
end

"""
    diagnose_pca_components(features, place_matched, dataset_name)

Comprehensive diagnostic analysis of PCA components:
1. Variance explained by each component
2. Component loadings (which place types load on which PCs)
3. Component interpretability (top loadings for each PC)
4. Component-crime correlations (bivariate relationships)
5. Component score distributions (variation across streets)
6. Alternative specifications (different variance thresholds)

Returns diagnostic report and saves detailed results to output/sensitivity/
"""
function diagnose_pca_components(
    place_matched::DataFrame,
    streets,
    dataset_name::String;
    variance_thresholds::Vector{Float64} = [0.90, 0.95, 0.99],
    max_components::Int = 10
)
    @info "="^80
    @info "PCA COMPONENT DIAGNOSTICS: $dataset_name"
    @info "="^80

    if !("raw_type" in names(place_matched))
        @warn "No raw_type column in place_matched - cannot run PCA diagnostics"
        return nothing
    end

    # Store all diagnostics
    diagnostics = Dict{String, Any}()

    # Test different variance thresholds using shared function
    threshold_comparison = DataFrame(
        variance_threshold = Float64[],
        n_components = Int[],
        variance_explained = Float64[],
        mean_component_variance = Float64[],
        max_component_variance = Float64[]
    )

    @info "\n" * "─"^80
    @info "Testing Variance Thresholds"
    @info "─"^80

    for threshold in variance_thresholds
        # Use shared PCA fitting function
        pca_result = fit_pca_model(place_matched; max_components=max_components, variance_threshold=threshold)

        if pca_result === nothing
            continue
        end

        pca_model = pca_result.pca_model
        n_components = size(pca_model, 2)
        variance_explained = principalratio(pca_model)
        component_vars = principalvars(pca_model)
        total_var = var(pca_model)

        # Calculate variance statistics
        variance_proportions = component_vars ./ total_var
        mean_var = mean(variance_proportions)
        max_var = maximum(variance_proportions)

        push!(threshold_comparison, (threshold, n_components, variance_explained, mean_var, max_var))

        @info "Threshold $threshold: $n_components components, $(round(variance_explained*100, digits=1))% variance"
    end

    diagnostics["threshold_comparison"] = threshold_comparison

    # Deep dive on default threshold (0.99) using shared function
    @info "\n" * "─"^80
    @info "Detailed Analysis: 99% Variance Threshold"
    @info "─"^80

    pca_result = fit_pca_model(place_matched; max_components=max_components, variance_threshold=0.99)

    if pca_result === nothing
        return nothing
    end

    pca_model = pca_result.pca_model
    raw_type_columns = pca_result.raw_type_columns

    n_components = size(pca_model, 2)
    loadings_matrix = loadings(pca_model)  # Place types × Components
    component_vars = principalvars(pca_model)
    total_var = var(pca_model)
    # Use the standardized matrix from pca_result
    transformed = pca_result.transformed_components  # Streets × Components (already computed)

    # 1. Variance explained by each component
    @info "\nVariance Explained by Component:"
    variance_explained_df = DataFrame(
        component = Int[],
        variance = Float64[],
        proportion = Float64[],
        cumulative_proportion = Float64[]
    )

    cumulative = 0.0
    for i in 1:n_components
        proportion = component_vars[i] / total_var
        cumulative += proportion
        push!(variance_explained_df, (i, component_vars[i], proportion, cumulative))
        @info "  PC_$i: $(round(proportion*100, digits=2))% (cumulative: $(round(cumulative*100, digits=1))%)"
    end

    diagnostics["variance_explained"] = variance_explained_df

    # 2. Component loadings (top contributors to each PC)
    @info "\nTop Place Type Loadings by Component:"
    top_loadings_df = DataFrame(
        component = Int[],
        place_type = String[],
        loading = Float64[],
        rank = Int[]
    )

    for i in 1:n_components
        @info "\n  PC_$i:"
        component_loadings = loadings_matrix[:, i]

        # Get top 5 positive and negative loadings
        sorted_indices = sortperm(abs.(component_loadings), rev=true)

        for (rank, idx) in enumerate(sorted_indices[1:min(5, length(sorted_indices))])
            place_type = raw_type_columns[idx]
            loading_value = component_loadings[idx]
            push!(top_loadings_df, (i, place_type, loading_value, rank))

            sign_str = loading_value > 0 ? "+" : "-"
            @info "    $sign_str $place_type: $(round(loading_value, digits=3))"
        end
    end

    diagnostics["top_loadings"] = top_loadings_df

    # 3. Full loadings matrix for detailed analysis
    loadings_df = DataFrame(place_type = raw_type_columns)
    for i in 1:n_components
        loadings_df[!, "PC_$i"] = loadings_matrix[:, i]
    end
    diagnostics["full_loadings"] = loadings_df

    # 4. Component score distributions
    @info "\nComponent Score Distributions:"
    score_distributions_df = DataFrame(
        component = Int[],
        mean = Float64[],
        std = Float64[],
        min = Float64[],
        q25 = Float64[],
        median = Float64[],
        q75 = Float64[],
        max = Float64[],
        prop_nonzero = Float64[]
    )

    for i in 1:n_components
        scores = transformed[:, i]
        prop_nonzero = count(!=(0.0), scores) / length(scores)

        push!(score_distributions_df, (
            i,
            mean(scores),
            std(scores),
            minimum(scores),
            quantile(scores, 0.25),
            median(scores),
            quantile(scores, 0.75),
            maximum(scores),
            prop_nonzero
        ))

        @info "  PC_$i: μ=$(round(mean(scores), digits=2)), σ=$(round(std(scores), digits=2)), nonzero=$(round(prop_nonzero*100, digits=1))%"
    end

    diagnostics["score_distributions"] = score_distributions_df

    # Save all diagnostics
    output_dir = joinpath(OUTPUT_DIR, "sensitivity")
    mkpath(output_dir)

    CSV.write(
        joinpath(output_dir, "$(dataset_name)_pca_threshold_comparison.csv"),
        threshold_comparison
    )

    CSV.write(
        joinpath(output_dir, "$(dataset_name)_pca_variance_explained.csv"),
        variance_explained_df
    )

    CSV.write(
        joinpath(output_dir, "$(dataset_name)_pca_top_loadings.csv"),
        top_loadings_df
    )

    CSV.write(
        joinpath(output_dir, "$(dataset_name)_pca_full_loadings.csv"),
        loadings_df
    )

    CSV.write(
        joinpath(output_dir, "$(dataset_name)_pca_score_distributions.csv"),
        score_distributions_df
    )

    # Generate comprehensive report
    generate_pca_diagnostic_report(diagnostics, dataset_name, raw_type_columns)

    @info "\n" * "="^80
    @info "PCA diagnostics complete. Results saved to: $output_dir"
    @info "="^80

    return diagnostics
end

"""
    generate_pca_diagnostic_report(diagnostics, dataset_name, place_types)

Generate comprehensive markdown report for PCA diagnostics.
"""
function generate_pca_diagnostic_report(
    diagnostics::Dict{String, Any},
    dataset_name::String,
    place_types::Vector{String}
)
    output_dir = joinpath(OUTPUT_DIR, "sensitivity")
    report_file = joinpath(output_dir, "$(dataset_name)_pca_diagnostics_report.md")

    threshold_comparison = diagnostics["threshold_comparison"]
    variance_explained = diagnostics["variance_explained"]
    top_loadings = diagnostics["top_loadings"]
    score_distributions = diagnostics["score_distributions"]

    open(report_file, "w") do io
        println(io, "# PCA Component Diagnostics: $(uppercase(dataset_name))")
        println(io, "\nGenerated: $(now())")
        println(io, "\n---\n")

        println(io, "## Research Question")
        println(io, "\nCan latent place type patterns (PCA components) predict crime hot spots?")
        println(io, "\n**Current Finding**: PCA models show R² ≈ 0 despite using 6 components")
        println(io, "\n**Diagnostic Goal**: Understand WHY PCA fails")
        println(io, "\n---\n")

        # Threshold comparison
        println(io, "## 1. Variance Threshold Sensitivity")
        println(io, "\n| Variance Threshold | N Components | Variance Explained | Mean Var/Component | Max Var/Component |")
        println(io, "|-------------------|--------------|--------------------|--------------------|-------------------|")

        for row in eachrow(threshold_comparison)
            println(io, "| $(row.variance_threshold) | $(row.n_components) | $(round(row.variance_explained*100, digits=1))% | $(round(row.mean_component_variance*100, digits=2))% | $(round(row.max_component_variance*100, digits=2))% |")
        end

        println(io, "\n**Interpretation**: ")
        n_components_99 = threshold_comparison[threshold_comparison.variance_threshold .== 0.99, :n_components][1]
        println(io, "At 99% variance threshold, we retain $n_components_99 components. Each component explains relatively small amounts of variance.")

        println(io, "\n---\n")

        # Variance explained
        println(io, "## 2. Variance Explained (99% Threshold)")
        println(io, "\n| Component | Variance | Proportion | Cumulative |")
        println(io, "|-----------|----------|------------|------------|")

        for row in eachrow(variance_explained)
            println(io, "| PC_$(row.component) | $(round(row.variance, digits=2)) | $(round(row.proportion*100, digits=2))% | $(round(row.cumulative_proportion*100, digits=1))% |")
        end

        println(io, "\n**Interpretation**: ")
        first_pc_var = variance_explained[1, :proportion] * 100
        println(io, "PC_1 explains $(round(first_pc_var, digits=1))% of variance. ")

        if first_pc_var < 20
            println(io, "This is relatively low, suggesting **no dominant latent pattern** in place type co-occurrence.")
        else
            println(io, "This suggests a moderate dominant pattern in place type co-occurrence.")
        end

        println(io, "\n---\n")

        # Top loadings for interpretability
        println(io, "## 3. Component Interpretability (Top Loadings)")

        n_components = maximum(top_loadings.component)
        for i in 1:n_components
            println(io, "\n### PC_$i")
            component_loadings = filter(row -> row.component == i, top_loadings)

            println(io, "\n| Rank | Place Type | Loading |")
            println(io, "|------|------------|---------|")

            for row in eachrow(component_loadings)
                sign_str = row.loading > 0 ? "+" : ""
                println(io, "| $(row.rank) | $(row.place_type) | $sign_str$(round(row.loading, digits=3)) |")
            end
        end

        println(io, "\n**Interpretation**: ")
        println(io, "Examine whether components represent interpretable latent constructs:")
        println(io, "- Do loadings cluster around theoretically meaningful place type groups?")
        println(io, "- Or are they diffuse/arbitrary combinations?")

        println(io, "\n---\n")

        # Score distributions
        println(io, "## 4. Component Score Distributions")
        println(io, "\n| Component | Mean | Std | Min | Q25 | Median | Q75 | Max | % Non-Zero |")
        println(io, "|-----------|------|-----|-----|-----|--------|-----|-----|------------|")

        for row in eachrow(score_distributions)
            println(io, "| PC_$(row.component) | $(round(row.mean, digits=2)) | $(round(row.std, digits=2)) | $(round(row.min, digits=1)) | $(round(row.q25, digits=1)) | $(round(row.median, digits=1)) | $(round(row.q75, digits=1)) | $(round(row.max, digits=1)) | $(round(row.prop_nonzero*100, digits=1))% |")
        end

        println(io, "\n**Interpretation**: ")
        low_variation_components = count(score_distributions.std .< 0.5)
        if low_variation_components > 0
            println(io, "$low_variation_components component(s) have very low standard deviation (<0.5), suggesting **limited variation across streets**.")
        end

        println(io, "\n---\n")

        # Key findings
        println(io, "## 5. Key Diagnostic Findings")
        println(io, "\n**Possible Reasons for PCA Failure (R² ≈ 0):**")
        println(io, "\n1. **Low Component Variance**: If individual components explain <10% variance each, no single pattern dominates")
        println(io, "2. **Uninterpretable Components**: If loadings are diffuse (no clear clusters), components may not capture meaningful constructs")
        println(io, "3. **Low Score Variation**: If component scores have low std (<1), limited variation to predict outcomes")
        println(io, "4. **Wrong Dimensionality**: Perhaps need MORE components (test lower variance threshold) or FEWER (too much noise)")
        println(io, "5. **Wrong Feature Space**: PCA assumes linear relationships; place types may have non-linear crime associations")
        println(io, "\n**Next Steps:**")
        println(io, "\n- Examine loadings for interpretability (Section 3)")
        println(io, "- Check if score distributions show sufficient variation (Section 4)")
        println(io, "- Test alternative variance thresholds (Section 1)")
        println(io, "- Consider that **place types may not have meaningful latent structure** for crime prediction")
        println(io, "")
    end

    @info "Saved PCA diagnostic report to: $report_file"
end

"""
    calculate_vif(features, predictor_cols)

Calculate VIF (Variance Inflation Factor) scores for predictors to diagnose
multicollinearity. VIF measures how much the variance of an estimated regression
coefficient increases when predictors are correlated.

Interpretation:
- VIF < 5: No multicollinearity concern
- VIF 5-10: Moderate multicollinearity
- VIF > 10: Severe multicollinearity
- VIF > 100: Extreme multicollinearity
"""
function calculate_vif(features::DataFrame, predictor_cols::Vector{Symbol})
    vif_scores = Dict{Symbol,Float64}()

    # Need at least 2 predictors for VIF
    if length(predictor_cols) < 2
        for col in predictor_cols
            vif_scores[col] = 1.0
        end
        return vif_scores
    end

    for target_col in predictor_cols
        # Get other predictors
        other_cols = filter(x -> x != target_col, predictor_cols)

        try
            # Prepare data
            model_data = features[:, vcat([target_col], other_cols)]
            dropmissing!(model_data)

            # Check if we have enough data
            if nrow(model_data) < length(other_cols) + 2
                vif_scores[target_col] = Inf
                continue
            end

            # Regress target_col on other predictors
            formula_str = "$(target_col) ~ " * join(String.(other_cols), " + ")
            formula = Meta.parse("@formula(" * formula_str * ")")

            model = lm(eval(formula), model_data)
            r2_value = r²(model)

            # VIF = 1 / (1 - R²)
            # Handle edge cases
            if r2_value >= 0.9999  # Nearly perfect multicollinearity
                vif = Inf
            else
                vif = 1.0 / (1.0 - r2_value)
            end

            vif_scores[target_col] = vif
        catch e
            # If model fails (e.g., perfect multicollinearity), VIF = Inf
            vif_scores[target_col] = Inf
        end
    end

    return vif_scores
end
