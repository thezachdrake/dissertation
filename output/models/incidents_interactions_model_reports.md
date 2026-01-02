# Model Results for INCIDENTS_INTERACTIONS

Generated: 2025-12-16 20:24:05

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
(Intercept)                        -7.74167     0.408468   -18.9529          0.0 ***
place_density                     -0.043977     0.351973    -0.1249     0.900567 
interact_SHOPPING_x_TRANSPORTATION     0.507224    13.302126     0.0381     0.969583 
interact_SHOPPING_x_AUTOMOTIVE    -0.725312    28.050333    -0.0259     0.979371 
interact_SHOPPING_x_SERVICES      -0.051352    35.356555    -0.0015     0.998841 
interact_SHOPPING_x_FOOD_DRINK    -0.375733    24.700308    -0.0152     0.987863 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     0.357499    10.870628     0.0329     0.973765 
interact_SHOPPING_x_HEALTH_WELLNESS     0.547379    21.755254     0.0252     0.979927 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -0.348433      24.3806    -0.0143     0.988597 
interact_AUTOMOTIVE_x_SERVICES     0.686988    48.378709     0.0142      0.98867 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.404756     25.73409     0.0157     0.987451 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -0.604313    40.204646     -0.015     0.988008 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP     -0.02725    16.641851    -0.0016     0.998694 
interact_SERVICES_x_FOOD_DRINK    -0.608235    23.778932    -0.0256     0.979593 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.490371      24.0163     0.0204      0.98371 
interact_HEALTH_WELLNESS_x_FINANCE    -0.408196    23.953519     -0.017     0.986404 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.009464     5.360683    -0.0018     0.998591 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.275088    13.756141       0.02     0.984045 
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
high_burglary_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.455247     0.137254   -39.7457          0.0 ***
place_density                      -1.14428     4.586695    -0.2495     0.802991 
interact_SHOPPING_x_TRANSPORTATION    24.548727   797.381849     0.0308      0.97544 
interact_SHOPPING_x_AUTOMOTIVE    11.008269   775.997556     0.0142     0.988682 
interact_SHOPPING_x_SERVICES     -39.371495  1371.410551    -0.0287     0.977097 
interact_SHOPPING_x_FOOD_DRINK   -57.879337  2346.011551    -0.0247     0.980317 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    14.918917   496.956094       0.03     0.976051 
interact_SHOPPING_x_HEALTH_WELLNESS    25.971868  1172.698848     0.0221     0.982331 
interact_SHOPPING_x_PLACE_OF_WORSHIP    28.713584  1310.247073     0.0219     0.982516 
interact_AUTOMOTIVE_x_SERVICES   -14.603791  1162.594996    -0.0126     0.989978 
interact_AUTOMOTIVE_x_FOOD_DRINK    30.723484  1353.158448     0.0227     0.981886 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -30.343803  1166.114079     -0.026      0.97924 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   -14.095623   300.039723     -0.047      0.96253 
interact_SERVICES_x_FOOD_DRINK    26.831579  1401.631904     0.0191     0.984727 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     3.268349   778.034113     0.0042     0.996648 
interact_HEALTH_WELLNESS_x_FINANCE    -1.035871   477.726684    -0.0022      0.99827 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -2.260244     181.5607    -0.0124     0.990067 
interact_PLACE_OF_WORSHIP_x_FINANCE    -1.907458   212.420496     -0.009     0.992835 
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
high_burglary_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -3.65614      0.05431   -67.3195          0.0 ***
place_density                     -0.046246     0.048217    -0.9591     0.337495 
interact_SHOPPING_x_TRANSPORTATION     0.515887     1.804686     0.2859     0.774986 
interact_SHOPPING_x_AUTOMOTIVE    -0.720869     3.819793    -0.1887     0.850313 
interact_SHOPPING_x_SERVICES       -0.04733     4.777493    -0.0099     0.992096 
interact_SHOPPING_x_FOOD_DRINK    -0.381398     3.329351    -0.1146     0.908797 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     0.367904     1.459522     0.2521     0.800986 
interact_SHOPPING_x_HEALTH_WELLNESS     0.540049     2.979346     0.1813      0.85616 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -0.360028     3.294413    -0.1093     0.912977 
interact_AUTOMOTIVE_x_SERVICES        0.666     6.578576     0.1012     0.919362 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.404469     3.479655     0.1162     0.907464 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -0.587749     5.471698    -0.1074     0.914459 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -0.023677     2.250039    -0.0105     0.991604 
interact_SERVICES_x_FOOD_DRINK    -0.614401     3.202467    -0.1919     0.847858 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.497456     3.250075     0.1531     0.878351 
interact_HEALTH_WELLNESS_x_FINANCE    -0.414704      3.22387    -0.1286     0.897646 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.003857     0.731355    -0.0053     0.995792 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.284137     1.852512     0.1534     0.878099 
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
high_drugs_jenks ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -6.96793     0.277563   -25.1039          0.0 ***
place_density                     -0.046898      0.25518    -0.1838     0.854182 
interact_SHOPPING_x_TRANSPORTATION     0.537962    10.224066     0.0526     0.958037 
interact_SHOPPING_x_AUTOMOTIVE    -0.788247    22.393044    -0.0352      0.97192 
interact_SHOPPING_x_SERVICES      -0.095207    26.402734    -0.0036     0.997123 
interact_SHOPPING_x_FOOD_DRINK    -0.359572    17.861324    -0.0201     0.983939 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     0.368459     8.007505      0.046     0.963299 
interact_SHOPPING_x_HEALTH_WELLNESS     0.593218    17.342089     0.0342     0.972712 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -0.350281    18.146229    -0.0193     0.984599 
interact_AUTOMOTIVE_x_SERVICES     0.762798    37.106907     0.0206     0.983599 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.422435    19.179099      0.022     0.982427 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -0.663089    31.333774    -0.0212     0.983116 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -0.025226    12.384952     -0.002     0.998375 
interact_SERVICES_x_FOOD_DRINK    -0.642066    17.517995    -0.0367     0.970763 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP      0.49819    18.654587     0.0267     0.978694 
interact_HEALTH_WELLNESS_x_FINANCE    -0.416402    18.348129    -0.0227     0.981894 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.004783     3.986223    -0.0012     0.999043 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.280893    10.538363     0.0267     0.978735 
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
high_drugs_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.136689     0.302732   -23.5743          0.0 ***
place_density                     -0.678541     5.006315    -0.1355     0.892187 
interact_SHOPPING_x_TRANSPORTATION     6.997709   461.247002     0.0152     0.987896 
interact_SHOPPING_x_AUTOMOTIVE    -1.897357   429.502074    -0.0044     0.996475 
interact_SHOPPING_x_SERVICES     -13.190414   803.748689    -0.0164     0.986906 
interact_SHOPPING_x_FOOD_DRINK   -14.414571  1268.833013    -0.0114     0.990936 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     5.935309   235.947185     0.0252     0.979931 
interact_SHOPPING_x_HEALTH_WELLNESS    10.475131   503.664963     0.0208     0.983407 
interact_SHOPPING_x_PLACE_OF_WORSHIP     7.206457   763.173447     0.0094     0.992466 
interact_AUTOMOTIVE_x_SERVICES     4.705341   892.482539     0.0053     0.995793 
interact_AUTOMOTIVE_x_FOOD_DRINK    11.315133   602.077359     0.0188     0.985006 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -13.585095   548.237728    -0.0248     0.980231 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -5.624764   373.477705    -0.0151     0.987984 
interact_SERVICES_x_FOOD_DRINK     0.929244   849.052652     0.0011     0.999127 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.445932   246.187726     0.0099     0.992073 
interact_HEALTH_WELLNESS_x_FINANCE     0.124029   207.659667     0.0006     0.999523 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.512299    93.757623     0.0055      0.99564 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.688563   166.815219     0.0041     0.996707 
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
high_drugs_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.387606     0.126605   -42.5545          0.0 ***
place_density                      -0.66514     2.036807    -0.3266     0.744001 
interact_SHOPPING_x_TRANSPORTATION     6.574948   188.217917     0.0349     0.972133 
interact_SHOPPING_x_AUTOMOTIVE    -2.128811   163.301068     -0.013     0.989599 
interact_SHOPPING_x_SERVICES     -12.215767   315.067414    -0.0388     0.969072 
interact_SHOPPING_x_FOOD_DRINK   -13.378436   517.664241    -0.0258     0.979382 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     5.688746    95.508869     0.0596     0.952504 
interact_SHOPPING_x_HEALTH_WELLNESS    10.014055   201.316347     0.0497     0.960327 
interact_SHOPPING_x_PLACE_OF_WORSHIP     6.384459   293.560894     0.0217     0.982649 
interact_AUTOMOTIVE_x_SERVICES     4.741605   324.077039     0.0146     0.988326 
interact_AUTOMOTIVE_x_FOOD_DRINK    10.886634   239.820236     0.0454     0.963792 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -12.962489   210.041062    -0.0617     0.950791 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -5.240099   117.442701    -0.0446     0.964412 
interact_SERVICES_x_FOOD_DRINK       0.3018   342.453083     0.0009     0.999297 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP      2.47813    92.266859     0.0269     0.978573 
interact_HEALTH_WELLNESS_x_FINANCE    -0.011076    68.116568    -0.0002      0.99987 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.594929    35.886806     0.0166     0.986773 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.836344    59.544754      0.014     0.988794 
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
high_larceny_jenks ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.212338     0.116211   -44.8522          0.0 ***
place_density                     -0.658271     1.848125    -0.3562     0.721703 
interact_SHOPPING_x_TRANSPORTATION     6.739061   171.433425     0.0393     0.968643 
interact_SHOPPING_x_AUTOMOTIVE    -1.954991   165.337048    -0.0118     0.990566 
interact_SHOPPING_x_SERVICES     -12.578786     300.7433    -0.0418     0.966638 
interact_SHOPPING_x_FOOD_DRINK   -13.621781   470.399982     -0.029     0.976898 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     5.707183    87.277252     0.0654     0.947862 
interact_SHOPPING_x_HEALTH_WELLNESS    10.070182    187.02923     0.0538      0.95706 
interact_SHOPPING_x_PLACE_OF_WORSHIP     6.590558    286.52136      0.023     0.981649 
interact_AUTOMOTIVE_x_SERVICES     4.643412   349.564072     0.0133     0.989402 
interact_AUTOMOTIVE_x_FOOD_DRINK    10.817368   223.265091     0.0485     0.961357 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -13.047762   206.342476    -0.0632     0.949581 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -5.300915   148.380757    -0.0357     0.971502 
interact_SERVICES_x_FOOD_DRINK     0.697543   317.552855     0.0022     0.998247 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.411597    92.685858      0.026     0.979242 
interact_HEALTH_WELLNESS_x_FINANCE     0.060069    81.856313     0.0007     0.999414 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.562271    35.890611     0.0157     0.987501 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.739295     64.13176     0.0115     0.990802 
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
high_larceny_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.975942     0.169296   -35.2988          0.0 ***
place_density                     -0.046449     0.154052    -0.3015     0.763023 
interact_SHOPPING_x_TRANSPORTATION     0.535842     6.179111     0.0867     0.930895 
interact_SHOPPING_x_AUTOMOTIVE    -0.791893    13.556414    -0.0584     0.953418 
interact_SHOPPING_x_SERVICES       -0.09992    15.991084    -0.0062     0.995014 
interact_SHOPPING_x_FOOD_DRINK    -0.356562    10.798327     -0.033     0.973659 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     0.365079     4.850059     0.0753     0.939997 
interact_SHOPPING_x_HEALTH_WELLNESS     0.596793    10.477933      0.057     0.954579 
interact_SHOPPING_x_PLACE_OF_WORSHIP    -0.344718    10.982456    -0.0314      0.97496 
interact_AUTOMOTIVE_x_SERVICES      0.76919    22.461636     0.0342     0.972682 
interact_AUTOMOTIVE_x_FOOD_DRINK     0.423597    11.612096     0.0365       0.9709 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS    -0.667042    18.943192    -0.0352      0.97191 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -0.025539     7.503193    -0.0034     0.997284 
interact_SERVICES_x_FOOD_DRINK    -0.639867    10.609418    -0.0603     0.951908 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     0.493401    11.289222     0.0437     0.965139 
interact_HEALTH_WELLNESS_x_FINANCE    -0.413995    11.107142    -0.0373     0.970267 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -0.005816     2.408365    -0.0024     0.998073 
interact_PLACE_OF_WORSHIP_x_FINANCE      0.27813      6.37974     0.0436     0.965227 
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
high_larceny_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -4.33731     0.185505    -23.381          0.0 ***
place_density                     -2.998755      8.77179    -0.3419     0.732454 
interact_SHOPPING_x_TRANSPORTATION    26.517164   604.443825     0.0439     0.965008 
interact_SHOPPING_x_AUTOMOTIVE    23.111582  2740.151589     0.0084      0.99327 
interact_SHOPPING_x_SERVICES     -33.233821   468.696924    -0.0709     0.943472 
interact_SHOPPING_x_FOOD_DRINK    -35.56846   204.916867    -0.1736     0.862199 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    12.869676   567.430563     0.0227     0.981905 
interact_SHOPPING_x_HEALTH_WELLNESS     7.303345  1933.156886     0.0038     0.996986 
interact_SHOPPING_x_PLACE_OF_WORSHIP     8.457654   505.373689     0.0167     0.986648 
interact_AUTOMOTIVE_x_SERVICES    -4.631657   2892.53043    -0.0016     0.998722 
interact_AUTOMOTIVE_x_FOOD_DRINK    10.090001  1985.452692     0.0051     0.995945 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -18.493999  2095.747322    -0.0088     0.992959 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   -24.202115   303.578772    -0.0797     0.936458 
interact_SERVICES_x_FOOD_DRINK    17.972933  2451.005075     0.0073     0.994149 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    43.585084  2018.761361     0.0216     0.982775 
interact_HEALTH_WELLNESS_x_FINANCE    -22.74956  1486.195701    -0.0153     0.987787 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -3.911149   653.880049     -0.006     0.995228 
interact_PLACE_OF_WORSHIP_x_FINANCE     4.570453    210.97229     0.0217     0.982716 
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
high_violence_jenks ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.201057     0.189865   -32.6603          0.0 ***
place_density                     -0.661492     3.044889    -0.2172     0.828016 
interact_SHOPPING_x_TRANSPORTATION     6.792299   282.513498      0.024     0.980819 
interact_SHOPPING_x_AUTOMOTIVE    -1.931776   269.924508    -0.0072      0.99429 
interact_SHOPPING_x_SERVICES      -12.69652   494.390475    -0.0257     0.979512 
interact_SHOPPING_x_FOOD_DRINK   -13.783775   775.522417    -0.0178      0.98582 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     5.749111   143.881327       0.04     0.968127 
interact_SHOPPING_x_HEALTH_WELLNESS    10.144044   308.016286     0.0329     0.973728 
interact_SHOPPING_x_PLACE_OF_WORSHIP     6.712834   470.234447     0.0143      0.98861 
interact_AUTOMOTIVE_x_SERVICES     4.631154   567.961508     0.0082     0.993494 
interact_AUTOMOTIVE_x_FOOD_DRINK     10.90771   367.668787     0.0297     0.976332 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -13.142151    338.35617    -0.0388     0.969017 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP      -5.3571   239.582562    -0.0224     0.982161 
interact_SERVICES_x_FOOD_DRINK     0.760786    522.65986     0.0015     0.998839 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.415589   151.945232     0.0159     0.987316 
interact_HEALTH_WELLNESS_x_FINANCE     0.070381   132.547519     0.0005     0.999576 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.548685    58.696539     0.0093     0.992542 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.727333   104.546285      0.007     0.994449 
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
high_violence_top25 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -4.572421     0.267597    -17.087          0.0 ***
place_density                     -3.597068    12.807423    -0.2809     0.778819 
interact_SHOPPING_x_TRANSPORTATION    31.694462   894.718563     0.0354     0.971742 
interact_SHOPPING_x_AUTOMOTIVE    27.555291  4073.397406     0.0068     0.994603 
interact_SHOPPING_x_SERVICES     -40.165606   705.071481     -0.057     0.954572 
interact_SHOPPING_x_FOOD_DRINK   -42.915665   306.578983      -0.14     0.888674 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION    15.542416   846.059331     0.0184     0.985343 
interact_SHOPPING_x_HEALTH_WELLNESS     9.016241  2877.507111     0.0031       0.9975 
interact_SHOPPING_x_PLACE_OF_WORSHIP    10.617616   754.880614     0.0141     0.988778 
interact_AUTOMOTIVE_x_SERVICES    -4.987639  4308.887132    -0.0012     0.999076 
interact_AUTOMOTIVE_x_FOOD_DRINK    12.482861   2955.81028     0.0042      0.99663 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -22.635705  3122.698694    -0.0072     0.994216 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP   -29.440755   457.884823    -0.0643     0.948734 
interact_SERVICES_x_FOOD_DRINK    21.360038  3643.123311     0.0059     0.995322 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP    52.153344  2996.622199     0.0174     0.986114 
interact_HEALTH_WELLNESS_x_FINANCE   -27.037121  2208.658289    -0.0122     0.990233 
interact_PLACE_OF_WORSHIP_x_EDUCATION    -4.636379   971.854412    -0.0048     0.996194 
interact_PLACE_OF_WORSHIP_x_FINANCE     5.435644   314.245478     0.0173     0.986199 
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
high_violence_top50 ~ 1 + place_density + interact_SHOPPING_x_TRANSPORTATION + interact_SHOPPING_x_AUTOMOTIVE + interact_SHOPPING_x_SERVICES + interact_SHOPPING_x_FOOD_DRINK + interact_SHOPPING_x_ENTERTAINMENT_RECREATION + interact_SHOPPING_x_HEALTH_WELLNESS + interact_SHOPPING_x_PLACE_OF_WORSHIP + interact_AUTOMOTIVE_x_SERVICES + interact_AUTOMOTIVE_x_FOOD_DRINK + interact_AUTOMOTIVE_x_HEALTH_WELLNESS + interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP + interact_SERVICES_x_FOOD_DRINK + interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP + interact_HEALTH_WELLNESS_x_FINANCE + interact_PLACE_OF_WORSHIP_x_EDUCATION + interact_PLACE_OF_WORSHIP_x_FINANCE
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -3.085335     0.041727   -73.9405          0.0 ***
place_density                     -0.683772     0.672196    -1.0172     0.309049 
interact_SHOPPING_x_TRANSPORTATION     6.989878    61.087454     0.1144     0.908902 
interact_SHOPPING_x_AUTOMOTIVE    -2.191829    57.381816    -0.0382      0.96953 
interact_SHOPPING_x_SERVICES     -13.123272   107.976102    -0.1215     0.903264 
interact_SHOPPING_x_FOOD_DRINK   -14.248903    167.95702    -0.0848     0.932391 
interact_SHOPPING_x_ENTERTAINMENT_RECREATION     5.993741    31.347504     0.1912     0.848366 
interact_SHOPPING_x_HEALTH_WELLNESS    10.621956    67.230231      0.158     0.874462 
interact_SHOPPING_x_PLACE_OF_WORSHIP     6.893404    103.17096     0.0668     0.946729 
interact_AUTOMOTIVE_x_SERVICES     5.002385   120.334237     0.0416     0.966841 
interact_AUTOMOTIVE_x_FOOD_DRINK    11.437973    80.305379     0.1424      0.88674 
interact_AUTOMOTIVE_x_HEALTH_WELLNESS   -13.722034    74.223267    -0.1849     0.853327 
interact_AUTOMOTIVE_x_PLACE_OF_WORSHIP    -5.554158    52.561041    -0.1057     0.915844 
interact_SERVICES_x_FOOD_DRINK     0.596099    112.45881     0.0053     0.995771 
interact_HEALTH_WELLNESS_x_PLACE_OF_WORSHIP     2.346748    33.247309     0.0706     0.943728 
interact_HEALTH_WELLNESS_x_FINANCE     0.164509    28.769357     0.0057     0.995438 
interact_PLACE_OF_WORSHIP_x_EDUCATION     0.653249    12.512665     0.0522     0.958364 
interact_PLACE_OF_WORSHIP_x_FINANCE     0.774904    22.872714     0.0339     0.972974 
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

