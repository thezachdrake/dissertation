# Model Summary: top_25_incidents_VIOLENCE

## Formula

```
top_25_incidents_VIOLENCE ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `513.7542`
- **Null Deviance:**    `590.6464`
- **Log-Likelihood:**   `-256.8771`
- **AIC:**              `545.7542`
- **BIC:**              `659.9327`
- **McFadden's R²:**    `0.1302`

## Coefficients

```
─────────────────────────────────────────────────────────────────────────────────────────────────────
                                        Coef.   Std. Error       z  Pr(>|z|)    Lower 95%   Upper 95%
─────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -5.85268      0.192633   -30.38    <1e-99   -6.23023     -5.47512
category_AUTOMOTIVE                 0.302049     0.134717     2.24    0.0250    0.0380085    0.56609
category_BUSINESS                   1.77657      1.18469      1.50    0.1337   -0.545372     4.09851
category_CULTURE                   -0.712905     0.686815    -1.04    0.2993   -2.05904      0.633228
category_EDUCATION                  0.295291     0.162935     1.81    0.0699   -0.0240553    0.614638
category_ENTERTAINMENT_RECREATION   0.733809     0.147441     4.98    <1e-06    0.44483      1.02279
category_FACILITIES                 0.0        NaN          NaN       NaN     NaN          NaN
category_FINANCE                    0.629614     0.275415     2.29    0.0223    0.0898103    1.16942
category_FOOD_DRINK                -0.0588722    0.0965205   -0.61    0.5419   -0.248049     0.130304
category_GOVERNMENT                 0.254755     0.239073     1.07    0.2866   -0.21382      0.723329
category_HEALTH_WELLNESS            0.0359514    0.0647675    0.56    0.5788   -0.0909905    0.162893
category_LODGING                   -1.21653      0.987492    -1.23    0.2180   -3.15198      0.718917
category_PLACE_OF_WORSHIP           0.237213     0.46918      0.51    0.6131   -0.682362     1.15679
category_SERVICES                   0.216786     0.052675     4.12    <1e-04    0.113545     0.320027
category_SHOPPING                   0.148277     0.0660032    2.25    0.0247    0.0189135    0.277641
category_SPORTS                    -0.0923353    0.282598    -0.33    0.7439   -0.646218     0.461547
category_TRANSPORTATION             0.279732     0.238285     1.17    0.2404   -0.187297     0.746761
─────────────────────────────────────────────────────────────────────────────────────────────────────
```