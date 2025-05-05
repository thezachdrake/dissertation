# Model Summary: top_25_arrests_VIOLENCE

## Formula

```
top_25_arrests_VIOLENCE ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `73.7736`
- **Null Deviance:**    `100.1289`
- **Log-Likelihood:**   `-36.8868`
- **AIC:**              `105.7736`
- **BIC:**              `219.9521`
- **McFadden's R²:**    `0.2632`

## Coefficients

```
─────────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)      Lower 95%    Upper 95%
─────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -8.13099       0.598219  -13.59    <1e-41     -9.30348      -6.95851
category_AUTOMOTIVE                  0.831884      0.234659    3.55    0.0004      0.37196       1.29181
category_BUSINESS                   -8.21598    1461.12       -0.01    0.9955  -2871.96       2855.53
category_CULTURE                     0.587126      0.534787    1.10    0.2723     -0.461036      1.63529
category_EDUCATION                   0.454637      0.379335    1.20    0.2307     -0.288846      1.19812
category_ENTERTAINMENT_RECREATION    0.541932      0.375263    1.44    0.1487     -0.19357       1.27743
category_FACILITIES                  0.0         NaN         NaN       NaN       NaN           NaN
category_FINANCE                   -12.8308      255.107      -0.05    0.9599   -512.832       487.171
category_FOOD_DRINK                 -0.643725      0.874215   -0.74    0.4615     -2.35716       1.0697
category_GOVERNMENT                  0.52259       0.18207     2.87    0.0041      0.165739      0.879441
category_HEALTH_WELLNESS            -0.317286      0.476592   -0.67    0.5056     -1.25139       0.616817
category_LODGING                     1.26388       1.17548     1.08    0.2823     -1.04002       3.56778
category_PLACE_OF_WORSHIP            0.792382      0.391426    2.02    0.0429      0.0252017     1.55956
category_SERVICES                    0.165923      0.206484    0.80    0.4217     -0.238779      0.570624
category_SHOPPING                    0.22656       0.254547    0.89    0.3734     -0.272343      0.725462
category_SPORTS                     -0.0221738     0.589235   -0.04    0.9700     -1.17705       1.13271
category_TRANSPORTATION            -10.7772      213.361      -0.05    0.9597   -428.957       407.402
─────────────────────────────────────────────────────────────────────────────────────────────────────────
```