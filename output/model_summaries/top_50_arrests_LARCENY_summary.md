# Model Summary: top_50_arrests_LARCENY

## Formula

```
top_50_arrests_LARCENY ~ 1 + category_AUTOMOTIVE + category_BUSINESS + category_CULTURE + category_EDUCATION + category_ENTERTAINMENT_RECREATION + category_FACILITIES + category_FINANCE + category_FOOD_DRINK + category_GOVERNMENT + category_HEALTH_WELLNESS + category_LODGING + category_PLACE_OF_WORSHIP + category_SERVICES + category_SHOPPING + category_SPORTS + category_TRANSPORTATION
```

## Model Diagnostics

- **Observations:**     `9285`
- **Deviance:**         `135.4854`
- **Null Deviance:**    `170.2287`
- **Log-Likelihood:**   `-67.7427`
- **AIC:**              `167.4854`
- **BIC:**              `281.6639`
- **McFadden's R²:**    `0.2041`

## Coefficients

```
──────────────────────────────────────────────────────────────────────────────────────────────────────
                                         Coef.  Std. Error       z  Pr(>|z|)    Lower 95%    Upper 95%
──────────────────────────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -7.02178      0.371982  -18.88    <1e-78    -7.75085    -6.2927
category_AUTOMOTIVE                  0.351015     0.499583    0.70    0.4823    -0.628151    1.33018
category_BUSINESS                    1.00127      3.64358     0.27    0.7835    -6.14002     8.14256
category_CULTURE                     0.478058     0.667951    0.72    0.4742    -0.831101    1.78722
category_EDUCATION                   0.149082     0.564303    0.26    0.7916    -0.956931    1.25509
category_ENTERTAINMENT_RECREATION  -10.6137     205.099      -0.05    0.9587  -412.6       391.372
category_FACILITIES                  0.0        NaN         NaN       NaN      NaN         NaN
category_FINANCE                     1.2915       0.774786    1.67    0.0955    -0.227047    2.81006
category_FOOD_DRINK                 -1.60693      0.832929   -1.93    0.0537    -3.23944     0.0255858
category_GOVERNMENT                  0.336415     0.300189    1.12    0.2624    -0.251944    0.924774
category_HEALTH_WELLNESS            -0.255942     0.414219   -0.62    0.5366    -1.0678      0.555913
category_LODGING                   -11.063      393.038      -0.03    0.9775  -781.403     759.277
category_PLACE_OF_WORSHIP          -11.4925     358.977      -0.03    0.9745  -715.075     692.09
category_SERVICES                   -0.265421     0.499097   -0.53    0.5949    -1.24363     0.712791
category_SHOPPING                    0.557318     0.150782    3.70    0.0002     0.26179     0.852845
category_SPORTS                    -10.0878     222.263      -0.05    0.9638  -445.715     425.54
category_TRANSPORTATION             -0.0770359    0.802251   -0.10    0.9235    -1.64942     1.49535
──────────────────────────────────────────────────────────────────────────────────────────────────────
```