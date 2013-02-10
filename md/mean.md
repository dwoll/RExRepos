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

[`modeest`](http://cran.r-project.org/package=modeest), [`psych`](http://cran.r-project.org/package=psych), [`robustbase`](http://cran.r-project.org/package=robustbase)


```r
wants <- c("modeest", "psych", "robustbase")
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
[1] 24.33
```


### Weighted mean


```r
weights <- c(0.6, 0.6, 0.3, 0.2, 0.4, 0.6)
weighted.mean(age, weights)
```

```
[1] 23.7
```


### Geometric mean


```r
library(psych)
geometric.mean(age)
```

```
[1] 23.87
```


### Harmonic mean


```r
library(psych)
harmonic.mean(age)
```

```
[1] 23.38
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
Bickel's modal skewness: -0.4286 
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
library(psych)
(ageWins <- winsor(age, trim=0.2))
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
[1] 24.33
```


### Hodges-Lehmann estimator (pseudo-median)


```r
wilcox.test(age, conf.int=TRUE)$estimate
```

```
(pseudo)median 
            24 
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
                -5.616 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:modeest))
try(detach(package:psych))
try(detach(package:robustbase))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/mean.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/mean.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/mean.R) - [all posts](https://github.com/dwoll/RExRepos/)
