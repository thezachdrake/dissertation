# Model Results for INCIDENTS_COUNTS

Generated: 2025-12-16 20:24:03

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
(Intercept)                        -7.73994     0.408337   -18.9548          0.0 ***
SPORTS                            -6.056766   547.112234    -0.0111     0.991167 
SHOPPING                           6.185642   626.573611     0.0099     0.992123 
OTHER                             -0.181132   452.600827    -0.0004     0.999681 
TRANSPORTATION                    -4.024013   255.521625    -0.0157     0.987435 
AUTOMOTIVE                        -6.810991   516.688633    -0.0132     0.989483 
SERVICES                          -4.271662   400.117488    -0.0107     0.991482 
FOOD_DRINK                        -2.333845   427.022112    -0.0055     0.995639 
ENTERTAINMENT_RECREATION          -5.720545   451.501694    -0.0127     0.989891 
HEALTH_WELLNESS                   -4.213877   241.522956    -0.0174      0.98608 
LODGING                           -5.066252  4006.501428    -0.0013     0.998991 
PLACE_OF_WORSHIP                   1.235014   813.673985     0.0015     0.998789 
EDUCATION                          8.459946   1366.87711     0.0062     0.995062 
GOVERNMENT                        -6.090852  1132.175208    -0.0054     0.995708 
BUSINESS                          -4.516185 14422.327719    -0.0003      0.99975 
FINANCE                           28.425756  1506.568954     0.0189     0.984947 
FACILITIES                        40.824301   5983.25352     0.0068     0.994556 
CULTURE                            0.708149   2722.44488     0.0003     0.999792 
place_density                     -0.075785    15.795768    -0.0048     0.996172 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 104.8819
Null Deviance: 104.9867
AIC: 142.8819
BIC: 286.1584
McFadden R²: 0.001
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
(Intercept)                       -5.450311     0.130468    -41.775          0.0 ***
SPORTS                            -6.200053   175.206937    -0.0354     0.971771 
SHOPPING                           5.984139    82.449389     0.0726     0.942141 
OTHER                              0.018863    129.64355     0.0001     0.999884 
TRANSPORTATION                    -4.107431    76.199547    -0.0539     0.957012 
AUTOMOTIVE                        -6.837658    130.25048    -0.0525     0.958133 
SERVICES                          -4.609124   113.582788    -0.0406     0.967631 
FOOD_DRINK                        -2.233968    49.510731    -0.0451     0.964011 
ENTERTAINMENT_RECREATION          -5.762104   139.396848    -0.0413     0.967028 
HEALTH_WELLNESS                   -4.228137    77.175839    -0.0548     0.956309 
LODGING                           -4.078172   995.547747    -0.0041     0.996732 
PLACE_OF_WORSHIP                   1.151762   114.067845     0.0101     0.991944 
EDUCATION                          8.878422   192.577196     0.0461     0.963228 
GOVERNMENT                        -6.030789   161.834732    -0.0373     0.970274 
BUSINESS                          -1.441645  1321.679844    -0.0011      0.99913 
FINANCE                            27.49206   398.232009      0.069     0.944962 
FACILITIES                        41.924096  1224.092262     0.0342     0.972678 
CULTURE                            0.320165   740.765433     0.0004     0.999655 
place_density                     -0.061891     4.289304    -0.0144     0.988488 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 761.3901
Null Deviance: 762.4223
AIC: 799.3901
BIC: 942.6665
McFadden R²: 0.0014
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
(Intercept)                       -3.654383     0.054295   -67.3063          0.0 ***
SPORTS                            -6.842984   104.703164    -0.0654     0.947891 
SHOPPING                           6.953336    97.661167     0.0712      0.94324 
OTHER                              -0.13375    81.768993    -0.0016     0.998695 
TRANSPORTATION                    -4.657009    47.482136    -0.0981     0.921869 
AUTOMOTIVE                        -7.815612    90.624358    -0.0862     0.931274 
SERVICES                          -5.071209    73.150399    -0.0693      0.94473 
FOOD_DRINK                        -2.597717     66.31201    -0.0392     0.968752 
ENTERTAINMENT_RECREATION          -6.493221    84.498241    -0.0768     0.938747 
HEALTH_WELLNESS                   -4.958401    45.537718    -0.1089     0.913293 
LODGING                            -6.15192   716.018565    -0.0086     0.993145 
PLACE_OF_WORSHIP                   1.462606   129.816382     0.0113     0.991011 
EDUCATION                          9.932554   215.263414     0.0461     0.963198 
GOVERNMENT                        -6.813561   174.965545    -0.0389     0.968936 
BUSINESS                           -2.88706  2182.940108    -0.0013     0.998945 
FINANCE                           32.531878   270.061523     0.1205     0.904118 
FACILITIES                        46.464218   983.640351     0.0472     0.962324 
CULTURE                             1.35821    499.97955     0.0027     0.997833 
place_density                     -0.082725     2.884165    -0.0287     0.977118 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 3248.3804
Null Deviance: 3254.5348
AIC: 3286.3804
BIC: 3429.6569
McFadden R²: 0.0019
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
(Intercept)                       -6.966242     0.277481   -25.1053          0.0 ***
SPORTS                            -6.708786   504.328973    -0.0133     0.989387 
SHOPPING                           6.905365   329.726455     0.0209     0.983291 
OTHER                             -0.087357    380.95364    -0.0002     0.999817 
TRANSPORTATION                    -4.369079   208.338117     -0.021     0.983269 
AUTOMOTIVE                        -7.361007   407.954168     -0.018     0.985604 
SERVICES                          -4.818435   332.765999    -0.0145     0.988447 
FOOD_DRINK                        -2.674403   210.798224    -0.0127     0.989877 
ENTERTAINMENT_RECREATION          -6.171661   395.167567    -0.0156     0.987539 
HEALTH_WELLNESS                    -4.61581   200.935348     -0.023     0.981673 
LODGING                           -6.997439  2861.341115    -0.0024     0.998049 
PLACE_OF_WORSHIP                   1.701915   348.100284     0.0049     0.996099 
EDUCATION                          9.045251   755.700945      0.012      0.99045 
GOVERNMENT                        -6.995985    669.99296    -0.0104     0.991669 
BUSINESS                          -8.837609  7976.770331    -0.0011     0.999116 
FINANCE                           31.473444   989.843333     0.0318     0.974634 
FACILITIES                        47.424119  3995.073333     0.0119     0.990529 
CULTURE                            1.954828  2219.579199     0.0009     0.999297 
place_density                     -0.084935    10.258312    -0.0083     0.993394 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 207.1346
Null Deviance: 207.3617
AIC: 245.1346
BIC: 388.4111
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
(Intercept)                       -7.133441     0.301632   -23.6495          0.0 ***
SPORTS                             -6.63888   526.578487    -0.0126     0.989941 
SHOPPING                           6.704475    348.98937     0.0192     0.984673 
OTHER                             -0.045433    377.23296    -0.0001     0.999904 
TRANSPORTATION                    -4.273392   210.886062    -0.0203     0.983833 
AUTOMOTIVE                        -7.161499   427.741874    -0.0167     0.986642 
SERVICES                          -4.741972   331.377065    -0.0143     0.988583 
FOOD_DRINK                        -2.594468    227.15931    -0.0114     0.990887 
ENTERTAINMENT_RECREATION          -5.997279   402.213418    -0.0149     0.988103 
HEALTH_WELLNESS                   -4.461244    202.03384    -0.0221     0.982383 
LODGING                           -7.304553  3030.076191    -0.0024     0.998077 
PLACE_OF_WORSHIP                   1.721261   375.299566     0.0046     0.996341 
EDUCATION                          8.811737   814.973746     0.0108     0.991373 
GOVERNMENT                        -6.905623   687.843029      -0.01      0.99199 
BUSINESS                          -8.331951  8597.672539     -0.001     0.999227 
FINANCE                           30.353471   1026.81777     0.0296     0.976417 
FACILITIES                         47.29704  4016.439614     0.0118     0.990604 
CULTURE                            2.320289  2309.322152      0.001     0.999198 
place_density                     -0.080909     10.89628    -0.0074     0.994075 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 178.9445
Null Deviance: 179.1367
AIC: 216.9445
BIC: 360.221
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
(Intercept)                       -5.384422     0.126277   -42.6398          0.0 ***
SPORTS                            -6.331318   182.210588    -0.0347     0.972281 
SHOPPING                           6.164457   141.222725     0.0437     0.965183 
OTHER                             -0.016623   133.208384    -0.0001       0.9999 
TRANSPORTATION                    -4.123869    79.013952    -0.0522     0.958376 
AUTOMOTIVE                        -6.938194   146.574774    -0.0473     0.962246 
SERVICES                          -4.586557   120.067104    -0.0382     0.969528 
FOOD_DRINK                        -2.317079    94.790769    -0.0244     0.980498 
ENTERTAINMENT_RECREATION          -5.785662    143.40544    -0.0403     0.967818 
HEALTH_WELLNESS                    -4.25497    75.844987    -0.0561     0.955261 
LODGING                           -5.763351  1276.073784    -0.0045     0.996396 
PLACE_OF_WORSHIP                   1.343487   188.472183     0.0071     0.994312 
EDUCATION                          8.828273   313.829243     0.0281     0.977558 
GOVERNMENT                        -6.230152   252.068389    -0.0247     0.980281 
BUSINESS                          -3.076773  3072.390511     -0.001     0.999201 
FINANCE                           28.318271   464.930083     0.0609     0.951432 
FACILITIES                        43.302954  1505.911756     0.0288      0.97706 
CULTURE                            1.504167   857.719693     0.0018     0.998601 
place_density                     -0.070267     5.076465    -0.0138     0.988956 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 804.7261
Null Deviance: 805.8286
AIC: 842.7261
BIC: 986.0026
McFadden R²: 0.0014
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
(Intercept)                       -5.209195     0.115785   -44.9902          0.0 ***
SPORTS                            -6.575613    196.05602    -0.0335     0.973244 
SHOPPING                           6.595203   132.424293     0.0498     0.960279 
OTHER                             -0.042043   138.441179    -0.0003     0.999758 
TRANSPORTATION                     -4.22074    77.960431    -0.0541     0.956824 
AUTOMOTIVE                        -7.076357   159.798081    -0.0443     0.964679 
SERVICES                          -4.683076   121.973845    -0.0384     0.969373 
FOOD_DRINK                          -2.5457    86.786579    -0.0293     0.976599 
ENTERTAINMENT_RECREATION          -5.917729   149.253805    -0.0396     0.968373 
HEALTH_WELLNESS                   -4.391506    74.527335    -0.0589     0.953012 
LODGING                           -7.336233  1148.901784    -0.0064     0.994905 
PLACE_OF_WORSHIP                   1.695331   144.080944     0.0118     0.990612 
EDUCATION                          8.717289   311.259911      0.028     0.977657 
GOVERNMENT                        -6.806287    260.81109    -0.0261      0.97918 
BUSINESS                          -7.848237  3292.832413    -0.0024     0.998098 
FINANCE                           29.867462   384.737849     0.0776     0.938122 
FACILITIES                        46.732824  1499.769863     0.0312     0.975142 
CULTURE                            2.415389   868.096759     0.0028      0.99778 
place_density                     -0.079386     4.152574    -0.0191     0.984747 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 931.7888
Null Deviance: 933.1018
AIC: 969.7888
BIC: 1113.0653
McFadden R²: 0.0014
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
(Intercept)                       -5.974246     0.169246   -35.2992          0.0 ***
SPORTS                            -6.707707   306.576061    -0.0219     0.982544 
SHOPPING                           6.895109   200.301348     0.0344     0.972539 
OTHER                             -0.082037   230.424113    -0.0004     0.999716 
TRANSPORTATION                    -4.363858   126.316823    -0.0345     0.972441 
AUTOMOTIVE                        -7.349598    248.05834    -0.0296     0.976363 
SERVICES                          -4.817416   201.356776    -0.0239     0.980913 
FOOD_DRINK                        -2.670938   128.202611    -0.0208     0.983378 
ENTERTAINMENT_RECREATION          -6.161258   239.651913    -0.0257     0.979489 
HEALTH_WELLNESS                   -4.606822   121.809866    -0.0378     0.969831 
LODGING                           -7.033442  1737.880734     -0.004     0.996771 
PLACE_OF_WORSHIP                   1.705988   211.550513     0.0081     0.993566 
EDUCATION                          9.032919   459.656927     0.0197     0.984321 
GOVERNMENT                        -6.994898   405.486219    -0.0173     0.986237 
BUSINESS                          -8.827502  4849.423955    -0.0018     0.998548 
FINANCE                           31.408324   600.964501     0.0523     0.958319 
FACILITIES                        47.459189  2416.667974     0.0196     0.984332 
CULTURE                            1.990557  1346.630936     0.0015     0.998821 
place_density                       -0.0847     6.229681    -0.0136     0.989152 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 488.2863
Null Deviance: 488.8982
AIC: 526.2863
BIC: 669.5628
McFadden R²: 0.0013
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
(Intercept)                       -4.326044     0.075027   -57.6601          0.0 ***
SPORTS                            -6.422207   116.781327     -0.055     0.956144 
SHOPPING                           6.385236    85.917048     0.0743     0.940757 
OTHER                             -0.036149    82.350504    -0.0004      0.99965 
TRANSPORTATION                    -4.132117    47.572385    -0.0869     0.930783 
AUTOMOTIVE                        -6.949102    96.677877    -0.0719     0.942698 
SERVICES                          -4.579043    72.306616    -0.0633     0.949505 
FOOD_DRINK                        -2.446764    56.710925    -0.0431     0.965586 
ENTERTAINMENT_RECREATION          -5.800776    89.900269    -0.0645     0.948553 
HEALTH_WELLNESS                   -4.286763    45.454563    -0.0943     0.924864 
LODGING                           -7.116485   693.237773    -0.0103     0.991809 
PLACE_OF_WORSHIP                    1.58733    97.841806     0.0162     0.987056 
EDUCATION                          8.617659   198.639836     0.0434     0.965396 
GOVERNMENT                         -6.54502   169.017882    -0.0387     0.969111 
BUSINESS                          -6.456925  2110.407951    -0.0031     0.997559 
FINANCE                           29.050594   239.002105     0.1215     0.903256 
FACILITIES                        45.058067   954.466615     0.0472     0.962348 
CULTURE                            2.336772   516.903426     0.0045     0.996393 
place_density                     -0.076616     2.549833      -0.03     0.976029 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 1919.746
Null Deviance: 1922.9092
AIC: 1957.746
BIC: 2101.0224
McFadden R²: 0.0016
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
(Intercept)                       -6.197898     0.189174   -32.7629          0.0 ***
SPORTS                            -6.588198   323.015775    -0.0204     0.983728 
SHOPPING                           6.615686   217.368692     0.0304      0.97572 
OTHER                             -0.042725   228.737661    -0.0002     0.999851 
TRANSPORTATION                    -4.230811   128.563949    -0.0329     0.973748 
AUTOMOTIVE                         -7.09005   263.128876    -0.0269     0.978503 
SERVICES                          -4.693832   201.416015    -0.0233     0.981408 
FOOD_DRINK                        -2.555156   142.320411     -0.018     0.985676 
ENTERTAINMENT_RECREATION          -5.931926   245.975591    -0.0241      0.98076 
HEALTH_WELLNESS                   -4.403504   122.917779    -0.0358     0.971422 
LODGING                           -7.327646  1886.408942    -0.0039     0.996901 
PLACE_OF_WORSHIP                   1.701698   236.030183     0.0072     0.994248 
EDUCATION                          8.731058   510.326336     0.0171      0.98635 
GOVERNMENT                        -6.828234   427.939355     -0.016     0.987269 
BUSINESS                          -7.956785  5396.727574    -0.0015     0.998824 
FINANCE                           29.949581   632.935651     0.0473     0.962259 
FACILITIES                        46.863575  2467.496523      0.019     0.984847 
CULTURE                            2.393706  1427.808825     0.0017     0.998662 
place_density                     -0.079607     6.810803    -0.0117     0.990674 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 403.1393
Null Deviance: 403.6287
AIC: 441.1393
BIC: 584.4158
McFadden R²: 0.0012
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
(Intercept)                        -4.55887     0.084061   -54.2329          0.0 ***
SPORTS                            -6.960308   171.875417    -0.0405     0.967698 
SHOPPING                           6.901804    75.933715     0.0909     0.927578 
OTHER                             -0.051601    134.18528    -0.0004     0.999693 
TRANSPORTATION                    -4.831871    79.922667    -0.0605     0.951792 
AUTOMOTIVE                        -7.919249   137.374689    -0.0576      0.95403 
SERVICES                           -5.38589   124.066724    -0.0434     0.965374 
FOOD_DRINK                        -2.562341    46.137715    -0.0555     0.955711 
ENTERTAINMENT_RECREATION          -6.667046   142.442613    -0.0468     0.962669 
HEALTH_WELLNESS                   -5.120011    77.365199    -0.0662     0.947235 
LODGING                           -3.812908  1094.503626    -0.0035      0.99722 
PLACE_OF_WORSHIP                   1.241206    123.27893     0.0101     0.991967 
EDUCATION                         10.453028   182.769144     0.0572     0.954392 
GOVERNMENT                        -6.851762   160.342643    -0.0427     0.965915 
BUSINESS                          -0.233037    970.84613    -0.0002     0.999808 
FINANCE                           32.386657   411.176158     0.0788     0.937219 
FACILITIES                        47.049771  1194.450746     0.0394     0.968579 
CULTURE                           -0.201829   862.978576    -0.0002     0.999813 
place_density                     -0.069181     5.306355     -0.013     0.989598 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 1591.3297
Null Deviance: 1593.8398
AIC: 1629.3297
BIC: 1772.6062
McFadden R²: 0.0016
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
(Intercept)                       -3.082062     0.041578   -74.1278          0.0 ***
SPORTS                            -7.543021   114.110328    -0.0661     0.947296 
SHOPPING                           7.887519    75.424297     0.1046     0.916713 
OTHER                             -0.188866    86.914782    -0.0022     0.998266 
TRANSPORTATION                    -5.072114    46.423557    -0.1093     0.912998 
AUTOMOTIVE                        -8.461685    93.226973    -0.0908      0.92768 
SERVICES                          -5.527563    77.008176    -0.0718     0.942778 
FOOD_DRINK                        -3.025365    48.988963    -0.0618     0.950757 
ENTERTAINMENT_RECREATION           -6.99152    87.532989    -0.0799     0.936338 
HEALTH_WELLNESS                   -5.471817    44.378626    -0.1233     0.901871 
LODGING                           -8.959191   668.754748    -0.0134     0.989311 
PLACE_OF_WORSHIP                   2.058483    81.555189     0.0252     0.979863 
EDUCATION                         10.460322   177.179662      0.059     0.952922 
GOVERNMENT                        -7.911167   148.230385    -0.0534     0.957437 
BUSINESS                          -8.336915  1853.942741    -0.0045     0.996412 
FINANCE                           36.638257   224.926074     0.1629     0.870605 
FACILITIES                        53.699527   869.801869     0.0617     0.950772 
CULTURE                            3.161319   512.230556     0.0062     0.995076 
place_density                     -0.100177     2.354832    -0.0425     0.966067 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 4966.629
Null Deviance: 4977.4317
AIC: 5004.629
BIC: 5147.9055
McFadden R²: 0.0022
Number of observations: 13917.0
```

---

