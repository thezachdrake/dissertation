# Model Summary: top_jenks_manual_arrests_DRUGS

## Formula

```
top_jenks_manual_arrests_DRUGS ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `0.0000`
- **Null Deviance:**    `20.2722`
- **Log-Likelihood:**   `-0.0000`
- **AIC:**              `32.0000`
- **BIC:**              `146.1785`
- **McFadden's R²:**    `1.0000`

## Coefficients

```
───────────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.  Std. Error       z  Pr(>|z|)       Lower 95%      Upper 95%
───────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -130.562       12102.9    -0.01    0.9914  -23851.7        23590.6
category_AUTOMOTIVE                  13.1392       1671.16    0.01    0.9937   -3262.27        3288.55
category_BUSINESS                    -6.08551     58243.6    -0.00    0.9999      -1.14161e5      1.14149e5
category_CULTURE                     12.0544      12531.6     0.00    0.9992  -24549.5        24573.6
category_EDUCATION                  -48.0692      12159.4    -0.00    0.9968  -23880.1        23784.0
category_ENTERTAINMENT_RECREATION   -24.1329      16218.3    -0.00    0.9988  -31811.4        31763.1
category_FACILITIES                   0.0           NaN     NaN       NaN        NaN            NaN
category_FINANCE                     36.2526       4225.85    0.01    0.9932   -8246.26        8318.76
category_FOOD_DRINK                  15.3513       1714.38    0.01    0.9929   -3344.76        3375.47
category_GOVERNMENT                   8.51944      1318.94    0.01    0.9948   -2576.55        2593.59
category_HEALTH_WELLNESS            -84.3419      10083.5    -0.01    0.9933  -19847.7        19679.0
category_LODGING                    -16.4695      14454.6    -0.00    0.9991  -28347.0        28314.1
category_PLACE_OF_WORSHIP           -39.8823      54758.2    -0.00    0.9994      -1.07364e5      1.07284e5
category_SERVICES                     5.12142       824.45    0.01    0.9950   -1610.77        1621.01
category_SHOPPING                   -72.6184      12872.6    -0.01    0.9955  -25302.5        25157.2
category_SPORTS                       4.58123      3075.1     0.00    0.9988   -6022.49        6031.66
category_TRANSPORTATION              -0.521316    15513.0    -0.00    1.0000  -30405.5        30404.4
───────────────────────────────────────────────────────────────────────────────────────────────────────────
```