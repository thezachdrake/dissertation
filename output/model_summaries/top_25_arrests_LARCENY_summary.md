# Model Summary: top_25_arrests_LARCENY

## Formula

```
top_25_arrests_LARCENY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `15.1223`
- **Null Deviance:**    `54.2243`
- **Log-Likelihood:**   `-7.5612`
- **AIC:**              `47.1223`
- **BIC:**              `161.3008`
- **McFadden's R²:**    `0.7211`

## Coefficients

```
──────────────────────────────────────────────────────────────────────────────────────────────────────
                                        Coef.   Std. Error       z  Pr(>|z|)     Lower 95%   Upper 95%
──────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -10.7977       2.17382    -4.97    <1e-06    -15.0583      -6.53713
category_AUTOMOTIVE                 -1.68214      2.23059    -0.75    0.4508     -6.05401      2.68974
category_BUSINESS                    7.51334      4.90487     1.53    0.1256     -2.10002     17.1267
category_CULTURE                     2.09347      0.806972    2.59    0.0095      0.511836     3.67511
category_EDUCATION                   0.652402     0.614067    1.06    0.2880     -0.551148     1.85595
category_ENTERTAINMENT_RECREATION  -12.1567     887.721      -0.01    0.9891  -1752.06      1727.75
category_FACILITIES                  0.0        NaN         NaN       NaN       NaN          NaN
category_FINANCE                    -3.22859      3.14323    -1.03    0.3043     -9.38921      2.93203
category_FOOD_DRINK                -14.8113     472.314      -0.03    0.9750   -940.531      910.908
category_GOVERNMENT                  0.651522     0.313034    2.08    0.0374      0.037987     1.26506
category_HEALTH_WELLNESS             0.134811     0.442788    0.30    0.7608     -0.733037     1.00266
category_LODGING                   -17.3322    1870.26       -0.01    0.9926  -3682.97      3648.3
category_PLACE_OF_WORSHIP          -12.641     1828.65       -0.01    0.9945  -3596.73      3571.45
category_SERVICES                    0.3256       0.599987    0.54    0.5874     -0.850352     1.50155
category_SHOPPING                    0.749891     0.199942    3.75    0.0002      0.358012     1.14177
category_SPORTS                    -13.199      990.05       -0.01    0.9894  -1953.66      1927.26
category_TRANSPORTATION              2.14707      1.14664     1.87    0.0611     -0.100312     4.39445
──────────────────────────────────────────────────────────────────────────────────────────────────────
```