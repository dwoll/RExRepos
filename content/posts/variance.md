---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Variance, robust spread measures, skewness and kurtosis"
categories: [Descriptive]
rerCat: Descriptive
tags: [Descriptive]
---




TODO
-------------------------

 - link to diagDistributions, varianceHom

Install required packages
-------------------------

[`DescTools`](http://cran.r-project.org/package=DescTools), [`robustbase`](http://cran.r-project.org/package=robustbase)


```r
wants <- c("DescTools", "robustbase")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Variance and standard deviation
-------------------------

### Corrected (sample) variance and standard deviation


```r
age <- c(17, 30, 30, 25, 23, 21)
N   <- length(age)
M   <- mean(age)
var(age)
```

```
[1] 26.26667
```

```r
sd(age)
```

```
[1] 5.125102
```

### Uncorrected (population) variance and standard deviation


```r
(cML <- cov.wt(as.matrix(age), method="ML"))
```

```
$cov
         [,1]
[1,] 21.88889

$center
[1] 24.33333

$n.obs
[1] 6
```

```r
(vML <- diag(cML$cov))
```

```
[1] 21.88889
```

```r
sqrt(vML)
```

```
[1] 4.678556
```

Robust spread measures
-------------------------

### Winsorized variance and standard deviation


```r
library(DescTools)
ageWins <- Winsorize(age, probs=c(0.2, 0.8))
var(ageWins)
```

```
[1] 17.2
```

```r
sd(ageWins)
```

```
[1] 4.147288
```

### Inter-quartile-range


```r
quantile(age)
```

```
   0%   25%   50%   75%  100% 
17.00 21.50 24.00 28.75 30.00 
```

```r
IQR(age)
```

```
[1] 7.25
```
### Mean absolute difference to the median


```r
library(DescTools)
MeanAD(age)
```

```
[1] 4
```

### Median absolute difference to the median (MAD)


```r
mad(age)
```

```
[1] 6.6717
```

### $Q_{n}$: more efficient alternative to MAD


```r
library(robustbase)
Qn(age)
```

```
[1] 6.792788
```

### $\tau$ estimate of scale


```r
scaleTau2(age)
```

```
[1] 4.865323
```

Diversity of categorical data
-------------------------


```r
fac <- factor(c("C", "D", "A", "D", "E", "D", "C", "E", "E", "B", "E"),
              levels=c(LETTERS[1:5], "Q"))
P   <- nlevels(fac)
(Fj <- prop.table(table(fac)))
```

```
fac
         A          B          C          D          E          Q 
0.09090909 0.09090909 0.18181818 0.27272727 0.36363636 0.00000000 
```

First, calculate Shannon index, then diversity measure.


```r
library(DescTools)
shannonIdx <- Entropy(Fj, base=exp(1))
(H <- (1/log(P)) * shannonIdx)
```

```
[1] 0.8193845
```

Higher moments: skewness and kurtosis
-------------------------


```r
library(DescTools)
Skew(age)
```

```
[1] -0.08611387
```

```r
Kurt(age)
```

```
[1] -1.772568
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:robustbase))
try(detach(package:DescTools))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/variance.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/variance.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/variance.R) - [all posts](https://github.com/dwoll/RExRepos/)
