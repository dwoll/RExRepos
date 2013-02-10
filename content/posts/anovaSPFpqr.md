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
summary(aov(DV ~ IVbtw1*IVbtw2*IVwth + Error(id/IVwth), data=dfSPFpq.rL))
```

```

Error: id
              Df Sum Sq Mean Sq F value Pr(>F)  
IVbtw1         1    0.1    0.11    0.04  0.847  
IVbtw2         1   17.7   17.75    6.33  0.017 *
IVbtw1:IVbtw2  1    0.0    0.05    0.02  0.897  
Residuals     36  101.0    2.81                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IVwth
                    Df Sum Sq Mean Sq F value Pr(>F)    
IVwth                2    540   270.0   80.86 <2e-16 ***
IVbtw1:IVwth         2      2     1.2    0.35   0.71    
IVbtw2:IVwth         2      7     3.7    1.10   0.34    
IVbtw1:IVbtw2:IVwth  2     12     5.8    1.73   0.18    
Residuals           72    240     3.3                   
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
[1] 0.0003014
```

```r
(gEtaSqB2 <- SSbtw2 / (SSbtw2 + SSEtot))
```

```
[1] 0.04787
```

```r
(gEtaSqW <- SSwth / (SSwth + SSEtot))
```

```
[1] 0.6047
```

```r
(gEtaSqB1W <- SSbtw1Wth / (SSbtw1Wth + SSEtot))
```

```
[1] 0.006598
```

```r
(gEtaSqB2W <- SSbtw2Wth / (SSbtw2Wth + SSEtot))
```

```
[1] 0.02045
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
[1] 0.0001352
```

```r
(gEtaSqB1B2W <- SSbtw1Btw2Wth / (SSbtw1Btw2Wth + SSEtot))
```

```
[1] 0.03166
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
(Intercept)           0      1      101     36  0.04  0.841    
IVbtw1                0      1      101     36  0.04  0.847    
IVbtw2               18      1      101     36  6.33  0.017 *  
IVbtw1:IVbtw2         0      1      101     36  0.02  0.897    
IVwth               540      2      240     72 80.86 <2e-16 ***
IVbtw1:IVwth          2      2      240     72  0.35  0.705    
IVbtw2:IVwth          7      2      240     72  1.10  0.337    
IVbtw1:IVbtw2:IVwth  12      2      240     72  1.73  0.185    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

                    Test statistic p-value
IVwth                        0.993   0.887
IVbtw1:IVwth                 0.993   0.887
IVbtw2:IVwth                 0.993   0.887
IVbtw1:IVbtw2:IVwth          0.993   0.887


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

                    GG eps Pr(>F[GG])    
IVwth                0.993     <2e-16 ***
IVbtw1:IVwth         0.993       0.70    
IVbtw2:IVwth         0.993       0.34    
IVbtw1:IVbtw2:IVwth  0.993       0.19    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

                    HF eps Pr(>F[HF])    
IVwth                 1.05     <2e-16 ***
IVbtw1:IVwth          1.05       0.71    
IVbtw2:IVwth          1.05       0.34    
IVbtw1:IVbtw2:IVwth   1.05       0.18    
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
(Intercept)    1 0.04      1     36  0.841  0.841  0.841
IVbtw1         1 0.04      1     36  0.847  0.847  0.847
IVbtw2         1 6.33      1     36  0.017  0.017  0.017
IVbtw1:IVbtw2  1 0.02      1     36  0.897  0.897  0.897
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

              Df     F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)    1 80.86      2     72  0.000  0.000  0.000
IVbtw1         1  0.35      2     72  0.705  0.704  0.705
IVbtw2         1  1.10      2     72  0.337  0.337  0.337
IVbtw1:IVbtw2  1  1.73      2     72  0.185  0.185  0.185
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
summary(aov(DV ~ IVbtw*IVwth1*IVwth2 + Error(id/(IVwth1*IVwth2)),
            data=dfSPFp.qrL))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
IVbtw      1    3.7    3.71    0.68   0.42
Residuals 18   98.3    5.46               

Error: id:IVwth1
             Df Sum Sq Mean Sq F value  Pr(>F)    
IVwth1        2    717     358    80.0 5.6e-14 ***
IVbtw:IVwth1  2      1       0     0.1     0.9    
Residuals    36    161       4                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IVwth2
             Df Sum Sq Mean Sq F value Pr(>F)    
IVwth2        1  114.7   114.7    30.6  3e-05 ***
IVbtw:IVwth2  1    0.4     0.4     0.1   0.75    
Residuals    18   67.5     3.8                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IVwth1:IVwth2
                    Df Sum Sq Mean Sq F value Pr(>F)
IVwth1:IVwth2        2    4.2    2.08    0.65   0.53
IVbtw:IVwth1:IVwth2  2    8.1    4.04    1.27   0.29
Residuals           36  114.2    3.17               
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
[1] 0.008331
```

```r
(gEtaSqW1 <- SSwth1 / (SSwth1 + SSEtot))
```

```
[1] 0.6189
```

```r
(gEtaSqBW1 <- SSbtwWth1 / (SSbtwWth1 + SSEtot))
```

```
[1] 0.002041
```

```r
(gEtaSqW2 <- SSwth2 / (SSwth2 + SSEtot))
```

```
[1] 0.2063
```

```r
(gEtaSqBW2 <- SSbtwWth2 / (SSbtwWth2 + SSEtot))
```

```
[1] 0.0008586
```

```r
(gEtaSqW1W2 <- SSwth1Wth2 / (SSwth1Wth2 + SSEtot))
```

```
[1] 0.00933
```

```r
(gEtaSqBW1W2 <- SSbtwWth1Wth2 / (SSbtwWth1Wth2 + SSEtot))
```

```
[1] 0.01799
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
(Intercept)         18099      1     98.3     18 3313.88 < 2e-16 ***
IVbtw                   4      1     98.3     18    0.68    0.42    
IVwth1                717      2    161.1     36   80.04 5.6e-14 ***
IVbtw:IVwth1            1      2    161.1     36    0.10    0.90    
IVwth2                115      1     67.5     18   30.56 3.0e-05 ***
IVbtw:IVwth2            0      1     67.5     18    0.10    0.75    
IVwth1:IVwth2           4      2    114.2     36    0.65    0.53    
IVbtw:IVwth1:IVwth2     8      2    114.2     36    1.27    0.29    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

                    Test statistic p-value
IVwth1                       0.992   0.933
IVbtw:IVwth1                 0.992   0.933
IVwth1:IVwth2                0.975   0.809
IVbtw:IVwth1:IVwth2          0.975   0.809


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

                    GG eps Pr(>F[GG])    
IVwth1               0.992      7e-14 ***
IVbtw:IVwth1         0.992       0.90    
IVwth1:IVwth2        0.976       0.52    
IVbtw:IVwth1:IVwth2  0.976       0.29    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

                    HF eps Pr(>F[HF])    
IVwth1                1.11    5.6e-14 ***
IVbtw:IVwth1          1.11       0.90    
IVwth1:IVwth2         1.09       0.53    
IVbtw:IVwth1:IVwth2   1.09       0.29    
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
(Intercept)  1 3313.88      1     18  0.000  0.000  0.000
IVbtw        1    0.68      1     18  0.421  0.421  0.421
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

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 80.0      2     36  0.000  0.000  0.000
IVbtw        1  0.1      2     36  0.904  0.903  0.904
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

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 30.6      1     18  0.000  0.000  0.000
IVbtw        1  0.1      1     18  0.754  0.754  0.754
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

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 0.65      2     36  0.526  0.522  0.526
IVbtw        1 1.27      2     36  0.292  0.292  0.292
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
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaSPFpqr.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaSPFpqr.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaSPFpqr.R) - [all posts](https://github.com/dwoll/RExRepos/)
