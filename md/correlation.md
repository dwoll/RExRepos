---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Covariance, correlation, association measures for continuous variables"
categories: [Descriptive]
rerCat: Descriptive
tags: [Association]
---




TODO
-------------------------

 - [`psych`](http://cran.r-project.org/package=psych) `cor.plot()`
 - link to diagScatter, diagMultivariate, association, associationOrder

Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin), [`psych`](http://cran.r-project.org/package=psych)


```r
wants <- c("coin", "psych")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Bivariate covariance and correlation
-------------------------

### Covariance

#### Corrected (sample) covariance


```r
x <- c(17, 30, 30, 25, 23, 21)
y <- c(1, 12, 8, 10, 5, 3)
cov(x, y)
```

```
[1] 19.2
```


#### Uncorrected (population) covariance


```r
(cmML <- cov.wt(cbind(x, y), method="ML")$cov)
```

```
      x     y
x 21.89 16.00
y 16.00 14.92
```



```r
cmML[upper.tri(cmML)]
```

```
[1] 16
```


### Correlation

#### Empirical correlation


```r
(r <- cor(x, y))
```

```
[1] 0.8855
```


#### Fisher's $Z$-transformation

Used, e.g., for averaging correlations


```r
library(psych)
(rZ <- fisherz(r))
```

```
[1] 1.401
```

```r
fisherz2r(rZ)
```

```
[1] 0.8855
```


### Partial and semi-partial correlation


```r
set.seed(1.234)
N  <- 100
z1 <- runif(N)
z2 <- runif(N)
x  <- -0.3*z1 + 0.2*z2 + rnorm(N, 0, 0.3)
y  <-  0.3*z1 - 0.4*z2 + rnorm(N, 0, 0.3)
cor(x, y)
```

```
[1] -0.1626
```


#### Partial correlation $r_{(xy).z}$


```r
x.z1 <- residuals(lm(x ~ z1))
y.z1 <- residuals(lm(y ~ z1))
cor(x.z1, y.z1)
```

```
[1] -0.1077
```



```r
x.z12 <- residuals(lm(x ~ z1 + z2))
y.z12 <- residuals(lm(y ~ z1 + z2))
cor(x.z12, y.z12)
```

```
[1] -0.04983
```


#### Semi-partial correlation $r_{(x.z)y}$


```r
cor(x.z1, y)
```

```
[1] -0.105
```


### Covariance matrix


```r
X1 <- c(19, 19, 31, 19, 24)
X2 <- c(95, 76, 94, 76, 76)
X3 <- c(197, 178, 189, 184, 173)
(X <- cbind(X1, X2, X3))
```

```
     X1 X2  X3
[1,] 19 95 197
[2,] 19 76 178
[3,] 31 94 189
[4,] 19 76 184
[5,] 24 76 173
```



```r
(covX <- cov(X))
```

```
      X1     X2   X3
X1 27.80  22.55  0.4
X2 22.55 102.80 82.4
X3  0.40  82.40 87.7
```

```r
(cML <- cov.wt(X, method="ML"))
```

```
$cov
      X1    X2    X3
X1 22.24 18.04  0.32
X2 18.04 82.24 65.92
X3  0.32 65.92 70.16

$center
   X1    X2    X3 
 22.4  83.4 184.2 

$n.obs
[1] 5
```

```r
cML$cov
```

```
      X1    X2    X3
X1 22.24 18.04  0.32
X2 18.04 82.24 65.92
X3  0.32 65.92 70.16
```


### Correlation matrix


```r
cor(X)
```

```
         X1     X2       X3
X1 1.000000 0.4218 0.008101
X2 0.421820 1.0000 0.867822
X3 0.008101 0.8678 1.000000
```

```r
cov2cor(covX)
```



```r
vec <- rnorm(nrow(X))
cor(vec, X)
```

```
         X1     X2     X3
[1,] 0.7816 0.5617 0.1837
```


Correlation for ordinal continuous variables
-------------------------

### Spearman's $\rho$


```r
DV1   <- c(97, 76, 56, 99, 50, 62, 36, 69, 55,  17)
DV2   <- c(42, 74, 22, 99, 73, 44, 10, 68, 19, -34)
DV3   <- c(61, 88, 21, 29, 56, 37, 21, 70, 46,  88)
DV4   <- c(58, 65, 38, 19, 55, 23, 26, 60, 50,  91)
DVmat <- cbind(DV1, DV2, DV3, DV4)
```



```r
cor(DV1, DV2, method="spearman")
```

```
[1] 0.7333
```

```r
cor(DVmat, method="spearman")
```

```
         DV1     DV2     DV3     DV4
DV1  1.00000  0.7333 0.05488 -0.1879
DV2  0.73333  1.0000 0.11586 -0.1636
DV3  0.05488  0.1159 1.00000  0.8964
DV4 -0.18788 -0.1636 0.89636  1.0000
```


### Kendall's $\tau$


```r
cor(DV1, DV2, method="kendall")
```

```
[1] 0.6444
```

```r
cor(DVmat, method="kendall")
```

```
         DV1      DV2     DV3      DV4
DV1  1.00000  0.64444 0.02273 -0.15556
DV2  0.64444  1.00000 0.11367 -0.06667
DV3  0.02273  0.11367 1.00000  0.79566
DV4 -0.15556 -0.06667 0.79566  1.00000
```


Correlation tests
-------------------------

### Pearson correlation


```r
cor.test(DV1, DV2)
```

```

	Pearson's product-moment correlation

data:  DV1 and DV2 
t = 3.5, df = 8, p-value = 0.008084
alternative hypothesis: true correlation is not equal to 0 
95 percent confidence interval:
 0.2902 0.9447 
sample estimates:
   cor 
0.7777 
```



```r
library(psych)
corr.test(DVmat, adjust="bonferroni")
```

```
Call:corr.test(x = DVmat, adjust = "bonferroni")
Correlation matrix 
      DV1   DV2   DV3   DV4
DV1  1.00  0.78 -0.09 -0.35
DV2  0.78  1.00 -0.07 -0.39
DV3 -0.09 -0.07  1.00  0.89
DV4 -0.35 -0.39  0.89  1.00
Sample Size 
    DV1 DV2 DV3 DV4
DV1  10  10  10  10
DV2  10  10  10  10
DV3  10  10  10  10
DV4  10  10  10  10
Probability values (Entries above the diagonal are adjusted for multiple tests.) 
     DV1  DV2 DV3 DV4
DV1 0.00 0.04   1   1
DV2 0.01 0.00   1   1
DV3 0.80 0.86   0   0
DV4 0.32 0.27   0   0
```


### Spearman's $\rho$


```r
cor.test(DV1, DV2, method="spearman")
```

```

	Spearman's rank correlation rho

data:  DV1 and DV2 
S = 44, p-value = 0.02117
alternative hypothesis: true rho is not equal to 0 
sample estimates:
   rho 
0.7333 
```

```r
library(coin)
spearman_test(DV1 ~ DV2, distribution=approximate(B=9999))
```

```

	Approximative Spearman Correlation Test

data:  DV1 by DV2 
Z = 2.2, p-value = 0.0184
alternative hypothesis: true mu is not equal to 0 
```



```r
library(psych)
corr.test(DVmat, method="spearman", adjust="bonferroni")
```

```
Call:corr.test(x = DVmat, method = "spearman", adjust = "bonferroni")
Correlation matrix 
      DV1   DV2  DV3   DV4
DV1  1.00  0.73 0.05 -0.19
DV2  0.73  1.00 0.12 -0.16
DV3  0.05  0.12 1.00  0.90
DV4 -0.19 -0.16 0.90  1.00
Sample Size 
    DV1 DV2 DV3 DV4
DV1  10  10  10  10
DV2  10  10  10  10
DV3  10  10  10  10
DV4  10  10  10  10
Probability values (Entries above the diagonal are adjusted for multiple tests.) 
     DV1  DV2 DV3 DV4
DV1 0.00 0.08   1   1
DV2 0.02 0.00   1   1
DV3 0.88 0.75   0   0
DV4 0.60 0.65   0   0
```


### Kendall's $\tau$


```r
cor.test(DV1, DV2, method="kendall")
```

```

	Kendall's rank correlation tau

data:  DV1 and DV2 
T = 37, p-value = 0.009148
alternative hypothesis: true tau is not equal to 0 
sample estimates:
   tau 
0.6444 
```



```r
library(psych)
corr.test(DVmat, method="kendall", adjust="bonferroni")
```

```
Call:corr.test(x = DVmat, method = "kendall", adjust = "bonferroni")
Correlation matrix 
      DV1   DV2  DV3   DV4
DV1  1.00  0.64 0.02 -0.16
DV2  0.64  1.00 0.11 -0.07
DV3  0.02  0.11 1.00  0.80
DV4 -0.16 -0.07 0.80  1.00
Sample Size 
    DV1 DV2 DV3 DV4
DV1  10  10  10  10
DV2  10  10  10  10
DV3  10  10  10  10
DV4  10  10  10  10
Probability values (Entries above the diagonal are adjusted for multiple tests.) 
     DV1  DV2  DV3  DV4
DV1 0.00 0.22 1.00 1.00
DV2 0.04 0.00 1.00 1.00
DV3 0.95 0.75 0.00 0.04
DV4 0.67 0.85 0.01 0.00
```


### Difference between two independent correlations


```r
N <- length(DV1)
library(psych)
r.test(n=N, n2=N, r12=cor(DV1, DV2), r34=cor(DV3, DV4))
```

```
Correlation tests 
Call:r.test(n = N, r12 = cor(DV1, DV2), r34 = cor(DV3, DV4), n2 = N)
Test of difference between two independent correlations 
 z value 0.73    with probability  0.46
```


Detach (automatically) loaded packages (if possible)
-------------------------
    

```r
try(detach(package:psych))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:stats4))
try(detach(package:mvtnorm))
try(detach(package:survival))
try(detach(package:splines))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/correlation.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/correlation.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/correlation.R) - [all posts](https://github.com/dwoll/RExRepos/)
