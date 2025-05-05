module Modeling

using DataFrames, GLM, StatsModels, Printf, CategoricalArrays, CSV, StatsBase

export fit_logit_models, save_model_summaries, save_model_coefficients

"""
    fit_logit_models(df::DataFrame, target_cols::Vector{Symbol}, place_terms::Vector{Term})

Fits logistic regression models (GLM with Bernoulli distribution and Logit link)
for each specified target column in the DataFrame, using the place_terms as predictors.

# Arguments
- `df::DataFrame`: The input DataFrame containing target and predictor columns.
- `target_cols::Vector{Symbol}`: Vector of Symbols for the target variables (e.g., :top_25_VIOLENCE).
- `place_terms::Vector{Term}`: Vector of Terms representing the predictor variables (e.g., from place categories).

# Returns
- `Dict{Symbol, StatsModels.TableRegressionModel}`: A dictionary where keys are the target
  variable symbols and values are the fitted `StatsModels.TableRegressionModel` models.
"""
function fit_logit_models(
    df::DataFrame,
    target_cols::Vector{Symbol},
    place_terms::Vector{Term},
)::Dict{Symbol,StatsModels.TableRegressionModel}
    # Initialize dictionary to store models
    fitted_models = Dict{Symbol,StatsModels.TableRegressionModel}()

    # Filter target columns that actually exist in the DataFrame using hasproperty
    valid_target_cols = filter(tc -> hasproperty(df, tc), target_cols)
    if isempty(valid_target_cols)
        @warn "None of the specified target columns were found in the DataFrame."
        return fitted_models
    end

    println("Starting model fitting for $(length(valid_target_cols)) target variables...")

    for target_sym in valid_target_cols
        println("Fitting model for: $target_sym")

        # Ensure target column is suitable (e.g., boolean or 0/1)
        if !(eltype(df[!, target_sym]) <: Union{Bool, Integer})
             @warn "Target column $target_sym is not Bool or Integer. Skipping."
             continue
        end
        # Check for sufficient variation in target (at least two unique values, e.g., 0 and 1)
        if length(unique(df[!, target_sym])) < 2
            @warn "Target column $target_sym has less than 2 unique values (needs both 0 and 1). Skipping."
            continue
        end

        # Create the formula: target ~ cat1 + cat2 + ...
        formula = Term(target_sym) ~ sum(place_terms)

        try
            # Fit the logistic regression model directly using the DataFrame
            # Bernoulli() works with Bool or Integer (0/1) types like BitVector
            model = glm(formula, df, Bernoulli(), LogitLink())

            # Store the fitted model
            fitted_models[target_sym] = model
            println("Successfully fitted model for $target_sym.")

        catch e
            println("Error fitting model for $target_sym: $e")
            # Optionally rethrow(e) or continue
        end
    end
    println("Finished model fitting. $(length(fitted_models)) models fitted successfully.")
    return fitted_models
end


"""
    save_model_summaries(models::Dict{Symbol, StatsModels.TableRegressionModel}, output_dir::String)

Saves a Markdown summary for each fitted model to a file.

# Arguments
- `models::Dict{Symbol, StatsModels.TableRegressionModel}`: Dictionary mapping target variable symbols to fitted GLM models.
- `output_dir::String`: The base directory where the 'model_summaries' subdirectory will be created/used.
"""
function save_model_summaries(models::Dict{Symbol,StatsModels.TableRegressionModel}, output_dir::String)
    summaries_dir = joinpath(output_dir, "model_summaries") # Define subdirectory path
    mkpath(summaries_dir) # Ensure the subdirectory exists
    println("Saving model summaries to $summaries_dir...")

    for (model_name, model) in models
        try
            # Start building the summary string (Markdown)
            summary_lines = Vector{String}()
            push!(summary_lines, "# Model Summary: $(model_name)\n")

            # Add formula
            formula_str = string(model.mf.f)
            push!(summary_lines, "## Formula\n")
            push!(summary_lines, "```")
            push!(summary_lines, formula_str)
            push!(summary_lines, "```\n")

            # Add model diagnostics
            push!(summary_lines, "## Model Diagnostics\n")
            # push!(summary_lines, "----------------") # Markdown uses headings, not dashes
            try push!(summary_lines, @sprintf("- **Observations:**     `%d`", nobs(model))) catch e push!(summary_lines, "- **Observations:**     *Error retrieving ($e)*") end
            try push!(summary_lines, @sprintf("- **Deviance:**         `%.4f`", deviance(model))) catch e push!(summary_lines, "- **Deviance:**         *Error retrieving ($e)*") end
            # Calculate nulldeviance for R² calculation
            null_dev = NaN
            try null_dev = nulldeviance(model) catch e push!(summary_lines, "- **Null Deviance:**    *Error retrieving ($e)*") end
            if !isnan(null_dev) push!(summary_lines, @sprintf("- **Null Deviance:**    `%.4f`", null_dev)) end

            try push!(summary_lines, @sprintf("- **Log-Likelihood:**   `%.4f`", loglikelihood(model))) catch e push!(summary_lines, "- **Log-Likelihood:**   *Error retrieving ($e)*") end
            try push!(summary_lines, @sprintf("- **AIC:**              `%.4f`", aic(model))) catch e push!(summary_lines, "- **AIC:**              *Error retrieving ($e)*") end
            try push!(summary_lines, @sprintf("- **BIC:**              `%.4f`", bic(model))) catch e push!(summary_lines, "- **BIC:**              *Error retrieving ($e)*") end
            # Calculate McFadden's R² manually
            r_squared_mcfadden = NaN
            if !isnan(null_dev) && null_dev != 0
                try r_squared_mcfadden = 1 - deviance(model) / null_dev catch e push!(summary_lines, "- **McFadden's R²:**    *Error calculating ($e)*") end
            elseif null_dev == 0
                 push!(summary_lines, "- **McFadden's R²:**    *Cannot calculate (Null Deviance is zero)*")
            end
            if !isnan(r_squared_mcfadden) push!(summary_lines, @sprintf("- **McFadden's R²:**    `%.4f`", r_squared_mcfadden)) end
            push!(summary_lines, "") # Blank line for spacing

            # Add coefficients table in a code block
            ct = coeftable(model)
            push!(summary_lines, "## Coefficients\n")
            push!(summary_lines, "```")
            push!(summary_lines, string(ct)) # Convert CoefTable to string
            push!(summary_lines, "```")
            
            # Join lines for the final string
            summary_str = join(summary_lines, "\n")

            # Define output filename with .md extension
            output_filename = joinpath(summaries_dir, string(model_name) * "_summary.md")

            open(output_filename, "w") do file
                write(file, summary_str)
            end
            println("  Saving summary for: $model_name to $(basename(output_filename))")
        catch e
            @error "Error saving summary for model '$model_name': $e"
        end
    end
    println("Finished saving model summaries.")
end


"""
    save_model_coefficients(models::Dict{Symbol, StatsModels.TableRegressionModel}, output_dir::String)

Saves the coefficient table for each fitted model to a separate CSV file.

# Arguments
- `models::Dict{Symbol, StatsModels.TableRegressionModel}`: Dictionary mapping target variable symbols to fitted GLM models.
- `output_dir::String`: The base directory where the 'model_coefficients' subdirectory will be created/used.
"""
function save_model_coefficients(models::Dict{Symbol,StatsModels.TableRegressionModel}, output_dir::String)
    coeffs_dir = joinpath(output_dir, "model_coefficients")
    mkpath(coeffs_dir) # Ensure the subdirectory exists
    println("Saving model coefficients to $coeffs_dir...")

    for (model_name, model) in models
        try
            ct = coeftable(model)
            # Convert CoefTable to DataFrame
            # Rows are predictors, Columns are Estimate, Std. Error, z value, Pr(>|z|)
            df_coeffs = DataFrame(
                predictor = ct.rownms,
                coefficient = ct.cols[1],
                std_error = ct.cols[2],
                z_value = ct.cols[3],
                p_value = ct.cols[4]
            )

            output_filename = joinpath(coeffs_dir, string(model_name) * "_coeffs.csv")
            CSV.write(output_filename, df_coeffs)
            println("  Saved coefficients for: $model_name to $(basename(output_filename))")
        catch e
            @error "Error saving coefficients for model '$model_name': $e"
            # Optionally rethrow or continue to next model
        end
    end
    println("Finished saving model coefficients.")
end

end # module Modeling