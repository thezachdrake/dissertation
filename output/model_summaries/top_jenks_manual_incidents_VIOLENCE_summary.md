# Model Summary: top_jenks_manual_incidents_VIOLENCE

## Formula

```
top_jenks_manual_incidents_VIOLENCE ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `15.9046`
- **Null Deviance:**    `37.7716`
- **Log-Likelihood:**   `-7.9523`
- **AIC:**              `47.9046`
- **BIC:**              `162.0831`
- **McFadden's R²:**    `0.5789`

## Coefficients

```
────────────────────────────────────────────────────────────────────────────────────────────────────────
                                        Coef.   Std. Error       z  Pr(>|z|)      Lower 95%    Upper 95%
────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -9.9362       1.50667    -6.59    <1e-10     -12.8892       -6.98318
category_AUTOMOTIVE                -16.3712     716.028      -0.02    0.9818   -1419.76       1387.02
category_BUSINESS                   -8.16084   5159.12       -0.00    0.9987  -10119.8       10103.5
category_CULTURE                   -12.8965    1553.65       -0.01    0.9934   -3058.0        3032.21
category_EDUCATION                 -11.9419    1114.69       -0.01    0.9915   -2196.7        2172.82
category_ENTERTAINMENT_RECREATION    2.30733      0.796919    2.90    0.0038       0.745393      3.86926
category_FACILITIES                  0.0        NaN         NaN       NaN        NaN           NaN
category_FINANCE                   -11.7403    1120.85       -0.01    0.9916   -2208.57       2185.09
category_FOOD_DRINK                 -0.860867     2.56161    -0.34    0.7368      -5.88152       4.15979
category_GOVERNMENT                -10.3342    2305.1        -0.00    0.9964   -4528.24       4507.57
category_HEALTH_WELLNESS           -14.3402     416.315      -0.03    0.9725    -830.303       801.623
category_LODGING                   -14.4094    2461.6        -0.01    0.9953   -4839.05       4810.24
category_PLACE_OF_WORSHIP          -11.2705    1944.04       -0.01    0.9954   -3821.52       3798.98
category_SERVICES                    0.294737     0.562117    0.52    0.6000      -0.806991      1.39647
category_SHOPPING                    0.524936     0.363388    1.44    0.1486      -0.187291      1.23716
category_SPORTS                    -14.7392     946.19       -0.02    0.9876   -1869.24       1839.76
category_TRANSPORTATION              0.617668     1.82278     0.34    0.7347      -2.95491       4.19025
────────────────────────────────────────────────────────────────────────────────────────────────────────
```