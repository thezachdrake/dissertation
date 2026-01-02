# Model Results for ARRESTS_INTERACTIONS

Generated: 2025-12-16 20:31:34

---

## Model: high_burglary_jenks

### Formula
```
high_burglary_jenks ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -8.436433     0.578982   -14.5712          0.0 ***
place_density                     -0.652931     9.149093    -0.0714     0.943107 
interact_SHOPPING_x_TRANSPORTATION     6.066341   821.046828     0.0074     0.994105 
interact_SHOPPING_x_AUTOMOTIVE    -2.329281   736.656436    -0.0032     0.997477 
interact_SHOPPING_x_SERVICES     -11.330544  1381.088119    -0.0082     0.993454 
interact_SHOPPING_x_FOOD_DRINK    -11.99181  2259.351378    -0.0053     0.995765 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     5.357935   417.979975     0.0128     0.989772 
interact_SHOPPING_x_HEALTH_WELLNESS     9.375593   880.993467     0.0106     0.991509 
interact_SHOPPING_x_PLACE_OF_WORSHIP     5.614443  1298.342098     0.0043      0.99655 
interact_AUTOMOTIVE_x_SERVICES     5.143146  1499.012194     0.0034     0.997262 
interact_AUTOMOTIVE_x_FOOD_DRINK     10.13531  1054.663328     0.0096     0.992332 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -12.293327   931.318858    -0.0132     0.989468 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -4.971688   567.630496    -0.0088     0.993012 
interact_SERVICES_x_FOOD_DRINK    -0.362221  1499.088797    -0.0002     0.999807 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.635019   411.403446     0.0064      0.99489 
interact_HEALTH_WELLNESS_x_FINANCE    -0.092828   322.366978    -0.0003      0.99977 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.645684   161.034607      0.004     0.996801 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.913701    271.10876     0.0034     0.997311 
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
high_burglary_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -8.14878     0.501892   -16.2361          0.0 ***
place_density                     -0.675296     8.256815    -0.0818     0.934816 
interact_SHOPPING_x_TRANSPORTATION      6.96765   762.631237     0.0091      0.99271 
interact_SHOPPING_x_AUTOMOTIVE    -1.898127   712.279668    -0.0027     0.997874 
interact_SHOPPING_x_SERVICES     -13.108411   1329.21405    -0.0099     0.992132 
interact_SHOPPING_x_FOOD_DRINK   -14.316695  2097.095329    -0.0068     0.994553 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     5.904511   389.707853     0.0152     0.987912 
interact_SHOPPING_x_HEALTH_WELLNESS    10.421108   832.184294     0.0125     0.990009 
interact_SHOPPING_x_PLACE_OF_WORSHIP     7.120505  1261.968769     0.0056     0.995498 
interact_AUTOMOTIVE_x_SERVICES     4.677261   1482.58276     0.0032     0.997483 
interact_AUTOMOTIVE_x_FOOD_DRINK    11.246861   994.381131     0.0113     0.990976 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -13.508217   906.574045    -0.0149     0.988112 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -5.573541   620.252415     -0.009      0.99283 
interact_SERVICES_x_FOOD_DRINK     0.911461   1404.95125     0.0006     0.999482 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.436424   406.902884      0.006     0.995223 
interact_HEALTH_WELLNESS_x_FINANCE      0.11434   344.693212     0.0003     0.999735 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.518375   155.427082     0.0033     0.997339 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.695197   276.328977     0.0025     0.997993 
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
high_burglary_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.826723     0.259245   -26.3331          0.0 ***
place_density                     -0.798389     5.231572    -0.1526     0.878706 
interact_SHOPPING_x_TRANSPORTATION    10.042668   628.692539      0.016     0.987255 
interact_SHOPPING_x_AUTOMOTIVE    -0.852911   489.512681    -0.0017      0.99861 
interact_SHOPPING_x_SERVICES     -17.990783  1021.973467    -0.0176     0.985955 
interact_SHOPPING_x_FOOD_DRINK   -22.303149  1747.120922    -0.0128     0.989815 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     7.968141   319.693096     0.0249     0.980115 
interact_SHOPPING_x_HEALTH_WELLNESS    14.316299   667.324611     0.0215     0.982884 
interact_SHOPPING_x_PLACE_OF_WORSHIP    10.812577   951.295694     0.0114     0.990931 
interact_AUTOMOTIVE_x_SERVICES     2.463161   925.711467     0.0027     0.997877 
interact_AUTOMOTIVE_x_FOOD_DRINK    15.968876   800.915692     0.0199     0.984093 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -17.652428   664.895089    -0.0265     0.978819 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -7.143996   266.688687    -0.0268     0.978629 
interact_SERVICES_x_FOOD_DRINK     4.162744  1123.941896     0.0037     0.997045 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.102526   290.976305     0.0072     0.994235 
interact_HEALTH_WELLNESS_x_FINANCE     0.186601   164.253278     0.0011     0.999094 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.395273   109.533742     0.0036     0.997121 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.618495   173.121777     0.0036     0.997149 
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
high_drugs_jenks ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.065455     4.448352    -1.5883     0.112212 
place_density                     -6.282283   104.081954    -0.0604      0.95187 
interact_SHOPPING_x_TRANSPORTATION      50.3117  5539.930437     0.0091     0.992754 
interact_SHOPPING_x_AUTOMOTIVE    87.442639 53751.817063     0.0016     0.998702 
interact_SHOPPING_x_SERVICES      36.737815 54867.343364     0.0007     0.999466 
interact_SHOPPING_x_FOOD_DRINK   -73.083939  1720.108497    -0.0425      0.96611 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    25.827363  8250.629762     0.0031     0.997502 
interact_SHOPPING_x_HEALTH_WELLNESS    15.840983  25556.88516     0.0006     0.999505 
interact_SHOPPING_x_PLACE_OF_WORSHIP  -118.848984  69622.61895    -0.0017     0.998638 
interact_AUTOMOTIVE_x_SERVICES  -230.582874 139801.752457    -0.0016     0.998684 
interact_AUTOMOTIVE_x_FOOD_DRINK     2.231993 35702.042566     0.0001      0.99995 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    23.485219 56721.242972     0.0004      0.99967 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    108.58528 73593.765132     0.0015     0.998823 
interact_SERVICES_x_FOOD_DRINK    41.912982 33996.195115     0.0012     0.999016 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    86.831454 24462.055409     0.0035     0.997168 
interact_HEALTH_WELLNESS_x_FINANCE   -86.577068 37512.867108    -0.0023     0.998159 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -11.97049 10423.560505    -0.0011     0.999084 
interact_PLACE_OF_WORSHIP_x_FINANCE    65.770123 23534.319144     0.0028      0.99777 
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
high_drugs_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.765733     0.266907   -25.3487          0.0 ***
place_density                     -1.573298    14.825351    -0.1061     0.915485 
interact_SHOPPING_x_TRANSPORTATION    34.009109  2397.549617     0.0142     0.988682 
interact_SHOPPING_x_AUTOMOTIVE     6.220692   526.556998     0.0118     0.990574 
interact_SHOPPING_x_SERVICES     -59.641129  4578.362873     -0.013     0.989606 
interact_SHOPPING_x_FOOD_DRINK   -86.073417  7673.120854    -0.0112      0.99105 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    24.114944  1709.473888     0.0141     0.988745 
interact_SHOPPING_x_HEALTH_WELLNESS    45.939919  4036.791826     0.0114      0.99092 
interact_SHOPPING_x_PLACE_OF_WORSHIP     44.60401  4400.774972     0.0101     0.991913 
interact_AUTOMOTIVE_x_SERVICES   -12.369393  2327.424914    -0.0053      0.99576 
interact_AUTOMOTIVE_x_FOOD_DRINK    53.296123  4667.624304     0.0114      0.99089 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -52.514771  3976.782323    -0.0132     0.989464 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   -19.982814   915.342167    -0.0218     0.982583 
interact_SERVICES_x_FOOD_DRINK    31.556241  3505.328578      0.009     0.992817 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    -4.379235  2501.551197    -0.0018     0.998603 
interact_HEALTH_WELLNESS_x_FINANCE      4.73425   1375.65132     0.0034     0.997254 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.848236    110.55919    -0.0077     0.993879 
interact_PLACE_OF_WORSHIP_x_FINANCE    -2.461315   648.956985    -0.0038     0.996974 
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
high_drugs_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.030023     0.106224   -47.3528          0.0 ***
place_density                     -0.906802     2.511353    -0.3611     0.718039 
interact_SHOPPING_x_TRANSPORTATION     9.834689   300.361803     0.0327      0.97388 
interact_SHOPPING_x_AUTOMOTIVE    -3.002621   226.232269    -0.0133     0.989411 
interact_SHOPPING_x_SERVICES      -18.58881   482.092025    -0.0386     0.969242 
interact_SHOPPING_x_FOOD_DRINK   -21.165136   831.732991    -0.0254     0.979698 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     8.489873   155.586434     0.0546     0.956483 
interact_SHOPPING_x_HEALTH_WELLNESS    15.119034   320.967714     0.0471      0.96243 
interact_SHOPPING_x_PLACE_OF_WORSHIP    10.873789   452.383269      0.024     0.980823 
interact_AUTOMOTIVE_x_SERVICES     6.567227   416.403629     0.0158     0.987417 
interact_AUTOMOTIVE_x_FOOD_DRINK    16.985451   388.970975     0.0437     0.965169 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -19.538679   322.123634    -0.0607     0.951633 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -8.210862   105.870447    -0.0776     0.938181 
interact_SERVICES_x_FOOD_DRINK     1.347918   527.323713     0.0026      0.99796 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.641929   140.126197     0.0189     0.984958 
interact_HEALTH_WELLNESS_x_FINANCE     0.677621    77.644664     0.0087     0.993037 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.847219     50.57634     0.0168     0.986635 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.639285    85.194808     0.0075     0.994013 
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
high_larceny_jenks ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.947684     0.166934   -35.6291          0.0 ***
place_density                     -0.047694     0.155753    -0.3062     0.759441 
interact_SHOPPING_x_TRANSPORTATION      0.54209     6.225915     0.0871     0.930616 
interact_SHOPPING_x_AUTOMOTIVE    -0.783288    13.608377    -0.0576       0.9541 
interact_SHOPPING_x_SERVICES      -0.088674    16.033344    -0.0055     0.995587 
interact_SHOPPING_x_FOOD_DRINK    -0.364776    10.877755    -0.0335     0.973249 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     0.374439     4.860919      0.077     0.938599 
interact_SHOPPING_x_HEALTH_WELLNESS     0.588065    10.570979     0.0556     0.955636 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -0.358787     11.02877    -0.0325     0.974048 
interact_AUTOMOTIVE_x_SERVICES     0.753972    22.557029     0.0334     0.973336 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.420463    11.653882     0.0361     0.971219 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -0.657334    19.076925    -0.0345     0.972513 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -0.025068     7.517667    -0.0033     0.997339 
interact_SERVICES_x_FOOD_DRINK    -0.646032    10.633465    -0.0608     0.951555 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.506054    11.334139     0.0446     0.964387 
interact_HEALTH_WELLNESS_x_FINANCE    -0.420313    11.137519    -0.0377     0.969896 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.003088     2.429395    -0.0013     0.998986 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.285488     6.397352     0.0446     0.964405 
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
high_larceny_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.345298     0.801677    -9.1624          0.0 ***
place_density                     -3.000872    39.429788    -0.0761     0.939334 
interact_SHOPPING_x_TRANSPORTATION    27.377281    2611.3212     0.0105     0.991635 
interact_SHOPPING_x_AUTOMOTIVE    26.978464 11805.316586     0.0023     0.998177 
interact_SHOPPING_x_SERVICES     -32.733659  2014.227684    -0.0163     0.987034 
interact_SHOPPING_x_FOOD_DRINK   -35.769746   918.998673    -0.0389     0.968952 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     12.08391  2441.221414     0.0049     0.996051 
interact_SHOPPING_x_HEALTH_WELLNESS     4.562269  8323.788683     0.0005     0.999563 
interact_SHOPPING_x_PLACE_OF_WORSHIP     7.929131  2155.898617     0.0037     0.997065 
interact_AUTOMOTIVE_x_SERVICES    -8.581393 12448.077675    -0.0007      0.99945 
interact_AUTOMOTIVE_x_FOOD_DRINK     7.287472  8548.020223     0.0009      0.99932 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -15.567917  9018.862452    -0.0017     0.998623 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   -24.383901  1294.908938    -0.0188     0.984976 
interact_SERVICES_x_FOOD_DRINK    21.422223 10561.189516      0.002     0.998382 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    46.489282  8705.894616     0.0053     0.995739 
interact_HEALTH_WELLNESS_x_FINANCE   -24.851665  6404.776398    -0.0039     0.996904 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -4.848051  2816.187572    -0.0017     0.998626 
interact_PLACE_OF_WORSHIP_x_FINANCE     4.294818   908.368972     0.0047     0.996228 
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
high_larceny_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.037466     0.175065    -34.487          0.0 ***
place_density                     -0.905639     4.145635    -0.2185     0.827074 
interact_SHOPPING_x_TRANSPORTATION     9.690746   491.634363     0.0197     0.984274 
interact_SHOPPING_x_AUTOMOTIVE    -3.087239   370.877004    -0.0083     0.993358 
interact_SHOPPING_x_SERVICES     -18.338766   789.583815    -0.0232      0.98147 
interact_SHOPPING_x_FOOD_DRINK    -20.76808  1361.021814    -0.0153     0.987825 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     8.411319   254.714169      0.033     0.973657 
interact_SHOPPING_x_HEALTH_WELLNESS    14.960119   525.334825     0.0285     0.977281 
interact_SHOPPING_x_PLACE_OF_WORSHIP    10.633679   740.458153     0.0144     0.988542 
interact_AUTOMOTIVE_x_SERVICES     6.711909   681.909284     0.0098     0.992147 
interact_AUTOMOTIVE_x_FOOD_DRINK    16.792092   636.696879     0.0264     0.978959 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -19.36695   527.846237    -0.0367     0.970732 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -8.135568   173.579754    -0.0469     0.962617 
interact_SERVICES_x_FOOD_DRINK     1.116736   863.247618     0.0013     0.998968 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.695278   229.433102     0.0117     0.990627 
interact_HEALTH_WELLNESS_x_FINANCE     0.644494   127.982625      0.005     0.995982 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.871521    82.808262     0.0105     0.991603 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.681265   139.816139     0.0049     0.996112 
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
high_violence_jenks ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.765733     0.266907   -25.3487          0.0 ***
place_density                     -1.573298    14.825351    -0.1061     0.915485 
interact_SHOPPING_x_TRANSPORTATION    34.009109  2397.549642     0.0142     0.988682 
interact_SHOPPING_x_AUTOMOTIVE     6.220692   526.557001     0.0118     0.990574 
interact_SHOPPING_x_SERVICES      -59.64113   4578.36292     -0.013     0.989606 
interact_SHOPPING_x_FOOD_DRINK   -86.073418  7673.120934    -0.0112      0.99105 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    24.114944  1709.473906     0.0141     0.988745 
interact_SHOPPING_x_HEALTH_WELLNESS     45.93992  4036.791868     0.0114      0.99092 
interact_SHOPPING_x_PLACE_OF_WORSHIP    44.604011  4400.775017     0.0101     0.991913 
interact_AUTOMOTIVE_x_SERVICES   -12.369394   2327.42494    -0.0053      0.99576 
interact_AUTOMOTIVE_x_FOOD_DRINK    53.296124  4667.624352     0.0114      0.99089 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -52.514772  3976.782364    -0.0132     0.989464 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   -19.982815   915.342176    -0.0218     0.982583 
interact_SERVICES_x_FOOD_DRINK    31.556242  3505.328614      0.009     0.992817 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    -4.379236  2501.551222    -0.0018     0.998603 
interact_HEALTH_WELLNESS_x_FINANCE      4.73425  1375.651333     0.0034     0.997254 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.848236    110.55919    -0.0077     0.993879 
interact_PLACE_OF_WORSHIP_x_FINANCE    -2.461315    648.95699    -0.0038     0.996974 
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
high_violence_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.065455     4.448353    -1.5883     0.112212 
place_density                     -6.282283   104.081954    -0.0604      0.95187 
interact_SHOPPING_x_TRANSPORTATION    50.311705   5539.93173     0.0091     0.992754 
interact_SHOPPING_x_AUTOMOTIVE    87.442691 53751.829818     0.0016     0.998702 
interact_SHOPPING_x_SERVICES      36.737867 54867.356373     0.0007     0.999466 
interact_SHOPPING_x_FOOD_DRINK   -73.083939    1720.1085    -0.0425      0.96611 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    25.827355  8250.631703     0.0031     0.997502 
interact_SHOPPING_x_HEALTH_WELLNESS    15.840959 25556.891212     0.0006     0.999505 
interact_SHOPPING_x_PLACE_OF_WORSHIP  -118.849051  69622.63547    -0.0017     0.998638 
interact_AUTOMOTIVE_x_SERVICES  -230.583008 139801.785637    -0.0016     0.998684 
interact_AUTOMOTIVE_x_FOOD_DRINK     2.231959 35702.051019     0.0001      0.99995 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    23.485273 56721.256424     0.0004      0.99967 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   108.585351 73593.782593     0.0015     0.998823 
interact_SERVICES_x_FOOD_DRINK    41.913015 33996.203167     0.0012     0.999016 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    86.831477 24462.061209     0.0035     0.997168 
interact_HEALTH_WELLNESS_x_FINANCE   -86.577104 37512.876011    -0.0023     0.998159 
interact_PLACE_OF_WORSHIP_x_EDUCATION     -11.9705 10423.562978    -0.0011     0.999084 
interact_PLACE_OF_WORSHIP_x_FINANCE    65.770146 23534.324728     0.0028      0.99777 
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
high_violence_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -4.751715      0.09822   -48.3784          0.0 ***
place_density                     -1.576037     5.434655      -0.29     0.771818 
interact_SHOPPING_x_TRANSPORTATION    34.207833   879.495329     0.0389     0.968974 
interact_SHOPPING_x_AUTOMOTIVE     6.189151    192.92511     0.0321     0.974408 
interact_SHOPPING_x_SERVICES     -60.003774  1679.563843    -0.0357     0.971501 
interact_SHOPPING_x_FOOD_DRINK   -86.676013  2814.672561    -0.0308     0.975434 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    24.277724   627.100636     0.0387     0.969118 
interact_SHOPPING_x_HEALTH_WELLNESS    46.320976  1480.797289     0.0313     0.975045 
interact_SHOPPING_x_PLACE_OF_WORSHIP    44.870711  1614.800921     0.0278     0.977832 
interact_AUTOMOTIVE_x_SERVICES   -12.492658   853.556714    -0.0146     0.988323 
interact_AUTOMOTIVE_x_FOOD_DRINK    53.720024  1712.218618     0.0314     0.974971 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -52.887979  1458.826154    -0.0363      0.97108 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   -20.032372   336.355879    -0.0596     0.952508 
interact_SERVICES_x_FOOD_DRINK    31.754416  1285.757651     0.0247     0.980297 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    -4.591265   917.511115     -0.005     0.996007 
interact_HEALTH_WELLNESS_x_FINANCE     4.846116   504.597318     0.0096     0.992337 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.817321    41.685706    -0.0196     0.984357 
interact_PLACE_OF_WORSHIP_x_FINANCE    -2.470693    237.97966    -0.0104     0.991717 
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

