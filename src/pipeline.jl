function run()::Nothing
    outputs = run_process()
    return Nothing
end

function run_downloads()::Nothing
    @info "Downloading crime data from NYC Open Data..."
    download_crime_data()
    download_street_data()
    download_place_data()
    return nothing
end

function run_process()::NamedTuple{
    (:incidents, :arrests, :places, :streets), NTuple{4, GeoTable}
}
    incidents::GeoTable = process_incident_data()
    arrests::GeoTable = process_arrest_data()
    places::GeoTable = process_place_data()
    streets::GeoTable = process_street_data()

    return (incidents = incidents, arrests = arrests, places = places, streets = streets)
end

function run_incidents()
    @info "="^80
    @info "RUNNING FULL ANALYSIS PIPELINE FOR INCIDENTS"
    @info "="^80

    # Step 2: Process raw data
    @info "\n[Step 2/6] Processing raw data..."
    incidents = process_incident_data()
    places = process_place_data()
    streets = process_street_data()

    # Step 3: Spatial analysis
    @info "\n[Step 3/6] Performing spatial analysis..."
    incidents_matched = match_points_to_streets(incidents, streets)
    places_matched = match_points_to_streets(places, streets)

    calculate_spatial_statistics(incidents_matched, "incidents")
    calculate_spatial_statistics(places_matched, "places")

    # Filter by distance (remove crimes >10m from street, keep all places)
    @info "Filtering incidents by distance (max 10m from street)..."
    incidents_matched = filter_points_by_distance(incidents_matched, 10)
    @info "Places not filtered to retain all facility locations"

    # Step 4a: Co-occurrence analysis (run FIRST to inform feature engineering)
    @info "\n[Step 4a/6] Analyzing place type co-occurrence..."
    # Create temporary features DataFrame just for co-occurrence analysis
    temp_features = DataFrame(; street_id = unique(streets.street_id))
    place_by_street = combine(
        groupby(places_matched, [:street_id, :category]), nrow => :count
    )
    place_wide = unstack(place_by_street, :street_id, :category, :count; fill = 0)
    temp_features = leftjoin(temp_features, place_wide; on = :street_id)

    # Fill missing values with 0 to ensure numeric type (fixes Union{Int, Missing} issue)
    for col in names(temp_features)
        if col != :street_id && eltype(temp_features[!, col]) >: Missing
            temp_features[!, col] = coalesce.(temp_features[!, col], 0)
        end
    end

    cooccurrence_results = run_cooccurrence_analysis(temp_features)
    pairs_df = cooccurrence_results[:pairs_analysis]

    # Step 4b: Feature engineering with co-occurrence data
    @info "\n[Step 4b/6] Creating street features..."
    result = create_street_features(
        incidents_matched,
        places_matched,
        streets,
        "incidents";
        cooccurrence_pairs = pairs_df
    )
    incidents_features = result.features
    pca_result = result.pca_result

    @info "Creating target variables..."
    incidents_targets = create_target_variables!(incidents_features)

    # Save feature matrix with target variables included
    features_dir = joinpath(OUTPUT_DIR, "features")
    mkpath(features_dir)
    CSV.write(joinpath(features_dir, "incidents_features.csv"), incidents_features)
    @info "Saved feature matrix with targets to: $(features_dir)/incidents_features.csv"

    # Step 6: Modeling
    @info "\n[Step 6/6] Fitting logistic regression models..."
    fit_logistic_models(incidents_features, incidents_targets, "incidents")

    @info "="^80
    @info "INCIDENTS ANALYSIS COMPLETE"
    @info "  Features: $(nrow(incidents_features)) streets × $(ncol(incidents_features)) columns"
    @info "  Targets: $(length(incidents_targets)) binary indicators"
    @info "  All outputs saved to: $(OUTPUT_DIR)/"
    @info "="^80

    return nothing
end

function run_arrests()
    @info "="^80
    @info "RUNNING FULL ANALYSIS PIPELINE FOR ARRESTS"
    @info "="^80

    # Step 2: Process raw data
    @info "\n[Step 2/6] Processing raw data..."
    arrests = process_arrest_data()
    places = process_place_data()
    streets = process_street_data()

    # Step 3: Spatial analysis
    @info "\n[Step 3/6] Performing spatial analysis..."
    arrests_matched = match_points_to_streets(arrests, streets)
    places_matched = match_points_to_streets(places, streets)

    calculate_spatial_statistics(arrests_matched, "arrests")
    calculate_spatial_statistics(places_matched, "places")

    # Filter by distance (remove crimes >10m from street, keep all places)
    @info "Filtering arrests by distance (max 10m from street)..."
    arrests_matched = filter_points_by_distance(arrests_matched, 10)
    @info "Places not filtered to retain all facility locations"

    # Step 4a: Co-occurrence analysis (run FIRST to inform feature engineering)
    @info "\n[Step 4a/6] Analyzing place type co-occurrence..."
    # Create temporary features DataFrame just for co-occurrence analysis
    temp_features = DataFrame(; street_id = unique(streets.street_id))
    place_by_street = combine(
        groupby(places_matched, [:street_id, :category]), nrow => :count
    )
    place_wide = unstack(place_by_street, :street_id, :category, :count; fill = 0)
    temp_features = leftjoin(temp_features, place_wide; on = :street_id)

    # Fill missing values with 0 to ensure numeric type (fixes Union{Int, Missing} issue)
    for col in names(temp_features)
        if col != :street_id && eltype(temp_features[!, col]) >: Missing
            temp_features[!, col] = coalesce.(temp_features[!, col], 0)
        end
    end

    cooccurrence_results = run_cooccurrence_analysis(temp_features)
    pairs_df = cooccurrence_results[:pairs_analysis]

    # Step 4b: Feature engineering with co-occurrence data
    @info "\n[Step 4b/6] Creating street features..."
    result = create_street_features(
        arrests_matched, places_matched, streets, "arrests"; cooccurrence_pairs = pairs_df
    )
    arrests_features = result.features
    pca_result = result.pca_result

    @info "Creating target variables..."
    arrests_targets = create_target_variables!(arrests_features)

    # Step 6: Modeling
    @info "\n[Step 6/6] Fitting logistic regression models..."
    fit_logistic_models(arrests_features, arrests_targets, "arrests")

    @info "="^80
    @info "ARRESTS ANALYSIS COMPLETE"
    @info "  Features: $(nrow(arrests_features)) streets × $(ncol(arrests_features)) columns"
    @info "  Targets: $(length(arrests_targets)) binary indicators"
    @info "  All outputs saved to: $(OUTPUT_DIR)/"
    @info "="^80

    return nothing
end

function run_jaccard_sensitivity()::Nothing
    @info "="^80
    @info "RUNNING JACCARD SENSITIVITY FOR INCIDENTS"
    @info "="^80

    # Step 2: Process raw data
    @info "\n[Step 2/6] Processing raw data..."
    incidents = process_incident_data()
    places = process_place_data()
    streets = process_street_data()

    # Step 3: Spatial analysis
    @info "\n[Step 3/6] Performing spatial analysis..."
    incidents_matched = match_points_to_streets(incidents, streets)
    places_matched = match_points_to_streets(places, streets)

    # Filter by distance (remove crimes >10m from street, keep all places)
    @info "Filtering incidents by distance (max 10m from street)..."
    incidents_matched = filter_points_by_distance(incidents_matched, 10)
    @info "Places not filtered to retain all facility locations"

    # Run sensitivity with just 2 thresholds to test
    results = sensitivity_jaccard_analysis(
        incidents_matched,
        places_matched,
        streets,
        "incidents_jaccard_sensitivity";
        thresholds = [0.60, 0.65, 0.75, 0.85, 0.90]  # Quick test
    )

    @info "="^80
    @info "JACCARD SENSITIVITY ANALYSIS COMPLETE"
    @info "  All outputs saved to: $(OUTPUT_DIR)/"
    @info "="^80

    return nothing
end

"""
    run_pca_diagnostics()

Run comprehensive PCA diagnostics to understand why PCA models fail (R² ≈ 0).

Analyzes:
- Variance explained by each component
- Component loadings (which place types contribute to each PC)
- Component interpretability (meaningful latent constructs?)
- Score distributions (sufficient variation across streets?)
- Alternative variance thresholds (90%, 95%, 99%)

Results saved to output/sensitivity/ with detailed report.
"""
function run_pca_diagnostics()
    @info "="^80
    @info "PCA DIAGNOSTIC PIPELINE"
    @info "="^80

    # Step 1: Load data sources
    @info "\n[Step 1/4] Loading data..."
    incidents = process_incident_data()
    places = process_place_data()
    streets = process_street_data()

    # Step 2: Spatial matching
    @info "\n[Step 2/4] Performing spatial analysis..."
    incidents_matched = match_points_to_streets(incidents, streets)
    places_matched = match_points_to_streets(places, streets)

    # Filter by distance
    @info "Filtering incidents by distance (max 10m from street)..."
    incidents_matched = filter_points_by_distance(incidents_matched, 10)

    # Step 3: Run PCA diagnostics on incidents
    @info "\n[Step 3/4] Running PCA diagnostics for INCIDENTS..."
    diagnose_pca_components(
        places_matched,
        streets,
        "incidents";
        variance_thresholds = [0.90, 0.95, 0.99],
        max_components = 10
    )

    # Step 4: Run PCA diagnostics on arrests (optional, for comparison)
    @info "\n[Step 4/4] Running PCA diagnostics for ARRESTS..."
    arrests = process_arrest_data()
    arrests_matched = match_points_to_streets(arrests, streets)
    arrests_matched = filter_points_by_distance(arrests_matched, 10)

    diagnose_pca_components(
        places_matched,
        streets,
        "arrests";
        variance_thresholds = [0.90, 0.95, 0.99],
        max_components = 10
    )

    @info "\n" * "="^80
    @info "PCA DIAGNOSTICS COMPLETE"
    @info "  Results saved to: $(OUTPUT_DIR)/sensitivity/"
    @info "  - Variance threshold comparisons"
    @info "  - Component loadings (interpretability)"
    @info "  - Score distributions (variation)"
    @info "  - Comprehensive markdown reports"
    @info "="^80

    return nothing
end
