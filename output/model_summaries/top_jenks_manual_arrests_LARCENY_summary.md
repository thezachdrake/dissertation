# Model Summary: top_jenks_manual_arrests_LARCENY

## Formula

```
top_jenks_manual_arrests_LARCENY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
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
───────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.  Std. Error       z  Pr(>|z|)   Lower 95%  Upper 95%
───────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -39.0291       3159.45    -0.01    0.9901   -6231.44    6153.39
category_AUTOMOTIVE                  3.4698        908.369    0.00    0.9970   -1776.9     1783.84
category_BUSINESS                   20.3798       5885.75     0.00    0.9972  -11515.5    11556.2
category_CULTURE                     4.44947      3041.3      0.00    0.9988   -5956.4     5965.29
category_EDUCATION                  -4.769        5871.26    -0.00    0.9994  -11512.2    11502.7
category_ENTERTAINMENT_RECREATION    0.0169868    3405.16     0.00    1.0000   -6673.97    6674.01
category_FACILITIES                  0.0           NaN      NaN       NaN        NaN        NaN
category_FINANCE                     0.350258     5389.05     0.00    0.9999  -10562.0    10562.7
category_FOOD_DRINK                 -3.52829      3510.12    -0.00    0.9992   -6883.24    6876.19
category_GOVERNMENT                  1.62318       393.122    0.00    0.9967    -768.883    772.129
category_HEALTH_WELLNESS            -0.0449239    1649.1     -0.00    1.0000   -3232.23    3232.14
category_LODGING                    -1.78819     15239.8     -0.00    0.9999  -29871.2    29867.6
category_PLACE_OF_WORSHIP            2.45758      7434.96     0.00    0.9997  -14569.8    14574.7
category_SERVICES                   -3.34254      5616.0     -0.00    0.9995  -11010.5    11003.8
category_SHOPPING                    1.68789       493.843    0.00    0.9973    -966.226    969.601
category_SPORTS                      0.467871     1994.34     0.00    0.9998   -3908.36    3909.29
category_TRANSPORTATION            -13.8829       9200.93    -0.00    0.9988  -18047.4    18019.6
───────────────────────────────────────────────────────────────────────────────────────────────────
```