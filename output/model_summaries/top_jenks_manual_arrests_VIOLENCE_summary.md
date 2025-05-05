# Model Summary: top_jenks_manual_arrests_VIOLENCE

## Formula

```
top_jenks_manual_arrests_VIOLENCE ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `37.1506`
- **Null Deviance:**    `54.2243`
- **Log-Likelihood:**   `-18.5753`
- **AIC:**              `69.1506`
- **BIC:**              `183.3291`
- **McFadden's R²:**    `0.3149`

## Coefficients

```
───────────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)       Lower 95%     Upper 95%
───────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -8.80273       0.849217  -10.37    <1e-24     -10.4672        -7.1383
category_AUTOMOTIVE                  0.430841      0.596132    0.72    0.4698      -0.737556       1.59924
category_BUSINESS                   -9.58257    5958.96       -0.00    0.9987  -11688.9        11669.8
category_CULTURE                   -12.9943     1168.13       -0.01    0.9911   -2302.49        2276.5
category_EDUCATION                   0.368408      0.84919     0.43    0.6644      -1.29597        2.03279
category_ENTERTAINMENT_RECREATION    0.680467      0.474364    1.43    0.1514      -0.24927        1.6102
category_FACILITIES                  0.0         NaN         NaN       NaN        NaN            NaN
category_FINANCE                   -16.2281     1035.0        -0.02    0.9875   -2044.79        2012.34
category_FOOD_DRINK                -12.7815      345.659      -0.04    0.9705    -690.261        664.698
category_GOVERNMENT                  0.476383      0.308861    1.54    0.1230      -0.128973       1.08174
category_HEALTH_WELLNESS            -0.29497       0.991655   -0.30    0.7661      -2.23858        1.64864
category_LODGING                     2.2208        1.59843     1.39    0.1647      -0.91207        5.35367
category_PLACE_OF_WORSHIP            0.939688      0.455315    2.06    0.0390       0.0472863      1.83209
category_SERVICES                    0.194396      0.206785    0.94    0.3472      -0.210896       0.599688
category_SHOPPING                    0.536619      0.392174    1.37    0.1712      -0.232028       1.30527
category_SPORTS                      0.0958207     0.913106    0.10    0.9164      -1.69383        1.88548
category_TRANSPORTATION            -12.8958      924.058      -0.01    0.9889   -1824.02        1798.22
───────────────────────────────────────────────────────────────────────────────────────────────────────────
```