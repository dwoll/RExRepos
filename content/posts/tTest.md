---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "t-tests"
categories: [Univariate]
rerCat: Univariate
tags: [tTests]
---




TODO
-------------------------

 - link to resamplingPerm

One-sample $t$-test
-------------------------

### Test


```r
set.seed(1.234)
N    <- 100
DV   <- rnorm(N, 5, 20)
muH0 <- 0
t.test(DV, alternative="two.sided", mu=muH0)
```

```

	One Sample t-test

data:  DV 
t = 3.996, df = 99, p-value = 0.0001242
alternative hypothesis: true mean is not equal to 0 
95 percent confidence interval:
  3.613 10.742 
sample estimates:
mean of x 
    7.178 
```


### Effect size estimate (Cohen's $d$)


```r
(d <- (mean(DV) - muH0) / sd(DV))
```

```
[1] 0.3996
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
t = 3.465, df = 37, p-value = 0.0006798
alternative hypothesis: true difference in means is greater than 0 
95 percent confidence interval:
 3.706   Inf 
sample estimates:
mean in group f mean in group m 
          181.1           173.9 
```


### Welch $t$-Test


```r
t.test(DV ~ IV, alternative="greater", var.equal=FALSE, data=tIndDf)
```

```

	Welch Two Sample t-test

data:  DV by IV 
t = 3.294, df = 23.35, p-value = 0.001566
alternative hypothesis: true difference in means is greater than 0 
95 percent confidence interval:
 3.467   Inf 
sample estimates:
mean in group f mean in group m 
          181.1           173.9 
```


### Effect size estimate (Cohen's $d$)


```r
n1 <- Nj[1]
n2 <- Nj[2]
sdPool <- sqrt(((n1-1)*var(DVm) + (n2-1)*var(DVf)) / (n1+n2-2))
(d     <- (mean(DVm) - mean(DVf)) / sdPool)
```

```
[1] 1.113
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
t = -5.088, df = 19, p-value = 3.268e-05
alternative hypothesis: true difference in means is less than 0 
95 percent confidence interval:
   -Inf -16.64 
sample estimates:
mean of the differences 
                 -25.21 
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
[1] -1.138
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/tTest.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/tTest.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/tTest.R) - [all posts](https://github.com/dwoll/RExRepos/)
