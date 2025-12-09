# Implementation Plan: Fix RQ2 (Co-occurrence-based Interactions) and RQ3 (PCA Components)

**Date:** 2025-11-24
**Status:** Planning Phase

---

## Executive Summary

This plan fixes two critical bugs preventing RQ2 and RQ3 from working correctly:

- **RQ3 Bug:** CSV saved before PCA components added → PC_ columns never make it to disk
- **RQ2 Bug:** Co-occurrence runs after feature creation → can't inform which interactions to create

---

## Research Questions (Clarified)

### RQ1: Place Type Category Frequency → Hot Spots
- **Features:** Aggregated categories (SHOPPING, FOOD_DRINK, etc.)
- **Model:** Counts only
- **Status:** ✓ Working

### RQ2: Place Type Category Combinations → Hot Spots
- **Features:** Interactions between categories that actually co-locate
- **Selection:** Use co-occurrence analysis (Jaccard ≥ 0.80)
- **Model:** Interactions only (16 empirically-grounded pairs)
- **Status:** ✗ Needs fixing (currently using 66 arbitrary pairs)

### RQ3: Raw Place Type Patterns → Hot Spots
- **Features:** Hundreds of granular types (before aggregation)
- **Dimension Reduction:** PCA to find latent patterns
- **Model:** PCA components as predictors
- **Status:** ✗ Needs fixing (PCA calculated but not saved)

---

## Critical Bugs Found

### Bug 1: RQ3 - PCA Components Not Saved

**Location:** `src/features.jl` - `create_street_features()` function

**Problem:**
```julia
Line 119: add_place_type_interactions!(features; standardize = true)
Line 131-136: CSV.write(...) ← SAVES TOO EARLY
Line 138-140: add_pca_components!(features, place_matched) ← ADDS PC_ AFTER SAVE
```

**Impact:**
- PC_ columns added to features DataFrame AFTER CSV save
- Saved CSV has no PCA components
- When modeling loads CSV, PCA models have zero predictors
- Models fit intercept-only (explains "No valid predictors" warnings)

**Evidence:**
- `grep "PC_" output/features/incidents_features.csv` returns empty
- PCA model reports show `Formula: high_larceny_top25 ~ 1` (intercept-only)

---

### Bug 2: RQ2 - Co-occurrence Analysis Not Used

**Location:** `src/pipeline.jl` - Pipeline flow

**Problem:**
```
Current flow:
1. create_street_features() → creates ALL 66 interactions
2. run_cooccurrence_analysis() → analyzes patterns (but results unused)
3. fit_logistic_models() → uses ALL 66 interactions
```

**Impact:**
- Co-occurrence analysis is purely descriptive
- Interaction selection uses arbitrary threshold (≥50 streets)
- Creates 66 interactions, many with no theoretical justification
- Models fail due to too many predictors for sparse outcomes

**Evidence:**
- Current features CSV has 66 `interact_` columns
- Co-occurrence runs at line 79 (after features created at line 69)
- `add_place_type_interactions!()` has no parameter for co-occurrence data

---

## Detailed Implementation Plan

### PART 1: Fix RQ3 (PCA Components)

#### Root Cause: `add_pca_components!()` violates Julia idioms

**The Real Bug:**
- Function has `!` but returns new DataFrame instead of modifying in-place
- Caller ignores return value (assumes in-place due to `!`)
- PC_ columns never added to the features DataFrame that gets passed to modeling

**Current implementation (BROKEN):**
```julia
# In add_pca_components!():
function add_pca_components!(features, ...)
    features = leftjoin(features, pca_components_df; on = :street_id)
    # ^^^ Creates NEW DataFrame
    return features  # Returns new one
end

# In create_street_features() line 140:
add_pca_components!(features, place_matched)
# ^^^ Ignores return value, features unchanged!
```

---

#### Fix 1: Make `add_pca_components!()` truly in-place (REQUIRED)

**File: `src/features.jl` - Function `add_pca_components!()`**

**Change the implementation to modify features in-place:**

```julia
function add_pca_components!(features::DataFrame, ...)
    # ... calculate PCA, get pca_components_df ...

    # INSTEAD OF: features = leftjoin(features, pca_components_df; on = :street_id)
    # DO THIS: Add columns directly (in-place modification)

    for col in names(pca_components_df)
        if col != "street_id"
            # Look up matching values by street_id
            street_id_map = Dict(
                pca_components_df[i, :street_id] => pca_components_df[i, col]
                for i in 1:nrow(pca_components_df)
            )

            # Add column to features
            features[!, col] = [
                get(street_id_map, street_id, missing)
                for street_id in features.street_id
            ]
        end
    end

    # Handle missing values
    for col in names(features)
        if startswith(String(col), "PC_") && eltype(features[!, col]) >: Missing
            features[!, col] = coalesce.(features[!, col], 0.0)
        end
    end

    @info "Added $(components_retained) PCA components to feature matrix"

    return nothing  # Bang functions don't need return values
end
```

**Why this is correct:**
- ✓ Modifies `features` DataFrame in-place
- ✓ Bang notation (`!`) is now accurate
- ✓ No return value capture needed
- ✓ Idiomatic Julia

**Caller in `create_street_features()` needs no changes:**
```julia
# Line 140 - this now works correctly:
add_pca_components!(features, place_matched)
```

---

#### Fix 2: Move CSV save after PCA (OPTIONAL but cleaner)

**File: `src/features.jl` - Function `create_street_features()`**

**For cleaner output files, reorder:**

```julia
# Line 117-119: Add interactions
add_place_type_interactions!(features; standardize = true)

# Line 138-140: Add PCA (NOW IN-PLACE)
add_pca_components!(features, place_matched)

# Line 131-136: Save CSV (MOVE AFTER PCA)
features_dir = joinpath(OUTPUT_DIR, "features")
mkpath(features_dir)
CSV.write(joinpath(features_dir, "$(dataset_name)_features.csv"), features)
```

**Note:** This is optional since modeling uses the DataFrame directly, but ensures the saved CSV matches what modeling sees.

**Result:**
- PC_ columns properly added to features DataFrame for modeling
- CSV also contains PC_ columns for inspection/debugging

---

### PART 2: Fix RQ2 (Co-occurrence-based Interactions)

#### Overview: Reorder pipeline to run co-occurrence first, pass results in-memory

---

#### Change 1: `src/pipeline.jl` - Function `run_incidents()`

**Move co-occurrence before feature creation, pass results through**

**Current flow (lines 52-79):**
```julia
# Step 4: Feature engineering
incidents_features = create_street_features(
    incidents_matched, places_matched, streets, "incidents"
)

# Step 5: Co-occurrence analysis (RUNS AFTER)
cooccurrence_results = run_cooccurrence_analysis(incidents_features)
```

**New flow:**
```julia
# Step 4a: Co-occurrence analysis (RUN FIRST on place data)
@info "\n[Step 4a/6] Analyzing place type co-occurrence..."
cooccurrence_results = run_cooccurrence_analysis(places_matched)
pairs_df = cooccurrence_results[:pairs_analysis]

# Step 4b: Feature engineering with co-occurrence data
@info "\n[Step 4b/6] Creating street features..."
incidents_features = create_street_features(
    incidents_matched,
    places_matched,
    streets,
    "incidents",
    cooccurrence_pairs = pairs_df  # PASS IN-MEMORY
)
```

**Same change needed for `run_arrests()` function**

---

#### Change 2: `src/features.jl` - Function `create_street_features()`

**Add optional `cooccurrence_pairs` parameter**

**Current signature (lines 2-4):**
```julia
function create_street_features(
    crime_matched, place_matched, streets_geo, dataset_name::String
)
```

**New signature:**
```julia
function create_street_features(
    crime_matched,
    place_matched,
    streets_geo,
    dataset_name::String;
    cooccurrence_pairs::Union{DataFrame, Nothing} = nothing
)
```

**Update call to interactions (line 119):**
```julia
# Current:
add_place_type_interactions!(features; standardize = true)

# New:
add_place_type_interactions!(
    features;
    standardize = true,
    cooccurrence_pairs = cooccurrence_pairs
)
```

---

#### Change 3: `src/features.jl` - Function `add_place_type_interactions!()`

**Use co-occurrence pairs to select interactions**

**Current signature (line 492):**
```julia
function add_place_type_interactions!(features::DataFrame; standardize::Bool = true)
```

**New signature:**
```julia
function add_place_type_interactions!(
    features::DataFrame;
    standardize::Bool = true,
    cooccurrence_pairs::Union{DataFrame, Nothing} = nothing,
    jaccard_threshold::Float64 = 0.80
)
```

**New logic (replaces lines 565-611):**

```julia
# Determine which pairs to create
valid_pairs = Set{Tuple{String, String}}()

if cooccurrence_pairs !== nothing
    # Use co-occurrence analysis (RQ2: empirically-grounded pairs)
    @info "Using co-occurrence analysis to select interaction pairs (Jaccard ≥ $jaccard_threshold)..."

    # Filter to high co-occurrence pairs
    high_cooc = filter(row ->
        row.jaccard_similarity >= jaccard_threshold &&
        !in(row.place1, ["total_crime", "street_length_meters", "place_density", "total_places"]) &&
        !in(row.place2, ["total_crime", "street_length_meters", "place_density", "total_places"]),
        cooccurrence_pairs
    )

    # Create set of valid pairs (order doesn't matter)
    for row in eachrow(high_cooc)
        push!(valid_pairs, (row.place1, row.place2))
        push!(valid_pairs, (row.place2, row.place1))  # Add reverse for lookup
    end

    @info "Found $(length(valid_pairs)÷2) high co-occurrence pairs to test"
else
    # Fallback: use prevalence threshold (old behavior)
    @info "No co-occurrence data provided, using prevalence threshold (≥$MIN_STREETS_FOR_INTERACTION streets)..."
    # Keep existing MIN_STREETS logic
end

# Create interactions
interaction_count = 0
interactions_created = String[]
interactions_skipped = 0

for i = 1:length(place_cols)
    for j = (i + 1):length(place_cols)
        col1_name = place_cols[i]
        col2_name = place_cols[j]

        # Use standardized columns if available
        col1 = standardize ? "$(col1_name)_std" : col1_name
        col2 = standardize ? "$(col2_name)_std" : col2_name

        # Check both columns exist and are numeric
        if col1 in names(features) &&
            col2 in names(features) &&
            eltype(features[!, col1]) <: Number &&
            eltype(features[!, col2]) <: Number

            # SELECTION LOGIC
            should_create = false

            if cooccurrence_pairs !== nothing
                # Use co-occurrence: only create if in valid_pairs
                should_create = (col1_name, col2_name) in valid_pairs
            else
                # Fallback: use prevalence threshold
                col1_present = sum(features[!, col1_name] .> 0)
                col2_present = sum(features[!, col2_name] .> 0)
                should_create = (col1_present >= MIN_STREETS_FOR_INTERACTION &&
                                col2_present >= MIN_STREETS_FOR_INTERACTION)
            end

            if should_create
                # Create interaction
                interaction_name = "interact_$(col1_name)_x_$(col2_name)"
                features[!, interaction_name] = features[!, col1] .* features[!, col2]
                interaction_count += 1
                push!(interactions_created, interaction_name)
            else
                interactions_skipped += 1
            end
        end
    end
end

if interactions_skipped > 0
    @info "Skipped $interactions_skipped low co-occurrence interactions"
end
```

---

## Expected Outcomes

### RQ1 Models (Counts) - Unchanged
- ✓ 24 models using aggregated category counts
- ✓ All converge successfully
- ✓ Current results remain valid

### RQ2 Models (Interactions) - FIXED
- ✓ 24 models using 16 co-occurrence-selected interactions
- ✓ Interactions include:
  - SHOPPING × FOOD_DRINK (85 streets, Jaccard=0.90)
  - SHOPPING × SERVICES (86 streets, Jaccard=0.87)
  - AUTOMOTIVE × SERVICES (81 streets, Jaccard=0.83)
  - SERVICES × FOOD_DRINK (83 streets, Jaccard=0.81)
  - Plus 12 more high co-occurrence pairs
- ✓ Theoretically justified by spatial co-location patterns
- ✓ Better convergence (16 vs 66 predictors)
- ⚠ Still may fail for very rare outcomes (e.g., drugs_jenks: 13 positives)

### RQ3 Models (PCA) - FIXED
- ✓ 24 models using PCA components from raw place types
- ✓ PC_ columns now present in features CSV
- ✓ Models test latent patterns across hundreds of raw types
- ✓ Data-driven dimensionality reduction
- ✓ Should see formulas like: `high_larceny_top25 ~ 1 + PC_1 + PC_2`

---

## Data Flow Diagrams

### Current (Broken) Flow
```
1. create_street_features()
   ├─ add_place_type_interactions!() [creates 66 pairs]
   ├─ CSV.write() [saves without PC_]
   └─ add_pca_components!() [adds PC_ after save]

2. run_cooccurrence_analysis() [results unused]

3. fit_logistic_models()
   ├─ loads CSV [no PC_ columns]
   └─ uses all 66 interactions [too many]
```

### New (Fixed) Flow
```
1. run_cooccurrence_analysis() [analyzes place patterns]
   └─ returns pairs_df (16 high Jaccard pairs)

2. create_street_features(cooccurrence_pairs = pairs_df)
   ├─ add_place_type_interactions!(pairs_df) [creates 16 pairs]
   ├─ add_pca_components!() [adds PC_ columns]
   └─ CSV.write() [saves with PC_ and 16 interactions]

3. fit_logistic_models()
   ├─ loads CSV [has PC_ columns]
   └─ uses 16 theoretically-grounded interactions
```

---

## Testing Checklist

### After Implementation

**1. Verify co-occurrence timing**
- [ ] Log messages show co-occurrence runs before feature creation
- [ ] No "reading from file" messages (all in-memory)
- [ ] See message: "Found 16 high co-occurrence pairs to test"

**2. Verify PC_ columns in CSV**
- [ ] Run: `head -1 output/features/incidents_features.csv | grep -o "PC_" | wc -l`
- [ ] Should show count > 0 (expected: 2-5 components)
- [ ] Same for arrests_features.csv

**3. Verify interaction selection**
- [ ] Run: `head -1 output/features/incidents_features.csv | grep -o "interact_" | wc -l`
- [ ] Should show 16 (not 66)
- [ ] Check interaction names match co-occurrence top pairs

**4. Verify model formulas**
- [ ] PCA models show: `high_larceny_top25 ~ 1 + PC_1 + PC_2 + ...`
- [ ] Not: `high_larceny_top25 ~ 1` (intercept-only)
- [ ] Interaction models show 16 terms (not 66)

**5. Run full pipeline**
- [ ] Both incidents and arrests complete
- [ ] Check convergence rates improve
- [ ] Verify comparison outputs make sense

---

## Co-occurrence Pairs Selected (Jaccard ≥ 0.80)

Based on actual data, these 16 pairs will be tested:

1. SHOPPING × FOOD_DRINK (85 streets, Jaccard=0.90)
2. SHOPPING × SERVICES (86 streets, Jaccard=0.87)
3. SHOPPING × AUTOMOTIVE (79 streets, Jaccard=0.85)
4. SHOPPING × TRANSPORTATION (81 streets, Jaccard=0.84)
5. AUTOMOTIVE × HEALTH_WELLNESS (74 streets, Jaccard=0.84)
6. PLACE_OF_WORSHIP × EDUCATION (65 streets, Jaccard=0.83)
7. SHOPPING × PLACE_OF_WORSHIP (74 streets, Jaccard=0.83)
8. AUTOMOTIVE × SERVICES (81 streets, Jaccard=0.83)
9. AUTOMOTIVE × FOOD_DRINK (78 streets, Jaccard=0.82)
10. PLACE_OF_WORSHIP × FINANCE (64 streets, Jaccard=0.82)
11. HEALTH_WELLNESS × FINANCE (66 streets, Jaccard=0.81)
12. SHOPPING × HEALTH_WELLNESS (75 streets, Jaccard=0.81)
13. SERVICES × FOOD_DRINK (83 streets, Jaccard=0.81)
14. AUTOMOTIVE × PLACE_OF_WORSHIP (70 streets, Jaccard=0.80)
15. SHOPPING × ENTERTAINMENT_RECREATION (76 streets, Jaccard=0.80)
16. HEALTH_WELLNESS × PLACE_OF_WORSHIP (68 streets, Jaccard=0.80)

**Theoretical interpretation:**
- Retail districts: SHOPPING combinations (8 pairs)
- Auto service corridors: AUTOMOTIVE combinations (5 pairs)
- Institutional zones: PLACE_OF_WORSHIP × EDUCATION/FINANCE
- Health/Finance centers: HEALTH_WELLNESS × FINANCE
- Food/Service streets: SERVICES × FOOD_DRINK

---

## Research Narrative

This implementation cleanly separates three conceptual approaches to testing place-crime relationships:

**RQ1: Category Frequency** (Simple, Interpretable)
- Aggregated place type counts (SHOPPING, FOOD_DRINK, etc.)
- Policy-relevant: "More bars = more violence?"

**RQ2: Category Combinations** (Moderate, Empirical)
- Interactions of co-located place types
- Selected via co-occurrence analysis (Jaccard ≥ 0.80)
- Theoretical bridge: Routine activities through spatial convergence
- Policy-relevant: "Bars + nightclubs = violence hotspots?"

**RQ3: Raw Type Patterns** (Complex, Data-Driven)
- PCA of hundreds of granular place types
- Latent dimensions represent underlying patterns
- Exploratory: "Are there hidden structure in place distributions?"

The co-occurrence analysis provides the empirical foundation for RQ2, showing that certain place combinations naturally co-locate in Manhattan's urban fabric. This spatial co-location justifies testing their combined effects on crime, aligning with routine activities theory's emphasis on convergence of activities in time and space.

---

## Questions to Resolve

1. **Should we use the same co-occurrence pairs for both incidents and arrests?**
   - Currently: One co-occurrence analysis run on place data
   - Place patterns don't differ by crime type
   - Recommendation: Yes, use same pairs for consistency

2. **Should we allow fallback to prevalence threshold if no co-occurrence data?**
   - Currently: Plan includes fallback to old MIN_STREETS logic
   - Recommendation: Yes, makes function more flexible

3. **Should we make Jaccard threshold configurable?**
   - Currently: Hard-coded at 0.80
   - Alternative: Parameter in pipeline
   - Recommendation: Hard-code for now, document rationale

---

## File Change Summary

**Files to modify:**
1. `src/features.jl` - 2 functions
   - `create_street_features()` - Add parameter, reorder saves
   - `add_place_type_interactions!()` - Add co-occurrence logic
2. `src/pipeline.jl` - 2 functions
   - `run_incidents()` - Reorder steps, pass data
   - `run_arrests()` - Reorder steps, pass data

**Files NOT modified:**
- `src/cooccurrence.jl` - Already works correctly
- `src/modeling.jl` - Already fixed in previous session
- `src/output.jl` - Already fixed in previous session

**Estimated changes:** ~150 lines modified across 2 files

---

## Implementation Priority

**Phase 1: Quick Win (RQ3 fix)**
- Move CSV save after PCA
- 5 lines of code
- Immediate impact
- Test: Check PC_ in CSV

**Phase 2: Structural Change (RQ2 fix)**
- Reorder pipeline
- Add parameters
- Implement co-occurrence logic
- ~100 lines of code
- Test: Check 16 interactions

**Phase 3: Full Testing**
- Run complete pipeline
- Verify all 72 models
- Check comparisons
- Validate results

---

## Success Metrics

**RQ3 Success:**
- ✓ PC_ columns in features CSV
- ✓ PCA models have predictors (not intercept-only)
- ✓ Model formulas show PC_1, PC_2, etc.
- ✓ Some PCA models win comparison (AIC < counts)

**RQ2 Success:**
- ✓ Exactly 16 interactions created
- ✓ All interactions match co-occurrence top pairs
- ✓ Better convergence rate (>50% models converge)
- ✓ Some interaction models win comparison

**Overall Success:**
- ✓ Clear winner pattern emerges across RQ1/RQ2/RQ3
- ✓ Results interpretable and theoretically grounded
- ✓ Comparison outputs show meaningful trade-offs
- ✓ Can answer: "Which complexity level predicts hot spots?"

---

**End of Implementation Plan**
