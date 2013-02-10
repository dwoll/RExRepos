---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Bowker-test"
categories: [Nonparametric, ClassicalNonparametric]
rerCat: Nonparametric
tags: [Nonparametric, ClassicalNonparametric]
---

Bowker-test
=========================

Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin)


```r
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Bowker test
-------------------------

### Using `mcnemar.test()`


```r
categ <- factor(1:3, labels=c("lo", "med", "hi"))
drug  <- rep(categ, c(30, 50, 20))
plac  <- rep(rep(categ, length(categ)), c(14,7,9, 5,26,19, 1,7,12))
cTab  <- table(drug, plac)
addmargins(cTab)
```

```
     plac
drug   lo med  hi Sum
  lo   14   7   9  30
  med   5  26  19  50
  hi    1   7  12  20
  Sum  20  40  40 100
```


`mcnemar.test()` automatically runs the Bowker test for tables with more than 2 rows/columns


```r
mcnemar.test(cTab)
```

```

	McNemar's Chi-squared test

data:  cTab 
McNemar's chi-squared = 12.27, df = 3, p-value = 0.006508
```


### Using `symmetry_test()` from package `coin`


```r
library(coin)
symmetry_test(cTab, teststat="quad", distribution=approximate(B=9999))
```

```

	Approximative General Independence Test

data:  response by
	 groups (drug, plac) 
	 stratified by block 
chi-squared = 12.14, p-value = 0.0019
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npBowker.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npBowker.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npBowker.R) - [all posts](https://github.com/dwoll/RExRepos/)
