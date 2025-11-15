function save_results(features::DataFrame, models::Dict{Symbol, Any})::Nothing
    @info "Saving analysis results..."

    # Create output directory structure
    output_data = joinpath(OUTPUT_DIR, "data")
    output_models = joinpath(OUTPUT_DIR, "models")
    output_tables = joinpath(OUTPUT_DIR, "tables")

    mkpath(output_data)
    mkpath(output_models)
    mkpath(output_tables)

    # Save feature matrix
    features_path = joinpath(output_data, "street_features.csv")
    CSV.write(features_path, features)
    @info "Saved feature matrix ($(nrow(features)) streets, $(ncol(features)) columns) to $features_path"

    # Generate and save model summaries
    model_summaries = calculate_model_summaries(models)
    summaries_path = joinpath(output_models, "model_summaries.csv")
    CSV.write(summaries_path, model_summaries)
    @info "Saved model summaries to $summaries_path"

    # Generate and save model coefficients
    model_coefficients = extract_model_coefficients(models)
    coefficients_path = joinpath(output_models, "model_coefficients.csv")
    CSV.write(coefficients_path, model_coefficients)
    @info "Saved model coefficients to $coefficients_path"

    # Generate and save model predictions
    predictions = calculate_model_predictions(models, features)
    predictions_path = joinpath(output_models, "model_predictions.csv")
    CSV.write(predictions_path, predictions)
    @info "Saved model predictions to $predictions_path"

    # Generate and save performance metrics
    performance = evaluate_model_performance(models, features)
    performance_path = joinpath(output_models, "model_performance.csv")
    CSV.write(performance_path, performance)
    @info "Saved model performance metrics to $performance_path"

    # Generate significant predictors summary
    significant_predictors = identify_significant_predictors(model_coefficients)
    if nrow(significant_predictors) > 0
        predictors_path = joinpath(output_tables, "significant_predictors.csv")
        CSV.write(predictors_path, significant_predictors)
        @info "Saved significant predictors summary to $predictors_path"
    end

    @info "All results saved successfully"
end

# =============================================================================
# Enhanced Output Functions for Comprehensive Analysis Documentation
# =============================================================================

"""
Save everything we've calculated to disk.

Creates a timestamped folder with all the analysis results - CSVs,
markdown reports, the whole nine yards. Pass in the interaction and
PCA results if you ran those analyses too.
"""
function save_comprehensive_results(
    incident_features::DataFrame,
    arrest_features::DataFrame,
    incident_models::Dict,
    arrest_models::Dict;
    interaction_results = nothing,
    pca_results = nothing,
    target_methods = ["top25", "top50", "median", "jenks"]
)
    @info "Saving comprehensive analysis results..."

    # Create timestamped output directory
    timestamp = Dates.format(now(), "yyyy-mm-dd_HHMMSS")
    run_dir = joinpath(OUTPUT_DIR, "run_$timestamp")
    mkpath(run_dir)

    # Create subdirectories
    for subdir in ["data", "models", "reports", "figures", "comparisons", "diagnostics"]
        mkpath(joinpath(run_dir, subdir))
    end

    # Save feature engineering summary
    save_feature_engineering_report(incident_features, arrest_features, run_dir)

    # Save target variable analysis
    save_target_variable_analysis(
        incident_features, arrest_features, target_methods, run_dir
    )

    # Save model diagnostics
    save_model_diagnostics(incident_models, arrest_models, run_dir)

    # Save interaction analysis if available
    if !isnothing(interaction_results)
        save_interaction_analysis(interaction_results, run_dir)
    end

    # Save PCA analysis if available
    if !isnothing(pca_results)
        save_pca_analysis(pca_results, run_dir)
    end

    # Generate master report
    generate_master_report(run_dir, timestamp)

    @info "Comprehensive results saved to: $run_dir"
    return run_dir
end

"""
Write up a summary of what features we created and how.

Shows street counts, crime concentration stats, place type distributions, etc.
Basically documents what we built from the raw data.
"""
function save_feature_engineering_report(
    incident_features::DataFrame, arrest_features::DataFrame, output_dir::String
)
    report_path = joinpath(output_dir, "reports", "feature_engineering.md")

    open(report_path, "w") do io
        println(io, "# Feature Engineering Report")
        println(io, "\n## Generated: $(Dates.format(now(), "yyyy-mm-dd HH:MM:SS"))")

        # Dataset overview
        println(io, "\n## Dataset Overview")
        println(io, "\n### Incident Features")
        println(io, "- Total streets: $(nrow(incident_features))")
        println(io, "- Total features: $(ncol(incident_features))")

        println(io, "\n### Arrest Features")
        println(io, "- Total streets: $(nrow(arrest_features))")
        println(io, "- Total features: $(ncol(arrest_features))")

        # Feature categories
        println(io, "\n## Feature Categories")

        # Count different feature types
        place_cols = [
            col for col in names(incident_features) if !startswith(String(col), "crime_") &&
            !startswith(String(col), "high_") &&
            !startswith(String(col), "interact_") &&
            col ∉ [
                :street_id,
                :street_name,
                :total_crime,
                :total_places,
                :crime_place_ratio,
                :commercial_activity
            ]
        ]

        crime_cols = [
            col for col in names(incident_features) if startswith(String(col), "crime_")
        ]
        target_cols = [
            col for col in names(incident_features) if startswith(String(col), "high_")
        ]
        interact_cols = [
            col for col in names(incident_features) if startswith(String(col), "interact_")
        ]

        println(io, "\n### Feature Counts")
        println(io, "| Category | Incident Features | Arrest Features |")
        println(io, "|----------|------------------|-----------------|")
        println(io, "| Place Types | $(length(place_cols)) | $(length(place_cols)) |")
        println(io, "| Crime Categories | $(length(crime_cols)) | $(length(crime_cols)) |")
        println(
            io, "| Target Variables | $(length(target_cols)) | $(length(target_cols)) |"
        )
        println(
            io, "| Interactions | $(length(interact_cols)) | $(length(interact_cols)) |"
        )

        # Crime concentration statistics
        println(io, "\n## Crime Concentration")

        for df_name in ["Incident", "Arrest"]
            df = df_name == "Incident" ? incident_features : arrest_features

            println(io, "\n### $df_name Data")

            if :total_crime in names(df)
                total_streets = nrow(df)
                streets_with_crime = sum(df.total_crime .> 0)
                crime_concentration = round(
                    100 * streets_with_crime / total_streets; digits = 1
                )

                # Calculate concentration metrics
                sorted_crime = sort(df.total_crime; rev = true)
                total_crime = sum(sorted_crime)

                if total_crime > 0
                    cumsum_crime = cumsum(sorted_crime)

                    # Find concentration points
                    pct_25_idx = findfirst(x -> x >= 0.25 * total_crime, cumsum_crime)
                    pct_50_idx = findfirst(x -> x >= 0.50 * total_crime, cumsum_crime)
                    pct_80_idx = findfirst(x -> x >= 0.80 * total_crime, cumsum_crime)

                    pct_25_streets = round(100 * pct_25_idx / total_streets; digits = 1)
                    pct_50_streets = round(100 * pct_50_idx / total_streets; digits = 1)
                    pct_80_streets = round(100 * pct_80_idx / total_streets; digits = 1)

                    println(
                        io,
                        "- Streets with any crime: $streets_with_crime ($crime_concentration%)"
                    )
                    println(io, "- 25% of crime in: $pct_25_streets% of streets")
                    println(io, "- 50% of crime in: $pct_50_streets% of streets")
                    println(io, "- 80% of crime in: $pct_80_streets% of streets")
                end
            end
        end

        # Place type distributions
        println(io, "\n## Place Type Distributions")
        println(io, "\n| Place Type | Streets with Type | Mean Count | Max Count |")
        println(io, "|------------|------------------|------------|-----------|")

        for col in place_cols
            if col in names(incident_features)
                values = incident_features[!, col]
                streets_with = sum(values .> 0)
                mean_count = round(mean(values[values .> 0]); digits = 2)
                max_count = maximum(values)

                println(io, "| $col | $streets_with | $mean_count | $max_count |")
            end
        end
    end

    # Save feature matrix samples
    CSV.write(
        joinpath(output_dir, "data", "incident_features_sample.csv"),
        first(incident_features, 100)
    )
    CSV.write(
        joinpath(output_dir, "data", "arrest_features_sample.csv"),
        first(arrest_features, 100)
    )

    @info "Feature engineering report saved"
end

"""
Break down how we defined "high crime" streets.

Shows the different thresholds (top25, median, jenks, etc) and how many
streets end up in each category. Also tracks what % of crime they capture.
"""
function save_target_variable_analysis(
    incident_features::DataFrame,
    arrest_features::DataFrame,
    target_methods::Vector{String},
    output_dir::String
)
    report_path = joinpath(output_dir, "reports", "target_variables.md")

    open(report_path, "w") do io
        println(io, "# Target Variable Analysis")
        println(io, "\n## Methods Used: $(join(target_methods, ", "))")

        # Analyze each crime category
        crime_categories = ["VIOLENCE", "LARCENY", "BURGLARY", "DRUGS"]

        for crime_cat in crime_categories
            println(io, "\n## $crime_cat Crime")

            for (df_name, df) in
                [("Incident", incident_features), ("Arrest", arrest_features)]
                crime_col = Symbol("crime_$crime_cat")

                if crime_col in names(df)
                    println(io, "\n### $df_name Data")

                    crime_values = df[!, crime_col]
                    total_crime = sum(crime_values)

                    println(io, "- Total $crime_cat crimes: $total_crime")
                    println(io, "- Streets with $crime_cat: $(sum(crime_values .> 0))")
                    println(io, "- Max crimes on one street: $(maximum(crime_values))")

                    # Target variable distributions
                    println(io, "\n#### Target Variable Thresholds")
                    println(
                        io,
                        "| Method | Threshold | Streets Above | % Streets | % Crime Captured |"
                    )
                    println(
                        io,
                        "|--------|-----------|---------------|-----------|------------------|"
                    )

                    for method in target_methods
                        target_col = Symbol("high_$(lowercase(crime_cat))_$method")
                        if target_col in names(df)
                            n_high = sum(df[!, target_col])
                            pct_streets = round(100 * n_high / nrow(df); digits = 1)

                            # Calculate crime captured
                            crime_in_high = sum(crime_values[df[!, target_col]])
                            pct_crime = if total_crime > 0
                                round(100 * crime_in_high / total_crime; digits = 1)
                            else
                                0.0
                            end

                            # Find threshold value
                            threshold = minimum(crime_values[df[!, target_col]]; init = 0)

                            println(
                                io,
                                "| $method | $threshold | $n_high | $pct_streets% | $pct_crime% |"
                            )
                        end
                    end
                end
            end
        end
    end

    @info "Target variable analysis saved"
end

"""
Dump all the model stats - AIC, BIC, R-squared, the works.

Creates both a CSV for analysis and a markdown report for reading.
"""
function save_model_diagnostics(
    incident_models::Dict, arrest_models::Dict, output_dir::String
)
    # Create diagnostics dataframe
    diagnostics = DataFrame()

    for (model_type, models) in [("incident", incident_models), ("arrest", arrest_models)]
        for (target_name, model) in models
            # Extract model information
            n_obs = nobs(model)
            n_params = length(coef(model))

            # Calculate various metrics
            model_aic = aic(model)
            model_bic = bic(model)
            model_deviance = deviance(model)
            null_deviance = nulldeviance(model)
            mcfadden_r2 = r2(model)

            # Likelihood ratio test
            lr_stat = null_deviance - model_deviance
            lr_pvalue = ccdf(Chisq(n_params - 1), lr_stat)

            push!(
                diagnostics,
                (
                    model_type = model_type,
                    target = String(target_name),
                    n_observations = n_obs,
                    n_parameters = n_params,
                    aic = model_aic,
                    bic = model_bic,
                    deviance = model_deviance,
                    null_deviance = null_deviance,
                    mcfadden_r2 = mcfadden_r2,
                    lr_statistic = lr_stat,
                    lr_pvalue = lr_pvalue
                )
            )
        end
    end

    # Save diagnostics
    CSV.write(joinpath(output_dir, "diagnostics", "model_diagnostics.csv"), diagnostics)

    # Create detailed report
    report_path = joinpath(output_dir, "reports", "model_diagnostics.md")

    open(report_path, "w") do io
        println(io, "# Model Diagnostics Report")

        for model_type in ["incident", "arrest"]
            println(io, "\n## $(titlecase(model_type)) Models")

            type_diagnostics = filter(row -> row.model_type == model_type, diagnostics)

            if nrow(type_diagnostics) > 0
                println(io, "\n### Summary Statistics")
                println(io, "- Total models: $(nrow(type_diagnostics))")
                println(
                    io,
                    "- Mean McFadden R²: $(round(mean(type_diagnostics.mcfadden_r2), digits=4))"
                )
                println(io, "- Mean AIC: $(round(mean(type_diagnostics.aic), digits=2))")

                println(io, "\n### Model Performance Table")
                println(
                    io, "| Target | N | Parameters | AIC | BIC | McFadden R² | LR p-value |"
                )
                println(
                    io, "|--------|---|------------|-----|-----|-------------|------------|"
                )

                for row in eachrow(type_diagnostics)
                    println(
                        io,
                        "| $(row.target) | $(row.n_observations) | $(row.n_parameters) | " *
                        "$(round(row.aic, digits=1)) | $(round(row.bic, digits=1)) | " *
                        "$(round(row.mcfadden_r2, digits=4)) | $(round(row.lr_pvalue, digits=4)) |"
                    )
                end
            end
        end
    end

    @info "Model diagnostics saved"
end

"""
Save the results from our three-way model comparison.

Documents which model won (counts vs interactions vs both) and
what the significant interaction terms were.
"""
function save_interaction_analysis(interaction_results, output_dir::String)
    report_path = joinpath(output_dir, "reports", "interaction_analysis.md")

    open(report_path, "w") do io
        println(io, "# Routine Activities Theory - Interaction Analysis")
        println(io, "\n## Three-Way Model Comparison")
        println(
            io,
            "Comparing: Base (counts only) vs Interactions-Only vs Full (counts + interactions)"
        )

        if haskey(interaction_results, :model_comparisons)
            comparisons = interaction_results.model_comparisons

            println(io, "\n### Model Performance Summary")
            println(
                io,
                "| Crime Type | Model Type | Best Model | Base AIC | Interact-Only AIC | Full AIC |"
            )
            println(
                io,
                "|------------|------------|------------|----------|-------------------|----------|"
            )

            for row in eachrow(comparisons)
                println(
                    io,
                    "| $(row.target) | $(row.model_type) | $(row.best_model) | " *
                    "$(round(row.base_aic, digits=1)) | $(round(row.interact_only_aic, digits=1)) | " *
                    "$(round(row.full_aic, digits=1)) |"
                )
            end

            # Save comparison data
            CSV.write(
                joinpath(output_dir, "comparisons", "interaction_model_comparison.csv"),
                comparisons
            )
        end

        if haskey(interaction_results, :significant_interactions)
            interactions = interaction_results.significant_interactions

            if nrow(interactions) > 0
                println(io, "\n## Significant Interaction Terms")
                println(io, "\n### Top 20 Most Significant Interactions")
                println(
                    io, "| Interaction | Coefficient | P-value | Model | Interpretation |"
                )
                println(
                    io, "|-------------|-------------|---------|-------|----------------|"
                )

                # Sort by p-value and show top 20
                sorted_interactions = sort(interactions, :p_value)
                for row in eachrow(first(sorted_interactions, 20))
                    println(
                        io,
                        "| $(row.interaction_term) | $(round(row.coefficient, digits=3)) | " *
                        "$(round(row.p_value, digits=4)) | $(row.model_type)/$(row.target) | " *
                        "$(row.interpretation) |"
                    )
                end

                # Save all interactions
                CSV.write(
                    joinpath(output_dir, "comparisons", "significant_interactions.csv"),
                    interactions
                )
            end
        end

        if haskey(interaction_results, :theory_validation)
            validations = interaction_results.theory_validation

            println(io, "\n## Routine Activities Theory Validation")
            println(io, "\n| Prediction | Supported | Evidence |")
            println(io, "|------------|-----------|----------|")

            for row in eachrow(validations)
                status = row.supported ? "✓" : "✗"
                println(io, "| $(row.prediction) | $status | $(row.evidence) |")
            end
        end

        if haskey(interaction_results, :interpretation)
            println(io, "\n## Overall Interpretation")
            println(io, "\n$(interaction_results.interpretation)")
        end
    end

    @info "Interaction analysis saved"
end

"""
Write up the PCA results if we ran that analysis.

Shows how many components we kept, what they represent, and how
PCA models compare to the category-based ones.
"""
function save_pca_analysis(pca_results, output_dir::String)
    report_path = joinpath(output_dir, "reports", "pca_analysis.md")

    open(report_path, "w") do io
        println(io, "# PCA Analysis Report")
        println(io, "\n## Principal Component Analysis of Raw Place Types")

        if haskey(pca_results, :n_components)
            println(io, "\n### PCA Summary")
            println(io, "- Components retained: $(pca_results.n_components)")
            println(
                io,
                "- Variance explained: $(round(pca_results.variance_explained * 100, digits=1))%"
            )
        end

        if haskey(pca_results, :component_loadings)
            loadings = pca_results.component_loadings

            println(io, "\n### Top Loadings for First 5 Components")

            for i = 1:min(5, size(loadings, 2))
                println(io, "\n#### PC$i")

                # Get top 10 loadings for this component
                comp_loadings = loadings[:, i]
                sorted_idx = sortperm(abs.(comp_loadings); rev = true)

                for j = 1:min(10, length(sorted_idx))
                    idx = sorted_idx[j]
                    if haskey(pca_results, :place_types)
                        place_type = pca_results.place_types[idx]
                        loading = comp_loadings[idx]
                        println(io, "- $(place_type): $(round(loading, digits=3))")
                    end
                end
            end
        end

        if haskey(pca_results, :model_comparison)
            println(io, "\n## Category-based vs PCA Model Comparison")

            comparison = pca_results.model_comparison

            println(io, "\n| Metric | Category-based | PCA-based | Improvement |")
            println(io, "|--------|----------------|-----------|-------------|")

            for row in eachrow(comparison)
                println(
                    io,
                    "| $(row.metric) | $(round(row.category_value, digits=3)) | " *
                    "$(round(row.pca_value, digits=3)) | $(round(row.improvement, digits=3)) |"
                )
            end
        end
    end

    @info "PCA analysis saved"
end

"""
Create the main report that ties everything together.

This is your starting point - links to all the other reports and
gives a high-level summary of what we found.
"""
function generate_master_report(output_dir::String, timestamp::String)
    master_path = joinpath(output_dir, "MASTER_REPORT.md")

    open(master_path, "w") do io
        println(io, "# Crime and Place Analysis - Master Report")
        println(io, "\n## Analysis Run: $timestamp")
        println(io, "\n---")

        println(io, "\n## Table of Contents")
        println(io, "\n1. [Feature Engineering](reports/feature_engineering.md)")
        println(io, "2. [Target Variables](reports/target_variables.md)")
        println(io, "3. [Model Diagnostics](reports/model_diagnostics.md)")

        # Check for optional reports
        if isfile(joinpath(output_dir, "reports", "interaction_analysis.md"))
            println(io, "4. [Interaction Analysis](reports/interaction_analysis.md)")
        end

        if isfile(joinpath(output_dir, "reports", "pca_analysis.md"))
            println(io, "5. [PCA Analysis](reports/pca_analysis.md)")
        end

        println(io, "\n## Key Findings Summary")

        # Read and summarize key metrics from saved CSVs
        if isfile(joinpath(output_dir, "diagnostics", "model_diagnostics.csv"))
            diagnostics = CSV.read(
                joinpath(output_dir, "diagnostics", "model_diagnostics.csv"), DataFrame
            )

            println(io, "\n### Model Performance")
            println(io, "- Total models fitted: $(nrow(diagnostics))")
            println(
                io,
                "- Average McFadden R²: $(round(mean(diagnostics.mcfadden_r2), digits=4))"
            )

            best_model = diagnostics[argmax(diagnostics.mcfadden_r2), :]
            println(
                io,
                "- Best performing model: $(best_model.target) ($(best_model.model_type))"
            )
            println(io, "  - McFadden R²: $(round(best_model.mcfadden_r2, digits=4))")
        end

        if isfile(joinpath(output_dir, "comparisons", "interaction_model_comparison.csv"))
            comparisons = CSV.read(
                joinpath(output_dir, "comparisons", "interaction_model_comparison.csv"),
                DataFrame
            )

            println(io, "\n### Interaction Analysis")

            # Count which model type wins most
            if :best_model in names(comparisons)
                model_wins = combine(groupby(comparisons, :best_model), nrow => :count)

                println(io, "\n#### Best Model Distribution")
                for row in eachrow(model_wins)
                    println(io, "- $(row.best_model): $(row.count) models")
                end
            end
        end

        println(io, "\n## Data Files")
        println(io, "\n### Feature Matrices")
        println(io, "- [Incident Features Sample](data/incident_features_sample.csv)")
        println(io, "- [Arrest Features Sample](data/arrest_features_sample.csv)")

        println(io, "\n### Model Results")
        println(io, "- [Model Diagnostics](diagnostics/model_diagnostics.csv)")

        if isfile(joinpath(output_dir, "comparisons", "interaction_model_comparison.csv"))
            println(
                io,
                "- [Interaction Model Comparison](comparisons/interaction_model_comparison.csv)"
            )
        end

        if isfile(joinpath(output_dir, "comparisons", "significant_interactions.csv"))
            println(
                io, "- [Significant Interactions](comparisons/significant_interactions.csv)"
            )
        end

        println(io, "\n---")
        return println(
            io, "\n*Report generated automatically by dissertation analysis pipeline*"
        )
    end

    @info "Master report generated at: $master_path"
end

"""
Summarize what kinds of places are on our streets.

Shows which place types are most common, how they cluster together,
and basic distribution stats.
"""
function save_place_type_summary(features::DataFrame, output_dir::String)
    # Identify place columns
    place_cols = [
        col for col in names(features) if !startswith(String(col), "crime_") &&
        !startswith(String(col), "high_") &&
        !startswith(String(col), "interact_") &&
        col ∉ [
            :street_id,
            :street_name,
            :total_crime,
            :total_places,
            :crime_place_ratio,
            :commercial_activity
        ]
    ]

    # Create summary statistics
    summary_df = DataFrame()

    for col in place_cols
        if col in names(features) && eltype(features[!, col]) <: Number
            values = features[!, col]

            push!(
                summary_df,
                (
                    place_type = String(col),
                    total_count = sum(values),
                    streets_with_type = sum(values .> 0),
                    percent_streets = round(
                        100 * sum(values .> 0) / nrow(features); digits = 1
                    ),
                    mean_when_present = mean(values[values .> 0]),
                    median_when_present = median(values[values .> 0]),
                    max_count = maximum(values),
                    std_dev = std(values)
                )
            )
        end
    end

    # Sort by prevalence
    sort!(summary_df, :streets_with_type; rev = true)

    # Save CSV
    CSV.write(joinpath(output_dir, "data", "place_type_summary.csv"), summary_df)

    # Create markdown report
    report_path = joinpath(output_dir, "reports", "place_types.md")

    open(report_path, "w") do io
        println(io, "# Place Type Distribution Analysis")

        println(io, "\n## Most Common Place Types")
        println(
            io,
            "\n| Rank | Place Type | Streets With | % Streets | Total Count | Mean Count |"
        )
        println(
            io,
            "|------|------------|--------------|-----------|-------------|------------|"
        )

        for (i, row) in enumerate(eachrow(first(summary_df, 10)))
            println(
                io,
                "| $i | $(row.place_type) | $(row.streets_with_type) | " *
                "$(row.percent_streets)% | $(row.total_count) | " *
                "$(round(row.mean_when_present, digits=2)) |"
            )
        end

        # Calculate co-location patterns
        println(io, "\n## Place Type Combinations")

        # Find streets with multiple place types
        place_counts = [
            sum(features[i, col] > 0 for col in place_cols) for i = 1:nrow(features)
        ]

        println(io, "\n### Streets by Number of Different Place Types")
        for n = 0:10
            count = sum(place_counts .== n)
            if count > 0
                pct = round(100 * count / nrow(features); digits = 1)
                println(io, "- $n place types: $count streets ($pct%)")
            end
        end
    end

    @info "Place type summary saved"
end

function save_dataset_summary(
    incident_matched::DataFrame,
    arrest_matched::DataFrame,
    place_matched::DataFrame,
    total_streets::Int
)
    @info "Creating dataset summary table..."

    descriptive_dir = joinpath(OUTPUT_DIR, "descriptive")
    mkpath(descriptive_dir)

    summary_rows = []

    # Crime incident counts by type
    for crime_category in CRIME_CATEGORIES
        category_incidents = filter(row -> row.crime == crime_category, incident_matched)
        total_count = nrow(category_incidents)

        if "street_id" in names(category_incidents)
            unique_streets = length(unique(category_incidents.street_id))
            percent_streets = round(100 * unique_streets / total_streets; digits = 2)
            count_by_street = combine(
                groupby(category_incidents, :street_id), nrow => :count
            )
            avg_per_street = round(mean(count_by_street.count); digits = 2)

            push!(
                summary_rows,
                (
                    dataset_name = "Incidents",
                    crime_or_place_type_name = crime_category,
                    total_count = total_count,
                    streets_with_any_count = unique_streets,
                    percent_streets = percent_streets,
                    avg_per_street = avg_per_street
                )
            )
        end
    end

    # Arrest counts by type
    for crime_category in CRIME_CATEGORIES
        category_arrests = filter(row -> row.crime == crime_category, arrest_matched)
        total_count = nrow(category_arrests)

        if "street_id" in names(category_arrests)
            unique_streets = length(unique(category_arrests.street_id))
            percent_streets = round(100 * unique_streets / total_streets; digits = 2)
            count_by_street = combine(groupby(category_arrests, :street_id), nrow => :count)
            avg_per_street = round(mean(count_by_street.count); digits = 2)

            push!(
                summary_rows,
                (
                    dataset_name = "Arrests",
                    crime_or_place_type_name = crime_category,
                    total_count = total_count,
                    streets_with_any_count = unique_streets,
                    percent_streets = percent_streets,
                    avg_per_street = avg_per_street
                )
            )
        end
    end

    # Place counts by category
    if "category" in names(place_matched) && "street_id" in names(place_matched)
        place_categories = unique(place_matched.category)

        for place_category in place_categories
            category_places = filter(row -> row.category == place_category, place_matched)
            total_count = nrow(category_places)
            unique_streets = length(unique(category_places.street_id))
            percent_streets = round(100 * unique_streets / total_streets; digits = 2)
            count_by_street = combine(groupby(category_places, :street_id), nrow => :count)
            avg_per_street = round(mean(count_by_street.count); digits = 2)

            push!(
                summary_rows,
                (
                    dataset_name = "Places",
                    crime_or_place_type_name = place_category,
                    total_count = total_count,
                    streets_with_any_count = unique_streets,
                    percent_streets = percent_streets,
                    avg_per_street = avg_per_street
                )
            )
        end
    end

    # Create DataFrame and save
    summary_df = DataFrame(summary_rows)
    output_path = joinpath(descriptive_dir, "dataset_summary.csv")
    CSV.write(output_path, summary_df)

    @info "Dataset summary saved to: $output_path"
    @info "Total rows: $(nrow(summary_df))"

    return nothing
end

"""
Calculate and save crime concentration statistics by crime type following
Weisburd's crime concentration framework.

Saves to: output/descriptive/crime_concentration_by_type.csv

# Arguments

  - `features::DataFrame`: Street-level feature matrix with crime counts
  - `dataset_name::String`: Either "incidents" or "arrests"
"""
function save_crime_concentration_by_type(features::DataFrame, dataset_name::String)
    @info "Calculating crime concentration statistics for $dataset_name..."

    descriptive_dir = joinpath(OUTPUT_DIR, "descriptive")
    mkpath(descriptive_dir)

    concentration_rows = []

    total_streets_count = nrow(features)

    for crime_category in CRIME_CATEGORIES
        crime_column_name = "crime_$(crime_category)"

        if crime_column_name in names(features)
            crime_counts = features[!, crime_column_name]
            total_crime_count = sum(crime_counts)
            streets_with_crime_count = sum(crime_counts .> 0)
            percent_streets_with_crime = round(
                100 * streets_with_crime_count / total_streets_count; digits = 2
            )

            # Calculate concentration percentiles
            # Sort streets by crime count (descending)
            sorted_crime_counts = sort(crime_counts; rev = true)
            cumulative_crime = cumsum(sorted_crime_counts)

            # Find how many streets account for X% of crime
            pct_25_streets = 0
            pct_50_streets = 0
            pct_75_streets = 0
            pct_90_streets = 0

            if total_crime_count > 0
                threshold_25 = 0.25 * total_crime_count
                threshold_50 = 0.50 * total_crime_count
                threshold_75 = 0.75 * total_crime_count
                threshold_90 = 0.90 * total_crime_count

                idx_25 = findfirst(x -> x >= threshold_25, cumulative_crime)
                idx_50 = findfirst(x -> x >= threshold_50, cumulative_crime)
                idx_75 = findfirst(x -> x >= threshold_75, cumulative_crime)
                idx_90 = findfirst(x -> x >= threshold_90, cumulative_crime)

                pct_25_streets = if !isnothing(idx_25)
                    round(100 * idx_25 / total_streets_count; digits = 2)
                else
                    0.0
                end
                pct_50_streets = if !isnothing(idx_50)
                    round(100 * idx_50 / total_streets_count; digits = 2)
                else
                    0.0
                end
                pct_75_streets = if !isnothing(idx_75)
                    round(100 * idx_75 / total_streets_count; digits = 2)
                else
                    0.0
                end
                pct_90_streets = if !isnothing(idx_90)
                    round(100 * idx_90 / total_streets_count; digits = 2)
                else
                    0.0
                end
            end

            push!(
                concentration_rows,
                (
                    dataset_name = dataset_name,
                    crime_type_name = crime_category,
                    total_crime_count = total_crime_count,
                    total_streets_count = total_streets_count,
                    streets_with_crime_count = streets_with_crime_count,
                    percent_streets_with_crime = percent_streets_with_crime,
                    percent_streets_accounting_for_25_percent_crime = pct_25_streets,
                    percent_streets_accounting_for_50_percent_crime = pct_50_streets,
                    percent_streets_accounting_for_75_percent_crime = pct_75_streets,
                    percent_streets_accounting_for_90_percent_crime = pct_90_streets
                )
            )
        end
    end

    # Create DataFrame and save
    concentration_df = DataFrame(concentration_rows)
    output_path = joinpath(descriptive_dir, "crime_concentration_$(dataset_name).csv")
    CSV.write(output_path, concentration_df)

    @info "Crime concentration statistics saved to: $output_path"

    return nothing
end

"""
Save target variable threshold analysis including all methods: top25, top50,
median, and Jenks natural breaks.

Saves to: output/descriptive/target_thresholds_[dataset_name].csv

# Arguments

  - `features::DataFrame`: Street-level feature matrix with crime counts and binary targets
  - `dataset_name::String`: Either "incidents" or "arrests"
"""
function save_target_thresholds_summary(features::DataFrame, dataset_name::String)
    @info "Creating target variable thresholds summary for $dataset_name..."

    descriptive_dir = joinpath(OUTPUT_DIR, "descriptive")
    mkpath(descriptive_dir)

    threshold_rows = []

    # All threshold methods
    threshold_methods = ["top25", "top50", "median", "jenks"]

    for crime_category in CRIME_CATEGORIES
        crime_column_name = "crime_$(crime_category)"
        crime_lower = lowercase(crime_category)

        if crime_column_name in names(features)
            crime_counts = features[!, crime_column_name]
            total_crime_count = sum(crime_counts)

            for threshold_method_name in threshold_methods
                target_column_name = "high_$(crime_lower)_$(threshold_method_name)"

                if target_column_name in names(features)
                    target_flags = features[!, target_column_name]
                    streets_flagged_count = sum(target_flags)
                    percent_streets_flagged = round(
                        100 * streets_flagged_count / nrow(features); digits = 2
                    )

                    # Calculate how much crime is captured by flagged streets
                    crime_in_flagged_streets = sum(crime_counts[target_flags])
                    percent_crime_captured = if total_crime_count > 0
                        round(100 * crime_in_flagged_streets / total_crime_count; digits = 2)
                    else
                        0.0
                    end

                    # Find the threshold value (minimum crime count in flagged streets)
                    threshold_value =
                        streets_flagged_count > 0 ? minimum(crime_counts[target_flags]) : 0

                    push!(
                        threshold_rows,
                        (
                            dataset_name = dataset_name,
                            crime_type_name = crime_category,
                            threshold_method_name = threshold_method_name,
                            threshold_value = threshold_value,
                            streets_flagged_count = streets_flagged_count,
                            percent_streets_flagged = percent_streets_flagged,
                            percent_crime_captured = percent_crime_captured,
                            total_crime_count = total_crime_count
                        )
                    )
                end
            end
        end
    end

    # Create DataFrame and save
    thresholds_df = DataFrame(threshold_rows)
    output_path = joinpath(descriptive_dir, "target_thresholds_$(dataset_name).csv")
    CSV.write(output_path, thresholds_df)

    @info "Target thresholds summary saved to: $output_path"
    @info "Threshold methods included: $(join(threshold_methods, ", "))"

    return nothing
end

"""
Extract and document the crime and place category mapping rules for
reproducibility.

Creates two files:

  - output/metadata/crime_category_mapping.csv: Maps offense descriptions to crime categories
  - output/metadata/place_category_mapping.csv: Maps Google place types to analysis categories

# Arguments

  - None (extracts mappings directly from processing logic)
"""
function save_category_mappings()
    @info "Documenting category mappings for reproducibility..."

    metadata_dir = joinpath(OUTPUT_DIR, "metadata")
    mkpath(metadata_dir)

    # Crime category mapping documentation
    crime_mapping_rows = [
        (
            offense_pattern = "MURDER|RAPE|ASSAULT|ROBBERY|MANSLAUGHTER|SHOOTING",
            crime_category = "VIOLENCE",
            description = "Violent crimes including murder, rape, assault, robbery, manslaughter, and shootings"
        ),
        (
            offense_pattern = "LARCENY|THEFT (excluding IDENTITY)",
            crime_category = "LARCENY",
            description = "All larceny and theft offenses (petit larceny, grand larceny, larceny from vehicle) excluding identity theft"
        ),
        (
            offense_pattern = "BURGLARY",
            crime_category = "BURGLARY",
            description = "All burglary offenses"
        ),
        (
            offense_pattern = "DRUG|NARCOTIC|MARIJUANA|CONTROLLED",
            crime_category = "DRUGS",
            description = "All drug-related offenses including narcotics, marijuana, and controlled substances"
        )
    ]

    crime_mapping_df = DataFrame(crime_mapping_rows)
    crime_output_path = joinpath(metadata_dir, "crime_category_mapping.csv")
    CSV.write(crime_output_path, crime_mapping_df)
    @info "Crime category mapping saved to: $crime_output_path"

    # Place category mapping documentation
    # This documents the major categories - full mapping is in processing.jl
    place_mapping_rows = [
        (
            place_category = "AUTOMOTIVE",
            example_types = "car_dealer, car_rental, car_repair, gas_station, parking",
            description = "Automotive sales, service, and infrastructure"
        ),
        (
            place_category = "BUSINESS",
            example_types = "corporate_office, farm, ranch",
            description = "Business and corporate facilities"
        ),
        (
            place_category = "CULTURE",
            example_types = "art_gallery, museum, theater, monument",
            description = "Cultural venues and landmarks"
        ),
        (
            place_category = "EDUCATION",
            example_types = "library, school, university, preschool",
            description = "Educational institutions at all levels"
        ),
        (
            place_category = "ENTERTAINMENT_RECREATION",
            example_types = "park, night_club, movie_theater, casino, amusement_park",
            description = "Entertainment and recreational venues"
        ),
        (
            place_category = "FACILITIES",
            example_types = "public_bath, public_bathroom, stable",
            description = "Public facilities and infrastructure"
        ),
        (
            place_category = "FINANCE",
            example_types = "bank, atm, accounting",
            description = "Financial institutions and services"
        ),
        (
            place_category = "FOOD_DRINK",
            example_types = "restaurant, cafe, bar, bakery, fast_food",
            description = "Food and beverage establishments of all types"
        ),
        (
            place_category = "GOVERNMENT",
            example_types = "city_hall, police, fire_station, post_office, courthouse",
            description = "Government facilities and public safety"
        ),
        (
            place_category = "HEALTH_WELLNESS",
            example_types = "hospital, pharmacy, doctor, dentist, spa, gym",
            description = "Healthcare and wellness facilities"
        ),
        (
            place_category = "LODGING",
            example_types = "hotel, motel, hostel, bed_and_breakfast",
            description = "Temporary lodging and accommodations"
        ),
        (
            place_category = "NATURAL_FEATURE",
            example_types = "beach",
            description = "Natural geographical features"
        ),
        (
            place_category = "PLACE_OF_WORSHIP",
            example_types = "church, synagogue, mosque, hindu_temple",
            description = "Religious facilities"
        ),
        (
            place_category = "SERVICES",
            example_types = "hair_salon, laundry, lawyer, real_estate, florist",
            description = "Personal and professional services"
        ),
        (
            place_category = "SHOPPING",
            example_types = "grocery_store, shopping_mall, clothing_store, bookstore",
            description = "Retail and shopping establishments"
        ),
        (
            place_category = "SPORTS_RECREATION",
            example_types = "gym, sports_club, golf_course, stadium",
            description = "Sports and athletic facilities"
        ),
        (
            place_category = "TRANSIT",
            example_types = "bus_station, subway_station, train_station, airport",
            description = "Transportation hubs and transit facilities"
        ),
        (
            place_category = "OTHER",
            example_types = "unclassified or missing types",
            description = "Places that don't fit other categories"
        )
    ]

    place_mapping_df = DataFrame(place_mapping_rows)
    place_output_path = joinpath(metadata_dir, "place_category_mapping.csv")
    CSV.write(place_output_path, place_mapping_df)
    @info "Place category mapping saved to: $place_output_path"

    @info "Category mapping documentation complete"

    return nothing
end

function create_summary_visualizations(features::DataFrame)::Nothing
    @info "Creating summary visualizations..."

    # Create figures directory
    figures_dir = joinpath(OUTPUT_DIR, "figures")
    mkpath(figures_dir)

    # === Crime Distribution Plot ===
    crime_cols = [col for col in names(features) if startswith(String(col), "crime_")]

    if !isempty(crime_cols)
        crime_totals = [sum(features[!, col]) for col in crime_cols]
        crime_names = [replace(String(col), "crime_" => "") for col in crime_cols]

        fig1 = Figure(; size = (800, 600))
        ax1 = Axis(
            fig1[1, 1];
            title = "Crime Distribution by Category",
            xlabel = "Crime Category",
            ylabel = "Total Incidents"
        )

        barplot!(ax1, 1:length(crime_names), crime_totals; color = :steelblue)
        ax1.xticks = (1:length(crime_names), crime_names)
        ax1.xticklabelrotation = π / 4

        save(joinpath(figures_dir, "crime_distribution.png"), fig1)
        @info "Saved crime distribution plot"
    end

    # === Place Distribution Plot ===
    place_cols = [
        col for col in names(features) if !startswith(String(col), "crime_") &&
        !startswith(String(col), "high_") &&
        !in(
            col,
            [
                :street_id,
                :street_name,
                :total_crime,
                :total_places,
                :crime_place_ratio,
                :commercial_activity
            ]
        )
    ]

    if !isempty(place_cols)
        place_totals = [sum(features[!, col]) for col in place_cols]
        place_names = [String(col) for col in place_cols]

        # Only show categories with some activity
        active_indices = findall(x -> x > 0, place_totals)

        if !isempty(active_indices)
            active_totals = place_totals[active_indices]
            active_names = place_names[active_indices]

            fig2 = Figure(; size = (800, 600))
            ax2 = Axis(
                fig2[1, 1];
                title = "Place Distribution by Category",
                xlabel = "Place Category",
                ylabel = "Total Places"
            )

            barplot!(ax2, 1:length(active_names), active_totals; color = :darkgreen)
            ax2.xticks = (1:length(active_names), active_names)
            ax2.xticklabelrotation = π / 4

            save(joinpath(figures_dir, "place_distribution.png"), fig2)
            @info "Saved place distribution plot"
        end
    end

    # === Feature Correlation Heatmap ===
    # Select numeric columns for correlation analysis
    numeric_cols = []
    for col in names(features)
        if eltype(features[!, col]) <: Number &&
            !in(col, [:street_id]) &&
            length(unique(features[!, col])) > 1
            push!(numeric_cols, col)
        end
    end

    if length(numeric_cols) >= 2
        # Calculate correlation matrix for a subset of key features
        key_features = numeric_cols[1:min(10, length(numeric_cols))]  # Limit to first 10

        try
            corr_matrix = cor(Matrix(features[!, key_features]))

            fig3 = Figure(; size = (800, 800))
            ax3 = Axis(
                fig3[1, 1];
                title = "Feature Correlations",
                xlabel = "Features",
                ylabel = "Features"
            )

            heatmap!(ax3, corr_matrix; colormap = :RdBu, colorrange = (-1, 1))
            ax3.xticks = (1:length(key_features), String.(key_features))
            ax3.yticks = (1:length(key_features), String.(key_features))
            ax3.xticklabelrotation = π / 4

            save(joinpath(figures_dir, "feature_correlations.png"), fig3)
            @info "Saved feature correlation heatmap"
        catch e
            @debug "Could not create correlation plot: $e"
        end
    end

    # === Spatial Distribution Plot ===
    if :distance_to_center in names(features) && :total_crime in names(features)
        try
            fig4 = Figure(; size = (800, 600))
            ax4 = Axis(
                fig4[1, 1];
                title = "Crime vs Distance to Manhattan Center",
                xlabel = "Distance to Center (km)",
                ylabel = "Total Crime Incidents"
            )

            scatter!(
                ax4,
                features.distance_to_center,
                features.total_crime;
                alpha = 0.6,
                markersize = 8,
                color = :red
            )

            save(joinpath(figures_dir, "spatial_distribution.png"), fig4)
            @info "Saved spatial distribution plot"
        catch e
            @debug "Could not create spatial plot: $e"
        end
    end

    @info "Summary visualizations complete"
end

function create_model_visualizations(
    models::Dict{Symbol, Any}, coefficients_df::DataFrame
)::Nothing
    @info "Creating model visualizations..."

    figures_dir = joinpath(OUTPUT_DIR, "figures")
    mkpath(figures_dir)

    # === Coefficient Forest Plot ===
    # Show top significant coefficients across models
    significant_coefs = filter(
        row -> row.p_value < 0.05 && row.term != "(Intercept)", coefficients_df
    )

    if nrow(significant_coefs) > 0
        # Get top coefficients by absolute value
        significant_coefs[!, :abs_coef] = abs.(significant_coefs.coefficient)
        sort!(significant_coefs, :abs_coef; rev = true)

        top_coefs = significant_coefs[1:min(20, nrow(significant_coefs)), :]

        try
            fig5 = Figure(; size = (1000, 800))
            ax5 = Axis(
                fig5[1, 1];
                title = "Top Model Coefficients (Significant)",
                xlabel = "Coefficient Value",
                ylabel = "Predictor"
            )

            # Create forest plot
            y_positions = 1:nrow(top_coefs)
            coeffs = top_coefs.coefficient
            std_errs = top_coefs.std_error

            # Plot coefficients with confidence intervals
            scatter!(ax5, coeffs, y_positions; markersize = 8, color = :blue)

            # Add confidence intervals
            for i = 1:length(coeffs)
                ci_lower = coeffs[i] - 1.96 * std_errs[i]
                ci_upper = coeffs[i] + 1.96 * std_errs[i]
                lines!(ax5, [ci_lower, ci_upper], [i, i]; color = :gray, linewidth = 2)
            end

            # Add vertical line at zero
            vlines!(ax5, [0]; color = :red, linestyle = :dash, linewidth = 2)

            ax5.yticks = (y_positions, top_coefs.term)

            save(joinpath(figures_dir, "coefficient_plots.png"), fig5)
            @info "Saved coefficient forest plot"
        catch e
            @debug "Could not create coefficient plot: $e"
        end
    end

    # === Model Comparison Plot ===
    try
        model_summaries = calculate_model_summaries(models)

        if nrow(model_summaries) > 0
            fig6 = Figure(; size = (800, 600))
            ax6 = Axis(
                fig6[1, 1];
                title = "Model Comparison - McFadden R²",
                xlabel = "Model",
                ylabel = "McFadden R²"
            )

            barplot!(
                ax6, 1:nrow(model_summaries), model_summaries.mcfadden_r2; color = :purple
            )
            ax6.xticks = (
                1:nrow(model_summaries),
                [replace(m, "high_" => "") for m in model_summaries.model]
            )
            ax6.xticklabelrotation = π / 4

            save(joinpath(figures_dir, "model_comparison.png"), fig6)
            @info "Saved model comparison plot"
        end
    catch e
        @debug "Could not create model comparison plot: $e"
    end

    @info "Model visualizations complete"
end

function generate_summary_report(features::DataFrame, models::Dict{Symbol, Any})::Nothing
    @info "Generating summary report..."

    report_path = joinpath(OUTPUT_DIR, "summary_report.md")

    open(report_path, "w") do io
        # Header
        println(io, "# Dissertation Analysis Summary Report")
        println(io, "Generated on: $(now())")
        println(io)

        # Data Summary
        println(io, "## Data Summary")
        println(io, "- **Streets analyzed:** $(nrow(features))")
        println(io, "- **Total features:** $(ncol(features) - 2)")  # Exclude street_id, street_name

        crime_cols = [col for col in names(features) if startswith(String(col), "crime_")]
        if !isempty(crime_cols)
            total_crimes = sum([sum(features[!, col]) for col in crime_cols])
            println(io, "- **Total crime incidents:** $(total_crimes)")
        end

        place_cols = [
            col for col in names(features) if !startswith(String(col), "crime_") &&
            !startswith(String(col), "high_") &&
            !in(
                col,
                [
                    :street_id,
                    :street_name,
                    :total_crime,
                    :total_places,
                    :crime_place_ratio,
                    :commercial_activity
                ]
            )
        ]
        if !isempty(place_cols)
            total_places = sum([sum(features[!, col]) for col in place_cols])
            println(io, "- **Total places:** $(total_places)")
        end

        println(io)

        # Model Results
        println(io, "## Model Results")
        println(io, "- **Models fitted:** $(length(models))")

        model_summaries = calculate_model_summaries(models)
        if nrow(model_summaries) > 0
            avg_r2 = mean(model_summaries.mcfadden_r2)
            println(io, "- **Average McFadden R²:** $(round(avg_r2, digits=3))")

            println(io, "\n### Individual Model Performance")
            for row in eachrow(model_summaries)
                println(
                    io,
                    "- **$(replace(row.model, "high_" => "")):** R² = $(round(row.mcfadden_r2, digits=3)), AIC = $(round(row.aic, digits=1))"
                )
            end
        end

        println(io)

        # Significant Predictors
        coefficients_df = extract_model_coefficients(models)
        significant_predictors = identify_significant_predictors(coefficients_df)

        if nrow(significant_predictors) > 0
            println(io, "## Key Findings")
            println(io, "### Most Important Predictors")

            top_predictors = significant_predictors[
                1:min(5, nrow(significant_predictors)), :
            ]
            for row in eachrow(top_predictors)
                effect_dir = row.effect_direction == "positive" ? "increases" : "decreases"
                println(
                    io,
                    "- **$(row.term):** Consistently $(effect_dir) crime risk ($(row.n_significant_models) models, avg coef: $(round(row.mean_coefficient, digits=3)))"
                )
            end
        end

        println(io)
        println(io, "## Files Generated")
        println(io, "- Feature matrix: `data/street_features.csv`")
        println(io, "- Model summaries: `models/model_summaries.csv`")
        println(io, "- Model coefficients: `models/model_coefficients.csv`")
        println(io, "- Model predictions: `models/model_predictions.csv`")
        println(io, "- Performance metrics: `models/model_performance.csv`")
        return println(io, "- Visualizations: `figures/` directory")
    end

    @info "Saved summary report to $report_path"
end

function print_analysis_summary(features::DataFrame, models::Dict{Symbol, Any})::Nothing
    println("\n" * "="^60)
    println("DISSERTATION ANALYSIS COMPLETE")
    println("="^60)

    # Data summary
    println("DATA PROCESSED:")
    println("   - Streets analyzed: $(nrow(features))")

    crime_cols = [col for col in names(features) if startswith(String(col), "crime_")]
    if !isempty(crime_cols)
        total_crimes = sum([sum(features[!, col]) for col in crime_cols])
        println("   - Crime incidents: $(total_crimes)")
    end

    println("   - Features created: $(ncol(features) - 2)")

    # Model summary
    println("\nMODELS FITTED:")
    model_summaries = calculate_model_summaries(models)

    for row in eachrow(model_summaries)
        crime_type = replace(row.model, "high_" => "")
        r2_str = round(row.mcfadden_r2; digits = 3)
        aic_str = round(row.aic; digits = 1)
        println("   - $(uppercase(crime_type)): R² = $(r2_str), AIC = $(aic_str)")
    end

    # Top predictors
    coefficients_df = extract_model_coefficients(models)
    significant_predictors = identify_significant_predictors(coefficients_df)

    if nrow(significant_predictors) > 0
        println("\nTOP PREDICTORS:")
        top_3 = significant_predictors[1:min(3, nrow(significant_predictors)), :]
        for row in eachrow(top_3)
            effect = row.effect_direction == "positive" ? "increases" : "decreases"
            println("   - $(row.term) $(effect) crime ($(row.n_significant_models) models)")
        end
    end

    println("\nOUTPUT SAVED TO: $(OUTPUT_DIR)")
    return println("="^60)
end
