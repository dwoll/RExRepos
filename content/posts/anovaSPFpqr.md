---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Three-way split-plot-factorial ANOVA (SPF-pq.r and SPF-p.qr design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---




TODO
-------------------------

 - link to anovaSPFpq, anovaMixed, dfReshape

Traditional univariate analysis and multivariate approach.

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`DescTools`](http://cran.r-project.org/package=DescTools)


```r
wants <- c("car", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Three-way SPF-$pq \cdot r$ ANOVA
-------------------------

### Using `aov()` with data in long format


```r
set.seed(123)
Njk   <- 10
P     <- 2
Q     <- 2
R     <- 3
DV_t1 <- rnorm(P*Q*Njk, -3, 2)
DV_t2 <- rnorm(P*Q*Njk,  1, 2)
DV_t3 <- rnorm(P*Q*Njk,  2, 2)
dfSPFpq.rL <- data.frame(id=factor(rep(1:(P*Q*Njk), times=R)),
                         IVbtw1=factor(rep(1:P, times=Q*R*Njk)),
                         IVbtw2=factor(rep(rep(1:Q, each=P*Njk), times=R)),
                         IVwth=factor(rep(1:R, each=P*Q*Njk)),
                         DV=c(DV_t1, DV_t2, DV_t3))
```


```r
aovSPFpq.r <- aov(DV ~ IVbtw1*IVbtw2*IVwth + Error(id/IVwth), data=dfSPFpq.rL)
summary(aovSPFpq.r)
```

```

Error: id
              Df Sum Sq Mean Sq F value Pr(>F)  
IVbtw1         1   0.11   0.106   0.038 0.8467  
IVbtw2         1  17.75  17.749   6.326 0.0165 *
IVbtw1:IVbtw2  1   0.05   0.048   0.017 0.8969  
Residuals     36 101.00   2.806                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:IVwth
                    Df Sum Sq Mean Sq F value Pr(>F)    
IVwth                2  540.0  269.99  80.859 <2e-16 ***
IVbtw1:IVwth         2    2.3    1.17   0.351  0.705    
IVbtw2:IVwth         2    7.4    3.68   1.103  0.337    
IVbtw1:IVbtw2:IVwth  2   11.5    5.77   1.728  0.185    
Residuals           72  240.4    3.34                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Effect size estimates: generalized $\hat{\eta}_{g}^{2}$


```r
library(DescTools)
EtaSq(aovSPFpq.r, type=1)
```

```
Error in EtaSq.aovlist(aovSPFpq.r, type = 1): konnte Funktion "is" nicht finden
```

### Using `Anova()` from package `car` with data in wide format


```r
dfSPFpq.rW <- reshape(dfSPFpq.rL, v.names="DV", timevar="IVwth",
                      idvar=c("id", "IVbtw1", "IVbtw2"), direction="wide")
```


```r
library(car)
fitSPFpq.r   <- lm(cbind(DV.1, DV.2, DV.3) ~ IVbtw1*IVbtw2, data=dfSPFpq.rW)
inSPFpq.r    <- data.frame(IVwth=gl(R, 1))
AnovaSPFpq.r <- Anova(fitSPFpq.r, idata=inSPFpq.r, idesign=~IVwth)
summary(AnovaSPFpq.r, multivariate=FALSE, univariate=TRUE)
```

```

Univariate Type II Repeated-Measures ANOVA Assuming Sphericity

                        SS num Df Error SS den Df       F Pr(>F)    
(Intercept)           0.11      1   101.00     36  0.0408 0.8411    
IVbtw1                0.11      1   101.00     36  0.0379 0.8467    
IVbtw2               17.75      1   101.00     36  6.3261 0.0165 *  
IVbtw1:IVbtw2         0.05      1   101.00     36  0.0170 0.8969    
IVwth               539.98      2   240.41     72 80.8589 <2e-16 ***
IVbtw1:IVwth          2.34      2   240.41     72  0.3511 0.7051    
IVbtw2:IVwth          7.37      2   240.41     72  1.1033 0.3373    
IVbtw1:IVbtw2:IVwth  11.54      2   240.41     72  1.7283 0.1849    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


Mauchly Tests for Sphericity

                    Test statistic p-value
IVwth                       0.9932 0.88741
IVbtw1:IVwth                0.9932 0.88741
IVbtw2:IVwth                0.9932 0.88741
IVbtw1:IVbtw2:IVwth         0.9932 0.88741


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

                     GG eps Pr(>F[GG])    
IVwth               0.99324     <2e-16 ***
IVbtw1:IVwth        0.99324     0.7037    
IVbtw2:IVwth        0.99324     0.3370    
IVbtw1:IVbtw2:IVwth 0.99324     0.1851    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

                      HF eps   Pr(>F[HF])
IVwth               1.051053 3.900060e-19
IVbtw1:IVwth        1.051053 7.051035e-01
IVbtw2:IVwth        1.051053 3.373222e-01
IVbtw1:IVbtw2:IVwth 1.051053 1.848719e-01
```

### Using `anova.mlm()` and `mauchly.test()` with data in wide format


```r
anova(fitSPFpq.r, M=~1, X=~0, idata=inSPFpq.r, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~0


Contrasts spanned by
~1

Greenhouse-Geisser epsilon: 1
Huynh-Feldt epsilon:        1

              Df      F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)    1 0.0408      1     36 0.84107 0.84107 0.84107
IVbtw1         1 0.0379      1     36 0.84668 0.84668 0.84668
IVbtw2         1 6.3261      1     36 0.01650 0.01650 0.01650
IVbtw1:IVbtw2  1 0.0170      1     36 0.89693 0.89693 0.89693
Residuals     36                                             
```

```r
anova(fitSPFpq.r, M=~IVwth, X=~1, idata=inSPFpq.r, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~1


Contrasts spanned by
~IVwth

Greenhouse-Geisser epsilon: 0.9932
Huynh-Feldt epsilon:        1.0511

              Df       F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)    1 80.8589      2     72 0.00000 0.00000 0.00000
IVbtw1         1  0.3511      2     72 0.70510 0.70367 0.70510
IVbtw2         1  1.1033      2     72 0.33732 0.33704 0.33732
IVbtw1:IVbtw2  1  1.7283      2     72 0.18487 0.18512 0.18487
Residuals     36                                              
```


```r
mauchly.test(fitSPFpq.r, M=~IVwth, X=~1, idata=inSPFpq.r)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~1

	Contrasts spanned by
	~IVwth


data:  SSD matrix from lm(formula = cbind(DV.1, DV.2, DV.3) ~ IVbtw1 * IVbtw2, data = dfSPFpq.rW)
W = 0.9932, p-value = 0.8874
```

Three-way SPF-$p \cdot qr$ ANOVA
-------------------------

### Using `aov()` with data in long format


```r
Nj     <- 10
P      <- 2
Q      <- 3
R      <- 2
DV_t11 <- rnorm(P*Nj,  8, 2)
DV_t21 <- rnorm(P*Nj, 13, 2)
DV_t31 <- rnorm(P*Nj, 13, 2)
DV_t12 <- rnorm(P*Nj, 10, 2)
DV_t22 <- rnorm(P*Nj, 15, 2)
DV_t32 <- rnorm(P*Nj, 15, 2)
dfSPFp.qrL <- data.frame(id=factor(rep(1:(P*Nj), times=Q*R)),
                         IVbtw=factor(rep(LETTERS[1:P], times=Q*R*Nj)),
                         IVwth1=factor(rep(1:Q, each=P*R*Nj)),
                         IVwth2=factor(rep(rep(1:R, each=P*Nj), times=Q)),
                         DV=c(DV_t11, DV_t12, DV_t21, DV_t22, DV_t31, DV_t32))
```


```r
aovSPFp.qr <- aov(DV ~ IVbtw*IVwth1*IVwth2 + Error(id/(IVwth1*IVwth2)),
                  data=dfSPFp.qrL)
summary(aovSPFp.qr)
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
IVbtw      1   2.32   2.323   0.407  0.531
Residuals 18 102.64   5.702               

Error: id:IVwth1
             Df Sum Sq Mean Sq F value   Pr(>F)    
IVwth1        2  534.5  267.25  62.647 1.89e-12 ***
IVbtw:IVwth1  2    5.1    2.53   0.593    0.558    
Residuals    36  153.6    4.27                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:IVwth2
             Df Sum Sq Mean Sq F value   Pr(>F)    
IVwth2        1 109.87  109.87  17.043 0.000631 ***
IVbtw:IVwth2  1  10.23   10.23   1.587 0.223859    
Residuals    18 116.03    6.45                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:IVwth1:IVwth2
                    Df Sum Sq Mean Sq F value Pr(>F)
IVwth1:IVwth2        2   6.93   3.466   0.846  0.437
IVbtw:IVwth1:IVwth2  2   7.80   3.899   0.952  0.396
Residuals           36 147.50   4.097               
```

### Effect size estimates: generalized $\hat{\eta}_{g}^{2}$


```r
library(DescTools)
EtaSq(aovSPFp.qr, type=1)
```

```
Error in EtaSq.aovlist(aovSPFp.qr, type = 1): konnte Funktion "is" nicht finden
```

### Using `Anova()` from package `car` with data in wide format


```r
dfW1       <- reshape(dfSPFp.qrL, v.names="DV", timevar="IVwth1",
                      idvar=c("id", "IVbtw", "IVwth2"), direction="wide")
dfSPFp.qrW <- reshape(dfW1, v.names=c("DV.1", "DV.2", "DV.3"),
                      timevar="IVwth2", idvar=c("id", "IVbtw"), direction="wide")
```


```r
library(car)
fitSPFp.qr   <- lm(cbind(DV.1.1, DV.2.1, DV.3.1, DV.1.2, DV.2.2, DV.3.2) ~ IVbtw,
                   data=dfSPFp.qrW)
inSPFp.qr    <- expand.grid(IVwth1=gl(Q, 1), IVwth2=gl(R, 1))
AnovaSPFp.qr <- Anova(fitSPFp.qr, idata=inSPFp.qr, idesign=~IVwth1*IVwth2)
summary(AnovaSPFp.qr, multivariate=FALSE, univariate=TRUE)
```

```

Univariate Type II Repeated-Measures ANOVA Assuming Sphericity

                         SS num Df Error SS den Df         F    Pr(>F)    
(Intercept)         18082.5      1   102.64     18 3170.9826 < 2.2e-16 ***
IVbtw                   2.3      1   102.64     18    0.4075 0.5313035    
IVwth1                534.5      2   153.58     36   62.6468 1.889e-12 ***
IVbtw:IVwth1            5.1      2   153.58     36    0.5930 0.5579974    
IVwth2                109.9      1   116.03     18   17.0433 0.0006311 ***
IVbtw:IVwth2           10.2      1   116.03     18    1.5869 0.2238586    
IVwth1:IVwth2           6.9      2   147.50     36    0.8460 0.4374751    
IVbtw:IVwth1:IVwth2     7.8      2   147.50     36    0.9516 0.3956300    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


Mauchly Tests for Sphericity

                    Test statistic p-value
IVwth1                     0.80930 0.16556
IVbtw:IVwth1               0.80930 0.16556
IVwth1:IVwth2              0.94011 0.59160
IVbtw:IVwth1:IVwth2        0.94011 0.59160


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

                     GG eps Pr(>F[GG])    
IVwth1              0.83985  8.499e-11 ***
IVbtw:IVwth1        0.83985     0.5308    
IVwth1:IVwth2       0.94350     0.4320    
IVbtw:IVwth1:IVwth2 0.94350     0.3915    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

                       HF eps   Pr(>F[HF])
IVwth1              0.9164691 1.373942e-11
IVbtw:IVwth1        0.9164691 5.443499e-01
IVwth1:IVwth2       1.0504830 4.374751e-01
IVbtw:IVwth1:IVwth2 1.0504830 3.956300e-01
```

### Using `anova.mlm()` and `mauchly.test()` with data in wide format


```r
anova(fitSPFp.qr, M=~1, X=~0,
      idata=inSPFp.qr, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~0


Contrasts spanned by
~1

Greenhouse-Geisser epsilon: 1
Huynh-Feldt epsilon:        1

            Df         F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 3170.9826      1     18 0.0000 0.0000 0.0000
IVbtw        1    0.4075      1     18 0.5313 0.5313 0.5313
Residuals   18                                             
```

```r
anova(fitSPFp.qr, M=~IVwth1, X=~1,
      idata=inSPFp.qr, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~1


Contrasts spanned by
~IVwth1

Greenhouse-Geisser epsilon: 0.8398
Huynh-Feldt epsilon:        0.9165

            Df      F num Df den Df Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1 62.647      2     36  0.000 0.00000 0.00000
IVbtw        1  0.593      2     36  0.558 0.53075 0.54435
Residuals   18                                            
```

```r
anova(fitSPFp.qr, M=~IVwth1 + IVwth2, X=~IVwth1,
      idata=inSPFp.qr, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~IVwth1


Contrasts spanned by
~IVwth1 + IVwth2

Greenhouse-Geisser epsilon: 1
Huynh-Feldt epsilon:        1

            Df       F num Df den Df   Pr(>F)   G-G Pr   H-F Pr
(Intercept)  1 17.0433      1     18 0.000631 0.000631 0.000631
IVbtw        1  1.5869      1     18 0.223859 0.223859 0.223859
Residuals   18                                                 
```

```r
anova(fitSPFp.qr, M=~IVwth1 + IVwth2 + IVwth1:IVwth2, X=~IVwth1 + IVwth2,
      idata=inSPFp.qr, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~IVwth1 + IVwth2


Contrasts spanned by
~IVwth1 + IVwth2 + IVwth1:IVwth2

Greenhouse-Geisser epsilon: 0.9435
Huynh-Feldt epsilon:        1.0505

            Df      F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1 0.8460      2     36 0.43748 0.43201 0.43748
IVbtw        1 0.9516      2     36 0.39563 0.39154 0.39563
Residuals   18                                             
```


```r
mauchly.test(fitSPFp.qr, M=~IVwth1, X=~1,
             idata=inSPFp.qr)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~1

	Contrasts spanned by
	~IVwth1


data:  SSD matrix from lm(formula = cbind(DV.1.1, DV.2.1, DV.3.1, DV.1.2, DV.2.2, DV.3.2) ~  SSD matrix from     IVbtw, data = dfSPFp.qrW)
W = 0.8093, p-value = 0.1656
```
Mauchly-Test for IVwth2 is unnecessary here since R=2 -> sphericity holds automatically


```r
mauchly.test(fitSPFp.qr, M=~IVwth1 + IVwth2, X=~IVwth1,
             idata=inSPFp.qr)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~IVwth1

	Contrasts spanned by
	~IVwth1 + IVwth2


data:  SSD matrix from lm(formula = cbind(DV.1.1, DV.2.1, DV.3.1, DV.1.2, DV.2.2, DV.3.2) ~  SSD matrix from     IVbtw, data = dfSPFp.qrW)
W = 1, p-value = 1
```

```r
mauchly.test(fitSPFp.qr, M=~IVwth1 + IVwth2 + IVwth1:IVwth2, X=~IVwth1 + IVwth2,
             idata=inSPFp.qr)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~IVwth1 + IVwth2

	Contrasts spanned by
	~IVwth1 + IVwth2 + IVwth1:IVwth2


data:  SSD matrix from lm(formula = cbind(DV.1.1, DV.2.1, DV.3.1, DV.1.2, DV.2.2, DV.3.2) ~  SSD matrix from     IVbtw, data = dfSPFp.qrW)
W = 0.9401, p-value = 0.5916
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:DescTools))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaSPFpqr.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaSPFpqr.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaSPFpqr.R) - [all posts](https://github.com/dwoll/RExRepos/)
