# PCA Component Diagnostics: ARRESTS

Generated: 2025-12-16T20:39:18.531

---

## Research Question

Can latent place type patterns (PCA components) predict crime hot spots?

**Current Finding**: PCA models show R² ≈ 0 despite using 6 components

**Diagnostic Goal**: Understand WHY PCA fails

---

## 1. Variance Threshold Sensitivity

| Variance Threshold | N Components | Variance Explained | Mean Var/Component | Max Var/Component |
|-------------------|--------------|--------------------|--------------------|-------------------|
| 0.9 | 10 | 78.7% | 7.87% | 54.34% |
| 0.95 | 10 | 78.7% | 7.87% | 54.34% |
| 0.99 | 10 | 78.7% | 7.87% | 54.34% |

**Interpretation**: 
At 99% variance threshold, we retain 10 components. Each component explains relatively small amounts of variance.

---

## 2. Variance Explained (99% Threshold)

| Component | Variance | Proportion | Cumulative |
|-----------|----------|------------|------------|
| PC_1 | 142.37 | 54.34% | 54.3% |
| PC_2 | 17.3 | 6.6% | 60.9% |
| PC_3 | 9.22 | 3.52% | 64.5% |
| PC_4 | 7.4 | 2.83% | 67.3% |
| PC_5 | 6.79 | 2.59% | 69.9% |
| PC_6 | 6.4 | 2.44% | 72.3% |
| PC_7 | 5.21 | 1.99% | 74.3% |
| PC_8 | 4.34 | 1.66% | 76.0% |
| PC_9 | 3.71 | 1.42% | 77.4% |
| PC_10 | 3.38 | 1.29% | 78.7% |

**Interpretation**: 
PC_1 explains 54.3% of variance. 
This suggests a moderate dominant pattern in place type co-occurrence.

---

## 3. Component Interpretability (Top Loadings)

### PC_1

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | restaurant | -0.991 |
| 2 | store | -0.986 |
| 3 | point_of_interest | -0.986 |
| 4 | consultant | -0.985 |
| 5 | transit_station | -0.985 |

### PC_2

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | heliport | -0.853 |
| 2 | airport | -0.853 |
| 3 | camping_cabin | -0.853 |
| 4 | fishing_charter | -0.853 |
| 5 | embassy | -0.853 |

### PC_3

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | chocolate_factory | -0.701 |
| 2 | ferry_terminal | -0.701 |
| 3 | wholesaler | -0.668 |
| 4 | amphitheatre | -0.646 |
| 5 | moving_company | -0.614 |

### PC_4

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | chocolate_factory | +0.603 |
| 2 | ferry_terminal | +0.603 |
| 3 | wholesaler | +0.55 |
| 4 | amphitheatre | +0.484 |
| 5 | sushi_restaurant | -0.449 |

### PC_5

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | cottage | +0.62 |
| 2 | dessert_restaurant | +0.602 |
| 3 | acai_shop | -0.443 |
| 4 | brazilian_restaurant | -0.443 |
| 5 | public_bath | +0.427 |

### PC_6

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | public_bath | +0.694 |
| 2 | hindu_temple | +0.594 |
| 3 | tourist_information_center | -0.523 |
| 4 | visitor_center | -0.475 |
| 5 | amusement_center | -0.424 |

### PC_7

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | cottage | -0.585 |
| 2 | warehouse_store | +0.569 |
| 3 | stable | -0.449 |
| 4 | transit_depot | -0.442 |
| 5 | video_arcade | +0.425 |

### PC_8

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | amusement_park | -0.597 |
| 2 | water_park | -0.514 |
| 3 | tanning_studio | -0.484 |
| 4 | dog_cafe | -0.415 |
| 5 | shoe_store | -0.397 |

### PC_9

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | mediterranean_restaurant | -0.521 |
| 2 | picnic_ground | -0.48 |
| 3 | zoo | -0.43 |
| 4 | video_arcade | +0.377 |
| 5 | thai_restaurant | -0.374 |

### PC_10

| Rank | Place Type | Loading |
|------|------------|---------|
| 1 | cultural_landmark | +0.527 |
| 2 | fire_station | +0.416 |
| 3 | picnic_ground | +0.348 |
| 4 | greek_restaurant | -0.347 |
| 5 | swimming_pool | -0.345 |

**Interpretation**: 
Examine whether components represent interpretable latent constructs:
- Do loadings cluster around theoretically meaningful place type groups?
- Or are they diffuse/arbitrary combinations?

---

## 4. Component Score Distributions

| Component | Mean | Std | Min | Q25 | Median | Q75 | Max | % Non-Zero |
|-----------|------|-----|-----|-----|--------|-----|-----|------------|
| PC_1 | 0.0 | 11.93 | -104.8 | 0.4 | 3.0 | 4.8 | 4.9 | 100.0% |
| PC_2 | -0.0 | 4.16 | -38.7 | -0.1 | 0.4 | 0.5 | 21.8 | 100.0% |
| PC_3 | 0.0 | 3.04 | -23.2 | 0.1 | 0.6 | 0.7 | 8.9 | 100.0% |
| PC_4 | 0.0 | 2.72 | -14.6 | -0.2 | 0.5 | 0.6 | 17.9 | 100.0% |
| PC_5 | -0.0 | 2.61 | -14.3 | -0.4 | -0.3 | 0.0 | 17.6 | 100.0% |
| PC_6 | -0.0 | 2.53 | -12.1 | 0.0 | 0.2 | 0.3 | 19.2 | 100.0% |
| PC_7 | 0.0 | 2.28 | -14.6 | -0.3 | -0.2 | 0.1 | 13.4 | 100.0% |
| PC_8 | 0.0 | 2.08 | -11.9 | -0.0 | -0.0 | 0.4 | 6.7 | 100.0% |
| PC_9 | -0.0 | 1.93 | -10.1 | -0.1 | 0.1 | 0.2 | 7.2 | 100.0% |
| PC_10 | -0.0 | 1.84 | -8.2 | -0.3 | -0.0 | 0.2 | 9.3 | 100.0% |

**Interpretation**: 

---

## 5. Key Diagnostic Findings

**Possible Reasons for PCA Failure (R² ≈ 0):**

1. **Low Component Variance**: If individual components explain <10% variance each, no single pattern dominates
2. **Uninterpretable Components**: If loadings are diffuse (no clear clusters), components may not capture meaningful constructs
3. **Low Score Variation**: If component scores have low std (<1), limited variation to predict outcomes
4. **Wrong Dimensionality**: Perhaps need MORE components (test lower variance threshold) or FEWER (too much noise)
5. **Wrong Feature Space**: PCA assumes linear relationships; place types may have non-linear crime associations

**Next Steps:**

- Examine loadings for interpretability (Section 3)
- Check if score distributions show sufficient variation (Section 4)
- Test alternative variance thresholds (Section 1)
- Consider that **place types may not have meaningful latent structure** for crime prediction

