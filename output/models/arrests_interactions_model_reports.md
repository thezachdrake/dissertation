# Model Results for ARRESTS_INTERACTIONS

Generated: 2025-12-09 15:41:31

---

## Model: high_burglary_jenks

### Formula
```
high_burglary_jenks ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -8.434041     0.578959   -14.5676          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.623158    55.445831     0.0293     0.976646 
interact_SHOPPING_x_AUTOMOTIVE     -1.07932    60.338834    -0.0179     0.985728 
interact_SHOPPING_x_SERVICES      -0.624963    93.770774    -0.0067     0.994682 
interact_SHOPPING_x_FOOD_DRINK    -1.337967    62.133619    -0.0215      0.98282 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.364031    31.913755    -0.0427     0.965908 
interact_SHOPPING_x_HEALTH_WELLNESS     3.930587    80.149406      0.049     0.960887 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.781724    92.061225    -0.0302     0.975895 
interact_AUTOMOTIVE_x_SERVICES     0.133855     84.13223     0.0016     0.998731 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.186246     47.13767      0.004     0.996847 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.119298    62.640028    -0.0179     0.985744 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.645448    82.911559     0.0319     0.974546 
interact_SERVICES_x_FOOD_DRINK    -0.094995    54.671242    -0.0017     0.998614 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.922259    41.975195      0.022     0.982471 
interact_HEALTH_WELLNESS_x_FINANCE    -2.413123    53.559456    -0.0451     0.964063 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.568609    23.289773    -0.0244     0.980522 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.803401    31.730885     0.0253       0.9798 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 56.6529
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_burglary_top25

### Formula
```
high_burglary_top25 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -8.145209     0.502369   -16.2136          0.0 ***
interact_SHOPPING_x_TRANSPORTATION      1.75151    74.926065     0.0234      0.98135 
interact_SHOPPING_x_AUTOMOTIVE    -1.064055    68.371396    -0.0156     0.987583 
interact_SHOPPING_x_SERVICES      -0.161877   106.781733    -0.0015      0.99879 
interact_SHOPPING_x_FOOD_DRINK    -2.814827    91.868452    -0.0306     0.975557 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.756629    37.207559    -0.0472     0.962345 
interact_SHOPPING_x_HEALTH_WELLNESS     5.779869    94.341415     0.0613     0.951148 
interact_SHOPPING_x_PLACE_OF_WORSHIP     -3.67353   102.142359     -0.036      0.97131 
interact_AUTOMOTIVE_x_SERVICES     0.053078     97.21001     0.0005     0.999564 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.511481    55.533033     0.0092     0.992651 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.993853    68.149523    -0.0293      0.97666 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.419267    92.169332     0.0371     0.970407 
interact_SERVICES_x_FOOD_DRINK    -0.092378     64.56906    -0.0014     0.998858 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.297687    47.142033     0.0275     0.978039 
interact_HEALTH_WELLNESS_x_FINANCE    -3.327018    61.770904    -0.0539     0.957046 
interact_PLACE_OF_WORSHIP_x_EDUCATION     -0.72095    30.371437    -0.0237     0.981062 
interact_PLACE_OF_WORSHIP_x_FINANCE     1.119752    36.541512     0.0306     0.975554 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 73.2354
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_burglary_top50

### Formula
```
high_burglary_top50 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.823277     0.259227   -26.3216          0.0 ***
interact_SHOPPING_x_TRANSPORTATION      1.75803    30.659387     0.0573     0.954274 
interact_SHOPPING_x_AUTOMOTIVE    -1.120837     30.63286    -0.0366     0.970812 
interact_SHOPPING_x_SERVICES      -0.472148    49.507746    -0.0095     0.992391 
interact_SHOPPING_x_FOOD_DRINK     -1.83884    36.036611     -0.051     0.959304 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.553476    16.561467    -0.0938     0.925268 
interact_SHOPPING_x_HEALTH_WELLNESS     4.675207    41.990456     0.1113     0.911347 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.261113    48.402043    -0.0674     0.946283 
interact_AUTOMOTIVE_x_SERVICES     0.068117    42.869083     0.0016     0.998732 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.247505    24.300556     0.0102     0.991874 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.405433    31.509087    -0.0446     0.964423 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.071128    42.639185      0.072     0.942581 
interact_SERVICES_x_FOOD_DRINK    -0.089074    29.003806    -0.0031      0.99755 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.071256    21.267276     0.0504     0.959827 
interact_HEALTH_WELLNESS_x_FINANCE    -2.824565    28.347161    -0.0996     0.920629 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.630441    12.794079    -0.0493     0.960699 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.946304    16.895445      0.056     0.955334 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 234.9683
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_drugs_jenks

### Formula
```
high_drugs_jenks ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.046971     0.289622   -24.3316          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.618579    30.254278     0.0535     0.957334 
interact_SHOPPING_x_AUTOMOTIVE    -1.022397    31.742704    -0.0322     0.974305 
interact_SHOPPING_x_SERVICES      -0.441812     51.68211    -0.0085     0.993179 
interact_SHOPPING_x_FOOD_DRINK    -1.518673    35.243795    -0.0431     0.965629 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.389015    16.206217    -0.0857     0.931698 
interact_SHOPPING_x_HEALTH_WELLNESS      4.05538    42.068651     0.0964     0.923204 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.845302    50.422904    -0.0564        0.955 
interact_AUTOMOTIVE_x_SERVICES     0.125112    43.965971     0.0028     0.997729 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.186393    24.640918     0.0076     0.993965 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.194939    33.371802    -0.0358     0.971436 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.653082     44.49927     0.0596     0.952458 
interact_SERVICES_x_FOOD_DRINK    -0.140236     29.08734    -0.0048     0.996153 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.931874    22.390285     0.0416     0.966802 
interact_HEALTH_WELLNESS_x_FINANCE    -2.484679    28.332856    -0.0877     0.930118 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.572924    12.735229     -0.045     0.964117 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.817219    17.213868     0.0475     0.962135 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 193.3327
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_drugs_top25

### Formula
```
high_drugs_top25 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.758543     0.251064   -26.9196          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.797287    30.756854     0.0584     0.953402 
interact_SHOPPING_x_AUTOMOTIVE    -1.152442    30.429564    -0.0379     0.969789 
interact_SHOPPING_x_SERVICES      -0.479881    48.593035    -0.0099     0.992121 
interact_SHOPPING_x_FOOD_DRINK    -1.978362    36.479995    -0.0542     0.956751 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.612621    16.815146    -0.0959     0.923598 
interact_SHOPPING_x_HEALTH_WELLNESS     4.901945    41.953226     0.1168     0.906984 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.386621    47.048356     -0.072     0.942616 
interact_AUTOMOTIVE_x_SERVICES      0.05262    42.620699     0.0012     0.999015 
interact_AUTOMOTIVE_x_FOOD_DRINK      0.28108     24.36012     0.0115     0.990794 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.487649    30.862358    -0.0482     0.961555 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.207269    41.843053     0.0766     0.938902 
interact_SERVICES_x_FOOD_DRINK    -0.066256    29.039823    -0.0023      0.99818 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.118214     20.87746     0.0536     0.957285 
interact_HEALTH_WELLNESS_x_FINANCE    -2.940989    28.299183    -0.1039     0.917229 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.652109    12.796071     -0.051     0.959356 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.989239    16.648285     0.0594     0.952618 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 248.5665
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_drugs_top50

### Formula
```
high_drugs_top50 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.026394     0.106056   -47.3938          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.626365    11.138643      0.146     0.883913 
interact_SHOPPING_x_AUTOMOTIVE    -1.029604    11.639341    -0.0885     0.929512 
interact_SHOPPING_x_SERVICES      -0.439734    19.013014    -0.0231     0.981548 
interact_SHOPPING_x_FOOD_DRINK    -1.530653    12.962701    -0.1181     0.906003 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.398127     5.951023    -0.2349     0.814256 
interact_SHOPPING_x_HEALTH_WELLNESS      4.08725     15.46671     0.2643     0.791579 
interact_SHOPPING_x_PLACE_OF_WORSHIP     -2.87045    18.571826    -0.1546     0.877169 
interact_AUTOMOTIVE_x_SERVICES     0.124033    16.132265     0.0077     0.993866 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.186256     9.044173     0.0206      0.98357 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.206036    12.258606    -0.0984     0.921628 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.677314     16.34429     0.1638     0.869883 
interact_SERVICES_x_FOOD_DRINK    -0.140075    10.685995    -0.0131     0.989541 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.937668     8.206586     0.1143     0.909033 
interact_HEALTH_WELLNESS_x_FINANCE    -2.502492    10.412109    -0.2403     0.810063 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.575922     4.681914     -0.123     0.902099 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.823965     6.331317     0.1301     0.896455 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 1086.8069
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_larceny_jenks

### Formula
```
high_larceny_jenks ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.946496     0.167393   -35.5241          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.666678    18.408148     0.0905     0.927858 
interact_SHOPPING_x_AUTOMOTIVE    -1.072114    18.983594    -0.0565     0.954963 
interact_SHOPPING_x_SERVICES      -0.439669    30.816898    -0.0143     0.988617 
interact_SHOPPING_x_FOOD_DRINK    -1.631497    21.467157     -0.076     0.939419 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.447925     9.840514    -0.1471     0.883022 
interact_SHOPPING_x_HEALTH_WELLNESS     4.285629    25.382575     0.1688     0.865921 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.008351    30.137334    -0.0998     0.920486 
interact_AUTOMOTIVE_x_SERVICES     0.094793    26.347377     0.0036     0.997129 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.207965    14.779347     0.0141     0.988773 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.269915    19.729189    -0.0644     0.948678 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.824367    26.625367     0.1061      0.91552 
interact_SERVICES_x_FOOD_DRINK    -0.124285    17.556876    -0.0071     0.994352 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.978995    13.240935     0.0739     0.941061 
interact_HEALTH_WELLNESS_x_FINANCE    -2.608798    17.099862    -0.1526     0.878743 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.594079       7.7256    -0.0769     0.938705 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.863909    10.339135     0.0836     0.933408 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 500.8358
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_larceny_top25

### Formula
```
high_larceny_top25 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.334822     0.334413   -21.9334          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.649598    34.483672     0.0478     0.961846 
interact_SHOPPING_x_AUTOMOTIVE    -1.031413    36.620261    -0.0282      0.97753 
interact_SHOPPING_x_SERVICES      -0.523997    57.261755    -0.0092     0.992699 
interact_SHOPPING_x_FOOD_DRINK    -1.578723    40.775216    -0.0387     0.969115 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.429628    19.350069    -0.0739     0.941104 
interact_SHOPPING_x_HEALTH_WELLNESS     4.174268    48.441828     0.0862     0.931331 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.867293    54.987965    -0.0521     0.958414 
interact_AUTOMOTIVE_x_SERVICES     0.154181    51.279112      0.003     0.997601 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.209814     28.70901     0.0073     0.994169 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.250268    37.751643    -0.0331      0.97358 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.689787    50.173824     0.0536     0.957246 
interact_SERVICES_x_FOOD_DRINK    -0.104763    33.327998    -0.0031     0.997492 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.966789    25.951312     0.0373     0.970283 
interact_HEALTH_WELLNESS_x_FINANCE    -2.538887    32.566602     -0.078      0.93786 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.591229    14.714635    -0.0402      0.96795 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.836419    19.279916     0.0434     0.965396 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 150.1797
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_larceny_top50

### Formula
```
high_larceny_top50 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.033837     0.174784   -34.5216          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.623227    18.352887     0.0884     0.929523 
interact_SHOPPING_x_AUTOMOTIVE    -1.028628    19.216087    -0.0535      0.95731 
interact_SHOPPING_x_SERVICES      -0.439763    31.303157     -0.014     0.988791 
interact_SHOPPING_x_FOOD_DRINK    -1.529288     21.37474    -0.0715     0.942963 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.395022     9.820448    -0.1421     0.887038 
interact_SHOPPING_x_HEALTH_WELLNESS      4.07892    25.493742       0.16     0.872884 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.862985    30.558625    -0.0937     0.925357 
interact_AUTOMOTIVE_x_SERVICES     0.121787    26.621638     0.0046      0.99635 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.188045     14.91782     0.0126     0.989943 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.202532    20.190176    -0.0596     0.952506 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.671893    26.960282     0.0991     0.921055 
interact_SERVICES_x_FOOD_DRINK    -0.139276     17.62481    -0.0079     0.993695 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.936043     13.53681     0.0691     0.944872 
interact_HEALTH_WELLNESS_x_FINANCE    -2.497232    17.166037    -0.1455     0.884336 
interact_PLACE_OF_WORSHIP_x_EDUCATION     -0.57505     7.721983    -0.0745     0.940637 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.821921     10.42931     0.0788     0.937185 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 464.8494
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_violence_jenks

### Formula
```
high_violence_jenks ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.758543     0.251064   -26.9196          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.797287    30.756854     0.0584     0.953402 
interact_SHOPPING_x_AUTOMOTIVE    -1.152442    30.429564    -0.0379     0.969789 
interact_SHOPPING_x_SERVICES      -0.479881    48.593035    -0.0099     0.992121 
interact_SHOPPING_x_FOOD_DRINK    -1.978362    36.479995    -0.0542     0.956751 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.612621    16.815146    -0.0959     0.923598 
interact_SHOPPING_x_HEALTH_WELLNESS     4.901945    41.953226     0.1168     0.906984 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.386621    47.048356     -0.072     0.942616 
interact_AUTOMOTIVE_x_SERVICES      0.05262    42.620699     0.0012     0.999015 
interact_AUTOMOTIVE_x_FOOD_DRINK      0.28108     24.36012     0.0115     0.990794 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.487649    30.862358    -0.0482     0.961555 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.207269    41.843053     0.0766     0.938902 
interact_SERVICES_x_FOOD_DRINK    -0.066256    29.039823    -0.0023      0.99818 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.118214     20.87746     0.0536     0.957285 
interact_HEALTH_WELLNESS_x_FINANCE    -2.940989    28.299183    -0.1039     0.917229 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.652109    12.796071     -0.051     0.959356 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.989239    16.648285     0.0594     0.952618 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 248.5665
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_violence_top25

### Formula
```
high_violence_top25 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.046971     0.289622   -24.3316          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.618579    30.254278     0.0535     0.957334 
interact_SHOPPING_x_AUTOMOTIVE    -1.022397    31.742704    -0.0322     0.974305 
interact_SHOPPING_x_SERVICES      -0.441812     51.68211    -0.0085     0.993179 
interact_SHOPPING_x_FOOD_DRINK    -1.518673    35.243795    -0.0431     0.965629 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.389015    16.206217    -0.0857     0.931698 
interact_SHOPPING_x_HEALTH_WELLNESS      4.05538    42.068651     0.0964     0.923204 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.845302    50.422904    -0.0564        0.955 
interact_AUTOMOTIVE_x_SERVICES     0.125112    43.965971     0.0028     0.997729 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.186393    24.640918     0.0076     0.993965 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.194939    33.371802    -0.0358     0.971436 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.653082     44.49927     0.0596     0.952458 
interact_SERVICES_x_FOOD_DRINK    -0.140236     29.08734    -0.0048     0.996153 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.931874    22.390285     0.0416     0.966802 
interact_HEALTH_WELLNESS_x_FINANCE    -2.484679    28.332856    -0.0877     0.930118 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.572924    12.735229     -0.045     0.964117 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.817219    17.213868     0.0475     0.962135 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 193.3327
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

## Model: high_violence_top50

### Formula
```
high_violence_top50 ~ 1 + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -4.744519     0.092404   -51.3455          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.803175    11.307073     0.1595     0.873296 
interact_SHOPPING_x_AUTOMOTIVE    -1.154757    11.172229    -0.1034     0.917678 
interact_SHOPPING_x_SERVICES      -0.480087    17.866295    -0.0269     0.978563 
interact_SHOPPING_x_FOOD_DRINK    -1.985373    13.416032     -0.148     0.882355 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.617973     6.172889    -0.2621     0.793237 
interact_SHOPPING_x_HEALTH_WELLNESS      4.91993    15.433926     0.3188     0.749898 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.398949    17.325461    -0.1962     0.844467 
interact_AUTOMOTIVE_x_SERVICES     0.055244    15.667014     0.0035     0.997187 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.279478     8.951836     0.0312     0.975094 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.495191    11.360572    -0.1316     0.895291 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.217389    15.383038     0.2092      0.83433 
interact_SERVICES_x_FOOD_DRINK    -0.067068    10.665516    -0.0063     0.994983 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.121575     7.683662      0.146     0.883946 
interact_HEALTH_WELLNESS_x_FINANCE    -2.950944     10.40304    -0.2837      0.77667 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.653666      4.70679    -0.1389     0.889547 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.992899     6.123183     0.1622     0.871185 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 1370.2744
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

