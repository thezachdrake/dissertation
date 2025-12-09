# Model Results for INCIDENTS_INTERACTIONS

Generated: 2025-12-09 15:40:34

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
(Intercept)                       -7.699309     0.929716    -8.2814          0.0 ***
interact_SHOPPING_x_TRANSPORTATION    30.484673   728.171539     0.0419     0.966607 
interact_SHOPPING_x_AUTOMOTIVE    -1.083645   306.414941    -0.0035     0.997178 
interact_SHOPPING_x_SERVICES     -30.046873  1237.229118    -0.0243     0.980625 
interact_SHOPPING_x_FOOD_DRINK   -52.992707  1914.941371    -0.0277     0.977923 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION      -1.4984   439.796011    -0.0034     0.997282 
interact_SHOPPING_x_HEALTH_WELLNESS    70.314499  1493.891975     0.0471     0.962459 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -5.820376   486.994033     -0.012     0.990464 
interact_AUTOMOTIVE_x_SERVICES   -18.107886   414.267176    -0.0437     0.965135 
interact_AUTOMOTIVE_x_FOOD_DRINK    19.365809   740.965471     0.0261     0.979149 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -37.296263   1053.72948    -0.0354     0.971765 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     18.62069   512.803996     0.0363     0.971034 
interact_SERVICES_x_FOOD_DRINK    -6.751084   793.768249    -0.0085     0.993214 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    13.333638   544.209143     0.0245     0.980453 
interact_HEALTH_WELLNESS_x_FINANCE   -19.050912   1123.86476     -0.017     0.986476 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -9.254221   241.241368    -0.0384       0.9694 
interact_PLACE_OF_WORSHIP_x_FINANCE     2.819289   405.273643      0.007      0.99445 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 104.9867
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
(Intercept)                       -5.451094      0.13081   -41.6719          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.616905    12.376758     0.1306      0.89606 
interact_SHOPPING_x_AUTOMOTIVE    -1.081693    13.463749    -0.0803     0.935966 
interact_SHOPPING_x_SERVICES      -0.640354    21.065784    -0.0304      0.97575 
interact_SHOPPING_x_FOOD_DRINK    -1.294729    13.687984    -0.0946     0.924642 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.349244     7.106523    -0.1899     0.849419 
interact_SHOPPING_x_HEALTH_WELLNESS     3.883834    17.941096     0.2165     0.828616 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.768016    20.796619    -0.1331     0.894115 
interact_AUTOMOTIVE_x_SERVICES     0.132384    18.763305     0.0071     0.994371 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.179543    10.523659     0.0171     0.986388 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.098531    14.078804     -0.078     0.937806 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.631997    18.561144     0.1418     0.887237 
interact_SERVICES_x_FOOD_DRINK    -0.095056    12.204326    -0.0078     0.993786 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.914949     9.340009      0.098     0.921964 
interact_HEALTH_WELLNESS_x_FINANCE    -2.388568    11.967624    -0.1996     0.841804 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.562838      5.16108    -0.1091     0.913159 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.797421     7.115332     0.1121     0.910767 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 762.4223
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
(Intercept)                       -3.655569     0.054412   -67.1826          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.492387     4.785931     0.3118     0.755171 
interact_SHOPPING_x_AUTOMOTIVE    -0.989535     4.959838    -0.1995     0.841864 
interact_SHOPPING_x_SERVICES      -0.594619     8.736379    -0.0681     0.945736 
interact_SHOPPING_x_FOOD_DRINK    -1.027487     4.866611    -0.2111     0.832786 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.171002     2.499529    -0.4685     0.639435 
interact_SHOPPING_x_HEALTH_WELLNESS     3.325556     6.715573     0.4952     0.620459 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.527707     8.756477    -0.2887     0.772836 
interact_AUTOMOTIVE_x_SERVICES     0.055061       6.8276     0.0081     0.993566 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.155567     3.929369     0.0396     0.968419 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -0.853587     5.701023    -0.1497     0.880981 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.357378     6.934442       0.34     0.733893 
interact_SERVICES_x_FOOD_DRINK    -0.126205     4.631424    -0.0272      0.97826 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.819048     3.417644     0.2397     0.810599 
interact_HEALTH_WELLNESS_x_FINANCE     -2.11867     4.545241    -0.4661     0.641123 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.482527      1.79259    -0.2692     0.787792 
interact_PLACE_OF_WORSHIP_x_FINANCE      0.71963     2.793023     0.2577     0.796675 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 3254.5348
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
(Intercept)                       -6.966757     0.278316   -25.0318          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.655354    30.321812     0.0546     0.956463 
interact_SHOPPING_x_AUTOMOTIVE    -1.063433     31.39963    -0.0339     0.972983 
interact_SHOPPING_x_SERVICES      -0.437734    50.969652    -0.0086     0.993148 
interact_SHOPPING_x_FOOD_DRINK    -1.607939    35.347812    -0.0455     0.963717 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     -1.43484    16.210208    -0.0885     0.929468 
interact_SHOPPING_x_HEALTH_WELLNESS     4.236996     41.87131     0.1012     0.919399 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.974805    49.825198    -0.0597     0.952391 
interact_AUTOMOTIVE_x_SERVICES     0.098675     43.54166     0.0023     0.998192 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.204256    24.403857     0.0084     0.993322 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.253529    32.670049    -0.0384     0.969393 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.790555    44.050815     0.0633     0.949489 
interact_SERVICES_x_FOOD_DRINK    -0.127662    28.965086    -0.0044     0.996483 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.968469     21.92557     0.0442     0.964768 
interact_HEALTH_WELLNESS_x_FINANCE     -2.58207    28.203965    -0.0915     0.927056 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.589473    12.735811    -0.0463     0.963083 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.853854    17.071575       0.05      0.96011 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 207.3617
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
(Intercept)                       -7.133089     0.303024   -23.5397          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.744592    45.370934     0.0385     0.969327 
interact_SHOPPING_x_AUTOMOTIVE    -1.066028    41.357468    -0.0258     0.979436 
interact_SHOPPING_x_SERVICES      -0.143458    64.431492    -0.0022     0.998223 
interact_SHOPPING_x_FOOD_DRINK    -2.837235    55.680861     -0.051     0.959361 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.759493    22.511404    -0.0782     0.937701 
interact_SHOPPING_x_HEALTH_WELLNESS     5.786871    56.500999     0.1024     0.918423 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.670047    61.339023    -0.0598     0.952289 
interact_AUTOMOTIVE_x_SERVICES     0.054288    58.791299     0.0009     0.999263 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.518083    33.624972     0.0154     0.987707 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.994431    40.953996    -0.0487     0.961159 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.419888    55.427093     0.0617     0.950801 
interact_SERVICES_x_FOOD_DRINK    -0.092638    39.079224    -0.0024     0.998109 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.290839    28.162115     0.0458     0.963441 
interact_HEALTH_WELLNESS_x_FINANCE    -3.328988    37.117854    -0.0897     0.928536 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.721733    18.363122    -0.0393     0.968649 
interact_PLACE_OF_WORSHIP_x_FINANCE     1.119062    21.984362     0.0509     0.959403 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 179.1367
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
(Intercept)                       -5.385093     0.126626   -42.5276          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.637324    12.471415     0.1313     0.895549 
interact_SHOPPING_x_AUTOMOTIVE    -1.063556    13.464511     -0.079     0.937041 
interact_SHOPPING_x_SERVICES      -0.585626    20.891797     -0.028     0.977637 
interact_SHOPPING_x_FOOD_DRINK    -1.442568    14.352356    -0.1005     0.919939 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.397588     7.134919    -0.1959     0.844704 
interact_SHOPPING_x_HEALTH_WELLNESS     4.044238    17.833714     0.2268     0.820599 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.819163    20.274951     -0.139     0.889413 
interact_AUTOMOTIVE_x_SERVICES     0.146498    18.826062     0.0078     0.993791 
interact_AUTOMOTIVE_x_FOOD_DRINK      0.19575    10.540383     0.0186     0.985183 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.176953    13.906861    -0.0846     0.932555 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.670009    18.441727     0.1448     0.884884 
interact_SERVICES_x_FOOD_DRINK    -0.097928    12.213834     -0.008     0.993603 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.941639      9.45537     0.0996     0.920672 
interact_HEALTH_WELLNESS_x_FINANCE    -2.472264      11.9508    -0.2069     0.836111 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.580953      5.29244    -0.1098     0.912592 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.818229     7.060545     0.1159     0.907742 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 805.8286
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
(Intercept)                       -5.208967     0.116289   -44.7932          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.768023    16.708806     0.1058      0.91573 
interact_SHOPPING_x_AUTOMOTIVE    -1.051371    15.457654     -0.068     0.945773 
interact_SHOPPING_x_SERVICES      -0.210874    24.294547    -0.0087     0.993075 
interact_SHOPPING_x_FOOD_DRINK    -2.666707    20.514224      -0.13     0.896572 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.730269      8.39624    -0.2061     0.836731 
interact_SHOPPING_x_HEALTH_WELLNESS     5.597505    21.249589     0.2634     0.792229 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.586574    23.244928    -0.1543     0.877377 
interact_AUTOMOTIVE_x_SERVICES     0.072979     21.99791     0.0033     0.997353 
interact_AUTOMOTIVE_x_FOOD_DRINK      0.46176    12.493693      0.037     0.970517 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.911055    15.517271    -0.1232     0.901983 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.328754    20.948467     0.1589     0.873746 
interact_SERVICES_x_FOOD_DRINK    -0.098983    14.570258    -0.0068      0.99458 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.265823    10.755603     0.1177     0.906314 
interact_HEALTH_WELLNESS_x_FINANCE    -3.245517    13.990304     -0.232     0.816551 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.708664      6.86541    -0.1032     0.917786 
interact_PLACE_OF_WORSHIP_x_FINANCE      1.08812     8.283828     0.1314     0.895495 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 933.1018
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
(Intercept)                       -5.974779      0.16975   -35.1975          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.649936    18.378477     0.0898     0.928466 
interact_SHOPPING_x_AUTOMOTIVE     -1.05916    19.068789    -0.0555     0.955705 
interact_SHOPPING_x_SERVICES      -0.436605    30.976175    -0.0141     0.988754 
interact_SHOPPING_x_FOOD_DRINK    -1.594813    21.418116    -0.0745     0.940644 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.428474     9.821379    -0.1454     0.884359 
interact_SHOPPING_x_HEALTH_WELLNESS     4.211858    25.398993     0.1658     0.868293 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.957392    30.276672    -0.0977     0.922187 
interact_AUTOMOTIVE_x_SERVICES     0.102164    26.435831     0.0039     0.996916 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.201283    14.812057     0.0136     0.989158 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.245257    19.872318    -0.0627     0.950035 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.772787     26.76141     0.1036     0.917478 
interact_SERVICES_x_FOOD_DRINK    -0.130015    17.567968    -0.0074     0.994095 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.962608    13.328695     0.0722     0.942426 
interact_HEALTH_WELLNESS_x_FINANCE    -2.568303    17.103803    -0.1502     0.880639 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.587209     7.722094     -0.076     0.939385 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.848562    10.361679     0.0819     0.934731 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 488.8982
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
(Intercept)                        -4.32665     0.075241   -57.5041          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.650773     7.686762     0.2148     0.829958 
interact_SHOPPING_x_AUTOMOTIVE    -1.038033     8.176129     -0.127     0.898973 
interact_SHOPPING_x_SERVICES      -0.530661     12.78242    -0.0415     0.966885 
interact_SHOPPING_x_FOOD_DRINK    -1.567259     9.067435    -0.1728     0.862773 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.430137     4.313611    -0.3315     0.740236 
interact_SHOPPING_x_HEALTH_WELLNESS     4.170825    10.806943     0.3859     0.699542 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -2.864737    12.281349    -0.2333      0.81556 
interact_AUTOMOTIVE_x_SERVICES     0.159784    11.458061     0.0139     0.988874 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.204856     6.413062     0.0319     0.974517 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS     -1.24671     8.445584    -0.1476     0.882645 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     2.692009    11.203436     0.2403      0.81011 
interact_SERVICES_x_FOOD_DRINK     -0.10542     7.430393    -0.0142      0.98868 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.963795     5.793266     0.1664      0.86787 
interact_HEALTH_WELLNESS_x_FINANCE    -2.536551     7.257962    -0.3495     0.726725 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.592336     3.281964    -0.1805     0.856774 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.834662     4.299008     0.1942     0.846057 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 1922.9092
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
(Intercept)                       -6.197639      0.19001   -32.6174          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.761657    27.586109     0.0639     0.949081 
interact_SHOPPING_x_AUTOMOTIVE    -1.053039    25.432163    -0.0414     0.966972 
interact_SHOPPING_x_SERVICES      -0.198783     39.89402     -0.005     0.996024 
interact_SHOPPING_x_FOOD_DRINK    -2.700736     33.84098    -0.0798     0.936391 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.734358    13.809901    -0.1256     0.900058 
interact_SHOPPING_x_HEALTH_WELLNESS     5.636969    34.985892     0.1611     0.871998 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.602754    38.171635    -0.0944     0.924805 
interact_AUTOMOTIVE_x_SERVICES     0.067472    36.168224     0.0019     0.998512 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.474047    20.569463      0.023     0.981613 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.930237    25.476878    -0.0758     0.939607 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.346741    34.422543     0.0972     0.922547 
interact_SERVICES_x_FOOD_DRINK     -0.09771    23.971873    -0.0041     0.996748 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.272921    17.656597     0.0721     0.942528 
interact_HEALTH_WELLNESS_x_FINANCE     -3.26203    22.996713    -0.1418       0.8872 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.711459    11.295843     -0.063     0.949779 
interact_PLACE_OF_WORSHIP_x_FINANCE     1.094331     13.61444     0.0804     0.935935 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 403.6287
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
(Intercept)                       -4.559296     0.084332   -54.0635          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.763139     9.563307     0.1844     0.853727 
interact_SHOPPING_x_AUTOMOTIVE    -1.158115     9.550405    -0.1213     0.903482 
interact_SHOPPING_x_SERVICES      -0.626657    15.668386      -0.04     0.968097 
interact_SHOPPING_x_FOOD_DRINK    -1.617116     10.66522    -0.1516     0.879483 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.526532     5.249872    -0.2908     0.771223 
interact_SHOPPING_x_HEALTH_WELLNESS     4.544489     13.35848     0.3402      0.73371 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.236494    15.614882    -0.2073     0.835799 
interact_AUTOMOTIVE_x_SERVICES     0.095359    13.432293     0.0071     0.994336 
interact_AUTOMOTIVE_x_FOOD_DRINK      0.19788     7.614842      0.026     0.979268 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.337721    10.043056    -0.1332     0.894036 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.064949    13.501124      0.227     0.820413 
interact_SERVICES_x_FOOD_DRINK    -0.058142     9.035308    -0.0064     0.994866 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.052672      6.63255     0.1587     0.873895 
interact_HEALTH_WELLNESS_x_FINANCE    -2.757858     8.930186    -0.3088     0.757455 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.625087     3.921178    -0.1594     0.873344 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.934569     5.346019     0.1748     0.861224 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 1593.8398
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
(Intercept)                       -3.082354     0.041718   -73.8861          0.0 ***
interact_SHOPPING_x_TRANSPORTATION     1.755044     4.992141     0.3516     0.725167 
interact_SHOPPING_x_AUTOMOTIVE    -1.066936     5.013687    -0.2128     0.831479 
interact_SHOPPING_x_SERVICES      -0.314433     7.898229    -0.0398     0.968244 
interact_SHOPPING_x_FOOD_DRINK    -2.084902      6.16874     -0.338     0.735379 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    -1.586074      2.60779    -0.6082     0.543051 
interact_SHOPPING_x_HEALTH_WELLNESS     4.821777      6.63572     0.7266     0.467447 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -3.227105     7.575509     -0.426     0.670114 
interact_AUTOMOTIVE_x_SERVICES     0.096226     7.017687     0.0137      0.98906 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.287354      3.95306     0.0727     0.942052 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -1.523109     5.076466       -0.3     0.764152 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     3.020408     6.849301      0.441     0.659227 
interact_SERVICES_x_FOOD_DRINK    -0.128344     4.630654    -0.0277     0.977888 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     1.079248     3.504038      0.308     0.758081 
interact_HEALTH_WELLNESS_x_FINANCE    -2.874426     4.450817    -0.6458     0.518396 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.646395     2.137434    -0.3024     0.762335 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.945883     2.663196     0.3552     0.722463 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: Inf
Null Deviance: 4977.4317
AIC: Inf
BIC: Inf
McFadden R²: -Inf
Number of observations: 13917.0
```

---

