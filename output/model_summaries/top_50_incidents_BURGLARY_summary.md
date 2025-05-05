# Model Summary: top_50_incidents_BURGLARY

## Formula

```
top_50_incidents_BURGLARY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `625.0691`
- **Null Deviance:**    `694.2632`
- **Log-Likelihood:**   `-312.5345`
- **AIC:**              `657.0691`
- **BIC:**              `771.2476`
- **McFadden's R²:**    `0.0997`

## Coefficients

```
────────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.   Std. Error       z  Pr(>|z|)      Lower 95%   Upper 95%
────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -5.52606      0.165385   -33.41    <1e-99    -5.8502       -5.20191
category_AUTOMOTIVE                  0.193233     0.15938      1.21    0.2254    -0.119147      0.505612
category_BUSINESS                  -10.4087     264.081       -0.04    0.9686  -527.999       507.181
category_CULTURE                     0.19395      0.261069     0.74    0.4575    -0.317737      0.705636
category_EDUCATION                   0.343158     0.14673      2.34    0.0194     0.0555723     0.630743
category_ENTERTAINMENT_RECREATION    0.165762     0.238911     0.69    0.4878    -0.302495      0.634019
category_FACILITIES                  0.0        NaN          NaN       NaN      NaN           NaN
category_FINANCE                     0.217935     0.32364      0.67    0.5007    -0.416387      0.852256
category_FOOD_DRINK                  0.137202     0.0612007    2.24    0.0250     0.0172508     0.257153
category_GOVERNMENT                 -9.55081     68.4332      -0.14    0.8890  -143.677       124.576
category_HEALTH_WELLNESS             0.0745389    0.0498003    1.50    0.1345    -0.023068      0.172146
category_LODGING                     0.448621     0.379635     1.18    0.2373    -0.295451      1.19269
category_PLACE_OF_WORSHIP            0.164381     0.452604     0.36    0.7165    -0.722707      1.05147
category_SERVICES                    0.129642     0.061147     2.12    0.0340     0.00979568    0.249488
category_SHOPPING                    0.17201      0.058389     2.95    0.0032     0.0575697     0.28645
category_SPORTS                     -0.0870683    0.309825    -0.28    0.7787    -0.694315      0.520178
category_TRANSPORTATION              0.143599     0.261132     0.55    0.5824    -0.368211      0.655409
────────────────────────────────────────────────────────────────────────────────────────────────────────
```