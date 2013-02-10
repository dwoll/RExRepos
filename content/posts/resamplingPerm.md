---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Permutation tests"
categories: [Nonparametric, Resampling]
rerCat: Nonparametric
tags: [PermutationTests]
---




TODO
-------------------------

 - link to combinatorics

Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin), [`e1071`](http://cran.r-project.org/package=e1071)


```r
wants <- c("coin", "e1071")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Two-sample $t$-test / one-way ANOVA for independent groups
-------------------------

Not limited to just two independent samples.

### Using package `coin`


```r
set.seed(123)
Nj     <- c(7, 8)
sigma  <- 20
DVa    <- rnorm(Nj[1], 100, sigma)
DVb    <- rnorm(Nj[2], 110, sigma)
tIndDf <- data.frame(DV=c(DVa, DVb),
                     IV=factor(rep(c("A", "B"), Nj)))
```



```r
library(coin)
oneway_test(DV ~ IV, alternative="less", distribution="exact", data=tIndDf)
```

```

	Exact 2-Sample Permutation Test

data:  DV by IV (A, B) 
Z = 0.1369, p-value = 0.5549
alternative hypothesis: true mu is less than 0 
```



```r
tRes <- t.test(DV ~ IV, alternative="less", var.equal=TRUE, data=tIndDf)
tRes$p.value
```

```
[1] 0.5515
```


### Manual exact test


```r
idx   <- seq(along=tIndDf$DV)
idxA  <- combn(idx, Nj[1])
getDM <- function(x) { mean(tIndDf$DV[!(idx %in% x)]) - mean(tIndDf$DV[x]) }
resDM <- apply(idxA, 2, getDM)
diffM <- diff(tapply(tIndDf$DV, tIndDf$IV, mean))
(pVal <- sum(resDM >= diffM) / length(resDM))
```

```
[1] 0.5549
```


### Diagram: permutation distribution


```r
hist(resDM, freq=FALSE, breaks="FD", xlab="Difference in means",
     main="Permutation test: Histogram difference in means")
curve(dnorm(x, 0, sigma/sqrt(Nj[1]) + sigma/sqrt(Nj[2])), lwd=2, add=TRUE)
legend(x="topright", lty=1, lwd=2, legend=expression(paste("N(0, ", sigma[1]^2 / n[1] + sigma[2]^2 / n[2], ")")))
```

![plot of chunk rerResamplingPerm01](content/assets/figure/rerResamplingPerm01.png) 



```r
plot(resDM, ecdf(resDM)(resDM), col="gray60", pch=16,
     xlab="Difference in means", ylab="cumulative relative frequency",
     main="Cumulative relative frequency and normal CDF")
curve(pnorm(x, 0, sigma/sqrt(Nj[1]) + sigma/sqrt(Nj[2])), lwd=2, add=TRUE)
legend(x="bottomright", lty=c(NA, 1), pch=c(16, NA), lwd=c(1, 2),
       col=c("gray60", "black"),
       legend=c("Permutations",
       expression(paste("N(0, ", sigma[1]^2 / n[1] + sigma[2]^2 / n[2], ")"))))
```

![plot of chunk rerResamplingPerm02](content/assets/figure/rerResamplingPerm02.png) 


Two-sample $t$-test / one-way ANOVA for dependent groups
-------------------------

Not limited to just two dependent samples.

### Using package `coin`


```r
N      <- 12
id     <- factor(rep(1:N, times=2))
DVpre  <- rnorm(N, 100, 20)
DVpost <- rnorm(N, 110, 20)
tDepDf <- data.frame(DV=c(DVpre, DVpost),
                     IV=factor(rep(0:1, each=N), labels=c("pre", "post")))
```



```r
library(coin)
oneway_test(DV ~ IV | id, alternative="less", distribution=approximate(B=9999), data=tDepDf)
```

```

	Approximative 2-Sample Permutation Test

data:  DV by IV (pre, post) 
	 stratified by id 
Z = -2.123, p-value = 0.0138
alternative hypothesis: true mu is less than 0 
```



```r
t.test(DV ~ IV, alternative="less", paired=TRUE, data=tDepDf)$p.value
```

```
[1] 0.01296
```


### Manual exact test


```r
DVd    <- DVpre - DVpost
sgnLst <- lapply(numeric(N), function(x) { c(-1, 1) } )
sgnMat <- data.matrix(expand.grid(sgnLst))
getMD  <- function(x) { mean(abs(DVd) * x) }
resMD  <- apply(sgnMat, 1, getMD)
(pVal  <- sum(resMD <= mean(DVd)) / length(resMD))
```

```
[1] 0.01392
```


Independence of two variables
-------------------------

### Fisher's exact test

```r
Nf  <- 7
DV1 <- rbinom(Nf, size=1, prob=0.5)
DV2 <- rbinom(Nf, size=1, prob=0.5)
fisher.test(DV1, DV2, alternative="greater")$p.value
```

```
[1] 1
```


### Manual exact test


```r
library(e1071)
permIdx  <- permutations(Nf)
getAgree <- function(idx) {
    sum(diag(table(DV1, DV2[idx])))
}

resAgree <- apply(permIdx, 1, getAgree)
agree12  <- sum(diag(table(DV1, DV2)))
(pVal    <- sum(resAgree >= agree12) / length(resAgree))
```

```
[1] 1
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:e1071))
try(detach(package:class))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/resamplingPerm.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/resamplingPerm.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/resamplingPerm.R) - [all posts](https://github.com/dwoll/RExRepos/)
