# Model Summary: top_25_incidents_LARCENY

## Formula

```
top_25_incidents_LARCENY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `100.2116`
- **Null Deviance:**    `156.6606`
- **Log-Likelihood:**   `-50.1058`
- **AIC:**              `132.2116`
- **BIC:**              `246.3900`
- **McFadden's R²:**    `0.3603`

## Coefficients

```
───────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)     Lower 95%   Upper 95%
───────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -7.67454      0.493849   -15.54    <1e-53    -8.64247     -6.70661
category_AUTOMOTIVE                 -0.0654967    0.628206    -0.10    0.9170    -1.29676      1.16577
category_BUSINESS                    2.76914      2.58192      1.07    0.2835    -2.29133      7.82962
category_CULTURE                    -2.38125      2.54007     -0.94    0.3485    -7.3597       2.59719
category_EDUCATION                  -0.275601     0.908018    -0.30    0.7615    -2.05528      1.50408
category_ENTERTAINMENT_RECREATION    0.50526      0.876771     0.58    0.5644    -1.21318      2.2237
category_FACILITIES                  0.0        NaN          NaN       NaN      NaN          NaN
category_FINANCE                     1.91213      0.517854     3.69    0.0002     0.897159     2.92711
category_FOOD_DRINK                 -2.13123      1.18307     -1.80    0.0716    -4.45001      0.187544
category_GOVERNMENT                  0.239313     0.629961     0.38    0.7040    -0.995389     1.47401
category_HEALTH_WELLNESS             0.177981     0.0817677    2.18    0.0295     0.0177188    0.338242
category_LODGING                   -12.3347     396.878       -0.03    0.9752  -790.202      765.533
category_PLACE_OF_WORSHIP          -10.2614     377.283       -0.03    0.9783  -749.722      729.199
category_SERVICES                   -0.026831     0.176871    -0.15    0.8794    -0.373491     0.319829
category_SHOPPING                    0.578705     0.119018     4.86    <1e-05     0.345433     0.811976
category_SPORTS                    -10.4256     213.03        -0.05    0.9610  -427.957      407.106
category_TRANSPORTATION              0.5345       0.640053     0.84    0.4037    -0.719981     1.78898
───────────────────────────────────────────────────────────────────────────────────────────────────────
```