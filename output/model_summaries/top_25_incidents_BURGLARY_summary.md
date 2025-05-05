# Model Summary: top_25_incidents_BURGLARY

## Formula

```
top_25_incidents_BURGLARY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `201.8816`
- **Null Deviance:**    `235.6065`
- **Log-Likelihood:**   `-100.9408`
- **AIC:**              `233.8816`
- **BIC:**              `348.0601`
- **McFadden's R²:**    `0.1431`

## Coefficients

```
────────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)     Lower 95%    Upper 95%
────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -6.78599       0.320229  -21.19    <1e-98     -7.41363     -6.15835
category_AUTOMOTIVE                  0.706831      0.198255    3.57    0.0004      0.318259     1.0954
category_BUSINESS                  -12.1232     1054.21       -0.01    0.9908  -2078.34      2054.1
category_CULTURE                     0.597587      0.38733     1.54    0.1229     -0.161567     1.35674
category_EDUCATION                   0.381112      0.328918    1.16    0.2466     -0.263556     1.02578
category_ENTERTAINMENT_RECREATION   -1.10999       0.939878   -1.18    0.2376     -2.95212      0.732136
category_FACILITIES                  0.0         NaN         NaN       NaN       NaN          NaN
category_FINANCE                   -12.3546      134.71       -0.09    0.9269   -276.382      251.673
category_FOOD_DRINK                  0.501243      0.148467    3.38    0.0007      0.210254     0.792233
category_GOVERNMENT                -11.4994      216.026      -0.05    0.9575   -434.903      411.904
category_HEALTH_WELLNESS            -1.21986       0.925663   -1.32    0.1876     -3.03412      0.594411
category_LODGING                     0.742733      0.721068    1.03    0.3030     -0.670533     2.156
category_PLACE_OF_WORSHIP          -11.0196      212.982      -0.05    0.9587   -428.456      406.417
category_SERVICES                    0.15158       0.164122    0.92    0.3557     -0.170094     0.473253
category_SHOPPING                   -0.0722876     0.221001   -0.33    0.7436     -0.505443     0.360867
category_SPORTS                      0.125125      0.228302    0.55    0.5836     -0.322338     0.572589
category_TRANSPORTATION              0.531594      0.419741    1.27    0.2053     -0.291084     1.35427
────────────────────────────────────────────────────────────────────────────────────────────────────────
```