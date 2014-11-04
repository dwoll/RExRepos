---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Nonparametric location tests for one and two samples"
categories: [Nonparametric, ClassicalNonparametric]
rerCat: Nonparametric
tags: [Nonparametric, ClassicalNonparametric]
---




Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin), [`DescTools`](http://cran.r-project.org/package=DescTools)


```r
wants <- c("coin", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

One-sample
-------------------------

### Sign-test

Two-sided test


```r
set.seed(123)
medH0 <- 30
DV    <- sample(0:100, 20, replace=TRUE)

library(DescTools)
SignTest(DV, mu=medH0)
```

```

	One-sample Sign-Test

data:  DV
S = 15, number of differences = 20, p-value = 0.04139
alternative hypothesis: true median is not equal to 30
95.9 percent confidence interval:
 33 89
sample estimates:
median of the differences 
                       54 
```

### Wilcoxon signed rank test


```r
IQ    <- c(99, 131, 118, 112, 128, 136, 120, 107, 134, 122)
medH0 <- 110
```


```r
wilcox.test(IQ, alternative="greater", mu=medH0, conf.int=TRUE)
```

```

	Wilcoxon signed rank test

data:  IQ
V = 48, p-value = 0.01855
alternative hypothesis: true location is greater than 110
95 percent confidence interval:
 113.5   Inf
sample estimates:
(pseudo)median 
           121 
```

Two independent samples
-------------------------

### Sign-test


```r
Nj  <- c(20, 30)
DVa <- rnorm(Nj[1], mean= 95, sd=15)
DVb <- rnorm(Nj[2], mean=100, sd=15)
wIndDf <- data.frame(DV=c(DVa, DVb),
                     IV=factor(rep(1:2, Nj), labels=LETTERS[1:2]))
```

Looks at the number of cases in each group which are below or above the median of the combined data.


```r
library(coin)
median_test(DV ~ IV, distribution="exact", data=wIndDf)
```

```

	Exact Median Test

data:  DV by IV (A, B)
Z = 1.1431, p-value = 0.3868
alternative hypothesis: true mu is not equal to 0
```

### Wilcoxon rank-sum test ($=$ Mann-Whitney $U$-test)


```r
wilcox.test(DV ~ IV, alternative="less", conf.int=TRUE, data=wIndDf)
```

```

	Wilcoxon rank sum test

data:  DV by IV
W = 202, p-value = 0.02647
alternative hypothesis: true location shift is less than 0
95 percent confidence interval:
      -Inf -1.770728
sample estimates:
difference in location 
             -9.761436 
```


```r
library(coin)
wilcox_test(DV ~ IV, alternative="less", conf.int=TRUE,
            distribution="exact", data=wIndDf)
```

```

	Exact Wilcoxon Mann-Whitney Rank Sum Test

data:  DV by IV (A, B)
Z = -1.9407, p-value = 0.02647
alternative hypothesis: true mu is less than 0
95 percent confidence interval:
      -Inf -1.770728
sample estimates:
difference in location 
             -9.761436 
```

Two dependent samples
-------------------------

### Sign-test


```r
N      <- 20
DVpre  <- rnorm(N, mean= 95, sd=15)
DVpost <- rnorm(N, mean=100, sd=15)
wDepDf <- data.frame(id=factor(rep(1:N, times=2)),
                     DV=c(DVpre, DVpost),
                     IV=factor(rep(0:1, each=N), labels=c("pre", "post")))
```

Two-sided test


```r
medH0  <- 0
DVdiff <- aggregate(DV ~ id, FUN=diff, data=wDepDf)

library(DescTools)
SignTest(DVdiff$DV, mu=medH0)
```

```

	One-sample Sign-Test

data:  DVdiff$DV
S = 13, number of differences = 20, p-value = 0.2632
alternative hypothesis: true median is not equal to 0
95.9 percent confidence interval:
 -1.255058 27.268025
sample estimates:
median of the differences 
                  8.47604 
```

### Wilcoxon signed rank test


```r
wilcoxsign_test(DV ~ IV | id, alternative="greater",
                distribution="exact", data=wDepDf)
```

```

	Exact Wilcoxon-Signed-Rank Test

data:  y by x (neg, pos) 
	 stratified by block
Z = 2.128, p-value = 0.01638
alternative hypothesis: true mu is greater than 0
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:DescTools))
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npWilcoxon.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npWilcoxon.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npWilcoxon.R) - [all posts](https://github.com/dwoll/RExRepos/)
