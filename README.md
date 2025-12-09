# Dissertation Analysis: Crime and Place in Manhattan

**Manual REPL Workflow for Analyzing Crime Concentration and Facility Composition**

This analysis examines the relationship between place types (facilities) and crime hot spots in Manhattan, addressing three research questions:

1. **RQ1**: Do different place types cluster together on street segments?
2. **RQ2**: Is the composition of place types on a street segment a predictor of a street being a crime hotspot?
3. **RQ3**: Does the interaction of street types increase the risk of a street segment being a crime hotspot?
---
## Environment Setup

### Required API Keys

```julia
# In your .env file or environment:
SODA_APP_TOKEN = "your-nyc-open-data-token" 
GOOGLE_MAPS_KEY = "your-google-maps-api-key"
```

### Optional Configuration

```julia
DATA_DIR = "data"              # Default location for downloaded data
OUTPUT_DIR = "output"          # Default location for all outputs
PLACES_SAMPLE_SIZE = "4000"    # Number of sampling points for Google Places. Under 4000/month is free.
```

### Load the Module

```julia
using Dissertation
```

---

## Seven-Step REPL Workflow

Run these steps in order. Each step saves outputs to the `output/` directory.

---

### Step 1: Download Data (Optional - Skip if Data Exists)

**Source**: `src/download.jl`

Download raw data from NYC Open Data and Google Places API:

```julia
# Download crime incidents and arrests from NYC Open Data
download_crime_data()
# Creates: data/incidents.geojson, data/arrests.geojson

# Download Manhattan street centerlines
download_street_data()
# Creates: data/streets.geojson

# Download place data from Google Places API
# Uses systematic 4000-point sampling grid across Manhattan
# 500m radius search at each point
download_place_data()
# Creates: data/places/*.json (one file per unique place)
```

**What You Get**:
- `data/incidents.geojson`: Crime incident reports
- `data/arrests.geojson`: Arrest records
- `data/streets.geojson`: NYC street centerlines
- `data/places/*.json`: Individual place records from Google Places

---

### Step 2: Process Raw Data

**Source**: `src/processing.jl`

Transform raw data into standardized GeoTables:

```julia
# Process crime incidents (maps to 4 crime categories)
incident_data = process_incident_data()
# Categories: VIOLENCE, LARCENY, BURGLARY, DRUGS

# Process arrest data (same 4 categories)
arrest_data = process_arrest_data()

# Process place data (maps to 18 place categories)
place_data = process_place_data()
# Categories: AUTOMOTIVE, BUSINESS, CULTURE, EDUCATION,
#            ENTERTAINMENT_RECREATION, FACILITIES, FINANCE,
#            FOOD_DRINK, GOVERNMENT, HEALTH_WELLNESS, LODGING,
#            NATURAL_FEATURE, PLACE_OF_WORSHIP, SERVICES,
#            SHOPPING, SPORTS, TRANSPORTATION, OTHER

# Process street network (Manhattan only)
street_data = process_street_data()
```

**Returns**: GeoTable objects with standardized categories and geometry

**Crime Categories** (defined in `src/Dissertation.jl`):
- `VIOLENCE`: Murder, rape, assault, robbery, manslaughter, shootings
- `LARCENY`: All theft/larceny
- `BURGLARY`: All burglary offenses
- `DRUGS`: All drug-related offenses

---

### Step 3: Spatial Analysis

**Source**: `src/spatial.jl`

Match crime/place points to street segments using K-nearest neighbor:

```julia
# Match incidents to nearest streets
incident_matched = match_points_to_streets(incident_data, street_data)

# Match arrests to nearest streets
arrest_matched = match_points_to_streets(arrest_data, street_data)

# Match places to nearest streets
place_matched = match_points_to_streets(place_data, street_data)

# Calculate and save spatial matching statistics
calculate_spatial_statistics(incident_matched, "incidents")
# Saves: output/spatial_analysis/incidents_spatial_stats.csv

calculate_spatial_statistics(arrest_matched, "arrests")
# Saves: output/spatial_analysis/arrests_spatial_stats.csv

calculate_spatial_statistics(place_matched, "places")
# Saves: output/spatial_analysis/places_spatial_stats.csv

# Filter by distance to remove poor matches and crimes at intersections(>10m from street)
incident_matched = filter_points_by_distance(incident_matched, 10)
arrest_matched = filter_points_by_distance(arrest_matched, 10)
# Note: Places not filtered to retain all facility locations
```

**Outputs Saved**:
- `output/spatial_analysis/[dataset]_spatial_stats.csv`: Distance metrics, match quality

**Returns**: DataFrames with `street_id`, `street_name`, `distance_to_street` columns added

---

### Step 4: Feature Engineering

**Source**: `src/features.jl`

Create street-level feature matrices with three feature types:

```julia
# Create incident features
# Automatically includes: place counts, interactions, AND PCA components
incident_features = create_street_features(
    incident_matched,
    place_matched,
    street_data,
    "incidents"  # dataset_name for output files
)
# Saves: output/features/incidents_features.csv

# Create arrest features
arrest_features = create_street_features(
    arrest_matched,
    place_matched,
    street_data,
    "arrests"
)
# Saves: output/features/arrests_features.csv

# Create target variables (all 4 methods created automatically)
incident_targets = create_target_variables!(incident_features)
# Creates binary indicators for: top25, top50, median, jenks
# Returns: Vector{Symbol} of target column names

arrest_targets = create_target_variables!(arrest_features)
```

**What This Creates**:

1. **Place Count Features**: 18 columns (one per place category)
2. **Interaction Features**: ~153 pairwise place interactions (automatically added)
3. **PCA Features**: Principal components from raw place types (automatically added)
4. **Crime Counts**: 4 columns (one per crime category)
5. **Target Variables**: 16 binary indicators per dataset
   - 4 crime types × 4 methods = 16 targets
   - Methods: `top25`, `top50`, `median`, `jenks`

**Feature Matrix Dimensions**:
- Rows: ~30,000 Manhattan street segments
- Columns: ~200+ features (place counts + interactions + PCA + crime counts + targets)

**Outputs Saved**:
- `output/features/[dataset]_features.csv`: Full feature matrix with all components

**Important Notes**:
- PCA is **always** run (not optional) - it's a core part of the analysis
- Interactions are **always** added (not optional)
- All 4 target methods are **always** created for comparison

<!-- TODO: Fix function signature in pipeline.jl - needs dataset_name parameter -->
<!-- TODO: Verify MODELING_CRIME_CATEGORIES exists or change to CRIME_CATEGORIES -->

---

### Step 5: Co-occurrence Analysis (Research Question 1)

**Source**: `src/cooccurrence.jl`

Analyze which place types cluster together on street segments:

```julia
# Analyze place type co-location patterns
cooccurrence_results = run_cooccurrence_analysis(incident_features)
# Note: Uses incident_features but place data is same for both datasets

# Saves:
# - output/cooccurrence/cooccurrence_matrix.csv (18×18 matrix)
# - output/cooccurrence/cooccurrence_pairs.csv (pairwise analysis)
# - output/cooccurrence/cooccurrence_summary.md (top findings)
```

**What This Analyzes**:
- How often pairs of place types appear on same streets
- Jaccard similarity coefficients
- Conditional probabilities P(place A | place B)
- Identifies facility clustering patterns (e.g., bars + restaurants)

**Addresses**: Research Question 1 about place type co-location

---

### Step 6: Predictive Modeling (Research Questions 2 & 3)

**Source**: `src/modeling.jl`

Fit logistic regression models to predict high-crime streets.

**Model Structure** (Hierarchical Research Design):

1. **RQ2: 32 models** (Test if place counts predict crime)
   - 4 crime types × 4 target methods × 2 datasets × 1 feature type (counts)
   - Simple counts: Can basic facility composition predict hot spots?

2. **RQ3: 64 models** (Test if place relationships add predictive power)
   - 4 crime types × 4 target methods × 2 datasets × 2 feature types (interactions + PCA)
   - **32 interaction models**: Pairwise combinations of 18 broad place categories
   - **32 PCA models**: Latent dimensions from hundreds of raw place types

3. **Total: 96 models**

**Key Difference Between RQ3 Approaches**:
- **Interactions**: Policy-relevant (e.g., "bars + nightclubs = risk")
- **PCA**: Nuanced but complex (latent patterns hard to interpret for policy)

**For each dataset (incidents, arrests)**:

```julia
# TODO: Need to implement functions to fit 3 separate feature type variants
# Currently, only base models (counts + interactions + PCA together) are fitted

# Expected workflow (needs implementation):

# ===== RQ2: PLACE COUNTS AS PREDICTORS (32 models) =====
# Test if basic facility composition predicts crime hot spots
incident_models_counts = fit_logistic_models_counts(incident_features, incident_targets)
arrest_models_counts = fit_logistic_models_counts(arrest_features, arrest_targets)
# Returns: 16 models per dataset (4 crimes × 4 thresholds)

# ===== RQ3: PLACE RELATIONSHIPS AS PREDICTORS (64 models) =====
# Test if facility combinations add predictive power

# 3a. INTERACTION MODELS (32 models) - Moderate Complexity
# Pairwise combinations of 18 broad place categories
incident_models_interact = fit_logistic_models_interactions(incident_features, incident_targets)
arrest_models_interact = fit_logistic_models_interactions(arrest_features, arrest_targets)
# Returns: 16 models per dataset (4 crimes × 4 thresholds)

# 3b. PCA MODELS (32 models) - High Complexity
# Latent dimensions from hundreds of raw place types
incident_models_pca = fit_logistic_models_pca(incident_features, incident_targets)
arrest_models_pca = fit_logistic_models_pca(arrest_features, arrest_targets)
# Returns: 16 models per dataset (4 crimes × 4 thresholds)

# ===== HIERARCHICAL COMPARISON =====
# How deep into the data do we need to go to find effects?
comparison_results = compare_all_model_variants(
    incident_models_counts, incident_models_interact, incident_models_pca,
    arrest_models_counts, arrest_models_interact, arrest_models_pca
)
# Compares: counts vs interactions vs PCA for each crime type and threshold
```

**Current Working Function** (fits combined features):
```julia
# This works now but combines all feature types:
all_models = fit_logistic_models(incident_features, incident_targets)
```

**Model Comparison Framework**:

Within each crime category, compare:

1. **Target Methods** (which threshold works best?):
   - `top25`: Highest crime streets accounting for 25% of crime (cumulative proportion)
   - `top50`: Highest crime streets accounting for top 50% of crime (cumulative proportion)
   - `median`: Streets above median crime count
   - `jenks`: Streets above Jenks natural break

2. **Feature Types** (which features predict best?):
   - **Counts**: Raw place type counts
   - **Interactions**: Pairwise place combinations
   - **PCA**: Latent place type dimensions

3. **Data Types** (incidents vs arrests):
   - Incidents: Crime occurrence patterns
   - Arrests: Law enforcement response patterns

**Outputs Saved**:
- Model coefficients
- AIC, BIC, McFadden R² metrics
- Confusion matrices
- Comparison tables

**Addresses**: Research Questions 2 and 3

<!-- TODO: Implement separate functions for counts-only, interactions-only, and PCA-only models -->
<!-- TODO: Remove three-way interaction comparison (base vs interact-only vs full) from pipeline.jl -->
<!-- TODO: Fix calculate_spatial_statistics() calls in pipeline.jl - missing dataset_name parameter -->

---

### Step 7: Generate Outputs (Continuous Throughout)

**Source**: `src/output.jl`

**Every function saves outputs automatically**. No separate "save" step needed.

**Output Philosophy**: Each analysis step creates paper-ready materials:
- CSV files for statistical analysis
- Markdown reports for results sections
- Visualizations for figures
- Exploratory statistics for understanding data

**Key Output Functions** (called automatically or manually as needed):

```julia
# Save comprehensive analysis results
output_dir = save_comprehensive_results(
    incident_features,
    arrest_features,
    incident_models,
    arrest_models;
    target_methods = ["top25", "top50", "median", "jenks"]
)

# Generate summary visualizations
create_summary_visualizations(incident_features)

# Extract and visualize model coefficients
coefficients_df = extract_model_coefficients(all_models)
create_model_visualizations(all_models, coefficients_df)

# Generate text summary
generate_summary_report(incident_features, all_models)
```

**Output Directory Structure**:

```
output/
├── spatial_analysis/          # Step 3 outputs
│   ├── incidents_spatial_stats.csv
│   ├── arrests_spatial_stats.csv
│   └── places_spatial_stats.csv
│
├── features/                  # Step 4 outputs
│   ├── incidents_features.csv
│   └── arrests_features.csv
│
├── cooccurrence/              # Step 5 outputs
│   ├── cooccurrence_matrix.csv
│   ├── cooccurrence_pairs.csv
│   └── cooccurrence_summary.md
│
├── models/                    # Step 6 outputs
│   ├── model_coefficients.csv
│   ├── model_summaries.csv
│   ├── model_predictions.csv
│   └── model_performance.csv
│
├── figures/                   # Visualizations
│   ├── crime_distribution.png
│   ├── place_distribution.png
│   ├── coefficient_plots.png
│   └── model_comparison.png
│
├── descriptive/               # Exploratory statistics
│   ├── dataset_summary.csv
│   ├── crime_concentration_incidents.csv
│   ├── crime_concentration_arrests.csv
│   └── target_thresholds_*.csv
│
└── run_YYYY-MM-DD_HHMMSS/    # Timestamped comprehensive runs
    ├── data/
    ├── models/
    ├── reports/
    ├── figures/
    └── MASTER_REPORT.md
```

---

## Function Reference by Source File

### `src/download.jl` - Data Acquisition
- `download_crime_data()` → incidents.geojson, arrests.geojson
- `download_street_data()` → streets.geojson
- `download_place_data(n_samples)` → places/*.json

### `src/processing.jl` - Data Standardization
- `process_incident_data()` → GeoTable (4 crime categories)
- `process_arrest_data()` → GeoTable (4 crime categories)
- `process_place_data()` → GeoTable (18 place categories)
- `process_street_data()` → GeoTable (Manhattan streets)
- `map_crime_category(offense, law_cat)` → Crime category string
- `map_place_category(primary_type)` → Place category string

### `src/spatial.jl` - Geographic Operations
- `match_points_to_streets(points, streets)` → DataFrame with street_id
- `filter_points_by_distance(data, max_dist)` → Filtered DataFrame
- `calculate_spatial_statistics(data, dataset_name)` → Dict + saves CSV
- `calculate_street_lengths(streets)` → Dict{street_id => meters}

### `src/features.jl` - Feature Engineering
- `create_street_features(crime, places, streets, dataset_name)` → DataFrame
  - Automatically includes counts, interactions, AND PCA
  - Saves to `output/features/[dataset]_features.csv`
- `create_target_variables!(features)` → Vector{Symbol}
  - Creates all 4 methods: top25, top50, median, jenks
- `add_place_type_interactions!(features)` → Modifies in place (called automatically)
- `add_pca_components!(features, places)` → Modifies in place (called automatically)
- `calculate_jenks_breaks(values, k)` → Natural break thresholds

### `src/cooccurrence.jl` - Research Question 1
- `run_cooccurrence_analysis(features)` → Dict + saves 3 files
- `calculate_cooccurrence_matrix(features)` → (DataFrame, Vector{Symbol})
- `analyze_cooccurrence_patterns(matrix, cols)` → DataFrame of pairs

### `src/modeling.jl` - Research Questions 2 & 3
- `fit_logistic_models(features, targets)` → Dict{Symbol => GLM.Model}
- `extract_model_coefficients(models)` → DataFrame
- `calculate_model_summaries(models)` → DataFrame (AIC, BIC, R²)
- `identify_significant_predictors(coefs, α)` → DataFrame
- `compare_target_methods(models)` → Comparison across thresholds

### `src/output.jl` - Results Generation
- `save_comprehensive_results(...)` → Timestamped output directory
- `save_feature_engineering_report(...)` → Markdown report
- `save_model_diagnostics(...)` → CSV + markdown
- `create_summary_visualizations(features)` → PNG plots
- `create_model_visualizations(models, coefs)` → PNG plots
- `generate_summary_report(features, models)` → Markdown summary
- `print_analysis_summary(features, models)` → Console output

---

## Research Questions Addressed

### RQ1: Place Type Co-location
**Step 5** analyzes which facility types cluster together on street segments.

**Method**: Co-occurrence matrix + Jaccard similarity
**Output**: Identifies pairs like bars + restaurants (nightlife zones)

### RQ2: Place Type as Risk Factor
**Step 6** tests whether facility composition can predict crime hot spots.

**Method**: Logistic regression (32 models)
**Comparison**: Which features place types have the biggest impact on crime hot spots?

### RQ3: Place Type Relationships as Risks
**Step 6** tests whether facility combinations add predictive power beyond simple counts.

**Method**: Logistic regression (64 models - two approaches)
- **32 Interaction models**: Pairwise combinations of broad place categories (policy-relevant)
- **32 PCA models**: Latent dimensions from raw place types (nuanced but complex)

**Comparison**: Do we need simple combinations or deep patterns to predict crime?
**Output**:
- If interactions work: Moderate-complexity policy (e.g., "bars + nightclubs = risk")
- If PCA works: Complex patterns requiring nuanced interventions

---

## Model Comparison Framework

The analysis uses a **hierarchical research design** to test increasing levels of analytical depth:

### 1. Target Method Comparison (Across All Models)
Which threshold definition works best for identifying crime hot spots?

**Metrics**: AIC, BIC, McFadden R²

**Four Methods Tested**:
- `top25`: Highest crime streets accounting for 25% of crime (cumulative proportion)
- `top50`: Highest crime streets accounting for 50% of crime (cumulative proportion)
- `jenks`: Streets above Jenks natural break (data-driven clustering)

Example for LARCENY:
- Compare `high_larceny_top25` vs `high_larceny_top50` vs `high_larceny_median` vs `high_larceny_jenks`

**Question**: Does data-driven Jenks outperform arbitrary thresholds?

---

### 2. RQ2: Place Counts as Predictors (32 models)
Can simple facility composition predict crime hot spots?

**Feature Type**: Raw place type counts (18 categories)

**Analytical Depth**: **Basic** - Just count facilities on each street

**Policy Implication**: If this works, simple interventions possible (e.g., "reduce bars")

Example for LARCENY with top25:
- Does count of bars, restaurants, ATMs, etc. predict high-larceny streets?

**Question**: Do place types on a street drive the routine activities that form crime hot spots?

---

### 3. RQ3: Place Relationships as Predictors (64 models)
Do place combinations add predictive power beyond simple counts?

This tests **two different levels of complexity**:

#### 3a. Interaction Models (32 models) - MODERATE COMPLEXITY
**Feature Type**: Pairwise combinations of 18 broad place categories

**Analytical Depth**: **Moderate** - Test if facility combinations matter

**Policy Implication**: Moderate complexity (e.g., "bars + nightclubs = risky combination")

**Theoretical Basis**: Routine activities theory - certain combinations create crime opportunities

Example:
- `FOOD_DRINK × ENTERTAINMENT_RECREATION` interaction
- `FINANCE × TRANSPORTATION` interaction (ATMs near transit = larceny risk)

#### 3b. PCA Models (32 models) - HIGH COMPLEXITY
**Feature Type**: Latent dimensions from hundreds of raw place types

**Analytical Depth**: **Deep** - Uncover hidden patterns in fine-grained data

**Policy Implication**: Complex patterns, harder to translate to actionable interventions

**Theoretical Basis**: Urban ecological patterns may emerge from subtle combinations

Example:
- PC1 might capture "nightlife density" (bars + nightclubs + late-night restaurants)
- PC2 might capture "commercial intensity" (offices + banks + services)

---

### Comparison Logic

The hierarchical design tests: **How deep do we need to go to find effects?**

1. **If counts work**: Simple problem, simple solutions
2. **If interactions work but not counts**: Moderate complexity, need to consider combinations
3. **If only PCA works**: Complex problem, nuanced patterns, difficult policy recommendations

**Within each feature type**, also compare:
- **Incidents vs Arrests**: Does enforcement respond to different patterns than occurrence?
- **Crime types**: Do different crimes show different facility associations?


