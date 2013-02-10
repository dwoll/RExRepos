---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Mixed-effects models for repeated-measures ANOVA"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---

Mixed-effects models for repeated-measures ANOVA
=========================

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
Residuals 79  75040     950               

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)  
Xw1         2   5756    2878    3.36  0.037 *
Residuals 158 135211     856                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
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
(Intercept)     1   158  2554.8  <.0001
Xw1             2   158     3.4  0.0371
```


assume compound symmetry


```r
lmeFit <- lme(Y ~ Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
              method="ML", data=d1)
anova(lmeFit)
```

```
            numDF denDF F-value p-value
(Intercept)     1   158  2554.8  <.0001
Xw1             2   158     3.4  0.0371
```



```r
anova(lme(Y ~ Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   158  2554.8  <.0001
Xw1             2   158     3.4  0.0371
```


#### Using `lmer()` from package `lme4`


```r
library(lme4)
anova(lmer(Y ~ Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
    Df Sum Sq Mean Sq F value
Xw1  2   5756    2878    3.24
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
B - A == 0  10.3637     4.5964    2.25    0.062 .
C - A == 0  10.4142     4.5964    2.27    0.061 .
C - B == 0   0.0504     4.5964    0.01    1.000  
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

Quantile = 2.344
95% family-wise confidence level
 

Linear Hypotheses:
           Estimate lwr      upr     
B - A == 0  10.3637  -0.4115  21.1390
C - A == 0  10.4142  -0.3611  21.1894
C - B == 0   0.0504 -10.7248  10.8257
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
Xw1         2  17269    8635    3.36  0.037 *
Residuals 158 405633    2567                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)
Xw2         2   9859    4929    1.62    0.2
Residuals 158 481938    3050               

Error: id:Xw1:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)
Xw1:Xw2     4   6118    1529     0.6   0.66
Residuals 316 802069    2538               
```


### Mixed-effects analysis

#### Using `lme()` from package `nlme`


```r
anova(lme(Y ~ Xw1*Xw2, random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF F-value p-value
(Intercept)     1   632  2440.2  <.0001
Xw1             2   632     3.4  0.0344
Xw2             2   632     1.7  0.1924
Xw1:Xw2         4   632     0.6  0.6626
```


assume compound symmetry


```r
anova(lme(Y ~ Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF F-value p-value
(Intercept)     1   632  2554.8  <.0001
Xw1             2   632     3.4  0.0352
Xw2             2   632     1.6  0.1995
Xw1:Xw2         4   632     0.6  0.6609
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
        Df Sum Sq Mean Sq F value
Xw1      2  17269    8635    3.39
Xw2      2   8419    4210    1.65
Xw1:Xw2  4   6118    1529    0.60
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
Xb1        1   5335    5335    5.97  0.017 *
Residuals 78  69705     894                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)   
Xw1         2   5756    2878    3.54 0.0313 * 
Xb1:Xw1     2   8414    4207    5.18 0.0067 **
Residuals 156 126797     813                  
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
(Intercept)     1   156  2715.5  <.0001
Xb1             1    78     6.0  0.0168
Xw1             2   156     3.5  0.0313
Xb1:Xw1         2   156     5.2  0.0067
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
          method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   156  2715.5  <.0001
Xb1             1    78     6.0  0.0168
Xw1             2   156     3.5  0.0313
Xb1:Xw1         2   156     5.2  0.0067
```



```r
anova(lme(Y ~ Xb1*Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   156  2715.5  <.0001
Xb1             1    78     6.0  0.0168
Xw1             2   156     3.5  0.0313
Xb1:Xw1         2   156     5.2  0.0067
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
        Df Sum Sq Mean Sq F value
Xb1      1   5335    5335    6.35
Xw1      2   5756    2878    3.43
Xb1:Xw1  2   8414    4207    5.01
```


Three-way split-plot-factorial ANOVA (SPF-$pq \cdot r$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xb1*Xb2*Xw1 + Error(id/Xw1), data=d1))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)   
Xb1        1   5335    5335    7.47 0.0078 **
Xb2        1   7246    7246   10.14 0.0021 **
Xb1:Xb2    1   8169    8169   11.44 0.0011 **
Residuals 76  54290     714                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1
             Df Sum Sq Mean Sq F value  Pr(>F)    
Xw1           2   5756    2878    4.12 0.01817 *  
Xb1:Xw1       2   8414    4207    6.02 0.00306 ** 
Xb2:Xw1       2  11336    5668    8.11 0.00045 ***
Xb1:Xb2:Xw1   2   9167    4583    6.55 0.00186 ** 
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
            numDF denDF F-value p-value
(Intercept)     1   152    3397  <.0001
Xb1             1    76       7  0.0078
Xb2             1    76      10  0.0021
Xw1             2   152       4  0.0182
Xb1:Xb2         1    76      11  0.0011
Xb1:Xw1         2   152       6  0.0031
Xb2:Xw1         2   152       8  0.0005
Xb1:Xb2:Xw1     2   152       7  0.0019
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1, random=~1 | id,
          correlation=corCompSymm(form=~1 | id), method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   152    3397  <.0001
Xb1             1    76       7  0.0078
Xb2             1    76      10  0.0021
Xw1             2   152       4  0.0182
Xb1:Xb2         1    76      11  0.0011
Xb1:Xw1         2   152       6  0.0031
Xb2:Xw1         2   152       8  0.0005
Xb1:Xb2:Xw1     2   152       7  0.0019
```



```r
anova(lme(Y ~ Xb1*Xb2*Xw1,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1)))),
          method="ML", data=d1))
```

```
            numDF denDF F-value p-value
(Intercept)     1   152    3397  <.0001
Xb1             1    76       7  0.0078
Xb2             1    76      10  0.0021
Xw1             2   152       4  0.0182
Xb1:Xb2         1    76      11  0.0011
Xb1:Xw1         2   152       6  0.0031
Xb2:Xw1         2   152       8  0.0005
Xb1:Xb2:Xw1     2   152       7  0.0019
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xb2*Xw1 + (1|id), data=d1))
```

```
Analysis of Variance Table
            Df Sum Sq Mean Sq F value
Xb1          1   5335    5335    7.57
Xb2          1   7246    7246   10.29
Xw1          2   5756    2878    4.09
Xb1:Xb2      1   8169    8169   11.60
Xb1:Xw1      2   8414    4207    5.97
Xb2:Xw1      2  11336    5668    8.05
Xb1:Xb2:Xw1  2   9167    4583    6.51
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
Xb1        1  16005   16005    5.97  0.017 *
Residuals 78 209116    2681                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1
           Df Sum Sq Mean Sq F value Pr(>F)   
Xw1         2  17269    8635    3.54 0.0313 * 
Xb1:Xw1     2  25243   12622    5.18 0.0067 **
Residuals 156 380390    2438                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw2
           Df Sum Sq Mean Sq F value Pr(>F)
Xw2         2   9859    4929     1.6   0.20
Xb1:Xw2     2   2462    1231     0.4   0.67
Residuals 156 479476    3074               

Error: id:Xw1:Xw2
             Df Sum Sq Mean Sq F value Pr(>F)
Xw1:Xw2       4   6118    1529    0.60   0.66
Xb1:Xw1:Xw2   4   7609    1902    0.75   0.56
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
            numDF denDF F-value p-value
(Intercept)     1   624  2474.0  <.0001
Xb1             1    78     5.4  0.0223
Xw1             2   624     3.4  0.0327
Xw2             2   624     1.7  0.1881
Xb1:Xw1         2   624     5.0  0.0068
Xb1:Xw2         2   624     0.4  0.6584
Xw1:Xw2         4   624     0.6  0.6561
Xb1:Xw1:Xw2     4   624     0.8  0.5531
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
            numDF denDF F-value p-value
(Intercept)     1   624  2715.4  <.0001
Xb1             1    78     6.0  0.0168
Xw1             2   624     3.4  0.0327
Xw2             2   624     1.6  0.2020
Xb1:Xw1         2   624     5.0  0.0068
Xb1:Xw2         2   624     0.4  0.6702
Xw1:Xw2         4   624     0.6  0.6561
Xb1:Xw1:Xw2     4   624     0.8  0.5531
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
            Df Sum Sq Mean Sq F value
Xb1          1  13653   13653    5.44
Xw1          2  17269    8635    3.44
Xw2          2   8410    4205    1.68
Xb1:Xw1      2  25243   12622    5.03
Xb1:Xw2      2   2100    1050    0.42
Xw1:Xw2      4   6118    1529    0.61
Xb1:Xw1:Xw2  4   7609    1902    0.76
```


Four-way split-plot-factorial ANOVA (SPF-$pq \cdot rs$ design)
-------------------------

### Conventional analysis using `aov()`


```r
summary(aov(Y ~ Xb1*Xb2*Xw1*Xw2 + Error(id/(Xw1*Xw2)), data=d2))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)   
Xb1        1  16005   16005    7.47 0.0078 **
Xb2        1  21738   21738   10.14 0.0021 **
Xb1:Xb2    1  24507   24507   11.44 0.0011 **
Residuals 76 162871    2143                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1
             Df Sum Sq Mean Sq F value  Pr(>F)    
Xw1           2  17269    8635    4.12 0.01817 *  
Xb1:Xw1       2  25243   12622    6.02 0.00306 ** 
Xb2:Xw1       2  34008   17004    8.11 0.00045 ***
Xb1:Xb2:Xw1   2  27500   13750    6.55 0.00186 ** 
Residuals   152 318882    2098                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw2
             Df Sum Sq Mean Sq F value Pr(>F)   
Xw2           2   9859    4929    1.73 0.1811   
Xb1:Xw2       2   2462    1231    0.43 0.6503   
Xb2:Xw2       2  11822    5911    2.07 0.1294   
Xb1:Xb2:Xw2   2  34080   17040    5.97 0.0032 **
Residuals   152 433574    2852                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:Xw1:Xw2
                 Df Sum Sq Mean Sq F value Pr(>F)  
Xw1:Xw2           4   6118    1529    0.61  0.656  
Xb1:Xw1:Xw2       4   7609    1902    0.76  0.553  
Xb2:Xw1:Xw2       4  24545    6136    2.45  0.046 *
Xb1:Xb2:Xw1:Xw2   4   7595    1899    0.76  0.554  
Residuals       304 762320    2508                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
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
(Intercept)         1   608  2782.9  <.0001
Xb1                 1    76     6.1  0.0156
Xb2                 1    76     8.3  0.0051
Xw1                 2   608     3.6  0.0268
Xw2                 2   608     1.9  0.1528
Xb1:Xb2             1    76     9.4  0.0031
Xb1:Xw1             2   608     5.3  0.0051
Xb2:Xw1             2   608     7.2  0.0008
Xb1:Xw2             2   608     0.5  0.6249
Xb2:Xw2             2   608     2.3  0.1053
Xw1:Xw2             4   608     0.6  0.6305
Xb1:Xb2:Xw1         2   608     5.8  0.0032
Xb1:Xb2:Xw2         2   608     6.5  0.0016
Xb1:Xw1:Xw2         4   608     0.8  0.5240
Xb2:Xw1:Xw2         4   608     2.6  0.0359
Xb1:Xb2:Xw1:Xw2     4   608     0.8  0.5249
```


assume compound symmetry


```r
anova(lme(Y ~ Xb1*Xb2*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))
```

```
                numDF denDF F-value p-value
(Intercept)         1   608  3113.2  <.0001
Xb1                 1    76     6.8  0.0107
Xb2                 1    76     9.3  0.0032
Xw1                 2   608     3.7  0.0255
Xw2                 2   608     1.7  0.1785
Xb1:Xb2             1    76    10.5  0.0018
Xb1:Xw1             2   608     5.4  0.0047
Xb2:Xw1             2   608     7.3  0.0008
Xb1:Xw2             2   608     0.4  0.6497
Xb2:Xw2             2   608     2.1  0.1268
Xw1:Xw2             4   608     0.7  0.6242
Xb1:Xb2:Xw1         2   608     5.9  0.0030
Xb1:Xb2:Xw2         2   608     6.0  0.0027
Xb1:Xw1:Xw2         4   608     0.8  0.5168
Xb2:Xw1:Xw2         4   608     2.6  0.0339
Xb1:Xb2:Xw1:Xw2     4   608     0.8  0.5178
```


#### Using `lmer()` from package `lme4`


```r
anova(lmer(Y ~ Xb1*Xb2*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))
```

```
Analysis of Variance Table
                Df Sum Sq Mean Sq F value
Xb1              1  14506   14506    6.12
Xb2              1  19703   19703    8.31
Xw1              2  17269    8635    3.64
Xw2              2   8935    4468    1.88
Xb1:Xb2          1  22212   22212    9.37
Xb1:Xw1          2  25243   12622    5.32
Xb2:Xw1          2  34008   17004    7.17
Xb1:Xw2          2   2231    1116    0.47
Xb2:Xw2          2  10715    5357    2.26
Xw1:Xw2          4   6118    1529    0.65
Xb1:Xb2:Xw1      2  27500   13750    5.80
Xb1:Xb2:Xw2      2  30889   15444    6.51
Xb1:Xw1:Xw2      4   7609    1902    0.80
Xb2:Xw1:Xw2      4  24545    6136    2.59
Xb1:Xb2:Xw1:Xw2  4   7595    1899    0.80
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
