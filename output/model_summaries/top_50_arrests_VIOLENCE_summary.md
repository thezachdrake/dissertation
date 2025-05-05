# Model Summary: top_50_arrests_VIOLENCE

## Formula

```
top_50_arrests_VIOLENCE ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `485.4837`
- **Null Deviance:**    `558.7642`
- **Log-Likelihood:**   `-242.7418`
- **AIC:**              `517.4837`
- **BIC:**              `631.6622`
- **McFadden's R²:**    `0.1311`

## Coefficients

```
──────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)    Lower 95%   Upper 95%
──────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -5.90537       0.198311   -29.78    <1e-99   -6.29405     -5.51669
category_AUTOMOTIVE                 0.375432      0.133912     2.80    0.0051    0.112969     0.637895
category_BUSINESS                   1.58662       1.37004      1.16    0.2468   -1.09861      4.27186
category_CULTURE                   -0.00964833    0.390583    -0.02    0.9803   -0.775176     0.75588
category_EDUCATION                  0.249013      0.176931     1.41    0.1593   -0.0977648    0.595792
category_ENTERTAINMENT_RECREATION   0.66101       0.155402     4.25    <1e-04    0.356429     0.965592
category_FACILITIES                 0.0         NaN          NaN       NaN     NaN          NaN
category_FINANCE                    0.44308       0.339039     1.31    0.1913   -0.221424     1.10758
category_FOOD_DRINK                -0.206763      0.158953    -1.30    0.1933   -0.518304     0.104779
category_GOVERNMENT                 0.464725      0.136056     3.42    0.0006    0.19806      0.731391
category_HEALTH_WELLNESS            0.0523136     0.0614995    0.85    0.3950   -0.0682232    0.172851
category_LODGING                   -0.51922       0.666508    -0.78    0.4360   -1.82555      0.787112
category_PLACE_OF_WORSHIP           0.745211      0.25817      2.89    0.0039    0.239207     1.25122
category_SERVICES                   0.178681      0.059183     3.02    0.0025    0.0626848    0.294678
category_SHOPPING                   0.196437      0.0681651    2.88    0.0040    0.0628363    0.330038
category_SPORTS                     0.0503527     0.21732      0.23    0.8168   -0.375587     0.476293
category_TRANSPORTATION            -0.15472       0.371664    -0.42    0.6772   -0.883168     0.573727
──────────────────────────────────────────────────────────────────────────────────────────────────────
```