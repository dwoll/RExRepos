---
layout: post
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
set.seed(1.234)
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
   no   7   3  10
   yes  6   4  10
   Sum 13   7  20
```



```r
mcnemar.test(cTab, correct=FALSE)
```

```

	McNemar's Chi-squared test

data:  cTab 
McNemar's chi-squared = 1, df = 1, p-value = 0.3173
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
chi-squared = 1, p-value = 0.5055
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

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npMcNemar.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npMcNemar.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npMcNemar.R) - [all posts](https://github.com/dwoll/RExRepos/)
