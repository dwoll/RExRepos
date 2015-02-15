---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "One-way repeated measures ANOVA (RB-p design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---

One-way repeated measures ANOVA (RB-p design)
=========================

TODO
-------------------------

 - link to anovaMixed, dfReshape

Traditional univariate analysis and multivariate approach.

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`DescTools`](http://cran.r-project.org/package=DescTools)


```r
wants <- c("car", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Traditional univariate approach
-------------------------

### Using `aov()` with data in long format


```r
set.seed(123)
N      <- 10
P      <- 4
muJ    <- rep(c(-1, 0, 1, 2), each=N)
dfRBpL <- data.frame(id=factor(rep(1:N, times=P)),
                     IV=factor(rep(1:P,  each=N)),
                     DV=rnorm(N*P, muJ, 3))
```


```r
aovRBp <- aov(DV ~ IV + Error(id/IV), data=dfRBpL)
summary(aovRBp)
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9  60.81   6.757               

Error: id:IV
          Df Sum Sq Mean Sq F value Pr(>F)  
IV         3  82.51  27.504   3.851 0.0205 *
Residuals 27 192.86   7.143                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Effect size estimate: generalized $\hat{\eta}_{g}^{2}$


```r
library(DescTools)
EtaSq(aovRBp, type=1)
```

```
Error in EtaSq.aovlist(aovRBp, type = 1): konnte Funktion "is" nicht finden
```

### Using `Anova()` from package `car` with data in wide format


```r
dfRBpW <- reshape(dfRBpL, v.names="DV", timevar="IV", idvar="id",
                  direction="wide")
```


```r
library(car)
fitRBp   <- lm(cbind(DV.1, DV.2, DV.3, DV.4) ~ 1, data=dfRBpW)
inRBp    <- data.frame(IV=gl(P, 1))
AnovaRBp <- Anova(fitRBp, idata=inRBp, idesign=~IV)
summary(AnovaRBp, multivariate=FALSE, univariate=TRUE)
```

```

Univariate Type III Repeated-Measures ANOVA Assuming Sphericity

                SS num Df Error SS den Df      F  Pr(>F)  
(Intercept) 16.157      1   60.813      9 2.3912 0.15643  
IV          82.512      3  192.859     27 3.8505 0.02047 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


Mauchly Tests for Sphericity

   Test statistic p-value
IV        0.30399 0.10403


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

    GG eps Pr(>F[GG])  
IV 0.58505    0.04805 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

      HF eps Pr(>F[HF])
IV 0.7155256 0.03663577
```

### Using `anova.mlm()` and `mauchly.test()` with data in wide format


```r
anova(fitRBp, M=~IV, X=~1, idata=inRBp, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~1


Contrasts spanned by
~IV

Greenhouse-Geisser epsilon: 0.5851
Huynh-Feldt epsilon:        0.7155

            Df      F num Df den Df   Pr(>F)   G-G Pr   H-F Pr
(Intercept)  1 3.8505      3     27 0.020472 0.048054 0.036636
Residuals    9                                                
```


```r
mauchly.test(fitRBp, M=~IV, X=~1, idata=inRBp)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~1

	Contrasts spanned by
	~IV


data:  SSD matrix from lm(formula = cbind(DV.1, DV.2, DV.3, DV.4) ~ 1, data = dfRBpW)
W = 0.304, p-value = 0.104
```

Multivariate approach
-------------------------

### Hotelling's $T^{2}$-test using `HotellingsT2Test()` from package `DescTools`


```r
DVw     <- data.matrix(subset(dfRBpW,
                       select=c("DV.1", "DV.2", "DV.3", "DV.4")))
diffMat <- combn(1:P, 2, function(x) { DVw[ , x[1]] - DVw[ , x[2]] } )
DVdiff  <- diffMat[ , 1:(P-1), drop=FALSE]
muH0    <- rep(0, ncol(DVdiff))
```


```r
library(DescTools)
HotellingsT2Test(DVdiff, mu=muH0)
```

```

	Hotelling's one sample T2-test

data:  DVdiff
T.2 = 12.2668, df1 = 3, df2 = 7, p-value = 0.003555
alternative hypothesis: true location is not equal to c(0,0,0)
```

### Using `Anova()` from package `car`


```r
library(car)
summary(AnovaRBp, multivariate=TRUE, univariate=FALSE)
```

```

Type III Repeated Measures MANOVA Tests:

------------------------------------------
 
Term: (Intercept) 

 Response transformation matrix:
     (Intercept)
DV.1           1
DV.2           1
DV.3           1
DV.4           1

Sum of squares and products for the hypothesis:
            (Intercept)
(Intercept)     64.6278

Sum of squares and products for error:
            (Intercept)
(Intercept)    243.2504

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df  Pr(>F)
Pillai            1 0.2099135 2.391158      1      9 0.15643
Wilks             1 0.7900865 2.391158      1      9 0.15643
Hotelling-Lawley  1 0.2656842 2.391158      1      9 0.15643
Roy               1 0.2656842 2.391158      1      9 0.15643

------------------------------------------
 
Term: IV 

 Response transformation matrix:
     IV1 IV2 IV3
DV.1   1   0   0
DV.2   0   1   0
DV.3   0   0   1
DV.4  -1  -1  -1

Sum of squares and products for the hypothesis:
          IV1      IV2       IV3
IV1 140.04485 87.57883 121.24202
IV2  87.57883 54.76853  75.82024
IV3 121.24202 75.82024 104.96371

Sum of squares and products for error:
          IV1       IV2       IV3
IV1  41.37357  29.39860 -16.70424
IV2  29.39860  85.74790 -16.52793
IV3 -16.70424 -16.52793 127.46877

Multivariate Tests: IV
                 Df test stat approx F num Df den Df    Pr(>F)   
Pillai            1  0.840184 12.26683      3      7 0.0035548 **
Wilks             1  0.159816 12.26683      3      7 0.0035548 **
Hotelling-Lawley  1  5.257214 12.26683      3      7 0.0035548 **
Roy               1  5.257214 12.26683      3      7 0.0035548 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:DescTools))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaRBp.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaRBp.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaRBp.R) - [all posts](https://github.com/dwoll/RExRepos/)
