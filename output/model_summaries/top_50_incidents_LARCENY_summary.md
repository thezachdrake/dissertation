# Model Summary: top_50_incidents_LARCENY

## Formula

```
top_50_incidents_LARCENY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `459.2530`
- **Null Deviance:**    `590.6464`
- **Log-Likelihood:**   `-229.6265`
- **AIC:**              `491.2530`
- **BIC:**              `605.4315`
- **McFadden's R²:**    `0.2225`

## Coefficients

```
────────────────────────────────────────────────────────────────────────────────────────────────────────
                                          Coef.   Std. Error       z  Pr(>|z|)     Lower 95%   Upper 95%
────────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -6.05906       0.212743   -28.48    <1e-99    -6.47602     -5.64209
category_AUTOMOTIVE                  0.0254701     0.19578      0.13    0.8965    -0.358252     0.409192
category_BUSINESS                    1.00527       1.35431      0.74    0.4579    -1.64913      3.65968
category_CULTURE                     0.0543027     0.309063     0.18    0.8605    -0.55145      0.660055
category_EDUCATION                   0.0496611     0.32483      0.15    0.8785    -0.586995     0.686317
category_ENTERTAINMENT_RECREATION    0.505711      0.227585     2.22    0.0263     0.0596521    0.95177
category_FACILITIES                  0.0         NaN          NaN       NaN      NaN          NaN
category_FINANCE                     0.955294      0.218279     4.38    <1e-04     0.527474     1.38311
category_FOOD_DRINK                  0.00164125    0.0724847    0.02    0.9819    -0.140426     0.143709
category_GOVERNMENT                  0.234223      0.279022     0.84    0.4012    -0.31265      0.781096
category_HEALTH_WELLNESS             0.144214      0.0390944    3.69    0.0002     0.0675905    0.220838
category_LODGING                    -0.124573      0.537899    -0.23    0.8169    -1.17884      0.92969
category_PLACE_OF_WORSHIP            0.229975      0.502912     0.46    0.6475    -0.755713     1.21566
category_SERVICES                    0.16148       0.053391     3.02    0.0025     0.0568351    0.266124
category_SHOPPING                    0.298035      0.060935     4.89    <1e-05     0.178605     0.417465
category_SPORTS                    -11.5389       81.7237      -0.14    0.8877  -171.714      148.636
category_TRANSPORTATION              0.544076      0.227133     2.40    0.0166     0.0989022    0.989249
────────────────────────────────────────────────────────────────────────────────────────────────────────
```