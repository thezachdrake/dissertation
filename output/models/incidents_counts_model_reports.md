# Model Results for INCIDENTS_COUNTS

Generated: 2025-12-09 15:40:32

---

## Model: high_burglary_jenks

### Formula
```
high_burglary_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -8.792523     0.987505    -8.9038          0.0 ***
SPORTS                            -2.693979  1139.422026    -0.0024     0.998114 
SHOPPING                           3.882026  1153.215022     0.0034     0.997314 
OTHER                              1.779156  1138.095666     0.0016     0.998753 
TRANSPORTATION                     -1.11362  1135.664846     -0.001     0.999218 
AUTOMOTIVE                        -0.868576  1138.242166    -0.0008     0.999391 
SERVICES                          -1.110705  1108.711508     -0.001     0.999201 
FOOD_DRINK                         0.707669  1092.112316     0.0006     0.999483 
ENTERTAINMENT_RECREATION          -0.764907  1135.046402    -0.0007     0.999462 
HEALTH_WELLNESS                    1.835212  1090.851948     0.0017     0.998658 
LODGING                          -10.922662  1714.483195    -0.0064     0.994917 
PLACE_OF_WORSHIP                   3.287979  1205.117307     0.0027     0.997823 
EDUCATION                          4.839134  1005.940058     0.0048     0.996162 
GOVERNMENT                        -3.074865  1056.365869    -0.0029     0.997678 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                            5.489799  1210.397713     0.0045     0.996381 
FACILITIES                         36.97061  2289.266135     0.0161     0.987115 
CULTURE                            8.717873  1294.976407     0.0067     0.994629 
total_crime                        0.027411     0.004423     6.1972          0.0 ***
total_places                      -1.543091  1109.319421    -0.0014      0.99889 
street_length_meters              -0.007665     0.009392    -0.8161     0.414437 
place_density                      0.019012     2.519557     0.0075     0.993979 
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
high_burglary_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.057572     0.170911   -35.4429          0.0 ***
SPORTS                             1.876799  4676.980623     0.0004      0.99968 
SHOPPING                          15.423535  4782.447479     0.0032     0.997427 
OTHER                              8.522753  4637.168145     0.0018     0.998534 
TRANSPORTATION                     4.233614  4640.743822     0.0009     0.999272 
AUTOMOTIVE                         1.313682  4762.432305     0.0003      0.99978 
SERVICES                           3.815334   4549.28634     0.0008     0.999331 
FOOD_DRINK                         5.933256  4507.960596     0.0013      0.99895 
ENTERTAINMENT_RECREATION           2.463646  4539.977357     0.0005     0.999567 
HEALTH_WELLNESS                    3.889902  4621.446958     0.0008     0.999328 
LODGING                            1.773901  6068.261417     0.0003     0.999767 
PLACE_OF_WORSHIP                  10.311546  4797.914124     0.0021     0.998285 
EDUCATION                          17.44356  4267.041095     0.0041     0.996738 
GOVERNMENT                         1.585328  4304.286222     0.0004     0.999706 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           39.674307  4405.564955      0.009     0.992815 
FACILITIES                        56.088135  6292.662678     0.0089     0.992888 
CULTURE                           10.355714  3744.069631     0.0028     0.997793 
total_crime                        0.029503     0.002344    12.5886          0.0 ***
total_places                       -8.58312  4620.329945    -0.0019     0.998518 
street_length_meters               0.000597     0.000248     2.4085      0.01602 *
place_density                     -0.082848     5.953283    -0.0139     0.988897 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 560.6525
Null Deviance: 762.4223
AIC: 602.6525
BIC: 761.0107
McFadden R²: 0.2646
Number of observations: 13917.0
```

---

## Model: high_burglary_top50

### Formula
```
high_burglary_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -3.982473     0.064659   -61.5919          0.0 ***
SPORTS                             1.819169  1617.642735     0.0011     0.999103 
SHOPPING                          15.457026  1658.698432     0.0093     0.992565 
OTHER                                8.4942  1607.424254     0.0053     0.995784 
TRANSPORTATION                     4.156435  1611.256664     0.0026     0.997942 
AUTOMOTIVE                         1.209269  1650.859636     0.0007     0.999416 
SERVICES                           3.741743   1578.12058     0.0024     0.998108 
FOOD_DRINK                         5.886781  1563.669689     0.0038     0.996996 
ENTERTAINMENT_RECREATION           2.372608  1575.897883     0.0015     0.998799 
HEALTH_WELLNESS                    3.784573  1602.688836     0.0024     0.998116 
LODGING                            1.743202  2100.545957     0.0008     0.999338 
PLACE_OF_WORSHIP                  10.306152  1663.081844     0.0062     0.995056 
EDUCATION                         17.501819  1481.739706     0.0118     0.990576 
GOVERNMENT                         1.520397  1491.323705      0.001     0.999187 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           39.998872  1533.737924     0.0261     0.979194 
FACILITIES                        56.267819  2204.106981     0.0255     0.979633 
CULTURE                           10.308089  1305.172596     0.0079     0.993698 
total_crime                        0.034034     0.002292    14.8474          0.0 ***
total_places                      -8.556267   1602.25803    -0.0053     0.995739 
street_length_meters               0.000644     0.000159     4.0552       5.0e-5 ***
place_density                     -0.083733     2.080322    -0.0403     0.967894 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 2919.6344
Null Deviance: 3254.5348
AIC: 2961.6344
BIC: 3119.9926
McFadden R²: 0.1029
Number of observations: 13917.0
```

---

## Model: high_drugs_jenks

### Formula
```
high_drugs_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.280199     0.337101   -21.5965          0.0 ***
SPORTS                             1.077944  9362.613708     0.0001     0.999908 
SHOPPING                           14.14096  9524.786493     0.0015     0.998815 
OTHER                              7.576925  9234.927236     0.0008     0.999345 
TRANSPORTATION                     3.438968  9208.733506     0.0004     0.999702 
AUTOMOTIVE                         0.599889  9486.667862     0.0001      0.99995 
SERVICES                           2.987198  9063.105467     0.0003     0.999737 
FOOD_DRINK                         5.085944  8971.350905     0.0006     0.999548 
ENTERTAINMENT_RECREATION           1.734307  9024.849651     0.0002     0.999847 
HEALTH_WELLNESS                    3.218818  9201.838998     0.0003     0.999721 
LODGING                            0.467173 12060.930178        0.0     0.999969 
PLACE_OF_WORSHIP                   9.255419  9567.065662      0.001     0.999228 
EDUCATION                         16.242249   8456.59661     0.0019     0.998468 
GOVERNMENT                         0.887053  8571.263375     0.0001     0.999917 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           37.241567  8723.651286     0.0043     0.996594 
FACILITIES                          53.6772 12281.497554     0.0044     0.996513 
CULTURE                             9.90414  7375.337598     0.0013     0.998929 
total_crime                        0.015802     0.002488     6.3509          0.0 ***
total_places                      -7.609932  9200.783131    -0.0008      0.99934 
street_length_meters               0.000263     0.001085     0.2425     0.808408 
place_density                     -0.078793    11.551347    -0.0068     0.994558 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 179.3346
Null Deviance: 207.3617
AIC: 221.3346
BIC: 379.6928
McFadden R²: 0.1352
Number of observations: 13917.0
```

---

## Model: high_drugs_top25

### Formula
```
high_drugs_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.467522     0.361002   -20.6855          0.0 ***
SPORTS                            -3.722005  6076.818001    -0.0006     0.999511 
SHOPPING                           8.598126  6274.944545     0.0014     0.998907 
OTHER                              2.532333  6032.218334     0.0004     0.999665 
TRANSPORTATION                    -1.545229  6076.498055    -0.0003     0.999797 
AUTOMOTIVE                        -4.321995  6192.518768    -0.0007     0.999443 
SERVICES                           -2.00425    6062.0519    -0.0003     0.999736 
FOOD_DRINK                         0.241777  5856.507849        0.0     0.999967 
ENTERTAINMENT_RECREATION            -3.2328  6046.720488    -0.0005     0.999573 
HEALTH_WELLNESS                   -1.748135  6035.132149    -0.0003     0.999769 
LODGING                           -2.503361  6254.214892    -0.0004     0.999681 
PLACE_OF_WORSHIP                   3.766791  6365.040147     0.0006     0.999528 
EDUCATION                         11.286456  5508.788754      0.002     0.998365 
GOVERNMENT                        -3.562894  5620.160938    -0.0006     0.999494 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           30.497868  6429.145795     0.0047     0.996215 
FACILITIES                        44.708751  8551.110331     0.0052     0.995828 
CULTURE                            3.558257  6640.144309     0.0005     0.999572 
total_crime                        0.015618     0.002587     6.0383          0.0 ***
total_places                      -2.527792  6029.820521    -0.0004     0.999666 
street_length_meters               0.000353     0.000928     0.3803     0.703711 
place_density                     -0.067923    12.860088    -0.0053     0.995786 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 153.8147
Null Deviance: 179.1367
AIC: 195.8147
BIC: 354.1729
McFadden R²: 0.1414
Number of observations: 13917.0
```

---

## Model: high_drugs_top50

### Formula
```
high_drugs_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.616177     0.169104   -33.2113          0.0 ***
SPORTS                            -4.956269  3578.975951    -0.0014     0.998895 
SHOPPING                           8.872004  3697.299354     0.0024     0.998085 
OTHER                              1.777128  3554.297878     0.0005     0.999601 
TRANSPORTATION                    -2.804115   3581.04972    -0.0008     0.999375 
AUTOMOTIVE                         -5.92744  3648.742624    -0.0016     0.998704 
SERVICES                          -3.232454   3572.27985    -0.0009     0.999278 
FOOD_DRINK                        -0.684921  3450.777441    -0.0002     0.999842 
ENTERTAINMENT_RECREATION          -4.637965  3562.886787    -0.0013     0.998961 
HEALTH_WELLNESS                   -3.074327  3555.961705    -0.0009      0.99931 
LODGING                           -3.990253  3660.799254    -0.0011      0.99913 
PLACE_OF_WORSHIP                   3.319426  3750.590992     0.0009     0.999294 
EDUCATION                         11.995804  3245.919484     0.0037     0.997051 
GOVERNMENT                        -4.922455  3312.051012    -0.0015     0.998814 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           34.388314  3786.587768     0.0091     0.992754 
FACILITIES                        48.476929  5043.468061     0.0096     0.992331 
CULTURE                            3.131714   3920.13738     0.0008     0.999363 
total_crime                         0.01919     0.001892    10.1452          0.0 ***
total_places                       -1.91095  3552.811381    -0.0005     0.999571 
street_length_meters              -0.000121     0.000957    -0.1266     0.899276 
place_density                     -0.079999     7.472017    -0.0107     0.991458 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 716.9702
Null Deviance: 805.8286
AIC: 758.9702
BIC: 917.3284
McFadden R²: 0.1103
Number of observations: 13917.0
```

---

## Model: high_larceny_jenks

### Formula
```
high_larceny_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                      -10.065907     1.307845    -7.6966          0.0 ***
SPORTS                            -1.339053   521.725345    -0.0026     0.997952 
SHOPPING                           0.841038   485.781887     0.0017     0.998619 
OTHER                              0.685097   519.672155     0.0013     0.998948 
TRANSPORTATION                    -0.326404   505.628823    -0.0006     0.999485 
AUTOMOTIVE                         0.068862   519.193356     0.0001     0.999894 
SERVICES                          -0.039561    492.62398    -0.0001     0.999936 
FOOD_DRINK                         0.127662   487.938544     0.0003     0.999791 
ENTERTAINMENT_RECREATION            -0.2879   501.831981    -0.0006     0.999542 
HEALTH_WELLNESS                    0.685716    475.48605     0.0014     0.998849 
LODGING                           -3.347951  1037.805226    -0.0032     0.997426 
PLACE_OF_WORSHIP                   0.396115    528.97911     0.0007     0.999403 
EDUCATION                           0.98024   470.917839     0.0021     0.998339 
GOVERNMENT                        -1.034539   545.432234    -0.0019     0.998487 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           -0.301694   643.904588    -0.0005     0.999626 
FACILITIES                        10.822346  1433.621351     0.0075     0.993977 
CULTURE                            2.059983   672.359952     0.0031     0.997555 
total_crime                        0.131719     0.016505     7.9808          0.0 ***
total_places                      -0.362224   487.269284    -0.0007     0.999407 
street_length_meters              -0.011273     0.005675    -1.9864     0.046993 *
place_density                      0.004002     0.656485     0.0061     0.995136 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 67.6766
Null Deviance: 933.1018
AIC: 109.6766
BIC: 268.0348
McFadden R²: 0.9275
Number of observations: 13917.0
```

---

## Model: high_larceny_top25

### Formula
```
high_larceny_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                         -9.3517     1.059744    -8.8245          0.0 ***
SPORTS                             -4.41715  8327.817744    -0.0005     0.999577 
SHOPPING                            5.37787  8528.008453     0.0006     0.999497 
OTHER                              1.629672  8328.722935     0.0002     0.999844 
TRANSPORTATION                    -2.901201   8260.13945    -0.0004      0.99972 
AUTOMOTIVE                        -3.417279  8274.295611    -0.0004      0.99967 
SERVICES                          -3.297485  8126.811602    -0.0004     0.999676 
FOOD_DRINK                        -0.161774  8020.217582       -0.0     0.999984 
ENTERTAINMENT_RECREATION          -2.977013  8231.392422    -0.0004     0.999711 
HEALTH_WELLNESS                   -0.764704  8219.456888    -0.0001     0.999926 
LODGING                           -4.536742  9975.202975    -0.0005     0.999637 
PLACE_OF_WORSHIP                   3.117862  8588.367466     0.0004      0.99971 
EDUCATION                          7.411041   7943.03241     0.0009     0.999256 
GOVERNMENT                        -5.467904    7565.4114    -0.0007     0.999423 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           14.053677  9822.949251     0.0014     0.998858 
FACILITIES                        47.802588 12152.156069     0.0039     0.996861 
CULTURE                            3.941761  8196.408838     0.0005     0.999616 
total_crime                        0.071327     0.008222     8.6756          0.0 ***
total_places                       -1.27859  8206.042231    -0.0002     0.999876 
street_length_meters              -0.005225     0.006349     -0.823     0.410516 
place_density                      0.034739     7.309947     0.0048     0.996208 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 62.0407
Null Deviance: 488.8982
AIC: 104.0407
BIC: 262.3989
McFadden R²: 0.8731
Number of observations: 13917.0
```

---

## Model: high_larceny_top50

### Formula
```
high_larceny_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.062756     0.338417     -20.87          0.0 ***
SPORTS                            -1.912279   420.428872    -0.0045     0.996371 
SHOPPING                            4.24331   428.362312     0.0099     0.992096 
OTHER                               2.26072   425.455883     0.0053      0.99576 
TRANSPORTATION                    -0.382568   420.609477    -0.0009     0.999274 
AUTOMOTIVE                        -0.208934   420.749088    -0.0005     0.999604 
SERVICES                          -0.431256   409.896923    -0.0011     0.999161 
FOOD_DRINK                         1.222056   405.197794      0.003     0.997594 
ENTERTAINMENT_RECREATION          -0.271602   422.311196    -0.0006     0.999487 
HEALTH_WELLNESS                    2.201615   404.483576     0.0054     0.995657 
LODGING                           -9.050242   637.250088    -0.0142     0.988669 
PLACE_OF_WORSHIP                   3.635057   443.047419     0.0082     0.993454 
EDUCATION                          5.076582    376.59187     0.0135     0.989245 
GOVERNMENT                        -2.281621   389.913162    -0.0059     0.995331 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                             5.85428   452.122168     0.0129     0.989669 
FACILITIES                        35.810756    839.14549     0.0427      0.96596 
CULTURE                            8.214681   477.728326     0.0172     0.986281 
total_crime                        0.206995      0.01176    17.6023          0.0 ***
total_places                      -2.035358   412.082293    -0.0049     0.996059 
street_length_meters              -0.006241     0.002217    -2.8152     0.004875 **
place_density                      0.018501     1.029292      0.018     0.985659 
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
high_violence_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.715834     0.237959   -28.2227          0.0 ***
SPORTS                            -5.004602  1636.576319    -0.0031      0.99756 
SHOPPING                           6.636456  1671.798415      0.004     0.996833 
OTHER                               1.08257  1623.671384     0.0007     0.999468 
TRANSPORTATION                    -2.975081  1642.323444    -0.0018     0.998555 
AUTOMOTIVE                        -5.496431  1667.169256    -0.0033     0.997369 
SERVICES                          -3.500183  1627.835387    -0.0022     0.998284 
FOOD_DRINK                        -1.157757  1567.471905    -0.0007     0.999411 
ENTERTAINMENT_RECREATION          -4.613976  1633.781363    -0.0028     0.997747 
HEALTH_WELLNESS                   -3.171256  1614.195034     -0.002     0.998432 
LODGING                           -1.119305  2249.005747    -0.0005     0.999603 
PLACE_OF_WORSHIP                   1.903455  1707.893637     0.0011     0.999111 
EDUCATION                          9.490676  1486.865983     0.0064     0.994907 
GOVERNMENT                        -4.806926  1525.936907    -0.0032     0.997487 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                           26.818592  1801.048124     0.0149      0.98812 
FACILITIES                        41.020891  2849.888998     0.0144     0.988516 
CULTURE                           -0.158322  2165.174278    -0.0001     0.999942 
total_crime                        0.021527     0.002109    10.2089          0.0 ***
total_places                      -0.974544  1609.792286    -0.0006     0.999517 
street_length_meters               0.000573     0.000336     1.7072     0.087784 .
place_density                     -0.050932     8.003419    -0.0064     0.994923 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 313.5194
Null Deviance: 403.6287
AIC: 355.5194
BIC: 513.8776
McFadden R²: 0.2232
Number of observations: 13917.0
```

---

## Model: high_violence_top25

### Formula
```
high_violence_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -4.99723     0.103039   -48.4982          0.0 ***
SPORTS                             1.803667  2743.130385     0.0007     0.999475 
SHOPPING                          15.417506  2811.048835     0.0055     0.995624 
OTHER                              8.452141  2725.149077     0.0031     0.997525 
TRANSPORTATION                     4.133429  2729.080561     0.0015     0.998792 
AUTOMOTIVE                         1.188779  2797.455193     0.0004     0.999661 
SERVICES                           3.727464  2673.915942     0.0014     0.998888 
FOOD_DRINK                         5.860985  2649.711383     0.0022     0.998235 
ENTERTAINMENT_RECREATION           2.347966  2670.110612     0.0009     0.999298 
HEALTH_WELLNESS                    3.773146  2716.087002     0.0014     0.998892 
LODGING                            1.758332  3555.931103     0.0005     0.999605 
PLACE_OF_WORSHIP                  10.259883  2818.950358     0.0036     0.997096 
EDUCATION                         17.462429  2510.164145      0.007     0.994449 
GOVERNMENT                         1.504875  2527.069324     0.0006     0.999525 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                            39.92568  2597.276905     0.0154     0.987735 
FACILITIES                         56.08222  3727.264966      0.015     0.987995 
CULTURE                           10.240442  2212.904797     0.0046     0.996308 
total_crime                        0.032374     0.002376    13.6247          0.0 ***
total_places                      -8.525862  2715.389792    -0.0031     0.997495 
street_length_meters               0.000596     0.000188     3.1646     0.001553 **
place_density                     -0.083645     3.511189    -0.0238     0.980994 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 1323.1776
Null Deviance: 1593.8398
AIC: 1365.1776
BIC: 1523.5358
McFadden R²: 0.1698
Number of observations: 13917.0
```

---

## Model: high_violence_top50

### Formula
```
high_violence_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + total_crime + total_places + street_length_meters + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -3.744145     0.058341    -64.177          0.0 ***
SPORTS                            -6.301133    639.94474    -0.0098     0.992144 
SHOPPING                           7.274293   655.100468     0.0111      0.99114 
OTHER                              0.499871   635.774816     0.0008     0.999373 
TRANSPORTATION                    -4.167742   642.287805    -0.0065     0.994823 
AUTOMOTIVE                        -7.189579   652.019251     -0.011     0.991202 
SERVICES                          -4.677032   636.898184    -0.0073     0.994141 
FOOD_DRINK                        -1.996828   613.999201    -0.0033     0.997405 
ENTERTAINMENT_RECREATION          -5.989126   638.724848    -0.0094     0.992519 
HEALTH_WELLNESS                    -4.57954   632.278851    -0.0072     0.994221 
LODGING                           -3.328356   838.982268     -0.004     0.996835 
PLACE_OF_WORSHIP                   1.768627   668.006834     0.0026     0.997888 
EDUCATION                         10.600736   582.031032     0.0182     0.985469 
GOVERNMENT                        -6.157813   595.725499    -0.0103     0.991753 
BUSINESS                                0.0          NaN        NaN          NaN 
FINANCE                            32.26339   698.152669     0.0462     0.963141 
FACILITIES                        46.393531  1077.069298     0.0431     0.965643 
CULTURE                            0.342417   815.629462     0.0004     0.999665 
total_crime                        0.098903     0.004405    22.4508          0.0 ***
total_places                       -0.52225   630.785085    -0.0008     0.999339 
street_length_meters               0.000587     0.000153     3.8448     0.000121 ***
place_density                     -0.069995     2.691588     -0.026     0.979253 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 3884.0879
Null Deviance: 4977.4317
AIC: 3926.0879
BIC: 4084.4461
McFadden R²: 0.2197
Number of observations: 13917.0
```

---

