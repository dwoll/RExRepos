---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "The mean and other location measures"
categories: [Descriptive]
rerCat: Descriptive
tags: [Descriptive]
---

The mean and other location measures
=========================

TODO
-------------------------

 - link to npWilcoxon for `wilcox.test()`

Install required packages
-------------------------

[`DescTools`](http://cran.r-project.org/package=DescTools), [`modeest`](http://cran.r-project.org/package=modeest), [`robustbase`](http://cran.r-project.org/package=robustbase)


```r
wants <- c("DescTools", "modeest", "robustbase")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Mean, weighted mean, geometric mean, harmonic mean, and mode
-------------------------

### Mean


```r
age <- c(17, 30, 30, 25, 23, 21)
mean(age)
```

```
[1] 24.33333
```

### Weighted mean


```r
weights <- c(0.6, 0.6, 0.3, 0.2, 0.4, 0.6)
weighted.mean(age, weights)
```

```
[1] 23.7037
```

### Geometric mean


```r
library(DescTools)
Gmean(age)
```

```
[1] 23.86509
```

### Harmonic mean


```r
library(DescTools)
Hmean(age)
```

```
[1] 23.38384
```

### Mode


```r
vec <- c(11, 22, 22, 33, 33, 33, 33)
library(modeest)
mfv(vec)
```

```
[1] 33
```

```r
mlv(vec, method="mfv")
```

```
Mode (most likely value): 33 
Bickel's modal skewness: -0.4285714 
Call: mlv.default(x = vec, method = "mfv") 
```

Robust location measures
-------------------------

### Median


```r
median(age)
```

```
[1] 24
```

### Trimmed mean


```r
mean(age, trim=0.2)
```

```
[1] 24.75
```

### Winsorized mean


```r
library(DescTools)
(ageWins <- Winsorize(age, probs=c(0.2, 0.8)))
```

```
[1] 21 30 30 25 23 21
```

```r
mean(ageWins)
```

```
[1] 25
```

### Huber-$M$ estimator


```r
library(robustbase)
hM <- huberM(age)
hM$mu
```

```
[1] 24.33333
```

### Hodges-Lehmann estimator (pseudo-median)


```r
library(DescTools)
HodgesLehmann(age, conf.level=0.95)
```

```
     est   lwr.ci   upr.ci 
23.99998 20.99997 27.50005 
```

### Hodges-Lehmann estimator of difference between two location parameters


```r
N <- 8
X <- rnorm(N, 100, 15)
Y <- rnorm(N, 110, 15)
wilcox.test(X, Y, conf.int=TRUE)$estimate
```

```
difference in location 
             -17.42787 
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:modeest))
try(detach(package:DescTools))
try(detach(package:robustbase))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/mean.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/mean.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/mean.R) - [all posts](https://github.com/dwoll/RExRepos/)
