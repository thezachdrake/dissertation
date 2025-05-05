# Model Summary: top_50_incidents_DRUGS

## Formula

```
top_50_incidents_DRUGS ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `368.6424`
- **Null Deviance:**    `415.4308`
- **Log-Likelihood:**   `-184.3212`
- **AIC:**              `400.6424`
- **BIC:**              `514.8209`
- **McFadden's R²:**    `0.1126`

## Coefficients

```
─────────────────────────────────────────────────────────────────────────────────────────────────────
                                        Coef.   Std. Error       z  Pr(>|z|)    Lower 95%   Upper 95%
─────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -6.1275       0.225835   -27.13    <1e-99   -6.57012     -5.68487
category_AUTOMOTIVE                -0.640043     0.440555    -1.45    0.1463   -1.50352      0.223429
category_BUSINESS                   3.31296      1.27437      2.60    0.0093    0.81524      5.81069
category_CULTURE                   -1.41951      1.06294     -1.34    0.1817   -3.50283      0.663811
category_EDUCATION                 -0.576845     0.628546    -0.92    0.3588   -1.80877      0.655083
category_ENTERTAINMENT_RECREATION   0.60493      0.213054     2.84    0.0045    0.187351     1.02251
category_FACILITIES                 0.0        NaN          NaN       NaN     NaN          NaN
category_FINANCE                    0.691681     0.343015     2.02    0.0438    0.0193833    1.36398
category_FOOD_DRINK                 0.0253331    0.0872379    0.29    0.7715   -0.14565      0.196316
category_GOVERNMENT                 0.355478     0.191016     1.86    0.0627   -0.0189069    0.729862
category_HEALTH_WELLNESS           -0.0179635    0.114883    -0.16    0.8757   -0.24313      0.207203
category_LODGING                    0.092815     0.676831     0.14    0.8909   -1.23375      1.41938
category_PLACE_OF_WORSHIP           0.845245     0.347591     2.43    0.0150    0.163978     1.52651
category_SERVICES                   0.120543     0.0778968    1.55    0.1217   -0.0321316    0.273218
category_SHOPPING                   0.270277     0.0754075    3.58    0.0003    0.122481     0.418073
category_SPORTS                    -0.0523499    0.424001    -0.12    0.9017   -0.883377     0.778677
category_TRANSPORTATION             0.661767     0.281587     2.35    0.0188    0.109867     1.21367
─────────────────────────────────────────────────────────────────────────────────────────────────────
```