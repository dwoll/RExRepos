---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "One-way repeated measures ANOVA (RB-p design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---




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
set.seed(1.234)
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
Residuals  9   60.4    6.71               

Error: id:IV
          Df Sum Sq Mean Sq F value Pr(>F)
IV         3   44.5   14.84    1.92   0.15
Residuals 27  208.6    7.72               
```


### Effect size estimate: generalized $\hat{\eta}_{g}^{2}$


```r
(anRes <- anova(lm(DV ~ IV*id, data=dfRBpL)))
```

```
Analysis of Variance Table

Response: DV
          Df Sum Sq Mean Sq F value Pr(>F)
IV         3   44.5   14.84               
id         9   60.4    6.71               
IV:id     27  208.6    7.72               
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
[1] 0.142
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
(Intercept) 24.1      1     60.4      9 3.59  0.091 .
IV          44.5      3    208.6     27 1.92  0.150  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

   Test statistic p-value
IV          0.611   0.581


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

   GG eps Pr(>F[GG])
IV  0.748       0.17

   HF eps Pr(>F[HF])
IV   1.01       0.15
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

Greenhouse-Geisser epsilon: 0.7478
Huynh-Feldt epsilon:        1.0081

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 1.92      3     27   0.15  0.169   0.15
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
W = 0.6113, p-value = 0.5811
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
T.2 = 1.994, df1 = 3, df2 = 7, p-value = 0.2036
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
(Intercept)       96.37

Sum of squares and products for error:
            (Intercept)
(Intercept)       241.5

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df Pr(>F)  
Pillai            1    0.2852    3.591      1      9 0.0906 .
Wilks             1    0.7148    3.591      1      9 0.0906 .
Hotelling-Lawley  1    0.3990    3.591      1      9 0.0906 .
Roy               1    0.3990    3.591      1      9 0.0906 .
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV 

 Response transformation matrix:
     IV1 IV2 IV3
DV.1   1   0   0
DV.2   0   1   0
DV.3   0   0   1
DV.4  -1  -1  -1

Sum of squares and products for the hypothesis:
      IV1   IV2   IV3
IV1 87.95 47.91 52.29
IV2 47.91 26.10 28.49
IV3 52.29 28.49 31.09

Sum of squares and products for error:
       IV1    IV2    IV3
IV1 127.30  27.66  17.01
IV2  27.66 120.98  85.45
IV3  17.01  85.45 116.54

Multivariate Tests: IV
                 Df test stat approx F num Df den Df Pr(>F)
Pillai            1    0.4607    1.994      3      7  0.204
Wilks             1    0.5393    1.994      3      7  0.204
Hotelling-Lawley  1    0.8544    1.994      3      7  0.204
Roy               1    0.8544    1.994      3      7  0.204
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
