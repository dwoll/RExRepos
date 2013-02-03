---
layout: post
title: "Two-way repeated-measures ANOVA (RBF-pq design)"
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
set.seed(1.234)
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
Residuals  9   89.4    9.93               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1   0.96   0.965    0.32   0.59
Residuals  9  27.48   3.054               

Error: id:IV2
          Df Sum Sq Mean Sq F value  Pr(>F)    
IV2        2  120.0    60.0    17.3 6.4e-05 ***
Residuals 18   62.4     3.5                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IV1:IV2
          Df Sum Sq Mean Sq F value Pr(>F)
IV1:IV2    2    0.6    0.30    0.07   0.94
Residuals 18   82.2    4.57               
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

               SS num Df Error SS den Df     F  Pr(>F)    
(Intercept) 114.6      1     89.4      9 11.53  0.0079 ** 
IV1           1.0      1     27.5      9  0.32  0.5878    
IV2         120.0      2     62.4     18 17.33 6.4e-05 ***
IV1:IV2       0.6      2     82.2     18  0.07  0.9363    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

        Test statistic p-value
IV2              0.910   0.684
IV1:IV2          0.757   0.328


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

        GG eps Pr(>F[GG])    
IV2      0.917    0.00012 ***
IV1:IV2  0.804    0.90246    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

        HF eps Pr(>F[HF])    
IV2      1.140    6.4e-05 ***
IV1:IV2  0.953       0.93    
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
(Intercept)  1 0.32      1      9  0.588  0.588  0.588
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

Greenhouse-Geisser epsilon: 0.917
Huynh-Feldt epsilon:        1.140

            Df    F num Df den Df   Pr(>F)   G-G Pr   H-F Pr
(Intercept)  1 17.3      2     18 6.38e-05 0.000116 6.38e-05
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

Greenhouse-Geisser epsilon: 0.8045
Huynh-Feldt epsilon:        0.9531

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 0.07      2     18  0.936  0.902   0.93
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
W = 0.9095, p-value = 0.6843
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
W = 0.7569, p-value = 0.3283
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
IV1         1    1.0     1.0               
IV2         2  120.0    60.0               
id          9   89.4     9.9               
IV1:IV2     2    0.6     0.3               
IV1:id      9   27.5     3.1               
IV2:id     18   62.4     3.5               
IV1:IV2:id 18   82.2     4.6               
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
[1] 0.003675
```

```r
(gEtaSq2 <- SS2 / (SS2 + SSEtot))
```

```
[1] 0.3147
```

```r
(gEtaSqI <- SSI / (SSI + SSEtot))
```

```
[1] 0.002304
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
Residuals  9   75.4    8.38               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1    0.3    0.27    0.06   0.82
Residuals  9   42.9    4.76               
```

```r
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==2)))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   67.5     7.5               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1   1.29    1.29    0.45   0.52
Residuals  9  25.90    2.88               
```

```r
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==3)))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   8.91    0.99               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1    0.0    0.00       0   0.98
Residuals  9   40.9    4.55               
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
(Intercept)       687.5

Sum of squares and products for error:
            (Intercept)
(Intercept)       536.4

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df  Pr(>F)   
Pillai            1    0.5617    11.53      1      9 0.00792 **
Wilks             1    0.4383    11.53      1      9 0.00792 **
Hotelling-Lawley  1    1.2816    11.53      1      9 0.00792 **
Roy               1    1.2816    11.53      1      9 0.00792 **
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
IV11 5.787

Sum of squares and products for error:
      IV11
IV11 164.9

Multivariate Tests: IV1
                 Df test stat approx F num Df den Df Pr(>F)
Pillai            1    0.0339   0.3159      1      9  0.588
Wilks             1    0.9661   0.3159      1      9  0.588
Hotelling-Lawley  1    0.0351   0.3159      1      9  0.588
Roy               1    0.0351   0.3159      1      9  0.588

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
IV21 461.5 311.2
IV22 311.2 209.9

Sum of squares and products for error:
      IV21  IV22
IV21 159.7  91.6
IV22  91.6 119.0

Multivariate Tests: IV2
                 Df test stat approx F num Df den Df  Pr(>F)   
Pillai            1    0.7475    11.84      2      8 0.00407 **
Wilks             1    0.2525    11.84      2      8 0.00407 **
Hotelling-Lawley  1    2.9604    11.84      2      8 0.00407 **
Roy               1    2.9604    11.84      2      8 0.00407 **
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
IV11:IV21    0.4607     1.052
IV11:IV22    1.0521     2.403

Sum of squares and products for error:
          IV11:IV21 IV11:IV22
IV11:IV21     83.70     48.24
IV11:IV22     48.24    211.18

Multivariate Tests: IV1:IV2
                 Df test stat approx F num Df den Df Pr(>F)
Pillai            1    0.0127  0.05131      2      8   0.95
Wilks             1    0.9873  0.05131      2      8   0.95
Hotelling-Lawley  1    0.0128  0.05131      2      8   0.95
Roy               1    0.0128  0.05131      2      8   0.95
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
