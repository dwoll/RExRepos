---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Crossvalidation and bootstrap prediction error for linear and generalized linear models"
categories: [Univariate]
rerCat: Univariate
tags: [Regression]
---




Install required packages
-------------------------

[`boot`](http://cran.r-project.org/package=boot)


```r
wants <- c("boot")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

$k$-fold crossvalidation
-------------------------

### Simulate data
    

```r
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 3)
dfRegr <- data.frame(X1, X2, X3, Y)
```

### Crossvalidation


```r
glmFit <- glm(Y ~ X1 + X2 + X3, data=dfRegr,
              family=gaussian(link="identity"))
```


```r
library(boot)                          # for cv.glm()
k    <- 3
kfCV <- cv.glm(data=dfRegr, glmfit=glmFit, K=k)
kfCV$delta
```

```
[1] 10.16324 10.03843
```

Leave-one-out crossvalidation
-------------------------


```r
LOOCV <- cv.glm(data=dfRegr, glmfit=glmFit, K=N)
```

CVE = mean(PRESS)


```r
LOOCV$delta
```

```
[1] 10.3501 10.3460
```

$k$-fold crossvalidation of logistic regression using Brier score
-------------------------

Generate data and fit logistic regression.


```r
SSRIpre  <- c(18, 16, 16, 15, 14, 20, 14, 21, 25, 11)
SSRIpost <- c(12,  0, 10,  9,  0, 11,  2,  4, 15, 10)
PlacPre  <- c(18, 16, 15, 14, 20, 25, 11, 25, 11, 22)
PlacPost <- c(11,  4, 19, 15,  3, 14, 10, 16, 10, 20)
WLpre    <- c(15, 19, 10, 29, 24, 15,  9, 18, 22, 13)
WLpost   <- c(17, 25, 10, 22, 23, 10,  2, 10, 14,  7)
DVpre    <- c(SSRIpre,  PlacPre,  WLpre)
DVpost   <- c(SSRIpost, PlacPost, WLpost)
postFac  <- cut(DVpost, breaks=c(-Inf, median(DVpost), Inf),
                        labels=c("lo", "hi"))
dfAncova <- data.frame(DVpre, DVpost, postFac)

glmLR <- glm(postFac ~ DVpre, family=binomial(link="logit"), data=dfAncova)
```

$k$-fold crossvalidation using Brier score $B$ as a strictly proper score.


```r
# Brier score loss function - general version for several GLMs
brierA <- function(y, pHat) {
    mean(((y == 1) * pHat)^2 + ((y == 0) * (1-pHat))^2)
}

library(boot)                          # for cv.glm()
B1 <- cv.glm(data=dfAncova, glmfit=glmLR, cost=brierA, K=10)
B1$delta
```

```
[1] 0.5560471 0.5544728
```

```r
# Brier score loss function - simplified version for logistic regression only
brierB <- function(y, pHat) {
    mean((y-pHat)^2)
}

B2 <- cv.glm(data=dfAncova, glmfit=glmLR, cost=brierB, K=10)
B2$delta
```

```
[1] 0.1841384 0.1824343
```

Bootstrap prediction error with optimism correction
-------------------------

Function to fit logistic regression and calculate Brier score. Take into account that logistic regression might not converge for resample due to perfect separation: Turn warnings into errors and use `try()` to handle errors.


```r
getBSB <- function(dat, idx) {
    op <- options(warn=2)
    on.exit(options(op))

    bsFit <- try(glm(postFac ~ DVpre, family=binomial(link="logit"), subset=idx, data=dat))
    fail  <- inherits(bsFit, "try-error")
    if(fail || !bsFit$converged) {
        return(NA)
    } else {
        BbsTrn <- brierB(bsFit$y, predict(bsFit, type="response"))
        BbsTst <- brierB(as.numeric(dat$postFac)-1, predict(bsFit, newdata=dat, type="response"))
        return(BbsTrn - BbsTst)
    }
}
```

Bootstrap logistic regression, calculate optimim in prediction error.

```r
library(boot)                          # for boot()
nR    <- 999
bsRes <- boot(dfAncova, statistic=getBSB, R=nR)

(Btrain   <- brierB(glmLR$y, predict(glmLR, type="response")))
```

```
[1] 0.1494605
```

```r
(optimism <- mean(bsRes$t, na.rm=TRUE))
```

```
[1] -0.01881823
```

Optimism-corrected bootstrap estimate of prediction error.


```r
(predErr <- Btrain - optimism)
```

```
[1] 0.1682787
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:boot))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/crossvalidation.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/crossvalidation.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/crossvalidation.R) - [all posts](https://github.com/dwoll/RExRepos/)
