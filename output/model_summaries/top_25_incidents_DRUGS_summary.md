# Model Summary: top_25_incidents_DRUGS

## Formula

```
top_25_incidents_DRUGS ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `106.4463`
- **Null Deviance:**    `128.9005`
- **Log-Likelihood:**   `-53.2232`
- **AIC:**              `138.4463`
- **BIC:**              `252.6248`
- **McFadden's R²:**    `0.1742`

## Coefficients

```
──────────────────────────────────────────────────────────────────────────────────────────────────────
                                       Coef.  Std. Error       z  Pr(>|z|)      Lower 95%    Upper 95%
──────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -7.72125     0.490648  -15.74    <1e-55     -8.6829       -6.75959
category_AUTOMOTIVE                 0.177977    0.331836    0.54    0.5917     -0.47241       0.828364
category_BUSINESS                  -9.29895   641.436      -0.01    0.9884  -1266.49       1247.89
category_CULTURE                   -9.94159   112.344      -0.09    0.9295   -230.132       210.249
category_EDUCATION                  0.263886    0.395472    0.67    0.5046     -0.511226      1.039
category_ENTERTAINMENT_RECREATION   0.490296    0.353351    1.39    0.1653     -0.202259      1.18285
category_FACILITIES                 0.0       NaN         NaN       NaN       NaN           NaN
category_FINANCE                    0.779418    0.648265    1.20    0.2292     -0.491159      2.04999
category_FOOD_DRINK                 0.155396    0.123189    1.26    0.2071     -0.0860493     0.396841
category_GOVERNMENT                 0.38159     0.321979    1.19    0.2360     -0.249478      1.01266
category_HEALTH_WELLNESS           -1.55074     1.11794    -1.39    0.1654     -3.74187       0.64039
category_LODGING                    0.206556    1.03171     0.20    0.8413     -1.81556       2.22867
category_PLACE_OF_WORSHIP           0.758896    0.45287     1.68    0.0938     -0.128713      1.6465
category_SERVICES                   0.265863    0.113088    2.35    0.0187      0.0442139     0.487511
category_SHOPPING                   0.186518    0.201527    0.93    0.3547     -0.208467      0.581502
category_SPORTS                     0.182073    0.350495    0.52    0.6034     -0.504885      0.86903
category_TRANSPORTATION             0.496078    0.516019    0.96    0.3364     -0.515301      1.50746
──────────────────────────────────────────────────────────────────────────────────────────────────────
```