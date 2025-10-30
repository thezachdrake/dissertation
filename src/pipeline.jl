function run(;
    download_data::Bool = false,
    force_reprocess::Bool = false,
    target_methods::Vector{String} = split(
        get(ENV, "TARGET_METHODS", "top25,top50,median,jenks"), ","
    )
)::Dict{Symbol, Any}
    @info "Starting Dissertation Analysis Pipeline" timestamp = now()

    start_time = time()

    try
        @info "Step 1: Data Acquisition"

        if download_data
            @info "Downloading fresh data from APIs..."

            # Check for required API keys
            if !haskey(ENV, "SODA_KEY")
                error("SODA_KEY environment variable required for NYC Open Data access")
            end

            if !haskey(ENV, "GOOGLE_MAPS_KEY")
                error(
                    "GOOGLE_MAPS_KEY environment variable required for Google Places API access"
                )
            end

            # Download all data sources
            download_crime_data()
            download_place_data()
            download_street_data()

        else
            @info "Using existing data files..."

            # Verify required data files exist
            required_files = [
                joinpath(DATA_DIR, "incidents.geojson"),
                joinpath(DATA_DIR, "arrests.geojson"),
                joinpath(DATA_DIR, "streets.geojson")
            ]

            places_dir = joinpath(DATA_DIR, "places")

            missing_files = []
            for file in required_files
                if !isfile(file)
                    push!(missing_files, file)
                end
            end

            if !isdir(places_dir) || length(readdir(places_dir)) == 0
                push!(missing_files, places_dir)
            end

            if !isempty(missing_files)
                @warn "Missing data files: $(join(missing_files, ", "))"
                @info "Consider running with download_data=true to fetch missing data"
                error(
                    "Required data files not found. Run with download_data=true or ensure data files exist."
                )
            end
        end

        @info "Step 2: Checking for cached data..."

        # Define cache file path
        features_cache = joinpath(OUTPUT_DIR, "data", "street_features.csv")

        features = nothing

        if isfile(features_cache) && !force_reprocess
            @info "Found cached feature matrix, loading..."

            try
                features = CSV.read(features_cache, DataFrame)
                @info "Loaded cached features: $(nrow(features)) streets, $(ncol(features)) columns"
            catch e
                @warn "Failed to load cached features: $e"
                @info "Will reprocess from raw data..."
                features = nothing
            end
        else
            if force_reprocess
                @info "Force reprocess flag set - will regenerate all features"
            else
                @info "No cached features found - will process from raw data"
            end
        end

        if features === nothing
            @info "Step 3: Processing raw data..."

            # Process each data source separately
            @info "Processing incident data..."
            incident_data = process_incident_data()

            @info "Processing arrest data..."
            arrest_data = process_arrest_data()

            @info "Processing place data..."
            place_data = process_place_data()

            @info "Processing street data..."
            street_data = process_street_data()

            @info "Step 4: Performing spatial analysis..."

            @info "Matching incident locations to streets..."
            incident_matched = match_points_to_streets(incident_data, street_data)

            # Calculate and log spatial statistics
            incident_spatial_stats = calculate_spatial_statistics(incident_matched)

            @info "Matching arrest locations to streets..."
            arrest_matched = match_points_to_streets(arrest_data, street_data)

            # Calculate and log spatial statistics
            arrest_spatial_stats = calculate_spatial_statistics(arrest_matched)

            @info "Matching place locations to streets..."
            place_matched = match_points_to_streets(place_data, street_data)

            place_spatial_stats = calculate_spatial_statistics(place_matched)

            # Filter by distance to remove intersection crimes and poor matches
            @info "Filtering points by distance to improve match quality..."
            incident_matched = filter_points_by_distance(incident_matched, 10)
            arrest_matched = filter_points_by_distance(arrest_matched, 10)
            # place_matched = filter_points_by_distance(place_matched, 10)

            @info "Step 5: Creating separate feature matrices..."

            # Create separate feature matrices for incidents and arrests
            incident_features = create_street_features(
                incident_matched, place_matched, street_data
            )
            arrest_features = create_street_features(
                arrest_matched, place_matched, street_data
            )

            # Spatial features removed - not needed for analysis

            @info "Feature engineering complete: $(nrow(incident_features)) streets for incidents, $(nrow(arrest_features)) streets for arrests"
        else
            @info "Step 3-5: Skipped (using cached features)"
        end

        @info "Step 5a: Analyzing place type co-occurrence (Research Question 1)..."

        # Run co-occurrence analysis for Research Question 1
        # Use incident_features since place data is the same for both
        cooccurrence_results = run_cooccurrence_analysis(incident_features)

        if haskey(cooccurrence_results, :pairs_analysis)
            n_pairs = nrow(cooccurrence_results[:pairs_analysis])
            @info "Co-occurrence analysis complete: analyzed $(n_pairs) place type pairs"
        end

        @info "Step 6: Creating target variables using methods: $(join(target_methods, ", "))..."

        # Create target variables for incidents
        incident_target_cols = create_target_variables!(
            incident_features; target_methods = target_methods
        )

        # Create target variables for arrests
        arrest_target_cols = create_target_variables!(
            arrest_features; target_methods = target_methods
        )

        if isempty(incident_target_cols) && isempty(arrest_target_cols)
            error(
                "No target variables could be created. Check that crime data exists in features."
            )
        end

        @info "Created $(length(incident_target_cols)) incident target variables and $(length(arrest_target_cols)) arrest target variables"

        @info "Step 7: Fitting predictive models..."

        # Fit models for incidents
        incident_models = if !isempty(incident_target_cols)
            fit_logistic_models(incident_features, incident_target_cols)
        else
            Dict()
        end

        # Fit models for arrests
        arrest_models = if !isempty(arrest_target_cols)
            fit_logistic_models(arrest_features, arrest_target_cols)
        else
            Dict()
        end

        if isempty(incident_models) && isempty(arrest_models)
            error(
                "No models could be fitted successfully. Check feature data and target variables."
            )
        end

        @info "Successfully fitted $(length(incident_models)) incident models and $(length(arrest_models)) arrest models"

        # === OPTIONAL PLACE TYPE INTERACTIONS (ROUTINE ACTIVITIES THEORY) ===
        incident_models_interact = Dict()
        arrest_models_interact = Dict()
        incident_models_interact_only = Dict()
        arrest_models_interact_only = Dict()
        incident_winners = Dict("Base" => 0, "Interactions-Only" => 0, "Full" => 0)
        arrest_winners = Dict("Base" => 0, "Interactions-Only" => 0, "Full" => 0)

        if get(ENV, "INCLUDE_PLACE_INTERACTIONS", "false") == "true"
            @info "Step 7b: Running routine activities interaction analysis..."
            @info "Creating place type interactions based on Cohen & Felson's routine activities theory"
            @info "Will create THREE model versions: base (counts only), interactions only, and full (counts + interactions)"

            # === VERSION 1: FULL MODEL (Counts + Interactions) ===
            # Create copies of features for full interaction models
            incident_features_interact = copy(incident_features)
            arrest_features_interact = copy(arrest_features)

            # Add pairwise place type interactions
            @info "Adding place type interactions to incident features (full model)..."
            add_place_type_interactions!(incident_features_interact; standardize = true)

            @info "Adding place type interactions to arrest features (full model)..."
            add_place_type_interactions!(arrest_features_interact; standardize = true)

            # === VERSION 2: INTERACTION-ONLY MODEL ===
            # Create features with ONLY interactions (no base counts)
            @info "Creating interaction-only feature sets..."

            # Start with copies that have metadata and crime data
            incident_features_interact_only = incident_features[
                :, [:street_id, :street_name]
            ]
            arrest_features_interact_only = arrest_features[:, [:street_id, :street_name]]

            # Add crime columns for targets
            for col in names(incident_features)
                if startswith(String(col), "crime_")
                    incident_features_interact_only[!, col] = incident_features[!, col]
                end
            end

            for col in names(arrest_features)
                if startswith(String(col), "crime_")
                    arrest_features_interact_only[!, col] = arrest_features[!, col]
                end
            end

            # Add total_crime for target creation
            incident_features_interact_only[!, :total_crime] = incident_features[
                !, :total_crime
            ]
            arrest_features_interact_only[!, :total_crime] = arrest_features[
                !, :total_crime
            ]

            # Add ONLY the interaction terms (not the base place counts)
            # First, create temporary dataframes with base counts to generate interactions
            temp_incident = copy(incident_features)
            temp_arrest = copy(arrest_features)

            # Generate interactions on temp dataframes
            add_place_type_interactions!(temp_incident; standardize = true)
            add_place_type_interactions!(temp_arrest; standardize = true)

            # Copy ONLY the interaction columns to the interaction-only features
            for col in names(temp_incident)
                if startswith(String(col), "interact_")
                    incident_features_interact_only[!, col] = temp_incident[!, col]
                end
            end

            for col in names(temp_arrest)
                if startswith(String(col), "interact_")
                    arrest_features_interact_only[!, col] = temp_arrest[!, col]
                end
            end

            # Create target variables (they should be the same as base model targets)
            incident_target_cols_interact = create_target_variables!(
                incident_features_interact; target_methods = target_methods
            )
            arrest_target_cols_interact = create_target_variables!(
                arrest_features_interact; target_methods = target_methods
            )

            # Fit FULL models (counts + interactions)
            @info "Fitting incident models with place counts + interactions (full model)..."
            incident_models_interact = if !isempty(incident_target_cols_interact)
                fit_logistic_models(incident_features_interact, incident_target_cols_interact)
            else
                Dict()
            end

            @info "Fitting arrest models with place counts + interactions (full model)..."
            arrest_models_interact = if !isempty(arrest_target_cols_interact)
                fit_logistic_models(arrest_features_interact, arrest_target_cols_interact)
            else
                Dict()
            end

            @info "Full models fitted: $(length(incident_models_interact)) incident, $(length(arrest_models_interact)) arrest"

            # Create target variables for interaction-only models
            incident_target_cols_interact_only = create_target_variables!(
                incident_features_interact_only; target_methods = target_methods
            )
            arrest_target_cols_interact_only = create_target_variables!(
                arrest_features_interact_only; target_methods = target_methods
            )

            # Fit INTERACTION-ONLY models
            @info "Fitting incident models with ONLY interactions (no base counts)..."
            incident_models_interact_only = if !isempty(incident_target_cols_interact_only)
                fit_logistic_models(
                    incident_features_interact_only, incident_target_cols_interact_only
                )
            else
                Dict()
            end

            @info "Fitting arrest models with ONLY interactions (no base counts)..."
            arrest_models_interact_only = if !isempty(arrest_target_cols_interact_only)
                fit_logistic_models(
                    arrest_features_interact_only, arrest_target_cols_interact_only
                )
            else
                Dict()
            end

            @info "Interaction-only models fitted: $(length(incident_models_interact_only)) incident, $(length(arrest_models_interact_only)) arrest"

            # Three-way model comparison
            @info "="^80
            @info "ROUTINE ACTIVITIES THEORY: Three-Way Model Comparison"
            @info "Base (counts only) vs Interactions-Only vs Full (counts + interactions)"
            @info "="^80

            # Compare incident models
            if !isempty(incident_models)
                @info "\n📊 INCIDENT MODELS THREE-WAY COMPARISON:"
                @info "-" * "="^78 * "-"

                for (target_name, base_model) in incident_models
                    if haskey(incident_models_interact, target_name) &&
                        haskey(incident_models_interact_only, target_name)
                        full_model = incident_models_interact[target_name]
                        interact_only_model = incident_models_interact_only[target_name]

                        # Calculate metrics for all three models
                        base_aic = aic(base_model)
                        interact_only_aic = aic(interact_only_model)
                        full_aic = aic(full_model)

                        base_bic = bic(base_model)
                        interact_only_bic = bic(interact_only_model)
                        full_bic = bic(full_model)

                        base_r2 = r2(base_model)
                        interact_only_r2 = r2(interact_only_model)
                        full_r2 = r2(full_model)

                        @info "\n📌 $(target_name):"
                        @info "  ┌─────────────────┬──────────────┬──────────────┬──────────────┐"
                        @info "  │ Metric          │ Base Model   │ Interact-Only│ Full Model   │"
                        @info "  ├─────────────────┼──────────────┼──────────────┼──────────────┤"
                        @info "  │ AIC             │ $(lpad(round(base_aic, digits=2), 12)) │ $(lpad(round(interact_only_aic, digits=2), 12)) │ $(lpad(round(full_aic, digits=2), 12)) │"
                        @info "  │ BIC             │ $(lpad(round(base_bic, digits=2), 12)) │ $(lpad(round(interact_only_bic, digits=2), 12)) │ $(lpad(round(full_bic, digits=2), 12)) │"
                        @info "  │ McFadden R²     │ $(lpad(round(base_r2, digits=4), 12)) │ $(lpad(round(interact_only_r2, digits=4), 12)) │ $(lpad(round(full_r2, digits=4), 12)) │"
                        @info "  └─────────────────┴──────────────┴──────────────┴──────────────┘"

                        # Determine best model
                        best_aic = minimum([base_aic, interact_only_aic, full_aic])
                        best_model = if best_aic == base_aic
                            "Base (counts only)"
                        elseif best_aic == interact_only_aic
                            "Interactions-Only"
                        else
                            "Full (counts + interactions)"
                        end

                        @info "  🏆 Best model (lowest AIC): $(best_model)"

                        # Interpretation
                        if best_aic == interact_only_aic
                            @info "  💡 Interpretation: Place relationships matter more than raw counts"
                        elseif best_aic == full_aic
                            @info "  💡 Interpretation: Both counts and interactions provide complementary information"
                        else
                            @info "  💡 Interpretation: Simple place counts are sufficient; interactions add complexity without benefit"
                        end
                    end
                end
            end

            # Compare arrest models
            if !isempty(arrest_models)
                @info "\n📊 ARREST MODELS THREE-WAY COMPARISON:"
                @info "-" * "="^78 * "-"

                for (target_name, base_model) in arrest_models
                    if haskey(arrest_models_interact, target_name) &&
                        haskey(arrest_models_interact_only, target_name)
                        full_model = arrest_models_interact[target_name]
                        interact_only_model = arrest_models_interact_only[target_name]

                        # Calculate metrics for all three models
                        base_aic = aic(base_model)
                        interact_only_aic = aic(interact_only_model)
                        full_aic = aic(full_model)

                        base_bic = bic(base_model)
                        interact_only_bic = bic(interact_only_model)
                        full_bic = bic(full_model)

                        base_r2 = r2(base_model)
                        interact_only_r2 = r2(interact_only_model)
                        full_r2 = r2(full_model)

                        @info "\n📌 $(target_name):"
                        @info "  ┌─────────────────┬──────────────┬──────────────┬──────────────┐"
                        @info "  │ Metric          │ Base Model   │ Interact-Only│ Full Model   │"
                        @info "  ├─────────────────┼──────────────┼──────────────┼──────────────┤"
                        @info "  │ AIC             │ $(lpad(round(base_aic, digits=2), 12)) │ $(lpad(round(interact_only_aic, digits=2), 12)) │ $(lpad(round(full_aic, digits=2), 12)) │"
                        @info "  │ BIC             │ $(lpad(round(base_bic, digits=2), 12)) │ $(lpad(round(interact_only_bic, digits=2), 12)) │ $(lpad(round(full_bic, digits=2), 12)) │"
                        @info "  │ McFadden R²     │ $(lpad(round(base_r2, digits=4), 12)) │ $(lpad(round(interact_only_r2, digits=4), 12)) │ $(lpad(round(full_r2, digits=4), 12)) │"
                        @info "  └─────────────────┴──────────────┴──────────────┴──────────────┘"

                        # Determine best model
                        best_aic = minimum([base_aic, interact_only_aic, full_aic])
                        best_model = if best_aic == base_aic
                            "Base (counts only)"
                        elseif best_aic == interact_only_aic
                            "Interactions-Only"
                        else
                            "Full (counts + interactions)"
                        end

                        @info "  🏆 Best model (lowest AIC): $(best_model)"

                        # Interpretation
                        if best_aic == interact_only_aic
                            @info "  💡 Interpretation: Law enforcement responds to place relationships, not counts"
                        elseif best_aic == full_aic
                            @info "  💡 Interpretation: Law enforcement considers both density and place combinations"
                        else
                            @info "  💡 Interpretation: Law enforcement primarily responds to place density"
                        end
                    end
                end
            end

            # Summary statistics across all models
            @info "\n📈 OVERALL SUMMARY:"
            @info "="^80

            # Count which model type wins most often (already initialized earlier)

            for (target_name, base_model) in incident_models
                if haskey(incident_models_interact, target_name) &&
                    haskey(incident_models_interact_only, target_name)
                    aics = [
                        aic(base_model),
                        aic(incident_models_interact_only[target_name]),
                        aic(incident_models_interact[target_name])
                    ]
                    min_idx = argmin(aics)
                    if min_idx == 1
                        incident_winners["Base"] += 1
                    elseif min_idx == 2
                        incident_winners["Interactions-Only"] += 1
                    else
                        incident_winners["Full"] += 1
                    end
                end
            end

            for (target_name, base_model) in arrest_models
                if haskey(arrest_models_interact, target_name) &&
                    haskey(arrest_models_interact_only, target_name)
                    aics = [
                        aic(base_model),
                        aic(arrest_models_interact_only[target_name]),
                        aic(arrest_models_interact[target_name])
                    ]
                    min_idx = argmin(aics)
                    if min_idx == 1
                        arrest_winners["Base"] += 1
                    elseif min_idx == 2
                        arrest_winners["Interactions-Only"] += 1
                    else
                        arrest_winners["Full"] += 1
                    end
                end
            end

            @info "Best Model Frequency (by lowest AIC):"
            @info "  Incident Models: Base=$(incident_winners["Base"]), Interactions-Only=$(incident_winners["Interactions-Only"]), Full=$(incident_winners["Full"])"
            @info "  Arrest Models: Base=$(arrest_winners["Base"]), Interactions-Only=$(arrest_winners["Interactions-Only"]), Full=$(arrest_winners["Full"])"

            @info "="^80
        end

        # Prepare interaction results for saving if analysis was run
        interaction_results = nothing
        if get(ENV, "INCLUDE_PLACE_INTERACTIONS", "false") == "true" &&
            !isempty(incident_models_interact) &&
            !isempty(arrest_models_interact)

            # Run comprehensive comparison
            interaction_results = compare_routine_activities_models(
                (incident_models, arrest_models),
                (incident_models_interact_only, arrest_models_interact_only),
                (incident_models_interact, arrest_models_interact),
                (incident_features, arrest_features),
                (incident_features_interact_only, arrest_features_interact_only),
                (incident_features_interact, arrest_features_interact)
            )
        end

        # === OPTIONAL PCA ANALYSIS ===
        incident_models_pca = Dict()
        arrest_models_pca = Dict()
        pca_results = nothing

        if get(ENV, "RUN_PCA_ANALYSIS", "false") == "true"
            @info "Step 7b: Running PCA-based analysis (alternative approach)..."

            # Create PCA-based feature matrices
            @info "Creating PCA features for incidents..."
            incident_features_pca = create_street_features_pca(
                incident_matched, place_matched
            )

            @info "Creating PCA features for arrests..."
            arrest_features_pca = create_street_features_pca(arrest_matched, place_matched)

            # Create target variables for PCA features
            incident_target_cols_pca = create_target_variables!(
                incident_features_pca; target_methods = target_methods
            )
            arrest_target_cols_pca = create_target_variables!(
                arrest_features_pca; target_methods = target_methods
            )

            # Fit models using PCA features
            incident_models_pca = if !isempty(incident_target_cols_pca)
                fit_logistic_models(incident_features_pca, incident_target_cols_pca)
            else
                Dict()
            end

            arrest_models_pca = if !isempty(arrest_target_cols_pca)
                fit_logistic_models(arrest_features_pca, arrest_target_cols_pca)
            else
                Dict()
            end

            @info "PCA models fitted: $(length(incident_models_pca)) incident, $(length(arrest_models_pca)) arrest"

            # Compare category vs PCA models with detailed target method analysis
            @info "="^80
            @info "COMPREHENSIVE MODEL COMPARISON: Category vs PCA, Target Methods"
            @info "="^80

            # Helper function to extract crime type and method from model name
            function parse_model_name(name::Symbol)
                name_str = String(name)
                # Example: high_larceny_top25 -> ("larceny", "top25")
                parts = split(name_str, "_")
                if length(parts) >= 3 && parts[1] == "high"
                    crime = parts[2]
                    method = join(parts[3:end], "_")
                    return (crime, method)
                end
                return (name_str, "unknown")
            end

            # Organize models by crime type and method
            function organize_models_by_crime(models)
                organized = Dict{String, Dict{String, Any}}()
                for (name, model) in models
                    crime, method = parse_model_name(name)
                    if !haskey(organized, crime)
                        organized[crime] = Dict{String, Any}()
                    end
                    organized[crime][method] = model
                end
                return organized
            end

            # === INCIDENT MODELS COMPARISON ===
            @info "\n" * "=" * 60
            @info "INCIDENT MODELS - Comparing Target Methods"
            @info "=" * 60

            incident_cat_by_crime = organize_models_by_crime(incident_models)
            incident_pca_by_crime = organize_models_by_crime(incident_models_pca)

            for crime in sort(collect(keys(incident_cat_by_crime)))
                @info "\n$(uppercase(crime)) CRIME - Incident Models:"
                @info "-" * 40

                # Collect metrics for all methods
                method_metrics = Dict{String, Dict{String, Float64}}()

                for method in ["top25", "top50", "median", "jenks"]
                    if haskey(incident_cat_by_crime[crime], method)
                        cat_model = incident_cat_by_crime[crime][method]
                        cat_aic = aic(cat_model)
                        cat_r2 = 1 - deviance(cat_model) / nulldeviance(cat_model)

                        method_metrics[method] = Dict(
                            "cat_aic" => cat_aic, "cat_r2" => cat_r2
                        )

                        # Add PCA metrics if available
                        if haskey(incident_pca_by_crime, crime) &&
                            haskey(incident_pca_by_crime[crime], method)
                            pca_model = incident_pca_by_crime[crime][method]
                            method_metrics[method]["pca_aic"] = aic(pca_model)
                            method_metrics[method]["pca_r2"] =
                                1 - deviance(pca_model) / nulldeviance(pca_model)
                        end
                    end
                end

                # Display comparison table
                @info "Method    | Cat AIC | Cat R² | PCA AIC | PCA R² | Best Model"
                @info "----------|---------|--------|---------|--------|------------"

                best_method_aic = ""
                best_aic = Inf
                best_method_r2 = ""
                best_r2 = -Inf

                for method in ["top25", "top50", "median", "jenks"]
                    if haskey(method_metrics, method)
                        metrics = method_metrics[method]
                        cat_aic_str = @sprintf("%.1f", metrics["cat_aic"])
                        cat_r2_str = @sprintf("%.3f", metrics["cat_r2"])

                        if haskey(metrics, "pca_aic")
                            pca_aic_str = @sprintf("%.1f", metrics["pca_aic"])
                            pca_r2_str = @sprintf("%.3f", metrics["pca_r2"])
                            best_model =
                                metrics["pca_aic"] < metrics["cat_aic"] ? "PCA" : "Category"

                            # Track best overall
                            min_aic = min(metrics["cat_aic"], metrics["pca_aic"])
                            max_r2 = max(metrics["cat_r2"], metrics["pca_r2"])
                        else
                            pca_aic_str = "N/A"
                            pca_r2_str = "N/A"
                            best_model = "Category"
                            min_aic = metrics["cat_aic"]
                            max_r2 = metrics["cat_r2"]
                        end

                        # Update best trackers
                        if min_aic < best_aic
                            best_aic = min_aic
                            best_method_aic = method
                        end
                        if max_r2 > best_r2
                            best_r2 = max_r2
                            best_method_r2 = method
                        end

                        # Format method name for display
                        method_display = rpad(method, 9)
                        @info "$method_display | $cat_aic_str | $cat_r2_str | $pca_aic_str | $pca_r2_str | $best_model"
                    end
                end

                # Summary for this crime type
                @info "\n→ Best AIC: $(best_method_aic) ($(round(best_aic, digits=1)))"
                @info "→ Best R²: $(best_method_r2) ($(round(best_r2, digits=3)))"

                # Special comparison: Jenks vs traditional methods
                if haskey(method_metrics, "jenks")
                    jenks_aic = get(method_metrics["jenks"], "cat_aic", Inf)
                    traditional_best_aic = Inf
                    traditional_best_method = ""

                    for method in ["top25", "top50", "median"]
                        if haskey(method_metrics, method)
                            method_aic = get(method_metrics[method], "cat_aic", Inf)
                            if method_aic < traditional_best_aic
                                traditional_best_aic = method_aic
                                traditional_best_method = method
                            end
                        end
                    end

                    if traditional_best_aic < Inf
                        @info "\n📊 Jenks vs Traditional Methods:"
                        if jenks_aic < traditional_best_aic
                            improvement = round(
                                100 * (traditional_best_aic - jenks_aic) /
                                traditional_best_aic;
                                digits = 1
                            )
                            @info "  ✓ Jenks outperforms best traditional ($(traditional_best_method)) by $(improvement)%"
                        else
                            deficit = round(
                                100 * (jenks_aic - traditional_best_aic) / jenks_aic;
                                digits = 1
                            )
                            @info "  ✗ Traditional ($(traditional_best_method)) outperforms Jenks by $(deficit)%"
                        end
                    end
                end
            end

            # === ARREST MODELS COMPARISON ===
            @info "\n" * "=" * 60
            @info "ARREST MODELS - Comparing Target Methods"
            @info "=" * 60

            arrest_cat_by_crime = organize_models_by_crime(arrest_models)
            arrest_pca_by_crime = organize_models_by_crime(arrest_models_pca)

            for crime in sort(collect(keys(arrest_cat_by_crime)))
                @info "\n$(uppercase(crime)) CRIME - Arrest Models:"
                @info "-" * 40

                # Collect metrics for all methods
                method_metrics = Dict{String, Dict{String, Float64}}()

                for method in ["top25", "top50", "median", "jenks"]
                    if haskey(arrest_cat_by_crime[crime], method)
                        cat_model = arrest_cat_by_crime[crime][method]
                        cat_aic = aic(cat_model)
                        cat_r2 = 1 - deviance(cat_model) / nulldeviance(cat_model)

                        method_metrics[method] = Dict(
                            "cat_aic" => cat_aic, "cat_r2" => cat_r2
                        )

                        # Add PCA metrics if available
                        if haskey(arrest_pca_by_crime, crime) &&
                            haskey(arrest_pca_by_crime[crime], method)
                            pca_model = arrest_pca_by_crime[crime][method]
                            method_metrics[method]["pca_aic"] = aic(pca_model)
                            method_metrics[method]["pca_r2"] =
                                1 - deviance(pca_model) / nulldeviance(pca_model)
                        end
                    end
                end

                # Display comparison table
                @info "Method    | Cat AIC | Cat R² | PCA AIC | PCA R² | Best Model"
                @info "----------|---------|--------|---------|--------|------------"

                best_method_aic = ""
                best_aic = Inf
                best_method_r2 = ""
                best_r2 = -Inf

                for method in ["top25", "top50", "median", "jenks"]
                    if haskey(method_metrics, method)
                        metrics = method_metrics[method]
                        cat_aic_str = @sprintf("%.1f", metrics["cat_aic"])
                        cat_r2_str = @sprintf("%.3f", metrics["cat_r2"])

                        if haskey(metrics, "pca_aic")
                            pca_aic_str = @sprintf("%.1f", metrics["pca_aic"])
                            pca_r2_str = @sprintf("%.3f", metrics["pca_r2"])
                            best_model =
                                metrics["pca_aic"] < metrics["cat_aic"] ? "PCA" : "Category"

                            # Track best overall
                            min_aic = min(metrics["cat_aic"], metrics["pca_aic"])
                            max_r2 = max(metrics["cat_r2"], metrics["pca_r2"])
                        else
                            pca_aic_str = "N/A"
                            pca_r2_str = "N/A"
                            best_model = "Category"
                            min_aic = metrics["cat_aic"]
                            max_r2 = metrics["cat_r2"]
                        end

                        # Update best trackers
                        if min_aic < best_aic
                            best_aic = min_aic
                            best_method_aic = method
                        end
                        if max_r2 > best_r2
                            best_r2 = max_r2
                            best_method_r2 = method
                        end

                        # Format method name for display
                        method_display = rpad(method, 9)
                        @info "$method_display | $cat_aic_str | $cat_r2_str | $pca_aic_str | $pca_r2_str | $best_model"
                    end
                end

                # Summary for this crime type
                @info "\n→ Best AIC: $(best_method_aic) ($(round(best_aic, digits=1)))"
                @info "→ Best R²: $(best_method_r2) ($(round(best_r2, digits=3)))"

                # Special comparison: Jenks vs traditional methods
                if haskey(method_metrics, "jenks")
                    jenks_aic = get(method_metrics["jenks"], "cat_aic", Inf)
                    traditional_best_aic = Inf
                    traditional_best_method = ""

                    for method in ["top25", "top50", "median"]
                        if haskey(method_metrics, method)
                            method_aic = get(method_metrics[method], "cat_aic", Inf)
                            if method_aic < traditional_best_aic
                                traditional_best_aic = method_aic
                                traditional_best_method = method
                            end
                        end
                    end

                    if traditional_best_aic < Inf
                        @info "\n📊 Jenks vs Traditional Methods:"
                        if jenks_aic < traditional_best_aic
                            improvement = round(
                                100 * (traditional_best_aic - jenks_aic) /
                                traditional_best_aic;
                                digits = 1
                            )
                            @info "  ✓ Jenks outperforms best traditional ($(traditional_best_method)) by $(improvement)%"
                        else
                            deficit = round(
                                100 * (jenks_aic - traditional_best_aic) / jenks_aic;
                                digits = 1
                            )
                            @info "  ✗ Traditional ($(traditional_best_method)) outperforms Jenks by $(deficit)%"
                        end
                    end
                end
            end

            @info "\n" * "=" * 80

            # Save PCA results
            if !isempty(incident_models_pca) || !isempty(arrest_models_pca)
                pca_output_dir = joinpath(OUTPUT_DIR, "pca_analysis")
                mkpath(pca_output_dir)

                # Save PCA feature matrices
                CSV.write(
                    joinpath(pca_output_dir, "incident_features_pca.csv"),
                    incident_features_pca
                )
                CSV.write(
                    joinpath(pca_output_dir, "arrest_features_pca.csv"), arrest_features_pca
                )

                # Save PCA model coefficients
                all_pca_models = merge(incident_models_pca, arrest_models_pca)
                if !isempty(all_pca_models)
                    pca_coefficients = extract_model_coefficients(all_pca_models)
                    CSV.write(
                        joinpath(pca_output_dir, "pca_model_coefficients.csv"),
                        pca_coefficients
                    )
                end

                # Save comprehensive comparison results
                comparison_df = DataFrame(;
                    model_name = String[],
                    data_type = String[],
                    crime_type = String[],
                    target_method = String[],
                    feature_type = String[],
                    aic = Float64[],
                    mcfadden_r2 = Float64[]
                )

                # Add category models
                for (name, model) in incident_models
                    crime, method = parse_model_name(name)
                    push!(
                        comparison_df,
                        (
                            String(name),
                            "incident",
                            crime,
                            method,
                            "category",
                            aic(model),
                            1 - deviance(model) / nulldeviance(model)
                        )
                    )
                end
                for (name, model) in arrest_models
                    crime, method = parse_model_name(name)
                    push!(
                        comparison_df,
                        (
                            String(name),
                            "arrest",
                            crime,
                            method,
                            "category",
                            aic(model),
                            1 - deviance(model) / nulldeviance(model)
                        )
                    )
                end

                # Add PCA models
                for (name, model) in incident_models_pca
                    crime, method = parse_model_name(name)
                    push!(
                        comparison_df,
                        (
                            String(name),
                            "incident",
                            crime,
                            method,
                            "pca",
                            aic(model),
                            1 - deviance(model) / nulldeviance(model)
                        )
                    )
                end
                for (name, model) in arrest_models_pca
                    crime, method = parse_model_name(name)
                    push!(
                        comparison_df,
                        (
                            String(name),
                            "arrest",
                            crime,
                            method,
                            "pca",
                            aic(model),
                            1 - deviance(model) / nulldeviance(model)
                        )
                    )
                end

                CSV.write(joinpath(pca_output_dir, "model_comparison.csv"), comparison_df)
                @info "PCA results and comparisons saved to $(pca_output_dir)"
            end
        end

        @info "Step 8: Saving results and generating outputs..."

        # Combine models for backwards compatibility
        all_models = merge(incident_models, arrest_models)

        # Save all results (will need to be updated to handle separate datasets)
        save_results(incident_features, all_models)

        # Save comprehensive analysis results with all outputs
        @info "Generating comprehensive analysis documentation..."

        # Prepare PCA results if available
        if get(ENV, "RUN_PCA_ANALYSIS", "false") == "true" &&
            (!isempty(incident_models_pca) || !isempty(arrest_models_pca))
            # Structure PCA results for comprehensive saving
            pca_results = Dict(
                :n_components => get(ENV, "PCA_COMPONENTS", "10"),
                :variance_explained => 0.85,  # This would need to be extracted from actual PCA
                :incident_models => incident_models_pca,
                :arrest_models => arrest_models_pca
            )
        else
            pca_results = nothing
        end

        # Save comprehensive results with all analyses
        output_dir = save_comprehensive_results(
            incident_features,
            arrest_features,
            incident_models,
            arrest_models;
            interaction_results = interaction_results,
            pca_results = pca_results,
            target_methods = target_methods
        )

        # Save place type summary
        save_place_type_summary(incident_features, output_dir)

        # Create visualizations
        create_summary_visualizations(incident_features)

        # Create model-specific visualizations
        coefficients_df = extract_model_coefficients(all_models)
        create_model_visualizations(all_models, coefficients_df)

        # Generate summary report
        generate_summary_report(incident_features, all_models)

        @info "Comprehensive analysis saved to: $output_dir"

        @info "Step 9: Analysis complete - generating summary..."

        # Calculate final statistics
        significant_predictors = identify_significant_predictors(coefficients_df)
        n_significant = nrow(significant_predictors)

        # Print console summary with co-occurrence results
        print_analysis_summary(incident_features, all_models)

        # Add co-occurrence summary if available
        if @isdefined(cooccurrence_results) && haskey(cooccurrence_results, :pairs_analysis)
            @info "Research Question 1 - Top co-locating place types identified"
        end

        # Calculate total runtime
        end_time = time()
        runtime_minutes = round((end_time - start_time) / 60; digits = 1)

        @info "Pipeline completed successfully in $(runtime_minutes) minutes!"

        # =================================================================
        # Return Summary Information
        # =================================================================
        return Dict(
            :success => true,
            :n_incident_streets => nrow(incident_features),
            :n_arrest_streets => nrow(arrest_features),
            :n_incident_features => ncol(incident_features) - 2,  # Exclude street_id and street_name
            :n_arrest_features => ncol(arrest_features) - 2,
            :incident_models_fitted => length(incident_models),
            :arrest_models_fitted => length(arrest_models),
            :total_models_fitted => length(all_models),
            :significant_predictors => n_significant,
            :output_dir => OUTPUT_DIR,
            :runtime_minutes => runtime_minutes,
            :target_methods => target_methods,
            :data_freshly_downloaded => download_data,
            :features_reprocessed => features === nothing || force_reprocess,
            :cooccurrence_analysis =>
                @isdefined(cooccurrence_results) ? cooccurrence_results : nothing
        )

    catch e
        @error "Pipeline failed with error: $e"

        # Log the full backtrace for debugging
        @error "Full backtrace:" exception = (e, catch_backtrace())

        # Calculate partial runtime
        end_time = time()
        runtime_minutes = round((end_time - start_time) / 60; digits = 1)

        # Return error information
        return Dict(
            :success => false,
            :error => string(e),
            :runtime_minutes => runtime_minutes,
            :output_dir => OUTPUT_DIR
        )
    end
end

function run_quick()::Dict{Symbol, Any}
    target_methods::Vector{String} = split(
        get(ENV, "TARGET_METHODS", "top25,top50,median,jenks"), ","
    )
    return run(;
        download_data = false, force_reprocess = false, target_methods = target_methods
    )
end

function run_fresh(;
    target_methods::Vector{String} = split(
        get(ENV, "TARGET_METHODS", "top25,top50,median,jenks"), ","
    )
)::Dict{Symbol, Any}
    return run(;
        download_data = true, force_reprocess = true, target_methods = target_methods
    )
end

function validate_environment()::Bool
    @info "Validating environment for dissertation analysis..."

    valid = true

    # Check data directory
    try
        mkpath(DATA_DIR)
        @info "Data directory: $DATA_DIR"
    catch e
        @error "Cannot create data directory: $DATA_DIR - $e"
        valid = false
    end

    # Check output directory
    try
        mkpath(OUTPUT_DIR)
        @info "Output directory: $OUTPUT_DIR"
    catch e
        @error "Cannot create output directory: $OUTPUT_DIR - $e"
        valid = false
    end

    # Check API keys (optional, only needed for downloads)
    if haskey(ENV, "SODA_KEY")
        @info "SODA_KEY found (NYC Open Data access enabled)"
    else
        @warn "SODA_KEY not found (download_data=true will fail)"
    end

    if haskey(ENV, "GOOGLE_MAPS_KEY")
        @info "GOOGLE_MAPS_KEY found (Google Places API access enabled)"
    else
        @warn "GOOGLE_MAPS_KEY not found (place data downloads will fail)"
    end

    if valid
        @info "Environment validation passed!"
    else
        @error "Environment validation failed - please fix the issues above"
    end

    return valid
end
