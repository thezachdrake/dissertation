# Dissertation Analysis: Facilities as Risk Factors For Crime Hot Spots

The goal of this project is to use data from NYPD and Google Maps Service to assess the impact that different types of places on a street segment have on the likelihood of that street segment being a crime hot spot. This analysis examines the relationship between place types (facilities) and crime hot spots in Manhattan, addressing three research questions.

I use street segments as the unit of analysis and cumulative proportion of crime to identify crime hot spots, keeping with the work of David Weisburd. 
In addition to cumulative proportion, I also test the use of Jenks natural breaks to identify hot spots.

Our focus is not on crime hot spots themselves, but on how the makeup of the places on a street segment impacts the likelihood of that street segment being a crime hot spot.

## Research Questions

1. **RQ1**: Does the number of different place types on a street segment affect the risk of that street segment being a crime hotspot?
2. **RQ2**: Does the combination of some place types on a street segment affect the risk of that street segment being a crime hotspot?
3. **RQ3**: Do any latent groups of place types on a street segment affect the risk of that street segment being a crime hotspot?

## Data Sources

### Crime Data
- **NYPD Crime Incidents**: Complaint reports from NYC Open Data
- **NYPD Arrests**: Arrest records from NYC Open Data
- **Geography**: Manhattan only
- **Crime Types**: Four categories analyzed
  - LARCENY (theft-related offenses)
  - VIOLENCE (assault, robbery, homicide, rape, shootings, etc.)
  - BURGLARY (breaking and entering)
  - DRUGS (controlled substance offenses)

### Spatial Data
- **Street Centerlines**: NYC LION street network dataset
- **Unit of Analysis**: Individual street segments (blockfaces)
- **Spatial Reference**: EPSG:2263 (New York State Plane, feet)

### Place Data
- **Source**: Google Places API
- **Types**: Points of interest (businesses, facilities, institutions)
- **Mapped Categories**: 17 standardized place types (see https://developers.google.com/maps/documentation/places/web-service/place-types)
  - AUTOMOTIVE
  - BUSINESS
  - CULTURE
  - EDUCATION
  - ENTERTAINMENT_RECREATION
  - FACILITIES
  - FINANCE
  - FOOD_DRINK
  - GOVERNMENT
  - HEALTH_WELLNESS
  - LODGING
  - OTHER
  - PLACE_OF_WORSHIP
  - SERVICES
  - SHOPPING
  - SPORTS
  - TRANSPORTATION
- I create a "primary_type" for each place that is the listed 'primaryType' from the Google Places API.
- I create a "raw_type" for each place that is all of the types in a list from the Google Places API, with the 'Table B' generic categoris in the link above removed.
- Count and interaction models use the 'primary_type' feature while PCA models use the 'raw_type' feature.

## Methodology

### Crime Hot Spot Identification

1. **Cumulative Proportion (Top 25%)**
   - Streets accounting for 25% of total crime volume
   - Identifies high-concentration segments

2. **Cumulative Proportion (Top 50%)**
   - Streets accounting for 50% of total crime volume
   - More inclusive threshold

3. **Jenks Natural Breaks**
   - Data-driven classification (k=3 classes: low, medium, high)
   - Identifies natural groupings in crime distribution
   - High class designated as hot spots

This produces 12 binary outcome variables per dataset:
- 4 crime types × 3 threshold methods = 12 targets
- Examples: `high_larceny_top25`, `high_violence_jenks`, `high_burglary_top50`

### Spatial Matching

**Crime-to-Street Matching:**
- Nearest neighbor algorithm (Manhattan distance metric)
- NYPD crime data is pre-geocded to the street segment centroid using NAD83.
- Distance filtering: Crimes >10m from nearest street are excluded as they are assumed to be crimes at intersections. Given that the incidents and arrests are pregeocded to the center of the street segmenet this is a safe assumption for a cut off. 

**Place-to-Street Matching:**
- Nearest neighbor algorithm (Manhattan distance metric)
- No distance filtering applied
- Rationale: All facilities retained to capture full neighborhood composition

**Output:** Each crime and place assigned to a `street_id`

### Co-occurrence Analysis

Conducted **before** feature engineering to inform interaction term selection:

1. Calculate place type co-occurrence across street segments
2. Compute Jaccard similarity for all place type pairs
3. Identify high co-occurrence pairs (Jaccard ≥ 0.80)
4. Use empirically-grounded pairs for interaction term creation

**Purpose:** Data-driven feature selection to avoid arbitrary interaction term combinations

## Feature Engineering

All features are computed at the street segment level. The feature matrix contains a row for each street segment with counts of place types, interaction effects of the place types, and the principal component values of the raw place types. In addition each row has the 12 target variables.  

### Base Features (RQ1)

**Place Type Counts:**
- One column per mapped category (12 categories)
- Raw counts of each facility type on the street segment
- Examples: `FOOD_DRINK`, `SHOPPING`, `FINANCE`

**Derived Variables:**
- `total_places`: Sum of all place counts
- `total_crime`: Sum of all crime counts
- `crime_place_ratio`: Total crime / (total places + 1)
- `place_density`: Places per 100 meters of street length (this is used as a control variable in the models for streets that just simply have more places and less area.)

### Interaction Features (RQ2)

**Standardization:**
- Place type counts are **z-score standardized** before creating interactions
- Formula: `z = (x - mean) / std`
- Purpose: Scale-invariant interpretation of interaction effects

**Interaction Term Creation:**
- Pairwise products of standardized place counts
- Selection: Only pairs with high co-occurrence (Jaccard ≥ 0.80)
- Naming convention: `interact_PLACETYPE1_x_PLACETYPE2`
- Examples: `interact_FOOD_DRINK_x_ENTERTAINMENT_RECREATION`

**Rationale:** Tests whether combinations of place types have effects beyond simple additive counts (composition hypothesis)

### PCA Features (RQ3)

**Standardization:**
- Place type counts are **z-score standardized** before PCA
- Ensures equal weighting of all place types in component extraction

**PCA Configuration:**
- Variance threshold: 99% (retain components explaining 99% of variance)
- Maximum components: 10
- Algorithm: Singular Value Decomposition (SVD)

**Component Naming:**
- `PC_1`, `PC_2`, `PC_3`, etc.
- Each component represents a latent pattern of place type co-variation

**Handling Zero-Facility Streets:**
- Streets with no places assigned 0.0 for all components
- Maintains consistent dimensionality

**Rationale:** Tests whether underlying patterns in facility composition (not visible in raw categories) predict crime hot spots

## Modeling Approach

Each research question is tested using **logistic regression** with a binomial family and logit link. The three model types are **independent** - they answer distinct theoretical questions and are not compared competitively.

### RQ1: Counts-Only Models

**Predictors:** Raw place type counts (12 categories) plus the place density control variable.

**Formula Example:**
```
high_larceny_top25 ~ AUTOMOTIVE + BUSINESS + CULTURE + EDUCATION +
                      ENTERTAINMENT_RECREATION + FACILITIES + FINANCE +
                      FOOD_DRINK + GOVERNMENT + HEALTH_WELLNESS +
                      LODGING + SERVICES + SHOPPING + TRANSPORTATION +
                      place_density
```

**Predictor Filtering:**
- Excludes: crime variables, target variables, interaction terms, PCA components, metadata
- Includes: Only mapped place type counts and the place density control variable.

**Theoretical Test:** Do raw facility counts (quantity) predict crime hot spots?

### RQ2: Interactions-Only Models

**Predictors:** Interaction terms (pairwise products of standardized counts)

**Formula Example:**
```
high_larceny_top25 ~ place_density + interact_FOOD_DRINK_x_ENTERTAINMENT_RECREATION +
                      interact_SHOPPING_x_FINANCE +
                      interact_BUSINESS_x_TRANSPORTATION + ...
```

**Predictor Filtering:**
- Pattern match: Columns starting with `interact_` + `place_density`
- Excludes: Base counts, PCA components

**Theoretical Test:** Do facility combinations (composition) predict crime hot spots beyond simple counts?

### RQ3: PCA-Only Models

**Predictors:** Principal components (latent dimensions)

**Formula Example:**
```
high_larceny_top25 ~ place_density + PC_1 + PC_2 + PC_3 + PC_4 + PC_5 + ...
```

**Predictor Filtering:**
- Pattern match: Columns starting with `PC_` + `place_density`
- Excludes: Base counts, interaction terms

**Theoretical Test:** Do latent patterns in facility composition predict crime hot spots?

### Model Estimation

- **Family:** Binomial (binary outcome)
- **Link Function:** Logit (log-odds)
- **Software:** GLM.jl (Julia standard library)
- **Estimation:** Maximum likelihood

### Model Evaluation

For each fitted model:
- **Deviance:** Model fit statistic
- **AIC/BIC:** Information criteria for complexity adjustment
- **McFadden R²:** Pseudo R-squared for logistic regression
- **Coefficients:** Log-odds ratios with standard errors and p-values
- **Performance Metrics:** Accuracy, precision, recall, F1 score

## Pipeline Execution Order

The analysis pipeline follows this sequence:

1. **Data Processing** (`run_process()`)
   - Load and clean raw data
   - Standardize crime categories
   - Map Google place types to standardized categories

2. **Spatial Matching** (`run_incidents()` / `run_arrests()`)
   - Match crimes to street segments (nearest neighbor)
   - Match places to street segments (nearest neighbor)
   - Calculate spatial statistics
   - Apply distance filtering (crimes only)

3. **Co-occurrence Analysis** (`run_cooccurrence_analysis()`)
   - Compute pairwise Jaccard similarities
   - Identify high co-occurrence pairs (≥ 0.80)
   - Generate pairs DataFrame for interaction term creation

4. **Feature Engineering** (`create_street_features()`)
   - Aggregate place counts by street
   - Standardize counts (z-score)
   - Create interaction terms (standardized × standardized)
   - Fit PCA on standardized counts
   - Generate PCA scores (components)

5. **Target Variable Creation** (`create_target_variables!()`)
   - Compute cumulative proportions (top 25%, top 50%)
   - Calculate Jenks breaks (natural classification)
   - Create 12 binary outcome variables

6. **Model Fitting** (`fit_logistic_models()`)
   - Fit counts-only models (RQ1)
   - Fit interactions-only models (RQ2)
   - Fit PCA-only models (RQ3)
   - Save three independent result sets

7. **Results Saving** (`save_results()`)
   - Model summaries (AIC, BIC, R²)
   - Coefficient tables
   - Predictions
   - Performance metrics
   - Markdown reports

## Output Structure

Results are saved to `output/` with the following structure:

```
output/
├── features/
│   ├── incidents_features.csv
│   └── arrests_features.csv
├── models/
│   ├── incidents_counts_model_summaries.csv
│   ├── incidents_counts_model_coefficients.csv
│   ├── incidents_interactions_model_summaries.csv
│   ├── incidents_interactions_model_coefficients.csv
│   ├── incidents_pca_model_summaries.csv
│   ├── incidents_pca_model_coefficients.csv
│   └── (same structure for arrests)
├── spatial_analysis/
│   ├── incidents_spatial_stats.csv
│   └── arrests_spatial_stats.csv
└── cooccurrence/
    ├── cooccurrence_matrix.csv
    └── cooccurrence_pairs.csv
```

## Research Design Rationale

### Independent Model Sets

The three model types (counts, interactions, PCA) are **not compared** as competing alternatives. Instead:

- **RQ1 tests the baseline hypothesis**: Do facility quantities matter?
- **RQ2 tests the composition hypothesis**: Do facility combinations matter?
- **RQ3 tests the complexity hypothesis**: Do latent facility patterns matter?

Each research question has theoretical motivation and contributes distinct knowledge about place-based crime risk factors.

### Multiple Crime Types

Analyzing four crime types separately allows for:
- Crime-specific facility relationships
- Differential effects by offense type
- Comprehensive assessment across crime categories

### Multiple Threshold Methods

Using cumulative proportion and Jenks breaks provides:
- Consistency with Weisburd's hot spot framework (cumulative proportion)
- Data-driven robustness check (Jenks natural breaks)
- Sensitivity analysis across threshold definitions
