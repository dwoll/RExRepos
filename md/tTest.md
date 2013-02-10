---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "t-tests"
categories: [Univariate]
rerCat: Univariate
tags: [tTests]
---

t-tests
=========================

TODO
-------------------------

 - link to resamplingPerm

One-sample $t$-test
-------------------------

### Test


```r
set.seed(123)
N    <- 100
DV   <- rnorm(N, 5, 20)
muH0 <- 0
t.test(DV, alternative="two.sided", mu=muH0)
```

```

	One Sample t-test

data:  DV 
t = 3.729, df = 99, p-value = 0.0003203
alternative hypothesis: true mean is not equal to 0 
95 percent confidence interval:
  3.186 10.431 
sample estimates:
mean of x 
    6.808 
```


### Effect size estimate (Cohen's $d$)


```r
(d <- (mean(DV) - muH0) / sd(DV))
```

```
[1] 0.3729
```


Two-sample $t$-test for independent samples
-------------------------

### $t$-Test


```r
Nj     <- c(18, 21)
DVm    <- rnorm(Nj[1], 180, 10)
DVf    <- rnorm(Nj[2], 175, 6)
tIndDf <- data.frame(DV=c(DVm, DVf),
                     IV=factor(rep(c("f", "m"), Nj)))
```



```r
t.test(DVf, DVm, alternative="less", var.equal=TRUE)
```



```r
t.test(DV ~ IV, alternative="greater", var.equal=TRUE, data=tIndDf)
```

```

	Two Sample t-test

data:  DV by IV 
t = 1.114, df = 37, p-value = 0.1363
alternative hypothesis: true difference in means is greater than 0 
95 percent confidence interval:
 -1.23   Inf 
sample estimates:
mean in group f mean in group m 
          177.0           174.7 
```


### Welch $t$-Test


```r
t.test(DV ~ IV, alternative="greater", var.equal=FALSE, data=tIndDf)
```

```

	Welch Two Sample t-test

data:  DV by IV 
t = 1.103, df = 34.36, p-value = 0.1388
alternative hypothesis: true difference in means is greater than 0 
95 percent confidence interval:
 -1.272    Inf 
sample estimates:
mean in group f mean in group m 
          177.0           174.7 
```


### Effect size estimate (Cohen's $d$)


```r
n1 <- Nj[1]
n2 <- Nj[2]
sdPool <- sqrt(((n1-1)*var(DVm) + (n2-1)*var(DVf)) / (n1+n2-2))
(d     <- (mean(DVm) - mean(DVf)) / sdPool)
```

```
[1] 0.3577
```


Two-sample $t$-test for dependent samples
-------------------------

### Test


```r
N      <- 20
DVpre  <- rnorm(N, mean=90,  sd=15)
DVpost <- rnorm(N, mean=100, sd=15)
tDepDf <- data.frame(DV=c(DVpre, DVpost),
                     IV=factor(rep(0:1, each=N), labels=c("pre", "post")))
```



```r
t.test(DV ~ IV, alternative="less", paired=TRUE, data=tDepDf)
```

```

	Paired t-test

data:  DV by IV 
t = -2.992, df = 19, p-value = 0.003748
alternative hypothesis: true difference in means is less than 0 
95 percent confidence interval:
   -Inf -6.739 
sample estimates:
mean of the differences 
                 -15.97 
```



```r
DVdiff <- DVpre - DVpost
t.test(DVdiff, alternative="less")
```


### Effect size estimate (Cohen's $d$)


```r
(d <- mean(DVdiff) / sd(DVdiff))
```

```
[1] -0.669
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/tTest.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/tTest.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/tTest.R) - [all posts](https://github.com/dwoll/RExRepos/)
