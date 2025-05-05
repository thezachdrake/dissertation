# Model Summary: top_25_arrests_DRUGS

## Formula

```
top_25_arrests_DRUGS ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `124.9600`
- **Null Deviance:**    `156.6606`
- **Log-Likelihood:**   `-62.4800`
- **AIC:**              `156.9600`
- **BIC:**              `271.1385`
- **McFadden's R²:**    `0.2024`

## Coefficients

```
────────────────────────────────────────────────────────────────────────────────────────────────────
                                       Coef.  Std. Error       z  Pr(>|z|)     Lower 95%   Upper 95%
────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -7.60491     0.45761   -16.62    <1e-61   -8.50181      -6.70801
category_AUTOMOTIVE                 0.110725    0.351508    0.32    0.7528   -0.578218      0.799669
category_BUSINESS                   4.30437     1.41127     3.05    0.0023    1.53833       7.0704
category_CULTURE                   -0.681383    1.05276    -0.65    0.5175   -2.74476       1.38199
category_EDUCATION                  0.209529    0.445652    0.47    0.6382   -0.663932      1.08299
category_ENTERTAINMENT_RECREATION   0.395021    0.374704    1.05    0.2918   -0.339385      1.12943
category_FACILITIES                 0.0       NaN         NaN       NaN     NaN           NaN
category_FINANCE                    0.666709    0.595308    1.12    0.2627   -0.500073      1.83349
category_FOOD_DRINK                 0.128182    0.112641    1.14    0.2551   -0.0925899     0.348955
category_GOVERNMENT                 0.484112    0.185678    2.61    0.0091    0.12019       0.848034
category_HEALTH_WELLNESS           -0.930987    0.623344   -1.49    0.1353   -2.15272       0.290744
category_LODGING                    0.841347    0.621759    1.35    0.1760   -0.377278      2.05997
category_PLACE_OF_WORSHIP           0.702361    0.481324    1.46    0.1445   -0.241017      1.64574
category_SERVICES                   0.208897    0.108699    1.92    0.0546   -0.00414938    0.421944
category_SHOPPING                   0.243871    0.112959    2.16    0.0309    0.0224761     0.465267
category_SPORTS                     0.211683    0.326892    0.65    0.5173   -0.429013      0.852379
category_TRANSPORTATION             0.401685    0.480812    0.84    0.4035   -0.540689      1.34406
────────────────────────────────────────────────────────────────────────────────────────────────────
```