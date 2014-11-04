---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
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
aovRBFpq <- aov(DV ~ IV1*IV2 + Error(id/(IV1*IV2)), data=dfRBFpqL)
summary(aovRBFpq)
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9  55.24   6.138               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1  8.229   8.229   2.569  0.143
Residuals  9 28.833   3.204               

Error: id:IV2
          Df Sum Sq Mean Sq F value  Pr(>F)   
IV2        2  122.4   61.22   7.944 0.00337 **
Residuals 18  138.7    7.71                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:IV1:IV2
          Df Sum Sq Mean Sq F value Pr(>F)
IV1:IV2    2   4.34   2.170   0.895  0.426
Residuals 18  43.67   2.426               
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

                 SS num Df Error SS den Df       F   Pr(>F)   
(Intercept) 101.073      1   55.239      9 16.4677 0.002850 **
IV1           8.229      1   28.833      9  2.5685 0.143472   
IV2         122.440      2  138.713     18  7.9442 0.003365 **
IV1:IV2       4.340      2   43.669     18  0.8945 0.426218   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


Mauchly Tests for Sphericity

        Test statistic p-value
IV2            0.70743 0.25045
IV1:IV2        0.99594 0.98385


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

         GG eps Pr(>F[GG])   
IV2     0.77365   0.007503 **
IV1:IV2 0.99596   0.425903   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

           HF eps  Pr(>F[HF])
IV2     0.9039018 0.004723577
IV1:IV2 1.2784582 0.426217623
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

            Df      F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1 2.5685      1      9 0.14347 0.14347 0.14347
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

            Df      F num Df den Df    Pr(>F)    G-G Pr    H-F Pr
(Intercept)  1 7.9442      2     18 0.0033651 0.0075029 0.0047236
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

            Df      F num Df den Df  Pr(>F) G-G Pr  H-F Pr
(Intercept)  1 0.8945      2     18 0.42622 0.4259 0.42622
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
library(DescTools)
EtaSq(aovRBFpq, type=1)
```

```
            eta.sq eta.sq.part eta.sq.gen
IV1     0.02049708  0.22202789 0.02995754
IV2     0.30498426  0.46884422 0.31484141
IV1:IV2 0.01081122  0.09040527 0.01602805
```

Simple effects
-------------------------

Separate error terms


```r
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==1)))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9  122.4    13.6               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)
IV1        1  0.359  0.3591   0.213  0.655
Residuals  9 15.183  1.6870               
```

```r
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==2)))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9  31.95    3.55               

Error: id:IV1
          Df Sum Sq Mean Sq F value Pr(>F)  
IV1        1  11.15  11.148   3.542 0.0925 .
Residuals  9  28.33   3.147                 
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
IV1        1  1.062   1.062    0.33   0.58
Residuals  9 28.993   3.221               
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
(Intercept)    606.4372

Sum of squares and products for error:
            (Intercept)
(Intercept)    331.4334

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df    Pr(>F)   
Pillai            1 0.6466107 16.46767      1      9 0.0028503 **
Wilks             1 0.3533893 16.46767      1      9 0.0028503 **
Hotelling-Lawley  1 1.8297405 16.46767      1      9 0.0028503 **
Roy               1 1.8297405 16.46767      1      9 0.0028503 **
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
IV11 49.37295

Sum of squares and products for error:
         IV11
IV11 172.9998

Multivariate Tests: IV1
                 Df test stat approx F num Df den Df  Pr(>F)
Pillai            1 0.2220279 2.568538      1      9 0.14347
Wilks             1 0.7779721 2.568538      1      9 0.14347
Hotelling-Lawley  1 0.2853931 2.568538      1      9 0.14347
Roy               1 0.2853931 2.568538      1      9 0.14347

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
         IV21     IV22
IV21 470.5200 317.6588
IV22 317.6588 214.4588

Sum of squares and products for error:
         IV21     IV22
IV21 427.1413 222.3627
IV22 222.3627 211.3598

Multivariate Tests: IV2
                 Df test stat approx F num Df den Df   Pr(>F)  
Pillai            1 0.5493664  4.87639      2      8 0.041238 *
Wilks             1 0.4506336  4.87639      2      8 0.041238 *
Hotelling-Lawley  1 1.2190976  4.87639      2      8 0.041238 *
Roy               1 1.2190976  4.87639      2      8 0.041238 *
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
IV11:IV21  0.3717586 -1.990582
IV11:IV22 -1.9905822 10.658576

Sum of squares and products for error:
          IV11:IV21 IV11:IV22
IV11:IV21  92.23768  43.83152
IV11:IV22  43.83152  82.60121

Multivariate Tests: IV1:IV2
                 Df test stat  approx F num Df den Df  Pr(>F)
Pillai            1 0.1725701 0.8342466      2      8 0.46873
Wilks             1 0.8274299 0.8342466      2      8 0.46873
Hotelling-Lawley  1 0.2085617 0.8342466      2      8 0.46873
Roy               1 0.2085617 0.8342466      2      8 0.46873
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:DescTools))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaRBFpq.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaRBFpq.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaRBFpq.R) - [all posts](https://github.com/dwoll/RExRepos/)
