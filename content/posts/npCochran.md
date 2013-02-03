---
layout: post
title: "Cochran-Q-test"
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


Cochran-$Q$-test
-------------------------


```r
N   <- 10
P   <- 5
cDf <- data.frame(id=factor(rep(1:N, each=P)),
                  year=factor(rep(1981:1985, times=N)),
                  pref=c(1,1,0,1,0, 0,1,0,0,1, 1,0,1,0,0, 1,1,1,1,1, 0,1,0,0,0,
                         1,0,1,1,1, 0,0,0,0,0, 1,1,1,1,0, 0,1,0,1,1, 1,0,1,0,0))
```



```r
library(coin)
symmetry_test(pref ~ year | id, teststat="quad", data=cDf)
```

```

	Asymptotic General Independence Test

data:  pref by
	 year (1981, 1982, 1983, 1984, 1985) 
	 stratified by id 
chi-squared = 1.333, df = 4, p-value = 0.8557
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

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npCochran.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npCochran.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npCochran.R) - [all posts](https://github.com/dwoll/RExRepos/)
