# Model Summary: top_50_arrests_DRUGS

## Formula

```
top_50_arrests_DRUGS ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `405.0507`
- **Null Deviance:**    `460.5244`
- **Log-Likelihood:**   `-202.5253`
- **AIC:**              `437.0507`
- **BIC:**              `551.2292`
- **McFadden's R²:**    `0.1205`

## Coefficients

```
───────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)     Lower 95%   Upper 95%
───────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -5.99107       0.211426   -28.34    <1e-99   -6.40546      -5.57669
category_AUTOMOTIVE                -0.346025      0.363195    -0.95    0.3407   -1.05787       0.365824
category_BUSINESS                   2.92636       1.2954       2.26    0.0239    0.387417      5.46529
category_CULTURE                   -1.64143       1.12886     -1.45    0.1459   -3.85395       0.571096
category_EDUCATION                 -0.311123      0.539737    -0.58    0.5643   -1.36899       0.746743
category_ENTERTAINMENT_RECREATION   0.41056       0.265821     1.54    0.1225   -0.110439      0.93156
category_FACILITIES                 0.0         NaN          NaN       NaN     NaN           NaN
category_FINANCE                    0.89217       0.302229     2.95    0.0032    0.299813      1.48453
category_FOOD_DRINK                 0.00420403    0.0875008    0.05    0.9617   -0.167294      0.175702
category_GOVERNMENT                 0.330024      0.201479     1.64    0.1014   -0.0648683     0.724916
category_HEALTH_WELLNESS           -0.184195      0.192857    -0.96    0.3395   -0.562188      0.193798
category_LODGING                   -0.0703171     0.688615    -0.10    0.9187   -1.41998       1.27934
category_PLACE_OF_WORSHIP           0.760128      0.335559     2.27    0.0235    0.102444      1.41781
category_SERVICES                   0.135014      0.0706953    1.91    0.0562   -0.00354635    0.273574
category_SHOPPING                   0.30939       0.0696369    4.44    <1e-05    0.172905      0.445876
category_SPORTS                    -0.0326061     0.420363    -0.08    0.9382   -0.856502      0.79129
category_TRANSPORTATION             0.540607      0.284079     1.90    0.0570   -0.0161771     1.09739
───────────────────────────────────────────────────────────────────────────────────────────────────────
```