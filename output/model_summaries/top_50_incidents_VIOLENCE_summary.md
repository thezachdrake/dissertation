# Model Summary: top_50_incidents_VIOLENCE

## Formula

```
top_50_incidents_VIOLENCE ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `1408.8651`
- **Null Deviance:**    `1584.2896`
- **Log-Likelihood:**   `-704.4325`
- **AIC:**              `1440.8651`
- **BIC:**              `1555.0436`
- **McFadden's R²:**    `0.1107`

## Coefficients

```
─────────────────────────────────────────────────────────────────────────────────────────────────────
                                        Coef.   Std. Error       z  Pr(>|z|)    Lower 95%   Upper 95%
─────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -4.56879      0.103166   -44.29    <1e-99   -4.771       -4.36659
category_AUTOMOTIVE                 0.390745     0.0827199    4.72    <1e-05    0.228617     0.552873
category_BUSINESS                   0.163959     1.15952      0.14    0.8876   -2.10866      2.43658
category_CULTURE                   -0.119847     0.243388    -0.49    0.6224   -0.596879     0.357186
category_EDUCATION                  0.307604     0.100712     3.05    0.0023    0.110212     0.504995
category_ENTERTAINMENT_RECREATION   0.365774     0.120889     3.03    0.0025    0.128836     0.602711
category_FACILITIES                 0.0        NaN          NaN       NaN     NaN          NaN
category_FINANCE                    0.541962     0.174492     3.11    0.0019    0.199965     0.88396
category_FOOD_DRINK                 0.0383601    0.0472409    0.81    0.4168   -0.0542304    0.13095
category_GOVERNMENT                 0.246703     0.1536       1.61    0.1082   -0.0543478    0.547754
category_HEALTH_WELLNESS            0.0297052    0.0377656    0.79    0.4315   -0.044314     0.103724
category_LODGING                    0.144653     0.31646      0.46    0.6476   -0.475598     0.764904
category_PLACE_OF_WORSHIP           0.388032     0.219778     1.77    0.0775   -0.0427248    0.818788
category_SERVICES                   0.148257     0.0379012    3.91    <1e-04    0.0739717    0.222542
category_SHOPPING                   0.164045     0.0490593    3.34    0.0008    0.0678909    0.2602
category_SPORTS                    -0.0379458    0.151429    -0.25    0.8021   -0.334741     0.258849
category_TRANSPORTATION             0.334052     0.142285     2.35    0.0189    0.0551781    0.612925
─────────────────────────────────────────────────────────────────────────────────────────────────────
```