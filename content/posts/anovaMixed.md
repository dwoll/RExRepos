---
layout: post
title: "Mixed-effects models for repeated-measures ANOVA"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---




TODO
-------------------------

 - RBF-$pq$: `lme()` with compound symmetry
 - SPF-$p \cdot qr$: `lme()` with compound symmetry

Install required packages
-------------------------

[`lme4`](http://cran.r-project.org/package=lme4), [`nlme`](http://cran.r-project.org/package=nlme)


```r
wants <- c("lme4", "nlme")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Simulate data for all designs
-------------------------

Two between-subjects factors, two within-subjects factors.


```r
set.seed(1.234)
P     <- 2               # Xb1
Q     <- 2               # Xb2
R     <- 3               # Xw1
S     <- 3               # Xw2
Njklm <- 20              # obs per cell
Njk   <- Njklm*P*Q       # number of subjects
N     <- Njklm*P*Q*R*S   # number of observations
id    <- gl(Njk,         R*S, N, labels=c(paste("s", 1:Njk, sep="")))
Xb1   <- gl(P,   Njklm*Q*R*S, N, labels=c("CG", "T"))
Xb2   <- gl(Q,   Njklm  *R*S, N, labels=c("f", "m"))
Xw1   <- gl(R,             S, N, labels=c("A", "B", "C"))
Xw2   <- gl(S,   1,           N, labels=c("-", "o", "+"))
```


Theoretical main effects and interactions


```r
mu      <- 100
eB1     <- c(-5, 5)
eB2     <- c(-5, 5)
eW1     <- c(-5, 0, 5)
eW2     <- c(-5, 0, 5)
eB1B2   <- c(-5, 5, 5, -5)
eB1W1   <- c(-5, 5, 2, -2, 3, -3)
eB1W2   <- c(-5, 5, 2, -2, 3, -3)
eB2W1   <- c(-5, 5, 2, -2, 3, -3)
eB2W2   <- c(-5, 5, 2, -2, 3, -3)
eW1W2   <- c(-5, 2, 3, 2, 3, -5, 2, -5, 3)
eB1B2W1 <- c(-5, 5, 5, -5, 2, -2, -2, 2, 3, -3, -3, 3)
eB1B2W2 <- c(-5, 5, 5, -5, 2, -2, -2, 2, 3, -3, -3, 3)
eB1W1W2 <- c(-5, 5, 2, -2, 3, -3, 3, -3, -5, 5, 2, -2, 2, -2, 3, -3, -5, 5)
eB2W1W2 <- c(-5, 5, 2, -2, 3, -3, 3, -3, -5, 5, 2, -2, 2, -2, 3, -3, -5, 5)
# no 3rd-order interaction B1xB2xW1xW2
```


Name values according to the corresponding cell in the experimental design


```r
names(eB1)     <- levels(Xb1)
names(eB2)     <- levels(Xb2)
names(eW1)     <- levels(Xw1)
names(eW2)     <- levels(Xw2)
names(eB1B2)   <- levels(interaction(Xb1, Xb2))
names(eB1W1)   <- levels(interaction(Xb1, Xw1))
names(eB1W2)   <- levels(interaction(Xb1, Xw2))
names(eB2W1)   <- levels(interaction(Xb2, Xw1))
names(eB2W2)   <- levels(interaction(Xb2, Xw2))
names(eW1W2)   <- levels(interaction(Xw1, Xw2))
names(eB1B2W1) <- levels(interaction(Xb1, Xb2, Xw1))
names(eB1B2W2) <- levels(interaction(Xb1, Xb2, Xw2))
names(eB1W1W2) <- levels(interaction(Xb1, Xw1, Xw2))
names(eB2W1W2) <- levels(interaction(Xb2, Xw1, Xw2))
```


Simulate data given the effects defined above


```r
muJKLM <- mu +
          eB1[Xb1] + eB2[Xb2] + eW1[Xw1] + eW2[Xw2] +
          eB1B2[interaction(Xb1, Xb2)] +
          eB1W1[interaction(Xb1, Xw1)] +
          eB1W2[interaction(Xb1, Xw2)] +
          eB2W1[interaction(Xb2, Xw1)] +
          eB2W2[interaction(Xb2, Xw2)] +
          eW1W2[interaction(Xw1, Xw2)] +
          eB1B2W1[interaction(Xb1, Xb2, Xw1)] +
          eB1B2W2[interaction(Xb1, Xb2, Xw2)] +
          eB1W1W2[interaction(Xb1, Xw1, Xw2)] +
          eB2W1W2[interaction(Xb2, Xw1, Xw2)]
muId  <- rep(rnorm(Njk, 0, 3), each=R*S)
mus   <- muJKLM + muId
sigma <- 50

Y  <- round(rnorm(N, mus, sigma), 1)
d2 <- data.frame(id, Xb1, Xb2, Xw1, Xw2, Y)
```


Data frame with just one within-subjects factor (average over levels of `Xw2`)


```r
d1 <- aggregate(Y ~ id + Xw1 + Xb1 + Xb2, data=d2, FUN=mean)
```


One-way repeated measures ANOVA (RB-$p$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xw1 + Error(id/Xw1), data=d1))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals 79  68427     866               

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)
Xw1         2   2795    1397    1.35   0.26
Residuals 158 163743    1036               
```


### Mixed-effects analysis

#### Using `lme()` from package `nlme`

no explicit assumption of compound symmetry, but
random intercept model equivalent to compound symmetry
iff all var comps positive (id > id:Xw1 and IV > id:Xw1)


```r
library(nlme)
anova(lme(Y ~ Xw1, random=~1 | id, method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   158  2392.4  <.0001
Xw1             2   158     1.4  0.2433
```


assume compound symmetry


```r
lmeFit <- lme(Y ~ Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
              method="ML", data=d1)
anova(lmeFit)
```

```
            numDF denDF F-value p-value
(Intercept)     1   158  2705.8  <.0001
Xw1             2   158     1.3  0.2626
```



```r
anova(lme(Y ~ Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   158  2705.8  <.0001
Xw1             2   158     1.3  0.2626
```


#### Using `lmer()` from package `lme4`


```r
library(lme4)
anova(lmer(Y ~ Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
    Df Sum Sq Mean Sq F value
Xw1  2   2795    1397    1.43
```


### Multiple comparisons using `glht()` from package `multcomp`


```r
library(multcomp)
contr <- glht(lmeFit, linfct=mcp(Xw1="Tukey"))
summary(contr)
```

```

	 Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: Tukey Contrasts


Fit: lme.formula(fixed = Y ~ Xw1, data = d1, random = ~1 | id, correlation = corCompSymm(form = ~1 | 
    id), method = "ML")

Linear Hypotheses:
           Estimate Std. Error z value Pr(>|z|)
B - A == 0   -0.902      5.058   -0.18     0.98
C - A == 0    6.745      5.058    1.33     0.38
C - B == 0    7.648      5.058    1.51     0.29
(Adjusted p values reported -- single-step method)
```

```r
confint(contr)
```

```

	 Simultaneous Confidence Intervals

Multiple Comparisons of Means: Tukey Contrasts


Fit: lme.formula(fixed = Y ~ Xw1, data = d1, random = ~1 | id, correlation = corCompSymm(form = ~1 | 
    id), method = "ML")

Quantile = 2.344
95% family-wise confidence level
 

Linear Hypotheses:
           Estimate lwr     upr    
B - A == 0  -0.902  -12.757  10.953
C - A == 0   6.745   -5.110  18.601
C - B == 0   7.647   -4.208  19.503
```


Two-way repeated measures ANOVA (RBF-$pq$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xw1*Xw2 + Error(id/(Xw1*Xw2)), data=d2))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals 79 205280    2598               

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)
Xw1         2   8384    4192    1.35   0.26
Residuals 158 491228    3109               

Error: id:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)  
Xw2         2  16588    8294    2.95  0.055 .
Residuals 158 444423    2813                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)
Xw1:Xw2     4  20527    5132    1.72   0.15
Residuals 316 942658    2983               
```


### Mixed-effects analysis

#### Using `lme()` from package `nlme`


```r
anova(lme(Y ~ Xw1*Xw2, random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF F-value p-value
(Intercept)     1   632  2399.2  <.0001
Xw1             2   632     1.4  0.2400
Xw2             2   632     2.8  0.0597
Xw1:Xw2         4   632     1.8  0.1371
```


assume compound symmetry


```r
anova(lme(Y ~ Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF F-value p-value
(Intercept)     1   632  2441.7  <.0001
Xw1             2   632     1.3  0.2604
Xw2             2   632     2.9  0.0568
Xw1:Xw2         4   632     1.8  0.1307
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
        Df Sum Sq Mean Sq F value
Xw1      2   8348    4174    1.43
Xw2      2  16588    8294    2.83
Xw1:Xw2  4  20527    5132    1.75
```


Two-way split-plot-factorial ANOVA (SPF-$p \cdot q$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xb1*Xw1 + Error(id/Xw1), data=d1))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Xb1        1   1912    1912    2.24   0.14
Residuals 78  66515     853               

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)   
Xw1         2   2795    1397    1.43 0.2422   
Xb1:Xw1     2  11416    5708    5.85 0.0036 **
Residuals 156 152326     976                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Mixed-effects

#### Using `lme()` from package `nlme`

random intercept model equivalent to compound symmetry
iff all var comps positive

no explicit assumption of compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1, random=~1 | id, method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   156  2506.0  <.0001
Xb1             1    78     2.0  0.1568
Xw1             2   156     1.5  0.2276
Xb1:Xw1         2   156     6.1  0.0028
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
          method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   156  2748.4  <.0001
Xb1             1    78     2.2  0.1383
Xw1             2   156     1.4  0.2422
Xb1:Xw1         2   156     5.8  0.0036
```



```r
anova(lme(Y ~ Xb1*Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   156  2748.4  <.0001
Xb1             1    78     2.2  0.1383
Xw1             2   156     1.4  0.2422
Xb1:Xw1         2   156     5.8  0.0036
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
        Df Sum Sq Mean Sq F value
Xb1      1   1912    1912    2.04
Xw1      2   2795    1397    1.49
Xb1:Xw1  2  11416    5708    6.10
```


Three-way split-plot-factorial ANOVA (SPF-$pq \cdot r$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xb1*Xb2*Xw1 + Error(id/Xw1), data=d1))
```

```

Error: id
          Df Sum Sq Mean Sq F value  Pr(>F)    
Xb1        1   1912    1912    2.84 0.09578 .  
Xb2        1   5255    5255    7.82 0.00654 ** 
Xb1:Xb2    1  10177   10177   15.14 0.00021 ***
Residuals 76  51082     672                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1
             Df Sum Sq Mean Sq F value Pr(>F)   
Xw1           2   2795    1397    1.44 0.2412   
Xb1:Xw1       2  11416    5708    5.86 0.0035 **
Xb2:Xw1       2   1989     995    1.02 0.3624   
Xb1:Xb2:Xw1   2   2383    1191    1.22 0.2969   
Residuals   152 147954     973                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Mixed-effects analysis

#### Using `lme()` from package `nlme`


```r
anova(lme(Y ~ Xb1*Xb2*Xw1, random=~1 | id, method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   152  2684.7  <.0001
Xb1             1    76     2.2  0.1430
Xb2             1    76     6.0  0.0164
Xw1             2   152     1.6  0.2051
Xb1:Xb2         1    76    11.7  0.0010
Xb1:Xw1         2   152     6.5  0.0019
Xb2:Xw1         2   152     1.1  0.3227
Xb1:Xb2:Xw1     2   152     1.4  0.2585
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1, random=~1 | id,
          correlation=corCompSymm(form=~1 | id), method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   152    3487  <.0001
Xb1             1    76       3  0.0958
Xb2             1    76       8  0.0065
Xw1             2   152       1  0.2412
Xb1:Xb2         1    76      15  0.0002
Xb1:Xw1         2   152       6  0.0035
Xb2:Xw1         2   152       1  0.3624
Xb1:Xb2:Xw1     2   152       1  0.2969
```



```r
anova(lme(Y ~ Xb1*Xb2*Xw1,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1)))),
          method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   152    3487  <.0001
Xb1             1    76       3  0.0958
Xb2             1    76       8  0.0065
Xw1             2   152       1  0.2412
Xb1:Xb2         1    76      15  0.0002
Xb1:Xw1         2   152       6  0.0035
Xb2:Xw1         2   152       1  0.3624
Xb1:Xb2:Xw1     2   152       1  0.2969
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xb2*Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
            Df Sum Sq Mean Sq F value
Xb1          1   1912    1912    2.19
Xb2          1   5255    5255    6.02
Xw1          2   2795    1397    1.60
Xb1:Xb2      1  10177   10177   11.66
Xb1:Xw1      2  11416    5708    6.54
Xb2:Xw1      2   1989     995    1.14
Xb1:Xb2:Xw1  2   2383    1191    1.36
```


Three-way split-plot-factorial ANOVA (SPF-$p \cdot qr$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xb1*Xw1*Xw2 + Error(id/(Xw1*Xw2)), data=d2))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Xb1        1   5736    5736    2.24   0.14
Residuals 78 199544    2558               

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)   
Xw1         2   8384    4192    1.43 0.2422   
Xb1:Xw1     2  34249   17124    5.85 0.0036 **
Residuals 156 456979    2929                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)   
Xw2         2  16588    8294    3.17 0.0447 * 
Xb1:Xw2     2  36287   18143    6.93 0.0013 **
Residuals 156 408136    2616                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1:Xw2
             Df Sum Sq Mean Sq F value Pr(>F)
Xw1:Xw2       4  20527    5132    1.72   0.15
Xb1:Xw1:Xw2   4   9233    2308    0.77   0.54
Residuals   312 933425    2992               
```


### Mixed-effects analysis

#### Using `lme()` from package `nlme`


```r
anova(lme(Y ~ Xb1*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF F-value p-value
(Intercept)     1   624  2470.2  <.0001
Xb1             1    78     2.0  0.1597
Xw1             2   624     1.5  0.2301
Xw2             2   624     2.9  0.0550
Xb1:Xw1         2   624     6.0  0.0026
Xb1:Xw2         2   624     6.4  0.0018
Xw1:Xw2         4   624     1.8  0.1266
Xb1:Xw1:Xw2     4   624     0.8  0.5184
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF F-value p-value
(Intercept)     1   624  2491.0  <.0001
Xb1             1    78     2.0  0.1580
Xw1             2   624     1.4  0.2398
Xw2             2   624     2.9  0.0537
Xb1:Xw1         2   624     5.8  0.0031
Xb1:Xw2         2   624     6.4  0.0017
Xw1:Xw2         4   624     1.8  0.1236
Xb1:Xw1:Xw2     4   624     0.8  0.5140
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
            Df Sum Sq Mean Sq F value
Xb1          1   5736    5736    2.02
Xw1          2   8384    4192    1.47
Xw2          2  16588    8294    2.91
Xb1:Xw1      2  34249   17124    6.02
Xb1:Xw2      2  36287   18143    6.37
Xw1:Xw2      4  20527    5132    1.80
Xb1:Xw1:Xw2  4   9233    2308    0.81
```


Four-way split-plot-factorial ANOVA (SPF-$pq \cdot rs$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xb1*Xb2*Xw1*Xw2 + Error(id/(Xw1*Xw2)), data=d2))
```

```

Error: id
          Df Sum Sq Mean Sq F value  Pr(>F)    
Xb1        1   5736    5736    2.84 0.09578 .  
Xb2        1  15766   15766    7.82 0.00654 ** 
Xb1:Xb2    1  30532   30532   15.14 0.00021 ***
Residuals 76 153247    2016                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1
             Df Sum Sq Mean Sq F value Pr(>F)   
Xw1           2   8384    4192    1.44 0.2412   
Xb1:Xw1       2  34249   17124    5.86 0.0035 **
Xb2:Xw1       2   5968    2984    1.02 0.3624   
Xb1:Xb2:Xw1   2   7149    3574    1.22 0.2969   
Residuals   152 443862    2920                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw2
             Df Sum Sq Mean Sq F value  Pr(>F)    
Xw2           2  16588    8294    3.31 0.03922 *  
Xb1:Xw2       2  36287   18143    7.24 0.00099 ***
Xb2:Xw2       2  20209   10105    4.03 0.01970 *  
Xb1:Xb2:Xw2   2   6870    3435    1.37 0.25720    
Residuals   152 381057    2507                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1:Xw2
                 Df Sum Sq Mean Sq F value Pr(>F)
Xw1:Xw2           4  20527    5132    1.72   0.15
Xb1:Xw1:Xw2       4   9233    2308    0.77   0.54
Xb2:Xw1:Xw2       4  18107    4527    1.52   0.20
Xb1:Xb2:Xw1:Xw2   4   8282    2070    0.69   0.60
Residuals       304 907036    2984               
```


### Mixed-effects analysis

#### Using `lme()` from package `nlme`

no explicit assumption of compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))
```

```
                numDF denDF F-value p-value
(Intercept)         1   608  2551.0  <.0001
Xb1                 1    76     2.1  0.1532
Xb2                 1    76     5.7  0.0192
Xw1                 2   608     1.5  0.2193
Xw2                 2   608     3.0  0.0501
Xb1:Xb2             1    76    11.1  0.0013
Xb1:Xw1             2   608     6.2  0.0021
Xb2:Xw1             2   608     1.1  0.3394
Xb1:Xw2             2   608     6.6  0.0015
Xb2:Xw2             2   608     3.7  0.0261
Xw1:Xw2             4   608     1.9  0.1155
Xb1:Xb2:Xw1         2   608     1.3  0.2741
Xb1:Xb2:Xw2         2   608     1.2  0.2883
Xb1:Xw1:Xw2         4   608     0.8  0.5016
Xb2:Xw1:Xw2         4   608     1.6  0.1620
Xb1:Xb2:Xw1:Xw2     4   608     0.8  0.5574
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
                numDF denDF F-value p-value
(Intercept)         1   608  2595.2  <.0001
Xb1                 1    76     2.1  0.1498
Xb2                 1    76     5.8  0.0183
Xw1                 2   608     1.4  0.2388
Xw2                 2   608     3.1  0.0475
Xb1:Xb2             1    76    11.3  0.0012
Xb1:Xw1             2   608     5.9  0.0030
Xb2:Xw1             2   608     1.0  0.3605
Xb1:Xw2             2   608     6.7  0.0013
Xb2:Xw2             2   608     3.7  0.0246
Xw1:Xw2             4   608     1.9  0.1099
Xb1:Xb2:Xw1         2   608     1.2  0.2948
Xb1:Xb2:Xw2         2   608     1.3  0.2822
Xb1:Xw1:Xw2         4   608     0.9  0.4926
Xb2:Xw1:Xw2         4   608     1.7  0.1551
Xb1:Xb2:Xw1:Xw2     4   608     0.8  0.5488
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xb2*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
                Df Sum Sq Mean Sq F value
Xb1              1   5736    5736    2.08
Xb2              1  15766   15766    5.72
Xw1              2   8384    4192    1.52
Xw2              2  16588    8294    3.01
Xb1:Xb2          1  30532   30532   11.08
Xb1:Xw1          2  34249   17124    6.21
Xb2:Xw1          2   5968    2984    1.08
Xb1:Xw2          2  36287   18143    6.58
Xb2:Xw2          2  20209   10105    3.67
Xw1:Xw2          4  20527    5132    1.86
Xb1:Xb2:Xw1      2   7149    3574    1.30
Xb1:Xb2:Xw2      2   6870    3435    1.25
Xb1:Xw1:Xw2      4   9233    2308    0.84
Xb2:Xw1:Xw2      4  18107    4527    1.64
Xb1:Xb2:Xw1:Xw2  4   8282    2070    0.75
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:lme4))
try(detach(package:nlme))
try(detach(package:Matrix))
try(detach(package:lattice))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaMixed.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaMixed.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaMixed.R) - [all posts](https://github.com/dwoll/RExRepos/)
