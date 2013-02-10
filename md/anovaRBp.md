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

[`car`](http://cran.r-project.org/package=car), [`ICSNP`](http://cran.r-project.org/package=ICSNP)


```r
wants <- c("car", "ICSNP")
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
summary(aov(DV ~ IV + Error(id/IV), data=dfRBpL))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   60.8    6.76               

Error: id:IV
          Df Sum Sq Mean Sq F value Pr(>F)  
IV         3   82.5   27.50    3.85   0.02 *
Residuals 27  192.9    7.14                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Effect size estimate: generalized $\hat{\eta}_{g}^{2}$


```r
(anRes <- anova(lm(DV ~ IV*id, data=dfRBpL)))
```

```
Analysis of Variance Table

Response: DV
          Df Sum Sq Mean Sq F value Pr(>F)
IV         3   82.5   27.50               
id         9   60.8    6.76               
IV:id     27  192.9    7.14               
Residuals  0    0.0                       
```



```r
SSEtot <- anRes["id", "Sum Sq"] + anRes["IV:id", "Sum Sq"]
SSb    <- anRes["IV", "Sum Sq"]
```



```r
(gEtaSq <- SSb / (SSb + SSEtot))
```

```
[1] 0.2454
```


Or from function `ezANOVA()` from package [`ez`](http://cran.r-project.org/package=ez)

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

              SS num Df Error SS den Df    F Pr(>F)  
(Intercept) 16.2      1     60.8      9 2.39   0.16  
IV          82.5      3    192.9     27 3.85   0.02 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

   Test statistic p-value
IV          0.304   0.104


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

   GG eps Pr(>F[GG])  
IV  0.585      0.048 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

   HF eps Pr(>F[HF])  
IV  0.716      0.037 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
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

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 3.85      3     27 0.0205 0.0481 0.0366
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

### Hotelling's $T^{2}$-test using `HotellingsT2()` from package `ICSNP`


```r
DVw     <- data.matrix(subset(dfRBpW,
                       select=c("DV.1", "DV.2", "DV.3", "DV.4")))
diffMat <- combn(1:P, 2, function(x) { DVw[ , x[1]] - DVw[ , x[2]] } )
DVdiff  <- diffMat[ , 1:(P-1), drop=FALSE]
muH0    <- rep(0, ncol(DVdiff))
```



```r
library(ICSNP)
HotellingsT2(DVdiff, mu=muH0)
```

```

	Hotelling's one sample T2-test

data:  DVdiff 
T.2 = 12.27, df1 = 3, df2 = 7, p-value = 0.003555
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
(Intercept)       64.63

Sum of squares and products for error:
            (Intercept)
(Intercept)       243.3

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df Pr(>F)
Pillai            1    0.2099    2.391      1      9  0.156
Wilks             1    0.7901    2.391      1      9  0.156
Hotelling-Lawley  1    0.2657    2.391      1      9  0.156
Roy               1    0.2657    2.391      1      9  0.156

------------------------------------------
 
Term: IV 

 Response transformation matrix:
     IV1 IV2 IV3
DV.1   1   0   0
DV.2   0   1   0
DV.3   0   0   1
DV.4  -1  -1  -1

Sum of squares and products for the hypothesis:
       IV1   IV2    IV3
IV1 140.04 87.58 121.24
IV2  87.58 54.77  75.82
IV3 121.24 75.82 104.96

Sum of squares and products for error:
       IV1    IV2    IV3
IV1  41.37  29.40 -16.70
IV2  29.40  85.75 -16.53
IV3 -16.70 -16.53 127.47

Multivariate Tests: IV
                 Df test stat approx F num Df den Df  Pr(>F)   
Pillai            1     0.840    12.27      3      7 0.00355 **
Wilks             1     0.160    12.27      3      7 0.00355 **
Hotelling-Lawley  1     5.257    12.27      3      7 0.00355 **
Roy               1     5.257    12.27      3      7 0.00355 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:ICSNP))
try(detach(package:ICS))
try(detach(package:survey))
try(detach(package:mvtnorm))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaRBp.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaRBp.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaRBp.R) - [all posts](https://github.com/dwoll/RExRepos/)
