---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Three-way split-plot-factorial ANOVA (SPF-pq.r and SPF-p.qr design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---

Three-way split-plot-factorial ANOVA (SPF-pq.r and SPF-p.qr design)
=========================

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
                          eta.sq  eta.sq.part   eta.sq.gen
IVbtw1              1.155981e-04 0.0010524579 0.0003115892
IVbtw2              1.928058e-02 0.1494602872 0.0494170687
IVbtw1:IVbtw2       5.186892e-05 0.0004725123 0.0001398342
IVwth               5.865837e-01 0.6919360568 0.6126434678
IVbtw1:IVwth        2.547111e-03 0.0096589020 0.0068209106
IVbtw2:IVwth        8.003689e-03 0.0297355126 0.0211244117
IVbtw1:IVbtw2:IVwth 1.253778e-02 0.0458090312 0.0327000780
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
IVbtw      1   3.71   3.706   0.679  0.421
Residuals 18  98.31   5.461               

Error: id:IVwth1
             Df Sum Sq Mean Sq F value   Pr(>F)    
IVwth1        2  716.5   358.3  80.042 5.62e-14 ***
IVbtw:IVwth1  2    0.9     0.5   0.101    0.904    
Residuals    36  161.1     4.5                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:IVwth2
             Df Sum Sq Mean Sq F value Pr(>F)    
IVwth2        1 114.65  114.65  30.564  3e-05 ***
IVbtw:IVwth2  1   0.38    0.38   0.101  0.754    
Residuals    18  67.52    3.75                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:IVwth1:IVwth2
                    Df Sum Sq Mean Sq F value Pr(>F)
IVwth1:IVwth2        2   4.15   2.077   0.655  0.526
IVbtw:IVwth1:IVwth2  2   8.08   4.042   1.274  0.292
Residuals           36 114.18   3.172               
```

### Effect size estimates: generalized $\hat{\eta}_{g}^{2}$


```r
library(DescTools)
EtaSq(aovSPFp.qr, type=1)
```

```
                          eta.sq eta.sq.part   eta.sq.gen
IVbtw               0.0028740065  0.03632976 0.0083311795
IVwth1              0.5556355565  0.81640536 0.6189329024
IVbtw:IVwth1        0.0006997461  0.00556892 0.0020412921
IVwth2              0.0889105137  0.62935256 0.2062858093
IVbtw:IVwth2        0.0002939672  0.00558274 0.0008585744
IVwth1:IVwth2       0.0032218292  0.03510836 0.0093300420
IVbtw:IVwth1:IVwth2 0.0062684477  0.06611257 0.0179939398
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
(Intercept)         18098.5      1   98.306     18 3313.8768 < 2.2e-16 ***
IVbtw                   3.7      1   98.306     18    0.6786    0.4209    
IVwth1                716.5      2  161.128     36   80.0421 5.617e-14 ***
IVbtw:IVwth1            0.9      2  161.128     36    0.1008    0.9044    
IVwth2                114.7      1   67.522     18   30.5637 3.002e-05 ***
IVbtw:IVwth2            0.4      1   67.522     18    0.1011    0.7542    
IVwth1:IVwth2           4.2      2  114.182     36    0.6549    0.5255    
IVbtw:IVwth1:IVwth2     8.1      2  114.182     36    1.2743    0.2919    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


Mauchly Tests for Sphericity

                    Test statistic p-value
IVwth1                     0.99188 0.93305
IVbtw:IVwth1               0.99188 0.93305
IVwth1:IVwth2              0.97532 0.80865
IVbtw:IVwth1:IVwth2        0.97532 0.80865


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

                     GG eps Pr(>F[GG])    
IVwth1              0.99195  6.993e-14 ***
IVbtw:IVwth1        0.99195     0.9030    
IVwth1:IVwth2       0.97592     0.5221    
IVbtw:IVwth1:IVwth2 0.97592     0.2917    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

                      HF eps   Pr(>F[HF])
IVwth1              1.114314 5.616681e-14
IVbtw:IVwth1        1.114314 9.043664e-01
IVwth1:IVwth2       1.093110 5.255497e-01
IVbtw:IVwth1:IVwth2 1.093110 2.919453e-01
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

            Df         F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1 3313.8768      1     18 0.00000 0.00000 0.00000
IVbtw        1    0.6786      1     18 0.42085 0.42085 0.42085
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

Greenhouse-Geisser epsilon: 0.9919
Huynh-Feldt epsilon:        1.1143

            Df       F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1 80.0421      2     36 0.00000 0.00000 0.00000
IVbtw        1  0.1008      2     36 0.90437 0.90299 0.90437
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

            Df       F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1 30.5637      1     18 0.00003 0.00003 0.00003
IVbtw        1  0.1011      1     18 0.75423 0.75423 0.75423
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

Greenhouse-Geisser epsilon: 0.9759
Huynh-Feldt epsilon:        1.0931

            Df      F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1 0.6549      2     36 0.52555 0.52211 0.52555
IVbtw        1 1.2743      2     36 0.29195 0.29167 0.29195
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
W = 0.9919, p-value = 0.933
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
W = 0.9753, p-value = 0.8086
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
