---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Two-way repeated-measures ANOVA (RBF-pq design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---

Two-way repeated-measures ANOVA (RBF-pq design)
=========================

TODO
-------------------------

 - link to anovaMixed, dfReshape

Traditional univariate analysis and multivariate approach.

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car)


```r
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Traditional univariate approach
-------------------------

### Using `aov()` with data in long format


```r
set.seed(123)
N    <- 10
P    <- 2
Q    <- 3
muJK <- c(rep(c(1, -2), N), rep(c(2, 0), N), rep(c(3, 3), N))
dfRBFpqL <- data.frame(id =factor(rep(1:N, times=P*Q)),
                       IV1=factor(rep(rep(1:P, each=N), times=Q)),
                       IV2=factor(rep(rep(1:Q, each=N*P))),
                       DV =rnorm(N*P*Q, muJK, 2))
```



```r
summary(aov(DV ~ IV1*IV2 + Error(id/(IV1*IV2)), data=dfRBFpqL))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   55.2    6.14               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1   8.23    8.23    2.57   0.14
Residuals  9  28.83    3.20               

Error: id:IV2
          Df Sum Sq Mean Sq F value Pr(>F)   
IV2        2    122    61.2    7.94 0.0034 **
Residuals 18    139     7.7                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IV1:IV2
          Df Sum Sq Mean Sq F value Pr(>F)
IV1:IV2    2    4.3    2.17    0.89   0.43
Residuals 18   43.7    2.43               
```


### Using `Anova()` from package `car` with data in wide format


```r
dfTemp   <- reshape(dfRBFpqL, v.names="DV", timevar="IV1",
                    idvar=c("id", "IV2"), direction="wide")
dfRBFpqW <- reshape(dfTemp, v.names=c("DV.1", "DV.2"),
                    timevar="IV2", idvar="id", direction="wide")
```



```r
library(car)
fitRBFpq   <- lm(cbind(DV.1.1, DV.2.1, DV.1.2, DV.2.2, DV.1.3, DV.2.3) ~ 1,
                 data=dfRBFpqW)
inRBFpq    <- expand.grid(IV1=gl(P, 1), IV2=gl(Q, 1))
AnovaRBFpq <- Anova(fitRBFpq, idata=inRBFpq, idesign=~IV1*IV2)
summary(AnovaRBFpq, multivariate=FALSE, univariate=TRUE)
```

```

Univariate Type III Repeated-Measures ANOVA Assuming Sphericity

               SS num Df Error SS den Df     F Pr(>F)   
(Intercept) 101.1      1     55.2      9 16.47 0.0029 **
IV1           8.2      1     28.8      9  2.57 0.1435   
IV2         122.4      2    138.7     18  7.94 0.0034 **
IV1:IV2       4.3      2     43.7     18  0.89 0.4262   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

        Test statistic p-value
IV2              0.707   0.250
IV1:IV2          0.996   0.984


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

        GG eps Pr(>F[GG])   
IV2      0.774     0.0075 **
IV1:IV2  0.996     0.4259   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

        HF eps Pr(>F[HF])   
IV2      0.904     0.0047 **
IV1:IV2  1.278     0.4262   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Using `anova.mlm()` and `mauchly.test()` with data in wide format


```r
anova(fitRBFpq, M=~IV1, X=~1, idata=inRBFpq, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~1


Contrasts spanned by
~IV1

Greenhouse-Geisser epsilon: 1
Huynh-Feldt epsilon:        1

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 2.57      1      9  0.143  0.143  0.143
Residuals    9                                        
```

```r
anova(fitRBFpq, M=~IV1 + IV2, X=~IV1, idata=inRBFpq, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~IV1


Contrasts spanned by
~IV1 + IV2

Greenhouse-Geisser epsilon: 0.7737
Huynh-Feldt epsilon:        0.9039

            Df    F num Df den Df  Pr(>F) G-G Pr  H-F Pr
(Intercept)  1 7.94      2     18 0.00337 0.0075 0.00472
Residuals    9                                          
```

```r
anova(fitRBFpq, M=~IV1 + IV2 + IV1:IV2, X=~IV1 + IV2,
      idata=inRBFpq, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~IV1 + IV2


Contrasts spanned by
~IV1 + IV2 + IV1:IV2

Greenhouse-Geisser epsilon: 0.996
Huynh-Feldt epsilon:        1.278

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 0.89      2     18  0.426  0.426  0.426
Residuals    9                                        
```


Mauchly-Test for IV1 is unnecessary here since P=2 -> sphericity holds automatically


```r
mauchly.test(fitRBFpq, M=~IV1, X=~1, idata=inRBFpq)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~1

	Contrasts spanned by
	~IV1


data:  SSD matrix from lm(formula = cbind(DV.1.1, DV.2.1, DV.1.2, DV.2.2, DV.1.3, DV.2.3) ~  SSD matrix from     1, data = dfRBFpqW) 
W = 1, p-value = 1
```

```r
mauchly.test(fitRBFpq, M=~IV1 + IV2, X=~IV1, idata=inRBFpq)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~IV1

	Contrasts spanned by
	~IV1 + IV2


data:  SSD matrix from lm(formula = cbind(DV.1.1, DV.2.1, DV.1.2, DV.2.2, DV.1.3, DV.2.3) ~  SSD matrix from     1, data = dfRBFpqW) 
W = 0.7074, p-value = 0.2505
```

```r
mauchly.test(fitRBFpq, M=~IV1 + IV2 + IV1:IV2, X=~IV1 + IV2, idata=inRBFpq)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~IV1 + IV2

	Contrasts spanned by
	~IV1 + IV2 + IV1:IV2


data:  SSD matrix from lm(formula = cbind(DV.1.1, DV.2.1, DV.1.2, DV.2.2, DV.1.3, DV.2.3) ~  SSD matrix from     1, data = dfRBFpqW) 
W = 0.9959, p-value = 0.9839
```


Effect size estimates: generalized $\hat{\eta}_{g}^{2}$
-------------------------


```r
(anRes <- anova(lm(DV ~ IV1*IV2*id, data=dfRBFpqL)))
```

```
Analysis of Variance Table

Response: DV
           Df Sum Sq Mean Sq F value Pr(>F)
IV1         1    8.2     8.2               
IV2         2  122.4    61.2               
id          9   55.2     6.1               
IV1:IV2     2    4.3     2.2               
IV1:id      9   28.8     3.2               
IV2:id     18  138.7     7.7               
IV1:IV2:id 18   43.7     2.4               
Residuals   0    0.0                       
```



```r
SSEtot <- anRes["id",         "Sum Sq"] +
          anRes["IV1:id",     "Sum Sq"] +
          anRes["IV2:id",     "Sum Sq"] +
          anRes["IV1:IV2:id", "Sum Sq"]
SS1    <- anRes["IV1",        "Sum Sq"]
SS2    <- anRes["IV2",        "Sum Sq"]
SSI    <- anRes["IV1:IV2",    "Sum Sq"]
```



```r
(gEtaSq1 <- SS1 / (SS1 + SSEtot))
```

```
[1] 0.02996
```

```r
(gEtaSq2 <- SS2 / (SS2 + SSEtot))
```

```
[1] 0.3148
```

```r
(gEtaSqI <- SSI / (SSI + SSEtot))
```

```
[1] 0.01603
```


Or from function `ezANOVA()` from package [`ez`](http://cran.r-project.org/package=ez)

Simple effects
-------------------------

Separate error terms


```r
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==1)))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9    122    13.6               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1   0.36   0.359    0.21   0.66
Residuals  9  15.18   1.687               
```

```r
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==2)))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   31.9    3.55               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)  
IV1        1   11.2   11.15    3.54  0.093 .
Residuals  9   28.3    3.15                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```

```r
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==3)))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   39.6     4.4               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1   1.06    1.06    0.33   0.58
Residuals  9  28.99    3.22               
```


Multivariate approach
-------------------------


```r
library(car)
summary(AnovaRBFpq, multivariate=TRUE, univariate=FALSE)
```

```

Type III Repeated Measures MANOVA Tests:

------------------------------------------
 
Term: (Intercept) 

 Response transformation matrix:
       (Intercept)
DV.1.1           1
DV.2.1           1
DV.1.2           1
DV.2.2           1
DV.1.3           1
DV.2.3           1

Sum of squares and products for the hypothesis:
            (Intercept)
(Intercept)       606.4

Sum of squares and products for error:
            (Intercept)
(Intercept)       331.4

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df  Pr(>F)   
Pillai            1    0.6466    16.47      1      9 0.00285 **
Wilks             1    0.3534    16.47      1      9 0.00285 **
Hotelling-Lawley  1    1.8297    16.47      1      9 0.00285 **
Roy               1    1.8297    16.47      1      9 0.00285 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV1 

 Response transformation matrix:
       IV11
DV.1.1    1
DV.2.1   -1
DV.1.2    1
DV.2.2   -1
DV.1.3    1
DV.2.3   -1

Sum of squares and products for the hypothesis:
      IV11
IV11 49.37

Sum of squares and products for error:
     IV11
IV11  173

Multivariate Tests: IV1
                 Df test stat approx F num Df den Df Pr(>F)
Pillai            1    0.2220    2.568      1      9  0.143
Wilks             1    0.7780    2.568      1      9  0.143
Hotelling-Lawley  1    0.2854    2.568      1      9  0.143
Roy               1    0.2854    2.568      1      9  0.143

------------------------------------------
 
Term: IV2 

 Response transformation matrix:
       IV21 IV22
DV.1.1    1    0
DV.2.1    1    0
DV.1.2    0    1
DV.2.2    0    1
DV.1.3   -1   -1
DV.2.3   -1   -1

Sum of squares and products for the hypothesis:
      IV21  IV22
IV21 470.5 317.7
IV22 317.7 214.5

Sum of squares and products for error:
      IV21  IV22
IV21 427.1 222.4
IV22 222.4 211.4

Multivariate Tests: IV2
                 Df test stat approx F num Df den Df Pr(>F)  
Pillai            1    0.5494    4.876      2      8 0.0412 *
Wilks             1    0.4506    4.876      2      8 0.0412 *
Hotelling-Lawley  1    1.2191    4.876      2      8 0.0412 *
Roy               1    1.2191    4.876      2      8 0.0412 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV1:IV2 

 Response transformation matrix:
       IV11:IV21 IV11:IV22
DV.1.1         1         0
DV.2.1        -1         0
DV.1.2         0         1
DV.2.2         0        -1
DV.1.3        -1        -1
DV.2.3         1         1

Sum of squares and products for the hypothesis:
          IV11:IV21 IV11:IV22
IV11:IV21    0.3718    -1.991
IV11:IV22   -1.9906    10.659

Sum of squares and products for error:
          IV11:IV21 IV11:IV22
IV11:IV21     92.24     43.83
IV11:IV22     43.83     82.60

Multivariate Tests: IV1:IV2
                 Df test stat approx F num Df den Df Pr(>F)
Pillai            1    0.1726   0.8342      2      8  0.469
Wilks             1    0.8274   0.8342      2      8  0.469
Hotelling-Lawley  1    0.2086   0.8342      2      8  0.469
Roy               1    0.2086   0.8342      2      8  0.469
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

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaRBFpq.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaRBFpq.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaRBFpq.R) - [all posts](https://github.com/dwoll/RExRepos/)
