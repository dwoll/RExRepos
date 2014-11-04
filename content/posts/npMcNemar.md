---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "McNemar-test"
categories: [Nonparametric, ClassicalNonparametric]
rerCat: Nonparametric
tags: [Nonparametric, ClassicalNonparametric]
---




Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin)


```r
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

McNemar-test
-------------------------

### Using `mcnemar.test()`


```r
set.seed(123)
N       <- 20
pre     <- rbinom(N, size=1, prob=0.6)
post    <- rbinom(N, size=1, prob=0.4)
preFac  <- factor(pre,  labels=c("no", "yes"))
postFac <- factor(post, labels=c("no", "yes"))
cTab    <- table(preFac, postFac)
addmargins(cTab)
```

```
      postFac
preFac no yes Sum
   no   3   5   8
   yes  6   6  12
   Sum  9  11  20
```


```r
mcnemar.test(cTab, correct=FALSE)
```

```

	McNemar's Chi-squared test

data:  cTab
McNemar's chi-squared = 0.0909, df = 1, p-value = 0.763
```

### Using `symmetry_test()` from package `coin`


```r
library(coin)
symmetry_test(cTab, teststat="quad", distribution=approximate(B=9999))
```

```

	Approximative General Independence Test

data:  response by
	 groups (postFac, preFac) 
	 stratified by block
chi-squared = 0.0909, p-value = 1
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npMcNemar.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npMcNemar.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npMcNemar.R) - [all posts](https://github.com/dwoll/RExRepos/)
