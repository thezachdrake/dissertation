# Spatial Matching Report

## Generated: 2025-12-16 20:39:18

## Data Quality

This analysis matched crime/arrest points to street segments using
nearest neighbor search with Manhattan (Cityblock) distance in a
locally-projected coordinate system (meters).

### Input Data Quality
| Metric | Count | Percent |
|--------|-------|---------|
| Total input points | 32982 | 100% |
| Invalid coordinates (0,0) | 96 | 0.29% |
| Valid points matched | 32886 | 99.71% |

**Note:** Invalid (0,0) coordinates were filtered before matching.
These represent incidents where NYPD did not successfully geocode the location.

## Distance Distribution

### Summary Statistics (meters)
| Statistic | Value |
|-----------|-------|
| Mean | 15.3 |
| Median | 3.0 |
| Std Dev | 23.7 |
| Min | 0.0 |
| Max | 1961.0 |
| 25th percentile | 0.1 |
| 75th percentile | 23.3 |
| 95th percentile | 57.2 |
| 99th percentile | 81.2 |

## Match Quality by Distance Threshold

The table below shows how many matched points fall within various
distance thresholds from their nearest street segment centroid.

| Threshold (m) | Points Within | % of Valid | Interpretation |
|---------------|---------------|------------|----------------|
| 5 | 17021 | 51.76% | Excellent match - virtually on the street |
| 10 | 20118 | 61.17% | Very good match - typical geocoding accuracy |
| 15 | 22289 | 67.78% |  |
| 20 | 24169 | 73.49% |  |
| 25 | 24933 | 75.82% | Good match - reasonable geocoding tolerance |
| 50 | 28356 | 86.23% | Acceptable match - may include nearby parallel streets |
| 75 | 32447 | 98.67% |  |
| 100 | 32866 | 99.94% | Loose match - could be cross-street or block distance |
| 150 | 32880 | 99.98% |  |
| 200 | 32885 | 100.0% | Very loose - potential geocoding issues |
| 500 | 32885 | 100.0% | Questionable - likely geocoding errors |

## Methodology Notes

### Coordinate System
- **Projection:** Local tangent plane at 40.75°N (Manhattan center)
- **Meters per degree (lat):** 111,320 m
- **Meters per degree (lon):** ~84,400 m (adjusted for latitude using cos)

### Distance Metric
- **Metric:** Manhattan/Cityblock distance
- **Rationale:** Appropriate for urban street grid navigation
- **Calculation:** |Δx| + |Δy| in projected meters

### Matching Strategy
- **Target:** Street segment centroids
- **Algorithm:** KD-tree nearest neighbor search
- **Output:** Each point matched to nearest street segment

## Recommendations for Analysis

Based on the distance distribution:

✓ **Excellent geocoding quality** (median ≤ 10m)
  - Majority of points geocoded to street centroids
  - Safe to use 10-25m threshold for analysis

**Suggested filtering threshold:** 57.2m (95th percentile)
This would retain 95% of matched points while filtering potential outliers.
