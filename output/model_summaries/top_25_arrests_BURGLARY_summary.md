# Model Summary: top_25_arrests_BURGLARY

## Formula

```
top_25_arrests_BURGLARY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `56.8125`
- **Null Deviance:**    `69.9972`
- **Log-Likelihood:**   `-28.4062`
- **AIC:**              `88.8125`
- **BIC:**              `202.9910`
- **McFadden's R²:**    `0.1884`

## Coefficients

```
────────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)     Lower 95%    Upper 95%
────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -8.18052       0.650745  -12.57    <1e-35     -9.45596     -6.90508
category_AUTOMOTIVE                  0.458032      0.466501    0.98    0.3262     -0.456293     1.37236
category_BUSINESS                   -8.47152    2504.94       -0.00    0.9973  -4918.07      4901.13
category_CULTURE                   -12.0819      450.817      -0.03    0.9786   -895.668      871.504
category_EDUCATION                   0.361094      0.615979    0.59    0.5577     -0.846203     1.56839
category_ENTERTAINMENT_RECREATION  -10.4944      328.813      -0.03    0.9745   -654.956      633.967
category_FACILITIES                  0.0         NaN         NaN       NaN       NaN          NaN
category_FINANCE                   -12.6977      419.721      -0.03    0.9759   -835.335      809.94
category_FOOD_DRINK                  0.0720029     0.727935    0.10    0.9212     -1.35472      1.49873
category_GOVERNMENT                  0.518919      0.198991    2.61    0.0091      0.128905     0.908933
category_HEALTH_WELLNESS             0.133398      0.135474    0.98    0.3248     -0.132126     0.398923
category_LODGING                   -10.4536      594.612      -0.02    0.9860  -1175.87      1154.96
category_PLACE_OF_WORSHIP            0.848575      0.552934    1.53    0.1249     -0.235156     1.93231
category_SERVICES                    0.407335      0.126998    3.21    0.0013      0.158423     0.656247
category_SHOPPING                   -0.637732      1.24068    -0.51    0.6072     -3.06942      1.79396
category_SPORTS                    -10.6047      360.11       -0.03    0.9765   -716.407      695.197
category_TRANSPORTATION            -10.4405      368.897      -0.03    0.9774   -733.466      712.585
────────────────────────────────────────────────────────────────────────────────────────────────────────
```