# Model Summary: top_jenks_manual_incidents_BURGLARY

## Formula

```
top_jenks_manual_incidents_BURGLARY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `19.7546`
- **Null Deviance:**    `20.2722`
- **Log-Likelihood:**   `-9.8773`
- **AIC:**              `51.7546`
- **BIC:**              `165.9331`
- **McFadden's R²:**    `0.0255`

## Coefficients

```
──────────────────────────────────────────────────────────────────────────────────────────────────────
                                        Coef.   Std. Error       z  Pr(>|z|)    Lower 95%    Upper 95%
──────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -8.87724       1.00007   -8.88    <1e-18     -10.8373     -6.91714
category_AUTOMOTIVE                -10.2828     1006.88      -0.01    0.9919   -1983.74     1963.17
category_BUSINESS                  -10.6763    10686.9       -0.00    0.9992  -20956.5     20935.2
category_CULTURE                    -9.10162    1838.0       -0.00    0.9960   -3611.52     3593.31
category_EDUCATION                  -9.3155     1397.19      -0.01    0.9947   -2747.75     2729.12
category_ENTERTAINMENT_RECREATION  -10.8104     1434.45      -0.01    0.9940   -2822.28     2800.66
category_FACILITIES                  0.0         NaN        NaN       NaN        NaN         NaN
category_FINANCE                    -8.25524    1591.99      -0.01    0.9959   -3128.5      3111.99
category_FOOD_DRINK                 -8.66113     707.212     -0.01    0.9902   -1394.77     1377.45
category_GOVERNMENT                 -9.65592    2869.41      -0.00    0.9973   -5633.6      5614.28
category_HEALTH_WELLNESS            -7.96304     519.975     -0.02    0.9878   -1027.09     1011.17
category_LODGING                    -0.734122   2763.61      -0.00    0.9998   -5417.31     5415.84
category_PLACE_OF_WORSHIP           -9.96706    2370.47      -0.00    0.9966   -4656.01     4636.07
category_SERVICES                   -9.07535     577.783     -0.02    0.9875   -1141.51     1123.36
category_SHOPPING                   -8.48532     659.551     -0.01    0.9897   -1301.18     1284.21
category_SPORTS                     -9.95639    1462.26      -0.01    0.9946   -2875.93     2856.02
category_TRANSPORTATION            -10.4096     1497.58      -0.01    0.9945   -2945.61     2924.79
──────────────────────────────────────────────────────────────────────────────────────────────────────
```