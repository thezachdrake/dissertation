# Model Results for ARRESTS_COUNTS

Generated: 2025-12-16 20:31:32

---

## Model: high_burglary_jenks

### Formula
```
high_burglary_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -8.433304     0.577413   -14.6053          0.0 ***
SPORTS                            -6.232557   790.085053    -0.0079     0.993706 
SHOPPING                           6.030358   395.352272     0.0153      0.98783 
OTHER                              0.006675   584.177936        0.0     0.999991 
TRANSPORTATION                    -4.116135   342.408051     -0.012     0.990409 
AUTOMOTIVE                        -6.872796   586.751094    -0.0117     0.990654 
SERVICES                          -4.603544   511.407685     -0.009     0.992818 
FOOD_DRINK                        -2.252342   241.948094    -0.0093     0.992572 
ENTERTAINMENT_RECREATION          -5.771923   625.273991    -0.0092     0.992635 
HEALTH_WELLNESS                   -4.238993   344.971733    -0.0123     0.990196 
LODGING                           -4.505934  4586.817106     -0.001     0.999216 
PLACE_OF_WORSHIP                   1.199477   535.923004     0.0022     0.998214 
EDUCATION                          8.877803   916.317781     0.0097      0.99227 
GOVERNMENT                        -6.074281   758.594254     -0.008     0.993611 
BUSINESS                           -1.72216  6854.615432    -0.0003       0.9998 
FINANCE                             27.7199  1809.553838     0.0153     0.987778 
FACILITIES                        42.236926  5586.182344     0.0076     0.993967 
CULTURE                            0.637189  3327.081939     0.0002     0.999847 
place_density                     -0.064187    19.207204    -0.0033     0.997334 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 56.6005
Null Deviance: 56.6529
AIC: 94.6005
BIC: 237.877
McFadden R²: 0.0009
Number of observations: 13917.0
```

---

## Model: high_burglary_top25

### Formula
```
high_burglary_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                        -8.14555     0.500073   -16.2887          0.0 ***
SPORTS                            -6.630751   870.424056    -0.0076     0.993922 
SHOPPING                           6.689209    578.29225     0.0116     0.990771 
OTHER                              -0.04479   622.221038    -0.0001     0.999943 
TRANSPORTATION                    -4.266147   348.125777    -0.0123     0.990222 
AUTOMOTIVE                        -7.148277   707.382135    -0.0101     0.991937 
SERVICES                          -4.733813   546.810145    -0.0087     0.993093 
FOOD_DRINK                        -2.587844   376.846724    -0.0069     0.994521 
ENTERTAINMENT_RECREATION          -5.985641   664.337932     -0.009     0.992811 
HEALTH_WELLNESS                   -4.450823   333.357498    -0.0134     0.989347 
LODGING                            -7.30988  5021.042473    -0.0015     0.998838 
PLACE_OF_WORSHIP                   1.718897   622.968075     0.0028     0.997798 
EDUCATION                           8.79625  1351.823629     0.0065     0.994808 
GOVERNMENT                        -6.893971  1139.207232    -0.0061     0.995172 
BUSINESS                          -8.275101 14267.208889    -0.0006     0.999537 
FINANCE                            30.27979   1698.34429     0.0178     0.985775 
FACILITIES                        47.236628  6637.432853     0.0071     0.994322 
CULTURE                            2.333552   3822.13311     0.0006     0.999513 
place_density                     -0.080658    18.066852    -0.0045     0.996438 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 73.1656
Null Deviance: 73.2354
AIC: 111.1656
BIC: 254.442
McFadden R²: 0.001
Number of observations: 13917.0
```

---

## Model: high_burglary_top50

### Formula
```
high_burglary_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.822996     0.258339    -26.411          0.0 ***
SPORTS                            -6.349448    381.28258    -0.0167     0.986714 
SHOPPING                            6.07086   173.005619     0.0351     0.972008 
OTHER                              0.065488   311.865563     0.0002     0.999832 
TRANSPORTATION                    -4.284671   193.379738    -0.0222     0.982323 
AUTOMOTIVE                        -7.000021   331.850525    -0.0211     0.983171 
SERVICES                          -4.868899   316.563733    -0.0154     0.987729 
FOOD_DRINK                        -2.269905   113.490985      -0.02     0.984043 
ENTERTAINMENT_RECREATION          -6.014751   329.093614    -0.0183     0.985418 
HEALTH_WELLNESS                   -4.443417   170.440066    -0.0261     0.979201 
LODGING                           -1.470217  2952.002893    -0.0005     0.999603 
PLACE_OF_WORSHIP                   0.901418   338.962708     0.0027     0.997878 
EDUCATION                          9.305608   417.265755     0.0223     0.982208 
GOVERNMENT                        -6.242992   386.250749    -0.0162     0.987104 
BUSINESS                          -0.613607  2046.178091    -0.0003     0.999761 
FINANCE                           27.932188   978.074858     0.0286     0.977217 
FACILITIES                         42.90776  2644.200572     0.0162     0.987053 
CULTURE                           -1.600586  2172.788903    -0.0007     0.999412 
place_density                     -0.050958    16.012503    -0.0032     0.997461 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 234.7063
Null Deviance: 234.9683
AIC: 272.7063
BIC: 415.9827
McFadden R²: 0.0011
Number of observations: 13917.0
```

---

## Model: high_drugs_jenks

### Formula
```
high_drugs_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.046357     0.288801   -24.3987          0.0 ***
SPORTS                            -6.684564   515.592347     -0.013     0.989656 
SHOPPING                           6.812293   337.769547     0.0202     0.983909 
OTHER                             -0.059095   377.825361    -0.0002     0.999875 
TRANSPORTATION                    -4.324532   209.320047    -0.0207     0.983517 
AUTOMOTIVE                        -7.262035   417.909213    -0.0174     0.986136 
SERVICES                          -4.790702   330.946306    -0.0145      0.98845 
FOOD_DRINK                        -2.639496   217.960673    -0.0121     0.990338 
ENTERTAINMENT_RECREATION          -6.086432   398.002591    -0.0153     0.987799 
HEALTH_WELLNESS                   -4.539983   201.278633    -0.0226     0.982005 
LODGING                           -7.190483  2930.235691    -0.0025     0.998042 
PLACE_OF_WORSHIP                   1.721444   359.072377     0.0048     0.996175 
EDUCATION                          8.930415   781.471387     0.0114     0.990882 
GOVERNMENT                        -6.968709   672.305821    -0.0104      0.99173 
BUSINESS                          -8.667623  8236.998591    -0.0011      0.99916 
FINANCE                           30.918646   1005.46528     0.0308     0.975468 
FACILITIES                        47.517881  3977.553291     0.0119     0.990468 
CULTURE                            2.163928  2254.123287      0.001     0.999234 
place_density                      -0.08288    10.508464    -0.0079     0.993707 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 193.1231
Null Deviance: 193.3327
AIC: 231.1231
BIC: 374.3995
McFadden R²: 0.0011
Number of observations: 13917.0
```

---

## Model: high_drugs_top25

### Formula
```
high_drugs_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.758385     0.250145   -27.0179          0.0 ***
SPORTS                            -6.932255   547.992165    -0.0127     0.989907 
SHOPPING                           7.398826   413.825377     0.0179     0.985735 
OTHER                             -0.407445   494.857095    -0.0008     0.999343 
TRANSPORTATION                    -4.777001   251.029962     -0.019     0.984817 
AUTOMOTIVE                        -8.026037   451.283727    -0.0178      0.98581 
SERVICES                          -4.926919   427.274074    -0.0115       0.9908 
FOOD_DRINK                        -2.785435   263.716713    -0.0106     0.991573 
ENTERTAINMENT_RECREATION          -6.688111   461.870693    -0.0145     0.988447 
HEALTH_WELLNESS                   -5.181561    240.92559    -0.0215     0.982841 
LODGING                           -6.560506  3515.349633    -0.0019     0.998511 
PLACE_OF_WORSHIP                   1.604284   469.446579     0.0034     0.997273 
EDUCATION                          9.849979   937.139808     0.0105     0.991614 
GOVERNMENT                        -7.172093   897.882798     -0.008     0.993627 
BUSINESS                           -5.91373  9993.913661    -0.0006     0.999528 
FINANCE                           34.639298  1186.713505     0.0292     0.976714 
FACILITIES                        47.300749  5214.160067     0.0091     0.992762 
CULTURE                            1.293194  2732.682332     0.0005     0.999622 
place_density                     -0.095925    12.423026    -0.0077     0.993839 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 248.2869
Null Deviance: 248.5665
AIC: 286.2869
BIC: 429.5634
McFadden R²: 0.0011
Number of observations: 13917.0
```

---

## Model: high_drugs_top50

### Formula
```
high_drugs_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.025779     0.105755    -47.523          0.0 ***
SPORTS                            -6.693988   188.610968    -0.0355     0.971688 
SHOPPING                            6.83245   123.195906     0.0555     0.955772 
OTHER                             -0.060164   138.541098    -0.0004     0.999654 
TRANSPORTATION                    -4.333464    76.735474    -0.0565     0.954965 
AUTOMOTIVE                        -7.283298   152.760942    -0.0477     0.961973 
SERVICES                          -4.801732   121.294837    -0.0396     0.968422 
FOOD_DRINK                        -2.647652    79.329693    -0.0334     0.973375 
ENTERTAINMENT_RECREATION          -6.102179   145.767985    -0.0419     0.966608 
HEALTH_WELLNESS                   -4.555252    73.862863    -0.0617     0.950824 
LODGING                           -7.188507  1068.767938    -0.0067     0.994633 
PLACE_OF_WORSHIP                   1.722237   130.689828     0.0132     0.989486 
EDUCATION                           8.95732   284.688059     0.0315       0.9749 
GOVERNMENT                        -6.978545   245.607385    -0.0284     0.977332 
BUSINESS                          -8.714604  2998.088067    -0.0029     0.997681 
FINANCE                           31.031941   367.839994     0.0844     0.932768 
FACILITIES                         47.55493  1457.346863     0.0326     0.973969 
CULTURE                            2.153936   823.194039     0.0026     0.997912 
place_density                     -0.083334     3.830768    -0.0218     0.982644 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 1085.2304
Null Deviance: 1086.8069
AIC: 1123.2304
BIC: 1266.5068
McFadden R²: 0.0015
Number of observations: 13917.0
```

---

## Model: high_larceny_jenks

### Formula
```
high_larceny_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -5.946002     0.166885   -35.6294          0.0 ***
SPORTS                            -6.714061   304.140349    -0.0221     0.982388 
SHOPPING                           6.927131   198.727417     0.0349     0.972193 
OTHER                             -0.094978   231.432521    -0.0004     0.999673 
TRANSPORTATION                    -4.379767   126.196791    -0.0347     0.972314 
AUTOMOTIVE                        -7.385764   245.756373    -0.0301     0.976025 
SERVICES                           -4.82451   201.999855    -0.0239     0.980945 
FOOD_DRINK                        -2.681997   126.687562    -0.0212      0.98311 
ENTERTAINMENT_RECREATION          -6.191734   239.124451    -0.0259     0.979342 
HEALTH_WELLNESS                   -4.634368   121.787133    -0.0381     0.969645 
LODGING                            -6.95222  1725.257133     -0.004     0.996785 
PLACE_OF_WORSHIP                   1.697171   209.539143     0.0081     0.993538 
EDUCATION                          9.073584   454.535559       0.02     0.984073 
GOVERNMENT                        -7.000846   406.326073    -0.0172     0.986253 
BUSINESS                          -8.862371  4797.995725    -0.0018     0.998526 
FINANCE                           31.608118   598.009706     0.0529     0.957847 
FACILITIES                        47.389889  2427.863157     0.0195     0.984427 
CULTURE                            1.906796  1340.852119     0.0014     0.998865 
place_density                     -0.085453     6.185143    -0.0138     0.988977 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 500.2064
Null Deviance: 500.8358
AIC: 538.2064
BIC: 681.4829
McFadden R²: 0.0013
Number of observations: 13917.0
```

---

## Model: high_larceny_top25

### Formula
```
high_larceny_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.334257     0.333442   -21.9956          0.0 ***
SPORTS                            -6.428582   527.069116    -0.0122     0.990269 
SHOPPING                           6.393754   385.087157     0.0166     0.986753 
OTHER                             -0.037923   372.297314    -0.0001     0.999919 
TRANSPORTATION                    -4.135808    214.16799    -0.0193     0.984593 
AUTOMOTIVE                        -6.945473   436.208154    -0.0159     0.987296 
SERVICES                          -4.579949   326.964439     -0.014     0.988824 
FOOD_DRINK                        -2.452239   254.210179    -0.0096     0.992303 
ENTERTAINMENT_RECREATION          -5.802812   405.413299    -0.0143      0.98858 
HEALTH_WELLNESS                   -4.287064   204.533523     -0.021     0.983277 
LODGING                           -7.098732  3127.339752    -0.0023     0.998189 
PLACE_OF_WORSHIP                   1.594058   436.662352     0.0037     0.997087 
EDUCATION                          8.606917   891.434071     0.0097     0.992296 
GOVERNMENT                        -6.565117   757.479815    -0.0087     0.993085 
BUSINESS                           -6.58667  9477.872921    -0.0007     0.999446 
FINANCE                           29.058058  1073.935615     0.0271     0.978414 
FACILITIES                        45.181448  4276.973238     0.0106     0.991571 
CULTURE                            2.311629  2337.736772      0.001     0.999211 
place_density                     -0.076532    11.481889    -0.0067     0.994682 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 150.0225
Null Deviance: 150.1797
AIC: 188.0225
BIC: 331.299
McFadden R²: 0.001
Number of observations: 13917.0
```

---

## Model: high_larceny_top50

### Formula
```
high_larceny_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.033232     0.174286   -34.6168          0.0 ***
SPORTS                            -6.689978   311.617553    -0.0215     0.982872 
SHOPPING                           6.826676   203.888308     0.0335      0.97329 
OTHER                             -0.061393    229.06484    -0.0003     0.999786 
TRANSPORTATION                    -4.331167   126.765575    -0.0342     0.972744 
AUTOMOTIVE                        -7.276814   252.495139    -0.0288     0.977008 
SERVICES                          -4.796924   200.570862    -0.0239     0.980919 
FOOD_DRINK                        -2.645234   131.390656    -0.0201     0.983938 
ENTERTAINMENT_RECREATION          -6.098584   240.924704    -0.0253     0.979805 
HEALTH_WELLNESS                   -4.551083   121.968623    -0.0373     0.970235 
LODGING                           -7.174991  1768.704419    -0.0041     0.996763 
PLACE_OF_WORSHIP                   1.720426   216.447888     0.0079     0.993658 
EDUCATION                          8.948336   471.156726      0.019     0.984847 
GOVERNMENT                        -6.974944    406.57569    -0.0172     0.986313 
BUSINESS                          -8.701617  4965.394626    -0.0018     0.998602 
FINANCE                           31.000157   607.938015      0.051     0.959332 
FACILITIES                        47.529014  2409.360194     0.0197     0.984261 
CULTURE                            2.143964  1362.133233     0.0016     0.998744 
place_density                     -0.083187     6.341396    -0.0131     0.989534 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 464.2725
Null Deviance: 464.8494
AIC: 502.2725
BIC: 645.549
McFadden R²: 0.0012
Number of observations: 13917.0
```

---

## Model: high_violence_jenks

### Formula
```
high_violence_jenks ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -6.758385     0.250145   -27.0179          0.0 ***
SPORTS                            -6.932255   547.992165    -0.0127     0.989907 
SHOPPING                           7.398826   413.825377     0.0179     0.985735 
OTHER                             -0.407445   494.857095    -0.0008     0.999343 
TRANSPORTATION                    -4.777001   251.029962     -0.019     0.984817 
AUTOMOTIVE                        -8.026037   451.283727    -0.0178      0.98581 
SERVICES                          -4.926919   427.274074    -0.0115       0.9908 
FOOD_DRINK                        -2.785435   263.716713    -0.0106     0.991573 
ENTERTAINMENT_RECREATION          -6.688111   461.870693    -0.0145     0.988447 
HEALTH_WELLNESS                   -5.181561    240.92559    -0.0215     0.982841 
LODGING                           -6.560506  3515.349633    -0.0019     0.998511 
PLACE_OF_WORSHIP                   1.604284   469.446579     0.0034     0.997273 
EDUCATION                          9.849979   937.139808     0.0105     0.991614 
GOVERNMENT                        -7.172093   897.882798     -0.008     0.993627 
BUSINESS                           -5.91373  9993.913661    -0.0006     0.999528 
FINANCE                           34.639298  1186.713505     0.0292     0.976714 
FACILITIES                        47.300749  5214.160067     0.0091     0.992762 
CULTURE                            1.293194  2732.682332     0.0005     0.999622 
place_density                     -0.095925    12.423026    -0.0077     0.993839 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 248.2869
Null Deviance: 248.5665
AIC: 286.2869
BIC: 429.5634
McFadden R²: 0.0011
Number of observations: 13917.0
```

---

## Model: high_violence_top25

### Formula
```
high_violence_top25 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -7.046357     0.288801   -24.3987          0.0 ***
SPORTS                            -6.684564   515.592347     -0.013     0.989656 
SHOPPING                           6.812293   337.769547     0.0202     0.983909 
OTHER                             -0.059095   377.825361    -0.0002     0.999875 
TRANSPORTATION                    -4.324532   209.320047    -0.0207     0.983517 
AUTOMOTIVE                        -7.262035   417.909213    -0.0174     0.986136 
SERVICES                          -4.790702   330.946306    -0.0145      0.98845 
FOOD_DRINK                        -2.639496   217.960673    -0.0121     0.990338 
ENTERTAINMENT_RECREATION          -6.086432   398.002591    -0.0153     0.987799 
HEALTH_WELLNESS                   -4.539983   201.278633    -0.0226     0.982005 
LODGING                           -7.190483  2930.235691    -0.0025     0.998042 
PLACE_OF_WORSHIP                   1.721444   359.072377     0.0048     0.996175 
EDUCATION                          8.930415   781.471387     0.0114     0.990882 
GOVERNMENT                        -6.968709   672.305821    -0.0104      0.99173 
BUSINESS                          -8.667623  8236.998591    -0.0011      0.99916 
FINANCE                           30.918646   1005.46528     0.0308     0.975468 
FACILITIES                        47.517881  3977.553291     0.0119     0.990468 
CULTURE                            2.163928  2254.123287      0.001     0.999234 
place_density                      -0.08288    10.508464    -0.0079     0.993707 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 193.1231
Null Deviance: 193.3327
AIC: 231.1231
BIC: 374.3995
McFadden R²: 0.0011
Number of observations: 13917.0
```

---

## Model: high_violence_top50

### Formula
```
high_violence_top50 ~ 1 + SPORTS + SHOPPING + OTHER + TRANSPORTATION + AUTOMOTIVE + SERVICES + FOOD_DRINK + ENTERTAINMENT_RECREATION + HEALTH_WELLNESS + LODGING + PLACE_OF_WORSHIP + EDUCATION + GOVERNMENT + BUSINESS + FINANCE + FACILITIES + CULTURE + place_density
```

### Coefficients
```
Term                               Estimate    Std.Error    z value     Pr(>|z|)
────────────────────────────────────────────────────────────────────────────────
(Intercept)                       -4.744347     0.092068    -51.531          0.0 ***
SPORTS                            -6.938663   200.606305    -0.0346     0.972408 
SHOPPING                           7.403915   152.921245     0.0484     0.961384 
OTHER                             -0.397101   180.457192    -0.0022     0.998244 
TRANSPORTATION                     -4.78389    92.028379     -0.052     0.958542 
AUTOMOTIVE                        -8.035786   165.840203    -0.0485     0.961354 
SERVICES                           -4.94454   155.841188    -0.0317     0.974689 
FOOD_DRINK                        -2.788186    97.580678    -0.0286     0.977205 
ENTERTAINMENT_RECREATION          -6.693724   169.004704    -0.0396     0.968407 
HEALTH_WELLNESS                   -5.189987    88.388831    -0.0587     0.953177 
LODGING                            -6.64185  1284.435816    -0.0052     0.995874 
PLACE_OF_WORSHIP                   1.613258   173.950099     0.0093       0.9926 
EDUCATION                          9.870304   345.946449     0.0285     0.977238 
GOVERNMENT                         -7.17812   330.003002    -0.0218     0.982646 
BUSINESS                          -5.891281  3686.542881    -0.0016     0.998725 
FINANCE                           34.668006   435.677326     0.0796     0.936577 
FACILITIES                        47.382478  1912.696863     0.0248     0.980236 
CULTURE                            1.362326   997.128297     0.0014      0.99891 
place_density                     -0.095955     4.545717    -0.0211     0.983159 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 1368.1875
Null Deviance: 1370.2744
AIC: 1406.1875
BIC: 1549.4639
McFadden R²: 0.0015
Number of observations: 13917.0
```

---

