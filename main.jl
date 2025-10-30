using Dissertation

# Set directories for this analysis run
output_dir = get(ENV, "OUTPUT_DIR", "output")
data_dir = get(ENV, "DATA_DIR", "data")

Dissertation.set_output_dir(output_dir)
Dissertation.set_data_dir(data_dir)

@info "  Data will be read from: $data_dir"
@info "  Results will written to: $output_dir"

start_time = time()

@info "Step 1: Validating required data files..."

required_files = [
    joinpath(data_dir, "incidents.geojson"),
    joinpath(data_dir, "arrests.geojson"),
    joinpath(data_dir, "streets.geojson")
]
places_dir = joinpath(data_dir, "places")

missing_files = String[]
for file in required_files
    if !isfile(file)
        push!(missing_files, file)
    end
end

if !isdir(places_dir) || length(readdir(places_dir)) == 0
    push!(missing_files, places_dir)
end

if !isempty(missing_files)
    error(
        "Missing required data files: $(join(missing_files, ", "))\n\n" *
        "Run the following module functions first:\n" *
        "  julia> using Dissertation\n" *
        "  julia> Dissertation.download_crime_data()  # For incidents/arrests\n" *
        "  julia> Dissertation.download_place_data()  # For places\n" *
        "  julia> Dissertation.download_street_data() # For streets\n"
    )
end

@info "✓ All required data files found"
@info ""

# =============================================================================
# Step 2: Data Processing
# =============================================================================

@info "Step 2: Processing raw data..."
@info "-"^80

# Process each dataset independently
# Each function handles its own summary reporting to output_dir
try
    @info "Processing incident data..."
    incident_data = process_incident_data()

    @info "Processing arrest data..."
    arrest_data = process_arrest_data()

    @info "Processing place data..."
    place_data = process_place_data()

    @info "Processing street data..."
    street_data = process_street_data()

    @info "✓ Data processing complete"
    @info "  - Incidents: $(nrow(incident_data)) records"
    @info "  - Arrests: $(nrow(arrest_data)) records"
    @info "  - Places: $(nrow(place_data)) records"
    @info "  - Streets: $(nrow(street_data)) segments"
    @info ""
catch e
    error(
        "Data processing failed: $e\n" *
        "Check that data files are valid and not corrupted."
    )
end

# =============================================================================
# Step 3: Spatial Analysis
# =============================================================================

@info "Step 3: Performing spatial analysis..."
@info "-"^80

# Match points to streets (includes distance filtering internally)
@info "Matching incident locations to streets..."
incident_matched = match_points_to_streets(incident_data, street_data)
incident_spatial_stats = calculate_spatial_statistics(incident_matched, "incidents")

@info ""
@info "Matching arrest locations to streets..."
arrest_matched = match_points_to_streets(arrest_data, street_data)
arrest_spatial_stats = calculate_spatial_statistics(arrest_matched, "arrests")

@info ""
@info "Matching place locations to streets..."
place_matched = match_points_to_streets(place_data, street_data)
place_spatial_stats = calculate_spatial_statistics(place_matched, "places")

@info ""
@info "✓ Spatial analysis complete"
@info "  - Incident matches: $(nrow(incident_matched)) points"
@info "  - Arrest matches: $(nrow(arrest_matched)) points"
@info "  - Place matches: $(nrow(place_matched)) points"
@info ""

# =============================================================================
# Step 4: Feature Engineering
# =============================================================================

@info "Step 4: Creating feature matrices..."
@info "-"^80

# Create street-level feature matrices with interactions included
# Each function handles its own feature distribution reporting
@info "Creating incident features..."
incident_features = create_street_features(
    incident_matched, place_matched, street_data, "incidents"
)

@info ""
@info "Creating arrest features..."
arrest_features = create_street_features(
    arrest_matched, place_matched, street_data, "arrests"
)

@info ""
@info "✓ Feature engineering complete"
@info "  - Incident features: $(nrow(incident_features)) streets × $(ncol(incident_features)) features"
@info "  - Arrest features: $(nrow(arrest_features)) streets × $(ncol(arrest_features)) features"
@info ""

# =============================================================================
# Step 4a: Co-occurrence Analysis (Research Question 1)
# =============================================================================

@info "Step 4a: Analyzing place type co-occurrence patterns..."
@info "-"^80

# Analyze how place types co-locate on street segments
cooccurrence_results = run_cooccurrence_analysis(place_matched)

@info ""
@info "✓ Co-occurrence analysis complete"
if haskey(cooccurrence_results, :pairs_analysis)
    n_pairs = nrow(cooccurrence_results[:pairs_analysis])
    @info "  - Analyzed $(n_pairs) place type pairs"
end
@info ""

# =============================================================================
# Step 5: Target Variable Creation
# =============================================================================

@info "Step 5: Creating target variables for all threshold methods..."
@info "-"^80

# Create all target methods (top25, top50, median, jenks) for all crime types
# Function reports on target distributions and class balance
@info "Creating incident target variables..."
incident_target_cols = create_target_variables!(incident_features)

@info ""
@info "Creating arrest target variables..."
arrest_target_cols = create_target_variables!(arrest_features)

@info ""
@info "✓ Target variables created for all methods"
@info "  - Incident targets: $(length(incident_target_cols)) variables"
@info "  - Arrest targets: $(length(arrest_target_cols)) variables"
@info ""

# =============================================================================
# Step 6: Comprehensive Model Fitting (96 models)
# =============================================================================

@info "Step 6: Fitting all model variants (96 models total)..."
@info "-"^80
@info "Model structure:"
@info "  - 2 datasets (incidents, arrests)"
@info "  - 4 crime types (LARCENY, VIOLENCE, BURGLARY, DRUGS)"
@info "  - 4 target methods (top25, top50, median, jenks)"
@info "  - 3 model types (base, interactions, PCA)"
@info "  - Total: 2 × 4 × 4 × 3 = 96 models"
@info ""

# Fit all model combinations systematically
# All-or-nothing: if any model fails, the entire step fails
try
    @info "Fitting incident models (48 models)..."
    incident_models = fit_all_model_variants(
        incident_features, incident_matched, place_matched, "incidents"
    )

    @info ""
    @info "Fitting arrest models (48 models)..."
    arrest_models = fit_all_model_variants(
        arrest_features, arrest_matched, place_matched, "arrests"
    )

    # Strict error checking
    if isempty(incident_models) || isempty(arrest_models)
        error("Model fitting failed. All 96 models must converge successfully.")
    end

    @info ""
    @info "✓ Successfully fitted all 96 models"
    @info "  - Incident models: $(length(incident_models))"
    @info "  - Arrest models: $(length(arrest_models))"
    @info ""
catch e
    error(
        "Model fitting failed: $e\n" *
        "Some models did not converge. Check feature data and model specifications."
    )
end

# =============================================================================
# Step 7: Comprehensive Model Comparison
# =============================================================================

@info "Step 7: Running comprehensive model comparisons..."
@info "-"^80
@info "Comparing across dimensions:"
@info "  - Model types (base vs interactions vs PCA)"
@info "  - Target methods (top25 vs top50 vs median vs jenks)"
@info "  - Crime types (4 categories)"
@info "  - Dataset types (incidents vs arrests)"
@info ""

comparison_results = compare_all_models(incident_models, arrest_models)

@info ""
@info "✓ Model comparison analysis complete"
@info "  - Comparison tables saved to: $(output_dir)/model_comparison/"
@info ""

# =============================================================================
# Pipeline Complete
# =============================================================================

end_time = time()
runtime_minutes = round((end_time - start_time) / 60; digits = 1)

@info "="^80
@info "PIPELINE COMPLETED SUCCESSFULLY"
@info "="^80
@info "Runtime: $(runtime_minutes) minutes"
@info "All results saved to: $(output_dir)"
@info ""
@info "Key outputs:"
@info "  - Spatial analysis: $(output_dir)/spatial_analysis/"
@info "  - Feature matrices: $(output_dir)/features/"
@info "  - Model coefficients: $(output_dir)/models/"
@info "  - Model comparisons: $(output_dir)/model_comparison/"
@info ""
@info "Next steps:"
@info "  - Inspect intermediate results in REPL variables"
@info "  - Review output tables and figures"
@info "  - Run additional analyses as needed"
@info "="^80
