# Model Results for ARRESTS_COUNTS

Generated: 2025-12-09 15:41:29

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
(Intercept)                      -10.497524     1.991897    -5.2701          0.0 ***
SPORTS                           -41.061825  12348.76058    -0.0033     0.997347 
SHOPPING                          -30.97004 10789.948337    -0.0029      0.99771 
OTHER                            -35.743918 11243.572447    -0.0032     0.997463 
TRANSPORTATION                   -39.071833 11476.559726    -0.0034     0.997284 
AUTOMOTIVE                       -41.291149 11580.373391    -0.0036     0.997155 
SERVICES                         -39.493824 11891.378993    -0.0033      0.99735 
FOOD_DRINK                        -37.67085 12077.335558    -0.0031     0.997511 
ENTERTAINMENT_RECREATION         -40.490096 11989.650403    -0.0034     0.997305 
HEALTH_WELLNESS                  -38.795944 11506.901952    -0.0034      0.99731 
LODGING                          -39.812082 15378.195265    -0.0026     0.997934 
PLACE_OF_WORSHIP                 -34.867091 10697.550805    -0.0033     0.997399 
EDUCATION                        -28.914131  12780.93555    -0.0023     0.998195 
GOVERNMENT                       -40.944183 13236.509281    -0.0031     0.997532 
BUSINESS                         -39.689121 33356.852199    -0.0012     0.999051 
FINANCE                          -14.731949  11219.30388    -0.0013     0.998952 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -35.407038 12385.900513    -0.0029     0.997719 
total_crime                        0.020766     0.004963     4.1845       2.9e-5 ***
total_places                      35.833373 11549.260439     0.0031     0.997524 
street_length_meters              -0.000645     0.012368    -0.0521      0.95844 
place_density                     -0.049525     35.96672    -0.0014     0.998901 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 13.8166
Null Deviance: 56.6529
AIC: 55.8166
BIC: 214.1748
McFadden R²: 0.7561
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
(Intercept)                       -9.410624     1.518945    -6.1955          0.0 ***
SPORTS                           -59.326286 12242.141377    -0.0048     0.996133 
SHOPPING                         -47.741048 11107.058275    -0.0043      0.99657 
OTHER                            -52.391016 11406.320746    -0.0046     0.996335 
TRANSPORTATION                    -57.96914 11230.011154    -0.0052     0.995881 
AUTOMOTIVE                        -58.45018 11532.829901    -0.0051     0.995956 
SERVICES                         -58.230778 11543.559341     -0.005     0.995975 
FOOD_DRINK                       -54.329205 11490.706906    -0.0047     0.996228 
ENTERTAINMENT_RECREATION         -57.673844  12150.33331    -0.0047     0.996213 
HEALTH_WELLNESS                  -55.352538 11253.528535    -0.0049     0.996075 
LODGING                          -58.740793 15572.025808    -0.0038      0.99699 
PLACE_OF_WORSHIP                 -50.318781 10599.225426    -0.0047     0.996212 
EDUCATION                        -45.415889 11593.253411    -0.0039     0.996874 
GOVERNMENT                       -60.720497  12070.48458     -0.005     0.995986 
BUSINESS                          -52.18827 18238.941673    -0.0029     0.997717 
FINANCE                          -37.381798 12360.855016     -0.003     0.997587 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -49.850869 10183.571931    -0.0049     0.996094 
total_crime                        0.022898     0.006462     3.5434     0.000395 ***
total_places                      52.697653 11354.007387     0.0046     0.996297 
street_length_meters              -0.006364     0.015576    -0.4086     0.682852 
place_density                      0.043675     5.645226     0.0077     0.993827 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 20.9814
Null Deviance: 73.2354
AIC: 62.9814
BIC: 221.3396
McFadden R²: 0.7135
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
(Intercept)                       -8.815993     0.787979   -11.1881          0.0 ***
SPORTS                           -42.278084  4771.681432    -0.0089     0.992931 
SHOPPING                         -31.824621  4177.650031    -0.0076     0.993922 
OTHER                            -36.661849  4081.749162     -0.009     0.992834 
TRANSPORTATION                   -40.303089  4287.939673    -0.0094     0.992501 
AUTOMOTIVE                       -42.541659  4482.716785    -0.0095     0.992428 
SERVICES                         -40.833494  4509.782813    -0.0091     0.992776 
FOOD_DRINK                       -38.705309  4347.848901    -0.0089     0.992897 
ENTERTAINMENT_RECREATION         -41.824192  4542.822109    -0.0092     0.992654 
HEALTH_WELLNESS                  -40.220942  4264.024041    -0.0094     0.992474 
LODGING                          -38.107493   5247.92056    -0.0073     0.994206 
PLACE_OF_WORSHIP                 -36.079729   4215.93173    -0.0086     0.993172 
EDUCATION                        -29.237602   4206.72658     -0.007     0.994455 
GOVERNMENT                       -42.077693  4676.152417     -0.009      0.99282 
BUSINESS                         -38.288647  6883.887324    -0.0056     0.995562 
FINANCE                           -14.69512  4431.335619    -0.0033     0.997354 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                           -38.25446  4856.970667    -0.0079     0.993716 
total_crime                        0.037388     0.004004     9.3387          0.0 ***
total_places                      36.817275  4279.162621     0.0086     0.993135 
street_length_meters              -0.000162     0.004261    -0.0381     0.969615 
place_density                     -0.039825    15.619956    -0.0025     0.997966 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 59.7299
Null Deviance: 234.9683
AIC: 101.7299
BIC: 260.0881
McFadden R²: 0.7458
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
(Intercept)                       -7.265549     0.333608   -21.7787          0.0 ***
SPORTS                           -52.906333  4389.681397    -0.0121     0.990384 
SHOPPING                         -39.771833   3844.46526    -0.0103     0.991746 
OTHER                            -46.376466  3965.183712    -0.0117     0.990668 
TRANSPORTATION                   -50.532729  4082.227719    -0.0124     0.990123 
AUTOMOTIVE                       -53.380858  4110.153819     -0.013     0.989638 
SERVICES                         -50.988403  4335.393895    -0.0118     0.990616 
FOOD_DRINK                       -48.888549  4263.678463    -0.0115     0.990851 
ENTERTAINMENT_RECREATION         -52.246706  4376.629581    -0.0119     0.990475 
HEALTH_WELLNESS                  -50.767319  4084.707706    -0.0124     0.990084 
LODGING                          -53.453653   3618.75038    -0.0148     0.988215 
PLACE_OF_WORSHIP                 -44.684598  3867.229438    -0.0116     0.990781 
EDUCATION                        -37.692822  4465.592256    -0.0084     0.993265 
GOVERNMENT                       -53.115051  4687.574264    -0.0113     0.990959 
BUSINESS                         -54.201607 12139.806297    -0.0045     0.996438 
FINANCE                          -16.547646  4441.339018    -0.0037     0.997027 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                           -44.10581  5597.649057    -0.0079     0.993713 
total_crime                          0.0121     0.002027     5.9695          0.0 ***
total_places                      46.344843   4096.41631     0.0113     0.990973 
street_length_meters               0.000316     0.000935     0.3383     0.735166 
place_density                     -0.079233    11.433239    -0.0069     0.994471 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 173.3956
Null Deviance: 193.3327
AIC: 215.3956
BIC: 373.7538
McFadden R²: 0.1031
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
(Intercept)                       -6.966528     0.283013   -24.6156          0.0 ***
SPORTS                           -54.150262  4203.394998    -0.0129     0.989722 
SHOPPING                         -40.506964  3662.112132    -0.0111     0.991175 
OTHER                            -47.525155  3749.964547    -0.0127     0.989888 
TRANSPORTATION                   -51.831281  3853.166883    -0.0135     0.989267 
AUTOMOTIVE                       -54.808701  3925.542984     -0.014      0.98886 
SERVICES                          -52.24401  4094.403549    -0.0128     0.989819 
FOOD_DRINK                       -50.110696  4006.604849    -0.0125     0.990021 
ENTERTAINMENT_RECREATION         -53.638962   4122.81568     -0.013      0.98962 
HEALTH_WELLNESS                  -52.159279  3861.723318    -0.0135     0.989224 
LODGING                           -54.18942  3520.427234    -0.0154     0.987719 
PLACE_OF_WORSHIP                 -45.717395  3695.782967    -0.0124      0.99013 
EDUCATION                        -38.429625  4120.730199    -0.0093     0.992559 
GOVERNMENT                       -54.453277  4396.097058    -0.0124     0.990117 
BUSINESS                         -56.154596 10357.283282    -0.0054     0.995674 
FINANCE                          -15.849958  4121.688643    -0.0038     0.996932 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                           -45.72877  5113.151188    -0.0089     0.992864 
total_crime                        0.012134     0.001969     6.1637          0.0 ***
total_places                      47.432861  3873.355608     0.0122     0.990229 
street_length_meters               0.000381     0.000669     0.5703     0.568477 
place_density                     -0.084579     9.726145    -0.0087     0.993062 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 225.4348
Null Deviance: 248.5665
AIC: 267.4348
BIC: 425.7929
McFadden R²: 0.0931
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
(Intercept)                        -5.22903     0.133583   -39.1444          0.0 ***
SPORTS                           -53.060978  1611.009796    -0.0329     0.973725 
SHOPPING                         -39.941745  1411.491066    -0.0283     0.977425 
OTHER                            -46.547034   1456.51888     -0.032     0.974506 
TRANSPORTATION                   -50.710341  1499.783939    -0.0338     0.973027 
AUTOMOTIVE                       -53.558189  1509.171231    -0.0355      0.97169 
SERVICES                          -51.16915  1591.243967    -0.0322     0.974347 
FOOD_DRINK                       -49.038422   1565.84484    -0.0313     0.975016 
ENTERTAINMENT_RECREATION         -52.403245  1607.277345    -0.0326     0.973991 
HEALTH_WELLNESS                  -50.882881  1500.119577    -0.0339     0.972942 
LODGING                          -53.818009  1321.440602    -0.0407     0.967514 
PLACE_OF_WORSHIP                 -44.824251   1420.04396    -0.0316     0.974819 
EDUCATION                        -37.815694  1640.340076    -0.0231     0.981608 
GOVERNMENT                       -53.277923   1722.30865    -0.0309     0.975322 
BUSINESS                         -54.207883  4443.210535    -0.0122     0.990266 
FINANCE                           -16.76352  1630.329096    -0.0103     0.991796 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -44.092177  2050.694884    -0.0215     0.982846 
total_crime                         0.02284     0.002257    10.1186          0.0 ***
total_places                      46.506021  1504.350825     0.0309     0.975338 
street_length_meters                 2.4e-5      0.00065     0.0374     0.970176 
place_density                     -0.079024     4.180117    -0.0189     0.984917 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 963.1769
Null Deviance: 1086.8069
AIC: 1005.1769
BIC: 1163.5351
McFadden R²: 0.1138
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
(Intercept)                       -6.758564     0.424794   -15.9102          0.0 ***
SPORTS                           -66.882222  5316.590046    -0.0126     0.989963 
SHOPPING                         -53.510335  4621.498114    -0.0116     0.990762 
OTHER                            -58.293993  4785.549881    -0.0122     0.990281 
TRANSPORTATION                   -65.025996  4780.134949    -0.0136     0.989146 
AUTOMOTIVE                       -65.413701  5259.953582    -0.0124     0.990078 
SERVICES                         -65.616994  4917.291287    -0.0133     0.989353 
FOOD_DRINK                       -61.156351    4821.0707    -0.0127     0.989879 
ENTERTAINMENT_RECREATION         -64.533401  5081.206556    -0.0127     0.989867 
HEALTH_WELLNESS                  -62.189958  4771.592796     -0.013     0.989601 
LODGING                          -64.072518  7318.221477    -0.0088     0.993014 
PLACE_OF_WORSHIP                 -57.073709  4432.679287    -0.0129     0.989727 
EDUCATION                        -49.898398  5624.593744    -0.0089     0.992922 
GOVERNMENT                       -68.015436  5418.785238    -0.0126     0.989985 
BUSINESS                          -58.85813 10658.646986    -0.0055     0.995594 
FINANCE                           -39.53118  7075.496865    -0.0056     0.995542 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -56.414503  4650.568742    -0.0121     0.990321 
total_crime                        0.055583     0.004904    11.3331          0.0 ***
total_places                      59.071545  4808.920221     0.0123     0.990199 
street_length_meters              -0.007713     0.004731    -1.6304     0.103011 
place_density                      0.048128     5.745371     0.0084     0.993316 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 182.1797
Null Deviance: 500.8358
AIC: 224.1797
BIC: 382.5379
McFadden R²: 0.6362
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
(Intercept)                       -9.447852     1.244867    -7.5894          0.0 ***
SPORTS                           -53.890163  8183.886028    -0.0066     0.994746 
SHOPPING                         -43.895182  7359.962055     -0.006     0.995241 
OTHER                            -47.595636  7541.303843    -0.0063     0.994964 
TRANSPORTATION                     -52.2751  7504.593027     -0.007     0.994442 
AUTOMOTIVE                       -53.132778  7900.201765    -0.0067     0.994634 
SERVICES                         -52.839453  7719.917263    -0.0068     0.994539 
FOOD_DRINK                       -49.567405  7656.365201    -0.0065     0.994835 
ENTERTAINMENT_RECREATION          -52.52016  8109.104117    -0.0065     0.994832 
HEALTH_WELLNESS                  -50.271854  7491.810565    -0.0067     0.994646 
LODGING                          -53.894572  10450.49941    -0.0052     0.995885 
PLACE_OF_WORSHIP                 -46.687865  7440.820342    -0.0063     0.994994 
EDUCATION                        -41.310164  8062.200586    -0.0051     0.995912 
GOVERNMENT                        -55.05655  8144.276552    -0.0068     0.994606 
BUSINESS                          -49.27351  13325.27474    -0.0037      0.99705 
FINANCE                          -33.816072  9742.658236    -0.0035     0.997231 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -45.355099  7121.920156    -0.0064     0.994919 
total_crime                         0.03573     0.005997     5.9583          0.0 ***
total_places                      48.081116  7558.862084     0.0064     0.994925 
street_length_meters              -0.004951     0.009034    -0.5481     0.583648 
place_density                      0.034278     8.667439      0.004     0.996845 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 30.4719
Null Deviance: 150.1797
AIC: 72.4719
BIC: 230.8301
McFadden R²: 0.7971
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
(Intercept)                       -6.635729     0.432078   -15.3577          0.0 ***
SPORTS                           -44.783202  2685.204456    -0.0167     0.986694 
SHOPPING                         -33.168447  2386.991408    -0.0139     0.988913 
OTHER                            -39.275071  2321.815543    -0.0169     0.986504 
TRANSPORTATION                   -43.234718  2440.913788    -0.0177     0.985868 
AUTOMOTIVE                       -45.308068  2551.744104    -0.0178     0.985834 
SERVICES                         -43.018947    2565.9844    -0.0168     0.986624 
FOOD_DRINK                       -40.645395  2475.961096    -0.0164     0.986903 
ENTERTAINMENT_RECREATION           -43.0952  2565.465785    -0.0168     0.986598 
HEALTH_WELLNESS                  -40.149258  2461.047273    -0.0163     0.986984 
LODGING                          -50.521499  2668.179223    -0.0189     0.984893 
PLACE_OF_WORSHIP                 -37.213243  2416.353608    -0.0154     0.987713 
EDUCATION                        -30.214864  2417.124172    -0.0125     0.990026 
GOVERNMENT                       -44.919164  2693.514508    -0.0167     0.986694 
BUSINESS                         -40.359061  4501.114484     -0.009     0.992846 
FINANCE                          -16.307996  2484.708348    -0.0066     0.994763 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -32.733525  2718.855216     -0.012     0.990394 
total_crime                        0.055914     0.005216    10.7202          0.0 ***
total_places                      38.800159  2437.821092     0.0159     0.987301 
street_length_meters              -0.013065     0.005632    -2.3197     0.020358 *
place_density                     -0.070814     4.909571    -0.0144     0.988492 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 157.6112
Null Deviance: 464.8494
AIC: 199.6112
BIC: 357.9694
McFadden R²: 0.6609
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
(Intercept)                       -8.211937     0.738383   -11.1215          0.0 ***
SPORTS                           -61.494651  7921.639465    -0.0078     0.993806 
SHOPPING                         -49.197741  7137.756893    -0.0069     0.994501 
OTHER                            -53.950813  7333.619116    -0.0074      0.99413 
TRANSPORTATION                   -59.940854  7287.386094    -0.0082     0.993437 
AUTOMOTIVE                        -60.89649  7519.859111    -0.0081     0.993539 
SERVICES                         -60.551615  7507.825405    -0.0081     0.993565 
FOOD_DRINK                       -56.321684  7464.290414    -0.0075      0.99398 
ENTERTAINMENT_RECREATION         -59.935056   7852.78068    -0.0076      0.99391 
HEALTH_WELLNESS                  -57.946671  7269.989337     -0.008      0.99364 
LODGING                          -57.290247   9799.15556    -0.0058     0.995335 
PLACE_OF_WORSHIP                 -52.610283  6918.705872    -0.0076     0.993933 
EDUCATION                        -46.214696  7638.874231     -0.006     0.995173 
GOVERNMENT                       -62.959344  7942.097848    -0.0079     0.993675 
BUSINESS                         -54.819321 14761.171547    -0.0037     0.997037 
FINANCE                          -35.891695  8158.889167    -0.0044      0.99649 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -53.570504  6912.785724    -0.0077     0.993817 
total_crime                        0.038858     0.004449     8.7333          0.0 ***
total_places                      54.508673  7349.689608     0.0074     0.994083 
street_length_meters              -0.005292     0.006546    -0.8084     0.418835 
place_density                      0.046747     5.843248      0.008     0.993617 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 68.2304
Null Deviance: 248.5665
AIC: 110.2304
BIC: 268.5886
McFadden R²: 0.7255
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
(Intercept)                       -8.303087     0.821073   -10.1125          0.0 ***
SPORTS                           -57.990472  6469.893251     -0.009     0.992849 
SHOPPING                          -46.75151  5706.747178    -0.0082     0.993464 
OTHER                            -50.841122  5861.166979    -0.0087     0.993079 
TRANSPORTATION                   -56.295342  5823.499006    -0.0097     0.992287 
AUTOMOTIVE                       -56.471264  5982.490301    -0.0094     0.992469 
SERVICES                         -56.515209  6020.323985    -0.0094      0.99251 
FOOD_DRINK                       -52.838937  5992.915196    -0.0088     0.992965 
ENTERTAINMENT_RECREATION         -55.545769  6231.651957    -0.0089     0.992888 
HEALTH_WELLNESS                  -53.077907  5834.345914    -0.0091     0.992741 
LODGING                          -60.418994   7865.86629    -0.0077     0.993871 
PLACE_OF_WORSHIP                 -48.825302  5535.823564    -0.0088     0.992963 
EDUCATION                        -44.600478  6342.964372     -0.007      0.99439 
GOVERNMENT                       -59.025893  6366.658953    -0.0093     0.992603 
BUSINESS                         -51.840377 12025.962199    -0.0043     0.996561 
FINANCE                          -38.324342  7343.160764    -0.0052     0.995836 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                           -46.17399  5595.519235    -0.0083     0.993416 
total_crime                        0.036579     0.004936     7.4109          0.0 ***
total_places                      51.302655  5885.477194     0.0087     0.993045 
street_length_meters              -0.008811      0.00777    -1.1339     0.256836 
place_density                      0.038623     6.095346     0.0063     0.994944 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 54.0781
Null Deviance: 193.3327
AIC: 96.0781
BIC: 254.4363
McFadden R²: 0.7203
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
(Intercept)                       -5.400793     0.125021   -43.1991          0.0 ***
SPORTS                           -51.198964  1688.143583    -0.0303     0.975805 
SHOPPING                         -38.334585  1488.367927    -0.0258     0.979452 
OTHER                            -44.768775   1535.61264    -0.0292     0.976742 
TRANSPORTATION                   -48.841776  1583.960614    -0.0308     0.975401 
AUTOMOTIVE                       -51.669457  1583.400138    -0.0326     0.973968 
SERVICES                         -49.281739  1674.891152    -0.0294     0.976527 
FOOD_DRINK                       -47.229868  1651.566249    -0.0286     0.977186 
ENTERTAINMENT_RECREATION         -50.565521  1684.875322      -0.03     0.976058 
HEALTH_WELLNESS                  -49.137721  1581.823765    -0.0311     0.975219 
LODGING                          -51.625814  1380.507969    -0.0374     0.970169 
PLACE_OF_WORSHIP                 -43.199268  1492.432602    -0.0289     0.976908 
EDUCATION                        -36.211237  1742.971016    -0.0208     0.983425 
GOVERNMENT                       -51.297823  1821.508878    -0.0282     0.977533 
BUSINESS                         -51.685742  4728.740174    -0.0109     0.991279 
FINANCE                          -15.470905  1725.093643     -0.009     0.992845 
FACILITIES                              0.0          NaN        NaN          NaN 
CULTURE                          -42.588658  2163.524966    -0.0197     0.984295 
total_crime                        0.071672     0.005398     13.277          0.0 ***
total_places                      44.749882  1585.887891     0.0282     0.977489 
street_length_meters               0.000633     0.000198     3.1938     0.001404 **
place_density                     -0.077971     4.416849    -0.0177     0.985916 
```

Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

### Model Statistics
```
Deviance: 933.249
Null Deviance: 1370.2744
AIC: 975.249
BIC: 1133.6072
McFadden R²: 0.3189
Number of observations: 13917.0
```

---

