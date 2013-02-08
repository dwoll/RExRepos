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

[`car`](http://cran.r-project.org/package=car)


```r
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Three-way SPF-$pq \cdot r$ ANOVA
-------------------------

### Using `aov()` with data in long format


```r
set.seed(1.234)
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
summary(aov(DV ~ IVbtw1*IVbtw2*IVwth + Error(id/IVwth), data=dfSPFpq.rL))
```

```

Error: id
              Df Sum Sq Mean Sq F value Pr(>F)
IVbtw1         1    1.1    1.10    0.29   0.59
IVbtw2         1    0.8    0.77    0.20   0.65
IVbtw1:IVbtw2  1    1.4    1.42    0.38   0.54
Residuals     36  136.1    3.78               

Error: id:IVwth
                    Df Sum Sq Mean Sq F value Pr(>F)    
IVwth                2    573   286.3   92.14 <2e-16 ***
IVbtw1:IVwth         2      2     1.2    0.40   0.67    
IVbtw2:IVwth         2      1     0.4    0.14   0.87    
IVbtw1:IVbtw2:IVwth  2      3     1.7    0.55   0.58    
Residuals           72    224     3.1                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Effect size estimates: generalized $\hat{\eta}_{g}^{2}$


```r
anRes     <- anova(lm(DV ~ IVbtw1*IVbtw2*IVwth*id, data=dfSPFpq.rL))
SSEtot    <- anRes["id", "Sum Sq"] + anRes["IVwth:id", "Sum Sq"]
SSbtw1    <- anRes["IVbtw1",       "Sum Sq"]
SSbtw2    <- anRes["IVbtw2",       "Sum Sq"]
SSwth     <- anRes["IVwth",        "Sum Sq"]
SSbtw1Wth <- anRes["IVbtw1:IVwth", "Sum Sq"]
SSbtw2Wth <- anRes["IVbtw2:IVwth", "Sum Sq"]
```



```r
(gEtaSqB1 <- SSbtw1 / (SSbtw1 + SSEtot))
```

```
[1] 0.003007
```

```r
(gEtaSqB2 <- SSbtw2 / (SSbtw2 + SSEtot))
```

```
[1] 0.002103
```

```r
(gEtaSqW <- SSwth / (SSwth + SSEtot))
```

```
[1] 0.6109
```

```r
(gEtaSqB1W <- SSbtw1Wth / (SSbtw1Wth + SSEtot))
```

```
[1] 0.00675
```

```r
(gEtaSqB2W <- SSbtw2Wth / (SSbtw2Wth + SSEtot))
```

```
[1] 0.002299
```


Due to the nesting structure, the following interaction sums of squares are not calculated in the model above. We need to fit a model without `id` to get them.


```r
anRes2        <- anova(lm(DV ~ IVbtw1*IVbtw2*IVwth, data=dfSPFpq.rL))
SSbtw1Btw2    <- anRes2["IVbtw1:IVbtw2",       "Sum Sq"]
SSbtw1Btw2Wth <- anRes2["IVbtw1:IVbtw2:IVwth", "Sum Sq"]
```



```r
(gEtaSqB1B2 <- SSbtw1Btw2 / (SSbtw1Btw2 + SSEtot))
```

```
[1] 0.003891
```

```r
(gEtaSqB1B2W <- SSbtw1Btw2Wth / (SSbtw1Btw2Wth + SSEtot))
```

```
[1] 0.009338
```


Or from function `ezANOVA()` from package [`ez`](http://cran.r-project.org/package=ez)

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

                     SS num Df Error SS den Df     F Pr(>F)    
(Intercept)           6      1      136     36  1.53   0.22    
IVbtw1                1      1      136     36  0.29   0.59    
IVbtw2                1      1      136     36  0.20   0.65    
IVbtw1:IVbtw2         1      1      136     36  0.38   0.54    
IVwth               573      2      224     72 92.14 <2e-16 ***
IVbtw1:IVwth          2      2      224     72  0.40   0.67    
IVbtw2:IVwth          1      2      224     72  0.14   0.87    
IVbtw1:IVbtw2:IVwth   3      2      224     72  0.55   0.58    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

                    Test statistic p-value
IVwth                        0.928   0.269
IVbtw1:IVwth                 0.928   0.269
IVbtw2:IVwth                 0.928   0.269
IVbtw1:IVbtw2:IVwth          0.928   0.269


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

                    GG eps Pr(>F[GG])    
IVwth                0.933     <2e-16 ***
IVbtw1:IVwth         0.933       0.66    
IVbtw2:IVwth         0.933       0.86    
IVbtw1:IVbtw2:IVwth  0.933       0.57    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

                    HF eps Pr(>F[HF])    
IVwth                0.982     <2e-16 ***
IVbtw1:IVwth         0.982       0.67    
IVbtw2:IVwth         0.982       0.87    
IVbtw1:IVbtw2:IVwth  0.982       0.57    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
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

              Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)    1 1.53      1     36  0.224  0.224  0.224
IVbtw1         1 0.29      1     36  0.593  0.593  0.593
IVbtw2         1 0.20      1     36  0.655  0.655  0.655
IVbtw1:IVbtw2  1 0.38      1     36  0.543  0.543  0.543
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

Greenhouse-Geisser epsilon: 0.9326
Huynh-Feldt epsilon:        0.9816

              Df     F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)    1 92.14      2     72  0.000  0.000  0.000
IVbtw1         1  0.40      2     72  0.673  0.658  0.669
IVbtw2         1  0.14      2     72  0.874  0.860  0.870
IVbtw1:IVbtw2  1  0.55      2     72  0.578  0.566  0.574
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
W = 0.9277, p-value = 0.269
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
summary(aov(DV ~ IVbtw*IVwth1*IVwth2 + Error(id/(IVwth1*IVwth2)),
            data=dfSPFp.qrL))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
IVbtw      1    0.1    0.10    0.01   0.91
Residuals 18  126.6    7.03               

Error: id:IVwth1
             Df Sum Sq Mean Sq F value Pr(>F)    
IVwth1        2    771     386  116.36 <2e-16 ***
IVbtw:IVwth1  2      6       3    0.94    0.4    
Residuals    36    119       3                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IVwth2
             Df Sum Sq Mean Sq F value  Pr(>F)    
IVwth2        1  110.8   110.8   28.59 4.4e-05 ***
IVbtw:IVwth2  1    0.3     0.3    0.07    0.79    
Residuals    18   69.8     3.9                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IVwth1:IVwth2
                    Df Sum Sq Mean Sq F value Pr(>F)   
IVwth1:IVwth2        2   46.0   23.01    6.14 0.0051 **
IVbtw:IVwth1:IVwth2  2    0.5    0.24    0.06 0.9385   
Residuals           36  134.8    3.74                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Effect size estimates: generalized $\hat{\eta}_{g}^{2}$


```r
anRes  <- anova(lm(DV ~ IVbtw*IVwth1*IVwth2*id, data=dfSPFp.qrL))
SSEtot <- anRes["id",               "Sum Sq"] +
          anRes["IVwth1:id",        "Sum Sq"] +
          anRes["IVwth2:id",        "Sum Sq"] +
          anRes["IVwth1:IVwth2:id", "Sum Sq"]
```



```r
SSbtw         <- anRes["IVbtw",               "Sum Sq"]
SSwth1        <- anRes["IVwth1",              "Sum Sq"]
SSwth2        <- anRes["IVwth2",              "Sum Sq"]
SSbtwWth1     <- anRes["IVbtw:IVwth1",        "Sum Sq"]
SSbtwWth2     <- anRes["IVbtw:IVwth2",        "Sum Sq"]
SSwth1Wth2    <- anRes["IVwth1:IVwth2",       "Sum Sq"]
SSbtwWth1Wth2 <- anRes["IVbtw:IVwth1:IVwth2", "Sum Sq"]
```



```r
(gEtaSqB  <- SSbtw / (SSbtw + SSEtot))
```

```
[1] 0.0002251
```

```r
(gEtaSqW1 <- SSwth1 / (SSwth1 + SSEtot))
```

```
[1] 0.6313
```

```r
(gEtaSqBW1 <- SSbtwWth1 / (SSbtwWth1 + SSEtot))
```

```
[1] 0.01366
```

```r
(gEtaSqW2 <- SSwth2 / (SSwth2 + SSEtot))
```

```
[1] 0.1974
```

```r
(gEtaSqBW2 <- SSbtwWth2 / (SSbtwWth2 + SSEtot))
```

```
[1] 0.0006177
```

```r
(gEtaSqW1W2 <- SSwth1Wth2 / (SSwth1Wth2 + SSEtot))
```

```
[1] 0.09268
```

```r
(gEtaSqBW1W2 <- SSbtwWth1Wth2 / (SSbtwWth1Wth2 + SSEtot))
```

```
[1] 0.001056
```


Or from function `ezANOVA()` from package [`ez`](http://cran.r-project.org/package=ez)

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

                       SS num Df Error SS den Df       F  Pr(>F)    
(Intercept)         17864      1    126.6     18 2540.02 < 2e-16 ***
IVbtw                   0      1    126.6     18    0.01  0.9057    
IVwth1                771      2    119.3     36  116.36 < 2e-16 ***
IVbtw:IVwth1            6      2    119.3     36    0.94  0.3994    
IVwth2                111      1     69.8     18   28.59 4.4e-05 ***
IVbtw:IVwth2            0      1     69.8     18    0.07  0.7917    
IVwth1:IVwth2          46      2    134.8     36    6.14  0.0051 ** 
IVbtw:IVwth1:IVwth2     0      2    134.8     36    0.06  0.9385    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

                    Test statistic p-value
IVwth1                       0.761  0.0984
IVbtw:IVwth1                 0.761  0.0984
IVwth1:IVwth2                0.790  0.1348
IVbtw:IVwth1:IVwth2          0.790  0.1348


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

                    GG eps Pr(>F[GG])    
IVwth1               0.807    1.1e-13 ***
IVbtw:IVwth1         0.807     0.3835    
IVwth1:IVwth2        0.826     0.0086 ** 
IVbtw:IVwth1:IVwth2  0.826     0.9094    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

                    HF eps Pr(>F[HF])    
IVwth1               0.875    1.2e-14 ***
IVbtw:IVwth1         0.875     0.3896    
IVwth1:IVwth2        0.899     0.0069 ** 
IVbtw:IVwth1:IVwth2  0.899     0.9231    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
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

            Df       F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 2540.02      1     18  0.000  0.000  0.000
IVbtw        1    0.01      1     18  0.906  0.906  0.906
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

Greenhouse-Geisser epsilon: 0.8073
Huynh-Feldt epsilon:        0.8751

            Df      F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 116.36      2     36  0.000  0.000   0.00
IVbtw        1   0.94      2     36  0.399  0.384   0.39
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

            Df     F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 28.59      1     18  0.000  0.000  0.000
IVbtw        1  0.07      1     18  0.792  0.792  0.792
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

Greenhouse-Geisser epsilon: 0.8264
Huynh-Feldt epsilon:        0.8993

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 6.14      2     36  0.005  0.009  0.007
IVbtw        1 0.06      2     36  0.939  0.909  0.923
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
W = 0.7613, p-value = 0.09842
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
W = 0.7899, p-value = 0.1348
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaSPFpqr.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaSPFpqr.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaSPFpqr.R) - [all posts](https://github.com/dwoll/RExRepos/)
