# Current Analytical Approach and Strategy

## Overview

This document describes the analytical pipeline currently implemented for analyzing the relationship between place types and crime patterns in Manhattan. The analysis operates at the street segment level, treating each street as the unit of analysis.

## Data Sources

### Crime Data

<!-- Incidents and Arrests should be YTD with only the last 12 months of data -->

- **NYPD Incident Data**: Historical crime reports from NYC Open Data
- **NYPD Arrest Data**: Arrest records as a measure of police activity
- **Geographic Scope**: Manhattan only (highest crime-to-street ratio)
- **Temporal Coverage**: Available quarterly updates from NYC Open Data

### Place Data

- **Google Places API**: Facility locations and types
- **Categories**: Restaurants, retail, lodging, services, entertainment, etc.
- **Coverage**: All establishments within Manhattan boundaries

### Street Data

- **NYC Street Centerlines**: Geographic representation of street segments
- **Source**: NYC Open Data's street centerline dataset
- **Usage**: Spatial backbone for aggregating crimes and places

## Data Processing Pipeline

### Step 1: Crime Categorization

The analysis groups hundreds of specific NYPD offense codes into 4 broader categories:

- **VIOLENCE**: Murder, assault, robbery - crimes involving physical confrontation
- **LARCENY**: All theft types (petit, grand, from vehicle) - property crimes without entry
- **BURGLARY**: Breaking and entering crimes - property crimes involving illegal entry
- **DRUGS**: All drug-related offenses

This simplification reduces complexity while maintaining meaningful distinctions between crime types with different spatial patterns.

### Step 2: Spatial Matching

All data points (crimes and places) are matched to their nearest street segment using K-nearest neighbor algorithms:

1. **Distance Metric**: Cityblock/Manhattan distance (appropriate for grid layout)
2. **Distance Threshold**: 50 meters maximum distance from street centerline
3. **K-NN Search**: Find nearest street segment for each point
4. **Assignment**: Each crime/place assigned to exactly one street
5. **Validation**: Points beyond threshold are excluded from analysis

### Step 3: Feature Engineering

For each street segment, the pipeline creates:

#### Crime Features

- Count of each crime type (violence, larceny, burglary, drugs)
- Total crime count

#### Place Features

- Count of each place category (12 categories derived from Google place types)
- Total place count
- Commercial activity index (sum of FOOD_DRINK, RETAIL, and SERVICES categories)
- **Planned**: Place density (places per street length) - to normalize for street size

#### Derived Features

- Crime-to-place ratio
- Street name and ID for tracking

### Step 4: Target Variable Creation

The analysis tests multiple definitions of "high crime" streets:

#### Threshold Methods

1. **Top 25%**: Streets containing the top 25% of total crime (cumulative proportion, not quartile)
2. **Top 50%**: Streets containing the top 50% of total crime (cumulative proportion, not median split)
3. **Median**: Streets above the median crime count
4. **Jenks Natural Breaks**: Data-driven thresholds based on natural groupings in the data

Each method × crime type combination creates a binary group membership variable. For example, a street either belongs to the "Top 25% Burglary" group or it doesn't - there's no in-between.

### Step 5: Co-occurrence Analysis

Examines which place types tend to appear together on the same streets:

1. **Co-occurrence Matrix**: Count of streets where each pair of place types both appear
2. **Jaccard Similarity**: Measure of overlap between place type distributions
3. **Normalized Metrics**: Account for different base rates of place types
4. **Visualization**: Heatmaps showing co-location patterns

This reveals the urban ecology - which types of establishments cluster together.

**Note**: PCA analysis is performed separately as an alternative feature engineering approach, using raw Google place types (~300+) instead of the 12 aggregated categories. This preserves more granular patterns but is computationally separate from co-occurrence analysis.

### Step 6: Statistical Modeling

Logistic regression models predict high-crime streets from place composition:

#### Model Specification

- **Outcome**: Binary high-crime group membership (varies by threshold method)
- **Predictors**: Place type counts (filtered to exclude rare place types - must appear on >5% of streets OR have >2 unique values)
- **Family**: Binomial with logit link
- **Separate Models**: Each crime type modeled independently

#### Model Comparisons

- Compare performance across threshold methods (AIC, BIC, McFadden R²)
- Identify consistent predictors across methods
- Extract significant coefficients and odds ratios
- Test interaction effects between place types

### Step 7: Output Generation

The pipeline produces comprehensive outputs:

#### Tables

- Place type distributions
- Crime concentration statistics
- Model coefficients and significance
- Co-occurrence matrices
- Method comparison metrics

#### Visualizations

- Bar plots of place distributions
- Heatmaps of co-occurrence patterns
- Coefficient plots for model interpretation
- Crime concentration curves

#### Reports

- Markdown summaries of findings
- LaTeX tables for publication
- Diagnostic logs with timestamps
- Environment documentation for reproducibility

## Key Analytical Decisions

### Why Street Segments?

- Natural unit for urban analysis
- Consistent geographic scale
- Meaningful for policy interventions
- Matches how people experience urban space

### Why These Crime Categories?

- Reduces hundreds of offense codes to manageable number
- Each category has distinct spatial patterns
- Aligns with different prevention strategies
- Maintains sufficient sample size for modeling

### Why Multiple Thresholds?

- No consensus definition of "high crime" in literature
- Tests robustness of findings to definitional changes
- Jenks method provides data-driven alternative
- Enables sensitivity analysis

### Why Manhattan?

- Highest crime density in NYC
- Best statistical power for analysis
- Complete place data coverage
- Diverse mix of land uses

## Technical Implementation

### Technology Stack

- **Language**: Julia 1.11+
- **Key Packages**:
    - GeoStats/GeoTables for spatial analysis
    - GLM for statistical modeling
    - DataFrames for data manipulation
    - CairoMakie for visualization

### Reproducibility Features

- Nix flake for environment management
- Centralized configuration system
- Deterministic random seeds
- Comprehensive logging
- Environment stamping

### Performance Optimizations

- Caching of processed features
- Parallel processing where applicable
- Efficient spatial indexing
- Batch API calls for data downloads

## Analysis Outputs

### Primary Results

1. **Co-occurrence patterns**: Which place types cluster together
2. **Crime predictors**: Which place types predict high crime
3. **Method comparison**: Which threshold definition works best
4. **Crime-specific models**: Different predictors for different crimes

### Validation Metrics

- Model fit statistics (AIC, BIC, pseudo-R²)
- Cross-validation results
- Significance testing with multiple comparison corrections
- Sensitivity to threshold definitions

### Practical Applications

- Identify crime-generating facility types
- Guide zoning and planning decisions
- Inform police resource allocation
- Support place-based crime prevention

## Current Limitations

### Data Limitations

- Point-in-time place data (not historical)
- Crime reporting biases
- Geocoding accuracy (~50m precision)
- Missing informal establishments

### Methodological Limitations

- Cross-sectional analysis (no causality)
- Ecological inference issues
- Modifiable areal unit problem
- No temporal dynamics

### Technical Limitations

- API rate limits for data collection
- Processing time for large datasets
- Storage requirements for outputs

## Future Enhancements

### Planned Improvements

- Temporal analysis with historical data
- Additional place data sources
- Network-based street measures
- Hierarchical modeling approaches

### Potential Extensions

- Other NYC boroughs
- Different crime categorizations
- Alternative spatial units
- Machine learning methods

## Summary

This analytical pipeline provides a systematic approach to understanding the relationship between urban facilities and crime concentration. By processing crime and place data at the street segment level, applying multiple analytical techniques, and producing comprehensive outputs, the system enables rigorous examination of urban crime patterns while maintaining reproducibility and transparency.
