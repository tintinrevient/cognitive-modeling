# Source Code

For the function **"runAllSimpleStrategies(nrSimulations, phoneNumber)"**, "phoneNumber" is a fixed value, and the key variables are as below:

**strategy**: 
* There are in total 11 strategies from 1 to 11
	* strategy = 1: dial 1 digit -> steer -> dial 1 digit -> steer -> ...
	* strategy = 2: dial 2 digits -> steer -> dial 2 digits -> steer -> ...
	* strategy = 3: dial 3 digits -> steer -> dial 3 digits -> steer -> ...
	* strategy = 11: dial 11 digits
* strategy is stored as a vector, where each element represents the task-switching position (in the 11-digit telephone number).
	* strategy = 1: strategy <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
	* strategy = 2: strategy <- c(2, 4, 6, 8, 10)
	* strategy = 3: strategy <- c(3, 6, 9)
	* strategy = 11: strategy <- c()

**steer**:
* There are in total 12 steers from 1 to 12
* For each 1 steer, there are 5 steering updates, and each steering update lasts 50ms
	* steer = 1 -> 5 steering updates = 5 * 50 ms = 250ms
	* steer = 2 -> 10 steering updates = 10 * 50ms = 500ms
	* steer = 3 -> 15 steering updates = 15 * 50ms = 750ms
* If strategy = 11, then steer = 0, which means the user types all 11 digits at once without interleaving with steering updates.

For simple strategies, we need to simulate for every combination of **strategy** and **steer**.
* strategy[1, 10] matches with steer[1, 12]
* strategy 11 matches with steer 0
* The total number of combinations = 10 strategies * 12 steers + 1 (strategy = 11, steer = 0) = 121.

For **every combination of strategy and steer**, we can run **a custom number of simulations** by setting **"nrSimulations"**.

the data is as below:
```
    strats steers         x       dev TrialTime
1       11      0 0.3522459 0.3522459      2950
2        1      1 0.3787535 0.3787535     10250
3        2      1 0.3344576 0.3344576      6600
4        3      1 0.3387467 0.3387467      5100
5        4      1 0.3231975 0.3231975      4450
6        5      1 0.3350787 0.3350787      4450
7        6      1 0.3368644 0.3368644      3600
8        7      1 0.3381712 0.3381712      3700
9        8      1 0.3656578 0.3656578      3700
10       9      1 0.3598242 0.3598242      3700
11      10      1 0.3743032 0.3743032      3700
12       1      2 0.3325600 0.3325600     12750
13       2      2 0.3221417 0.3221417      7850
14       3      2 0.3089692 0.3089692      5850
15       4      2 0.3234304 0.3234304      4950
16       5      2 0.3369805 0.3369805      4950
17       6      2 0.3516911 0.3516911      3850
18       7      2 0.3424145 0.3424145      3950
19       8      2 0.3616628 0.3616628      3950
20       9      2 0.3616317 0.3616317      3950
21      10      2 0.3735409 0.3735409      3950
22       1      3 0.2960208 0.2960208     15250
23       2      3 0.2943259 0.2943259      9100
24       3      3 0.3092805 0.3092805      6600
25       4      3 0.3040904 0.3040904      5450
26       5      3 0.2989783 0.2989783      5450
27       6      3 0.3167179 0.3167179      4100
28       7      3 0.3269787 0.3269787      4200
29       8      3 0.3531954 0.3531954      4200
30       9      3 0.3410032 0.3410032      4200
31      10      3 0.3646797 0.3646797      4200
32       1      4 0.2914534 0.2914534     17750
33       2      4 0.2836885 0.2836885     10350
34       3      4 0.2921881 0.2921881      7350
35       4      4 0.3079640 0.3079640      5950
36       5      4 0.3136567 0.3136567      5950
37       6      4 0.3196711 0.3196711      4350
38       7      4 0.3144704 0.3144704      4450
39       8      4 0.3281059 0.3281059      4450
40       9      4 0.3361921 0.3361921      4450
41      10      4 0.3407001 0.3407001      4450
42       1      5 0.2779380 0.2779380     20250
43       2      5 0.2933992 0.2933992     11600
44       3      5 0.2848296 0.2848296      8100
45       4      5 0.3079624 0.3079624      6450
46       5      5 0.3151996 0.3151996      6450
47       6      5 0.3267379 0.3267379      4600
48       7      5 0.3300266 0.3300266      4700
49       8      5 0.3142275 0.3142275      4700
50       9      5 0.3305463 0.3305463      4700
51      10      5 0.3423507 0.3423507      4700
52       1      6 0.2711899 0.2711899     22750
53       2      6 0.2892774 0.2892774     12850
54       3      6 0.2829930 0.2829930      8850
55       4      6 0.2968554 0.2968554      6950
56       5      6 0.3218815 0.3218815      6950
57       6      6 0.3028144 0.3028144      4850
58       7      6 0.3206943 0.3206943      4950
59       8      6 0.3358413 0.3358413      4950
60       9      6 0.3281880 0.3281880      4950
61      10      6 0.3484587 0.3484587      4950
62       1      7 0.2629352 0.2629352     25250
63       2      7 0.2772360 0.2772360     14100
64       3      7 0.2849167 0.2849167      9600
65       4      7 0.2902865 0.2902865      7450
66       5      7 0.3117554 0.3117554      7450
67       6      7 0.3020083 0.3020083      5100
68       7      7 0.2973445 0.2973445      5200
69       8      7 0.3115624 0.3115624      5200
70       9      7 0.3252218 0.3252218      5200
71      10      7 0.3453391 0.3453391      5200
72       1      8 0.2557728 0.2557728     27750
73       2      8 0.2842560 0.2842560     15350
74       3      8 0.2760524 0.2760524     10350
75       4      8 0.2980864 0.2980864      7950
76       5      8 0.3001569 0.3001569      7950
77       6      8 0.2932752 0.2932752      5350
78       7      8 0.3211921 0.3211921      5450
79       8      8 0.3205830 0.3205830      5450
80       9      8 0.3240128 0.3240128      5450
81      10      8 0.3322406 0.3322406      5450
82       1      9 0.2519247 0.2519247     30250
83       2      9 0.2642586 0.2642586     16600
84       3      9 0.2802969 0.2802969     11100
85       4      9 0.2893969 0.2893969      8450
86       5      9 0.3009460 0.3009460      8450
87       6      9 0.2794624 0.2794624      5600
88       7      9 0.3059842 0.3059842      5700
89       8      9 0.3246441 0.3246441      5700
90       9      9 0.3239399 0.3239399      5700
91      10      9 0.3147897 0.3147897      5700
92       1     10 0.2526493 0.2526493     32750
93       2     10 0.2639601 0.2639601     17850
94       3     10 0.2786543 0.2786543     11850
95       4     10 0.2868853 0.2868853      8950
96       5     10 0.2915283 0.2915283      8950
97       6     10 0.3125166 0.3125166      5850
98       7     10 0.2966733 0.2966733      5950
99       8     10 0.3262096 0.3262096      5950
100      9     10 0.3166252 0.3166252      5950
101     10     10 0.3190865 0.3190865      5950
102      1     11 0.2461644 0.2461644     35250
103      2     11 0.2568249 0.2568249     19100
104      3     11 0.2653209 0.2653209     12600
105      4     11 0.2916315 0.2916315      9450
106      5     11 0.2956100 0.2956100      9450
107      6     11 0.2961941 0.2961941      6100
108      7     11 0.3200941 0.3200941      6200
109      8     11 0.3157780 0.3157780      6200
110      9     11 0.3238159 0.3238159      6200
111     10     11 0.3079912 0.3079912      6200
112      1     12 0.2433933 0.2433933     37750
113      2     12 0.2489055 0.2489055     20350
114      3     12 0.2662782 0.2662782     13350
115      4     12 0.2842815 0.2842815      9950
116      5     12 0.2879050 0.2879050      9950
117      6     12 0.3082362 0.3082362      6350
118      7     12 0.3063999 0.3063999      6450
119      8     12 0.3060779 0.3060779      6450
120      9     12 0.3196574 0.3196574      6450
121     10     12 0.3309768 0.3309768      6450
```

For each 1 simulation, we run the function **"runOneTrial(strategy, nrSteeringUpdates, normalPhoneStructure, phoneStringLength, phoneNumber)"**.

The fixed values are as below:
* normalPhoneStructure = c(1,6) -> For a UK-style telephone number (i.e., 07854-325698), the first chunk starts at digit 1, the second chunk starts at digit 6.
* phoneStringLength = 11
* phoneNumber = any 11 digits of number, e.g., phoneNumber = "07854325698"


The key variables are as below:
* strategy = c(3, 6, 9) -> the task switch starts <mark>**before**</mark> dialing the 3rd, 6th, 9th digit.
* nrSteeringUpdates = any number from the range [0, 12]
* "events" = ["none", "switch1", "steer", "switch2", "keypress"]

When below parameters are set, the data is as below:
* strategy = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
* nrSteeringUpdates = 1

```
    times   events      drifts
1       0     none 0.270000000
2      50  switch1 0.264901971
3     100  switch1 0.257630892
4     150  switch1 0.251043369
5     200  switch1 0.243037243
6     250    steer 0.241940689
7     300    steer 0.239503194
8     350    steer 0.240484257
9     400    steer 0.239039063
10    450    steer 0.236574173
11    500  switch2 0.235190112
12    550  switch2 0.231786430
13    600  switch2 0.229435385
14    650  switch2 0.225862111
15    700     none 0.219191798
16    750     none 0.208231848
17    800     none 0.193540753
18    850     none 0.177160010
19    900     none 0.163443631
20    950     none 0.151899670
21   1000 keypress 0.138144499
22   1050  switch1 0.124077735
23   1100  switch1 0.111733620
24   1150  switch1 0.097335329
25   1200  switch1 0.080011966
26   1250    steer 0.090280673
27   1300    steer 0.093698894
28   1350    steer 0.092196038
29   1400    steer 0.094156591
30   1450    steer 0.098821655
31   1500  switch2 0.097527051
32   1550  switch2 0.094165943
33   1600  switch2 0.090989077
34   1650  switch2 0.086931250
35   1700     none 0.086205935
36   1750     none 0.084145604
37   1800     none 0.082880788
38   1850     none 0.085351696
39   1900     none 0.087271414
40   1950     none 0.083983381
41   2000 keypress 0.079536970
42   2050  switch1 0.075863485
43   2100  switch1 0.069782726
44   2150  switch1 0.067141112
45   2200  switch1 0.065525334
46   2250    steer 0.066222747
47   2300    steer 0.065249575
48   2350    steer 0.061607375
49   2400    steer 0.063345321
50   2450    steer 0.063331041
51   2500  switch2 0.065199756
52   2550  switch2 0.065960436
53   2600  switch2 0.069745853
54   2650  switch2 0.078194289
55   2700     none 0.093610734
56   2750     none 0.104487183
57   2800     none 0.111541507
58   2850     none 0.112133102
59   2900     none 0.115491664
60   2950     none 0.117109377
61   3000 keypress 0.124465251
62   3050  switch1 0.133719795
63   3100  switch1 0.143941272
64   3150  switch1 0.146992275
65   3200  switch1 0.148289141
66   3250    steer 0.143284095
67   3300    steer 0.144204215
68   3350    steer 0.145766995
69   3400    steer 0.144635445
70   3450    steer 0.141574947
71   3500  switch2 0.136740085
72   3550  switch2 0.136359791
73   3600  switch2 0.135824681
74   3650  switch2 0.137128936
75   3700     none 0.138643048
76   3750     none 0.137668534
77   3800     none 0.137482196
78   3850     none 0.139112317
79   3900     none 0.137756873
80   3950     none 0.134688354
81   4000 keypress 0.132205079
82   4050  switch1 0.128222064
83   4100  switch1 0.121816058
84   4150  switch1 0.110747641
85   4200  switch1 0.099605148
86   4250    steer 0.106135191
87   4300    steer 0.109677445
88   4350    steer 0.114057334
89   4400    steer 0.112835732
90   4450    steer 0.112818642
91   4500  switch2 0.111059021
92   4550  switch2 0.112881574
93   4600  switch2 0.117954458
94   4650  switch2 0.124327627
95   4700     none 0.124555377
96   4750     none 0.126128524
97   4800     none 0.127228504
98   4850     none 0.128522647
99   4900     none 0.133154240
100  4950     none 0.133120664
101  5000 keypress 0.133739669
102  5050  switch1 0.135884538
103  5100  switch1 0.141760757
104  5150  switch1 0.143742646
105  5200  switch1 0.148014711
106  5250    steer 0.152758178
107  5300    steer 0.158956629
108  5350    steer 0.163445427
109  5400    steer 0.169687033
110  5450    steer 0.173727787
111  5500  switch2 0.167305858
112  5550  switch2 0.159832908
113  5600  switch2 0.152394391
114  5650  switch2 0.146195044
115  5700     none 0.140389104
116  5750     none 0.130784178
117  5800     none 0.119409225
118  5850     none 0.112670168
119  5900     none 0.104672979
120  5950     none 0.101993900
121  6000 keypress 0.095558585
122  6050  switch1 0.088803666
123  6100  switch1 0.078726207
124  6150  switch1 0.067961198
125  6200  switch1 0.056941851
126  6250    steer 0.060266297
127  6300    steer 0.062828732
128  6350    steer 0.061433007
129  6400    steer 0.059610559
130  6450    steer 0.057356659
131  6500  switch2 0.054874132
132  6550  switch2 0.056712494
133  6600  switch2 0.058842038
134  6650  switch2 0.058528134
135  6700     none 0.060584119
136  6750     none 0.066494396
137  6800     none 0.078948940
138  6850     none 0.090585181
139  6900     none 0.100530932
140  6950     none 0.111864955
141  7000 keypress 0.122602062
142  7050  switch1 0.132414282
143  7100  switch1 0.146533145
144  7150  switch1 0.161612452
145  7200  switch1 0.179558679
146  7250    steer 0.180950343
147  7300    steer 0.178723807
148  7350    steer 0.174921973
149  7400    steer 0.172920728
150  7450    steer 0.170494261
151  7500  switch2 0.172890140
152  7550  switch2 0.170872597
153  7600  switch2 0.163524985
154  7650  switch2 0.151770374
155  7700     none 0.138674087
156  7750     none 0.125351570
157  7800     none 0.116371909
158  7850     none 0.104284419
159  7900     none 0.089868649
160  7950     none 0.077271824
161  8000 keypress 0.063911062
162  8050  switch1 0.044856078
163  8100  switch1 0.028118821
164  8150  switch1 0.006333957
165  8200  switch1 0.017691751
166  8250    steer 0.019538190
167  8300    steer 0.014053209
168  8350    steer 0.020797181
169  8400    steer 0.020250069
170  8450    steer 0.021735007
171  8500  switch2 0.016971388
172  8550  switch2 0.013022817
173  8600  switch2 0.009072353
174  8650  switch2 0.003308379
175  8700     none 0.001303055
176  8750     none 0.009069905
177  8800     none 0.022158084
178  8850     none 0.032720610
179  8900     none 0.049983596
180  8950     none 0.065777773
181  9000 keypress 0.085003388
182  9050  switch1 0.068247969
183  9100  switch1 0.051800517
184  9150  switch1 0.030730579
185  9200  switch1 0.009335444
186  9250    steer 0.012517249
187  9300    steer 0.012538744
188  9350    steer 0.010833809
189  9400    steer 0.007772323
190  9450    steer 0.006943813
191  9500  switch2 0.007133118
192  9550  switch2 0.008126514
193  9600  switch2 0.006081029
194  9650  switch2 0.003364885
195  9700     none 0.001831735
196  9750     none 0.008376116
197  9800     none 0.019530266
198  9850     none 0.026252630
199  9900     none 0.030340155
200  9950     none 0.038293824
201 10000 keypress 0.042595511
202 10050  switch1 0.046482634
203 10100  switch1 0.054504604
204 10150  switch1 0.065220349
205 10200  switch1 0.079081965
206 10250    steer 0.078783307
207 10300    steer 0.080345981
208 10350    steer 0.081876696
209 10400    steer 0.083982021
210 10450    steer 0.087898522
211 10500  switch2 0.086299427
212 10550  switch2 0.080006866
213 10600  switch2 0.075639990
214 10650  switch2 0.068730788
215 10700     none 0.065596256
216 10750     none 0.061428799
217 10800     none 0.053607844
218 10850     none 0.045236079
219 10900     none 0.037959793
220 10950     none 0.030600760
221 11000 keypress 0.026839359
```

The assumptions are as below:

**drifts**:
* startvelocity = 0 
* startingPositionInLane = 0.27m
* timeStepPerDriftUpdate = 50ms
* gaussDeviateMean = 0
* gaussDeviateSD = 0.06

**laneDriftList = calculateLaneDrift()**, and its formula as below:
* locVelocity <- locVelocity + rnorm(1, 0, 0.06)
* lastLaneDrift <- lastLaneDrift + locVelocity * timeStepPerDriftUpdate / 1000
* laneDriftList <- c(laneDriftList, abs(lastLaneDrift)) 

The important assumption above is:
* <mark>rnorm(1, 0, 0.06) generates the lateral position for 1 millisecond </mark>
* lane drift (that is, posX = exact position) over 50 milliseconds (or 50/1000 seconds) is updated by adding rnorm(1, 0, 0.06) * 50 / 1000.

**times**:
* dialTimes = c(250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250): baseline time of the keypress interval while focusing on dialing
* chunkRetrievalTime = 100ms: by adding chunkRetrievalTime, dialTimes = c(350, 250, 250, 250, 250, 350, 250, 250, 250, 250, 250)
* stateInformationRetrievalTime = 100ms: by adding stateInformationRetrievalTime, if you are NOT switching at a chunk boundary
* switchCost = 200ms: switching time between dialing and driving, which will be added to dialTimes per strategy

**times = updateTimestampslist(times, time)**: 
* it generate timestamps, e.g., c(0, 50, 100, 150, ...)

