# Model Summary: top_50_arrests_BURGLARY

## Formula

```
top_50_arrests_BURGLARY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `86.7501`
- **Null Deviance:**    `114.6582`
- **Log-Likelihood:**   `-43.3750`
- **AIC:**              `118.7501`
- **BIC:**              `232.9286`
- **McFadden's R²:**    `0.2434`

## Coefficients

```
─────────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)      Lower 95%    Upper 95%
─────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -7.74886       0.517364  -14.98    <1e-49     -8.76287      -6.73484
category_AUTOMOTIVE                  0.782864      0.230623    3.39    0.0007      0.330851      1.23488
category_BUSINESS                   -8.82474    2408.59       -0.00    0.9971  -4729.58       4711.93
category_CULTURE                     1.13226       0.595404    1.90    0.0572     -0.0347068     2.29923
category_EDUCATION                   0.469229      0.34262     1.37    0.1708     -0.202293      1.14075
category_ENTERTAINMENT_RECREATION  -11.965       317.783      -0.04    0.9700   -634.808       610.878
category_FACILITIES                  0.0         NaN         NaN       NaN       NaN           NaN
category_FINANCE                   -13.8163      413.014      -0.03    0.9733   -823.309       795.676
category_FOOD_DRINK                 -0.305066      0.866802   -0.35    0.7249     -2.00397       1.39384
category_GOVERNMENT                  0.558897      0.15999     3.49    0.0005      0.245322      0.872472
category_HEALTH_WELLNESS             0.0854448     0.150562    0.57    0.5704     -0.209652      0.380542
category_LODGING                   -11.7628      579.633      -0.02    0.9838  -1147.82       1124.3
category_PLACE_OF_WORSHIP            0.608188      0.549003    1.11    0.2679     -0.467837      1.68421
category_SERVICES                    0.289468      0.115302    2.51    0.0121      0.0634806     0.515455
category_SHOPPING                   -0.314814      0.815868   -0.39    0.6996     -1.91389       1.28426
category_SPORTS                    -11.2869      350.373      -0.03    0.9743   -698.005       675.431
category_TRANSPORTATION            -11.5163      353.096      -0.03    0.9740   -703.573       680.54
─────────────────────────────────────────────────────────────────────────────────────────────────────────
```