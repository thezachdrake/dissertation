# Code Changes Summary

## Date: 2024

This document summarizes the changes made to the dissertation codebase based on review comments.

## Changes Implemented

### 1. Removed Violence Ratio Feature
**Files Modified:**
- `src/features.jl`
- `src/cooccurrence.jl`
- `src/output.jl`

**Changes:**
- Removed violence_ratio calculation from `create_street_features()` function (lines 107-115)
- Removed violence_ratio calculation from `create_street_features_pca()` function (lines 664-672)
- Removed violence_ratio from excluded columns list in `add_place_type_interactions!()`
- Removed violence_ratio from excluded columns in co-occurrence analysis
- Removed violence_ratio from excluded columns in output functions

**Rationale:** This metric was deemed unnecessary for the analysis.

### 2. Removed Distance to City Center Feature
**Files Modified:**
- `src/features.jl`
- `src/pipeline.jl`
- `src/output.jl`

**Changes:**
- Completely removed `add_spatial_features!()` function (lines 343-402)
- Removed calls to `add_spatial_features!()` in pipeline.jl (lines 140-148)
- Removed distance_to_center from excluded columns lists throughout
- Added comment "Spatial features removed - not needed for analysis"

**Rationale:** Distance to city center was not needed for the current analysis approach.

### 3. Added Street Length Calculation
**Files Modified:**
- `src/spatial.jl`
- `src/features.jl`

**New Functionality:**
- Added `calculate_street_lengths()` function in spatial.jl (lines 115-188)
  - Calculates geodesic length of each street segment in meters
  - Uses Haversine approximation for distance calculation
  - Returns dictionary mapping street_id to length in meters
  - Includes summary statistics logging

### 4. Added Place Density Metric
**Files Modified:**
- `src/features.jl`
- `src/pipeline.jl`

**New Functionality:**
- Modified `create_street_features()` to accept optional `streets_geo` parameter
- Added street_length_meters column to feature matrix
- Added place_density column (places per 100 meters of street)
- Applied same changes to `create_street_features_pca()` function
- Updated pipeline.jl to pass street_data to feature creation functions

**Rationale:** Place density normalizes for street size, providing a more accurate measure of facility concentration.

### 5. Documentation Updates
**Files Modified:**
- `docs/CURRENT_ANALYTICAL_APPROACH.md`

**Changes:**
- Confirmed Cityblock/Manhattan distance is used for spatial matching
- Confirmed Top25/Top50 use cumulative proportions (not quartiles)
- Clarified commercial activity definition (FOOD_DRINK, RETAIL, SERVICES)
- Clarified 5% prevalence filter for predictors
- Updated binary variable description to "group membership"
- Added note about PCA being separate from co-occurrence analysis
- Removed references to violence_ratio and distance_to_center
- Added planned place density feature

## Items Not Changed

### 1. Crime Data Temporal Coverage
**Comment:** "Incidents and Arrests should be YTD with only the last 12 months of data"
**Status:** Not implemented per user request
**Current State:** Downloads all available data without date filtering

## Verification Results

### Confirmed Working as Expected:
1. **Distance Metric:** Cityblock distance confirmed in spatial.jl
2. **Top25/Top50 Methods:** Using cumulative proportions as intended
3. **Commercial Categories:** Defined as FOOD_DRINK, RETAIL, SERVICES
4. **5% Prevalence Filter:** Predictors must have >2 unique values OR appear on >5% of streets

## Testing

- Module compiles successfully with all changes
- No breaking changes to existing API
- All functions maintain backward compatibility where appropriate

## Future Considerations

1. The street length and place density features are now available but optional
2. If streets_geo is not provided, these features will be skipped
3. The pipeline has been updated to utilize these new features automatically
