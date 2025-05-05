# Model Summary: top_jenks_manual_arrests_BURGLARY

## Formula

```
top_jenks_manual_arrests_BURGLARY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `26.2687`
- **Null Deviance:**    `37.7716`
- **Log-Likelihood:**   `-13.1344`
- **AIC:**              `58.2687`
- **BIC:**              `172.4472`
- **McFadden's R²:**    `0.3045`

## Coefficients

```
────────────────────────────────────────────────────────────────────────────────────────────────────────
                                        Coef.   Std. Error       z  Pr(>|z|)      Lower 95%    Upper 95%
────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -9.25183      1.08729    -8.51    <1e-16    -11.3829       -7.12079
category_AUTOMOTIVE                  0.437273     0.628674    0.70    0.4867     -0.794906      1.66945
category_BUSINESS                   -8.3902    4109.32       -0.00    0.9984  -8062.52       8045.74
category_CULTURE                   -12.5314     754.564      -0.02    0.9867  -1491.45       1466.39
category_EDUCATION                   0.585399     0.483092    1.21    0.2256     -0.361444      1.53224
category_ENTERTAINMENT_RECREATION  -11.0772     525.144      -0.02    0.9832  -1040.34       1018.19
category_FACILITIES                  0.0        NaN         NaN       NaN       NaN           NaN
category_FINANCE                   -12.9751     674.931      -0.02    0.9847  -1335.82       1309.87
category_FOOD_DRINK                  0.194107     0.842045    0.23    0.8177     -1.45627       1.84449
category_GOVERNMENT                  0.560347     0.24576     2.28    0.0226      0.0786654     1.04203
category_HEALTH_WELLNESS             0.1716       0.155351    1.10    0.2693     -0.132881      0.476082
category_LODGING                   -10.941      966.921      -0.01    0.9910  -1906.07       1884.19
category_PLACE_OF_WORSHIP          -11.4669    1001.56       -0.01    0.9909  -1974.48       1951.55
category_SERVICES                    0.442948     0.145399    3.05    0.0023      0.157971      0.727924
category_SHOPPING                   -0.363331     1.25834    -0.29    0.7728     -2.82964       2.10298
category_SPORTS                    -10.4988     556.538      -0.02    0.9849  -1101.29       1080.3
category_TRANSPORTATION            -10.4979     587.004      -0.02    0.9857  -1161.0        1140.01
────────────────────────────────────────────────────────────────────────────────────────────────────────
```