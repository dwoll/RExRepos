---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
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

[`AICcmodavg`](http://cran.r-project.org/package=AICcmodavg), [`lme4`](http://cran.r-project.org/package=lme4), [`multcomp`](http://cran.r-project.org/package=multcomp), [`nlme`](http://cran.r-project.org/package=nlme), [`pbkrtest`](http://cran.r-project.org/package=pbkrtest)


```r
wants <- c("AICcmodavg", "lme4", "multcomp", "nlme", "pbkrtest")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Simulate data for all designs
-------------------------

Two between-subjects factors, two within-subjects factors.


```r
set.seed(123)
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
Residuals 79  75040   949.9               

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)  
Xw1         2   5756  2878.2   3.363 0.0371 *
Residuals 158 135211   855.8                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Mixed-effects analysis

#### Using `lme()` from package `nlme`

No explicit assumption of compound symmetry, but
random intercept model equivalent to compound symmetry
iff all var comps positive (id > id:Xw1 and IV > id:Xw1)


```r
library(nlme)
anova(lme(Y ~ Xw1, random=~1 | id, method="ML", data=d1))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   158 2554.7564  <.0001
Xw1             2   158    3.3633  0.0371
```

Assume compound symmetry


```r
lmeFit <- lme(Y ~ Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
              method="ML", data=d1)
anova(lmeFit)
```

```
            numDF denDF   F-value p-value
(Intercept)     1   158 2554.7627  <.0001
Xw1             2   158    3.3633  0.0371
```


```r
anova(lme(Y ~ Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   158 2554.7564  <.0001
Xw1             2   158    3.3633  0.0371
```

#### Using `lmer()` from package `lme4`


```r
library(lme4)
fitF <- lmer(Y ~ Xw1 + (1|id), data=d1)
anova(fitF)
```

```
Analysis of Variance Table
    Df Sum Sq Mean Sq F value
Xw1  2 5756.4  2878.2  3.3633
```

$F$-test with $p$-value with Kenward-Roger corrected degrees of freedom from package `pbkrtest`. Needs a full model and a restricted model with the effect of interest.


```r
# restricted model
fitR <- lmer(Y ~ 1 + (1|id), data=d1)
library(pbkrtest)
KRmodcomp(fitF, fitR)
```

```
F-test with Kenward-Roger approximation; computing time: 0.15 sec.
large : Y ~ Xw1 + (1 | id)
small : Y ~ 1 + (1 | id)
          stat      ndf      ddf F.scaling p.value  
Ftest   3.3633   2.0000 158.0000         1 0.03712 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

AIC comparison table using package `AICcmodavg`.


```r
library(AICcmodavg)
AICc(fitF)
```

```
[1] 2304.445
```

```r
aictab(cand.set=list(fitR, fitF),
       modnames=c("restricted", "full"),
       sort=FALSE, second.ord=FALSE)
```

```

Model selection based on AIC :

           K     AIC Delta_AIC AICWt   Res.LL
restricted 3 2316.36     12.17     0 -1155.18
full       5 2304.19      0.00     1 -1147.09
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
B - A == 0 10.36375    4.59638   2.255   0.0625 .
C - A == 0 10.41417    4.59638   2.266   0.0607 .
C - B == 0  0.05042    4.59638   0.011   0.9999  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
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

Quantile = 2.3433
95% family-wise confidence level
 

Linear Hypotheses:
           Estimate  lwr       upr      
B - A == 0  10.36375  -0.40673  21.13423
C - A == 0  10.41417  -0.35632  21.18465
C - B == 0   0.05042 -10.72007  10.82090
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
Residuals 79 225120    2850               

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)  
Xw1         2  17269    8635   3.363 0.0371 *
Residuals 158 405633    2567                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)
Xw2         2   9859    4929   1.616  0.202
Residuals 158 481938    3050               

Error: id:Xw1:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)
Xw1:Xw2     4   6118    1530   0.603  0.661
Residuals 316 802069    2538               
```

### Mixed-effects analysis

#### Using `lme()` from package `nlme`


```r
anova(lme(Y ~ Xw1*Xw2, random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   632 2440.2286  <.0001
Xw1             2   632    3.3889  0.0344
Xw2             2   632    1.6522  0.1924
Xw1:Xw2         4   632    0.6003  0.6626
```

Assume compound symmetry


```r
anova(lme(Y ~ Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   632 2554.7545  <.0001
Xw1             2   632    3.3633  0.0352
Xw2             2   632    1.6160  0.1995
Xw1:Xw2         4   632    0.6026  0.6609
```

#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
        Df  Sum Sq Mean Sq F value
Xw1      2 17269.2  8634.6  3.3889
Xw2      2  8419.5  4209.8  1.6522
Xw1:Xw2  4  6118.0  1529.5  0.6003
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
Xb1        1   5335    5335    5.97 0.0168 *
Residuals 78  69705     894                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw1
           Df Sum Sq Mean Sq F value  Pr(>F)   
Xw1         2   5756    2878   3.541 0.03133 * 
Xb1:Xw1     2   8414    4207   5.176 0.00666 **
Residuals 156 126797     813                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Mixed-effects

#### Using `lme()` from package `nlme`

Random intercept model equivalent to compound symmetry
iff all var comps positive

No explicit assumption of compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1, random=~1 | id, method="ML", data=d1))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   156 2715.4696  <.0001
Xb1             1    78    5.9697  0.0168
Xw1             2   156    3.5411  0.0313
Xb1:Xw1         2   156    5.1762  0.0067
```

Assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
          method="ML", data=d1))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   156 2715.4765  <.0001
Xb1             1    78    5.9697  0.0168
Xw1             2   156    3.5411  0.0313
Xb1:Xw1         2   156    5.1762  0.0067
```


```r
anova(lme(Y ~ Xb1*Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   156 2715.4698  <.0001
Xb1             1    78    5.9697  0.0168
Xw1             2   156    3.5411  0.0313
Xb1:Xw1         2   156    5.1762  0.0067
```

#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
        Df Sum Sq Mean Sq F value
Xb1      1 4852.2  4852.2  5.9697
Xw1      2 5756.4  2878.2  3.5411
Xb1:Xw1  2 8414.4  4207.2  5.1762
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
Xb1        1   5335    5335   7.468 0.00781 **
Xb2        1   7246    7246  10.144 0.00210 **
Xb1:Xb2    1   8169    8169  11.436 0.00114 **
Residuals 76  54290     714                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw1
             Df Sum Sq Mean Sq F value   Pr(>F)    
Xw1           2   5756    2878   4.116 0.018166 *  
Xb1:Xw1       2   8414    4207   6.016 0.003058 ** 
Xb2:Xw1       2  11336    5668   8.105 0.000452 ***
Xb1:Xb2:Xw1   2   9167    4583   6.554 0.001861 ** 
Residuals   152 106294     699                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Mixed-effects analysis

#### Using `lme()` from package `nlme`


```r
anova(lme(Y ~ Xb1*Xb2*Xw1, random=~1 | id, method="ML", data=d1))
```

```
            numDF denDF  F-value p-value
(Intercept)     1   152 3397.096  <.0001
Xb1             1    76    7.468  0.0078
Xb2             1    76   10.144  0.0021
Xw1             2   152    4.116  0.0182
Xb1:Xb2         1    76   11.436  0.0011
Xb1:Xw1         2   152    6.016  0.0031
Xb2:Xw1         2   152    8.105  0.0005
Xb1:Xb2:Xw1     2   152    6.554  0.0019
```

Assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1, random=~1 | id,
          correlation=corCompSymm(form=~1 | id), method="ML", data=d1))
```

```
            numDF denDF  F-value p-value
(Intercept)     1   152 3397.098  <.0001
Xb1             1    76    7.468  0.0078
Xb2             1    76   10.144  0.0021
Xw1             2   152    4.116  0.0182
Xb1:Xb2         1    76   11.436  0.0011
Xb1:Xw1         2   152    6.016  0.0031
Xb2:Xw1         2   152    8.105  0.0005
Xb1:Xb2:Xw1     2   152    6.554  0.0019
```


```r
anova(lme(Y ~ Xb1*Xb2*Xw1,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1)))),
          method="ML", data=d1))
```

```
            numDF denDF  F-value p-value
(Intercept)     1   152 3397.098  <.0001
Xb1             1    76    7.468  0.0078
Xb2             1    76   10.144  0.0021
Xw1             2   152    4.116  0.0182
Xb1:Xb2         1    76   11.436  0.0011
Xb1:Xw1         2   152    6.016  0.0031
Xb2:Xw1         2   152    8.105  0.0005
Xb1:Xb2:Xw1     2   152    6.554  0.0019
```

#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xb2*Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
            Df  Sum Sq Mean Sq F value
Xb1          1  5222.5  5222.5  7.4682
Xb2          1  7093.5  7093.5 10.1437
Xw1          2  5756.4  2878.2  4.1158
Xb1:Xb2      1  7997.0  7997.0 11.4356
Xb1:Xw1      2  8414.4  4207.2  6.0163
Xb2:Xw1      2 11335.9  5668.0  8.1052
Xb1:Xb2:Xw1  2  9166.6  4583.3  6.5541
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
Xb1        1  16005   16005    5.97 0.0168 *
Residuals 78 209116    2681                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw1
           Df Sum Sq Mean Sq F value  Pr(>F)   
Xw1         2  17269    8635   3.541 0.03133 * 
Xb1:Xw1     2  25243   12622   5.176 0.00666 **
Residuals 156 380390    2438                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)
Xw2         2   9859    4929   1.604  0.204
Xb1:Xw2     2   2462    1231   0.400  0.671
Residuals 156 479476    3074               

Error: id:Xw1:Xw2
             Df Sum Sq Mean Sq F value Pr(>F)
Xw1:Xw2       4   6118    1530   0.601  0.662
Xb1:Xw1:Xw2   4   7609    1902   0.747  0.561
Residuals   312 794460    2546               
```

### Mixed-effects analysis

#### Using `lme()` from package `nlme`


```r
anova(lme(Y ~ Xb1*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   624 2473.9526  <.0001
Xb1             1    78    5.4387  0.0223
Xw1             2   624    3.4396  0.0327
Xw2             2   624    1.6751  0.1881
Xb1:Xw1         2   624    5.0278  0.0068
Xb1:Xw2         2   624    0.4183  0.6584
Xw1:Xw2         4   624    0.6093  0.6561
Xb1:Xw1:Xw2     4   624    0.7577  0.5531
```

Assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF   F-value p-value
(Intercept)     1   624 2715.3729  <.0001
Xb1             1    78    5.9695  0.0168
Xw1             2   624    3.4396  0.0327
Xw2             2   624    1.6038  0.2020
Xb1:Xw1         2   624    5.0278  0.0068
Xb1:Xw2         2   624    0.4005  0.6702
Xw1:Xw2         4   624    0.6093  0.6561
Xb1:Xw1:Xw2     4   624    0.7577  0.5531
```

#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
            Df  Sum Sq Mean Sq F value
Xb1          1 13653.2 13653.2  5.4387
Xw1          2 17269.2  8634.6  3.4396
Xw2          2  8410.1  4205.1  1.6751
Xb1:Xw1      2 25243.2 12621.6  5.0278
Xb1:Xw2      2  2100.1  1050.1  0.4183
Xw1:Xw2      4  6118.0  1529.5  0.6093
Xb1:Xw1:Xw2  4  7608.8  1902.2  0.7577
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
Xb1        1  16005   16005   7.468 0.00781 **
Xb2        1  21738   21738  10.144 0.00210 **
Xb1:Xb2    1  24507   24507  11.436 0.00114 **
Residuals 76 162871    2143                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw1
             Df Sum Sq Mean Sq F value   Pr(>F)    
Xw1           2  17269    8635   4.116 0.018166 *  
Xb1:Xw1       2  25243   12622   6.016 0.003058 ** 
Xb2:Xw1       2  34008   17004   8.105 0.000452 ***
Xb1:Xb2:Xw1   2  27500   13750   6.554 0.001861 ** 
Residuals   152 318882    2098                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw2
             Df Sum Sq Mean Sq F value  Pr(>F)   
Xw2           2   9859    4929   1.728 0.18110   
Xb1:Xw2       2   2462    1231   0.432 0.65031   
Xb2:Xw2       2  11822    5911   2.072 0.12945   
Xb1:Xb2:Xw2   2  34080   17040   5.974 0.00318 **
Residuals   152 433574    2852                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:Xw1:Xw2
                 Df Sum Sq Mean Sq F value Pr(>F)  
Xw1:Xw2           4   6118    1529   0.610 0.6558  
Xb1:Xw1:Xw2       4   7609    1902   0.759 0.5530  
Xb2:Xw1:Xw2       4  24545    6136   2.447 0.0465 *
Xb1:Xb2:Xw1:Xw2   4   7595    1899   0.757 0.5539  
Residuals       304 762320    2508                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Mixed-effects analysis

#### Using `lme()` from package `nlme`

No explicit assumption of compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))
```

```
                numDF denDF   F-value p-value
(Intercept)         1   608 2782.9276  <.0001
Xb1                 1    76    6.1180  0.0156
Xb2                 1    76    8.3098  0.0051
Xw1                 2   608    3.6417  0.0268
Xw2                 2   608    1.8843  0.1528
Xb1:Xb2             1    76    9.3682  0.0031
Xb1:Xw1             2   608    5.3232  0.0051
Xb2:Xw1             2   608    7.1714  0.0008
Xb1:Xw2             2   608    0.4705  0.6249
Xb2:Xw2             2   608    2.2595  0.1053
Xw1:Xw2             4   608    0.6451  0.6305
Xb1:Xb2:Xw1         2   608    5.7991  0.0032
Xb1:Xb2:Xw2         2   608    6.5138  0.0016
Xb1:Xw1:Xw2         4   608    0.8023  0.5240
Xb2:Xw1:Xw2         4   608    2.5880  0.0359
Xb1:Xb2:Xw1:Xw2     4   608    0.8008  0.5249
```

Assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
                numDF denDF   F-value p-value
(Intercept)         1   608 3113.1727  <.0001
Xb1                 1    76    6.8440  0.0107
Xb2                 1    76    9.2959  0.0032
Xw1                 2   608    3.6924  0.0255
Xw2                 2   608    1.7281  0.1785
Xb1:Xb2             1    76   10.4799  0.0018
Xb1:Xw1             2   608    5.3973  0.0047
Xb2:Xw1             2   608    7.2713  0.0008
Xb1:Xw2             2   608    0.4315  0.6497
Xb2:Xw2             2   608    2.0722  0.1268
Xw1:Xw2             4   608    0.6541  0.6242
Xb1:Xb2:Xw1         2   608    5.8798  0.0030
Xb1:Xb2:Xw2         2   608    5.9737  0.0027
Xb1:Xw1:Xw2         4   608    0.8134  0.5168
Xb2:Xw1:Xw2         4   608    2.6240  0.0339
Xb1:Xb2:Xw1:Xw2     4   608    0.8119  0.5178
```

#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xb2*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
                Df Sum Sq Mean Sq F value
Xb1              1  14506 14506.1  6.1180
Xb2              1  19703 19702.9  8.3098
Xw1              2  17269  8634.6  3.6417
Xw2              2   8935  4467.7  1.8843
Xb1:Xb2          1  22212 22212.5  9.3682
Xb1:Xw1          2  25243 12621.6  5.3232
Xb2:Xw1          2  34008 17003.9  7.1714
Xb1:Xw2          2   2231  1115.7  0.4705
Xb2:Xw2          2  10715  5357.5  2.2595
Xw1:Xw2          4   6118  1529.5  0.6451
Xb1:Xb2:Xw1      2  27500 13749.9  5.7991
Xb1:Xb2:Xw2      2  30889 15444.5  6.5138
Xb1:Xw1:Xw2      4   7609  1902.2  0.8023
Xb2:Xw1:Xw2      4  24545  6136.2  2.5880
Xb1:Xb2:Xw1:Xw2  4   7595  1898.7  0.8008
```

Further resources
-------------------------

For an alternative approach using generalized estimating equations (GEE), see package [`geepack`](http://cran.r-project.org/package=geepack).

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:multcomp))
try(detach(package:mvtnorm))
try(detach(package:survival))
try(detach(package:splines))
try(detach(package:TH.data))
try(detach(package:lme4))
try(detach(package:nlme))
try(detach(package:Matrix))
try(detach(package:Rcpp))
try(detach(package:AICcmodavg))
try(detach(package:pbkrtest))
try(detach(package:MASS))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaMixed.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaMixed.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaMixed.R) - [all posts](https://github.com/dwoll/RExRepos/)
