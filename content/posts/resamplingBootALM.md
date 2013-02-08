---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Bootstrapping linear models"
categories: [Nonparametric, Resampling]
rerCat: Nonparametric
tags: [Bootstrapping]
---




TODO
-------------------------

 - GLM example
 - link to resamplingBoot

Install required packages
-------------------------

[`boot`](http://cran.r-project.org/package=boot)


```r
wants <- c("boot")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Regression parameters: Case resampling
-------------------------


```r
set.seed(1.234)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 3)
dfRegr <- data.frame(X1, X2, X3, Y)
```



```r
(fit <- lm(Y ~ X1 + X2 + X3, data=dfRegr))
```

```

Call:
lm(formula = Y ~ X1 + X2 + X3, data = dfRegr)

Coefficients:
(Intercept)           X1           X2           X3  
     14.482        0.476       -0.321       -0.391  
```

```r
sqrt(diag(vcov(fit)))
```

```
(Intercept)          X1          X2          X3 
    8.54235     0.04797     0.03941     0.01052 
```

```r
confint(fit)
```

```
              2.5 %  97.5 %
(Intercept) -2.4746 31.4383
X1           0.3805  0.5710
X2          -0.3991 -0.2427
X3          -0.4119 -0.3702
```



```r
getRegr <- function(dat, idx) {
    bsFit <- lm(Y ~ X1 + X2 + X3, subset=idx, data=dat)
    coef(bsFit)
}
```



```r
library(boot)
nR <- 999
(bsRegr <- boot(dfRegr, statistic=getRegr, R=nR))
```

```

ORDINARY NONPARAMETRIC BOOTSTRAP


Call:
boot(data = dfRegr, statistic = getRegr, R = nR)


Bootstrap Statistics :
    original     bias    std. error
t1*  14.4819 -0.0912465    10.15789
t2*   0.4758  0.0009374     0.05676
t3*  -0.3209 -0.0013366     0.04059
t4*  -0.3911 -0.0005230     0.01137
```



```r
boot.ci(bsRegr, conf=0.95, type="bca", index=1)$bca
```

```
     conf                         
[1,] 0.95 28.29 978.2 -4.821 35.42
```

```r
boot.ci(bsRegr, conf=0.95, type="bca", index=2)$bca
```

```
     conf                         
[1,] 0.95 18.5 967.3 0.3568 0.5796
```

```r
boot.ci(bsRegr, conf=0.95, type="bca", index=3)$bca
```

```
     conf                          
[1,] 0.95 33.98 982 -0.3964 -0.2355
```

```r
boot.ci(bsRegr, conf=0.95, type="bca", index=4)$bca
```

```
     conf                         
[1,] 0.95 32.6 981 -0.4123 -0.3688
```


ANOVA
-------------------------

### Model-based resampling

Under the null hypothesis


```r
P     <- 4
Nj    <- c(41, 37, 42, 40)
muJ   <- rep(c(-1, 0, 1, 2), Nj)
dfCRp <- data.frame(IV=factor(rep(LETTERS[1:P], Nj)),
                    DV=rnorm(sum(Nj), muJ, 6))
```



```r
anBase <- anova(lm(DV ~ IV, data=dfCRp))
Fbase  <- anBase["IV", "F value"]
(pBase <- anBase["IV", "Pr(>F)"])
```

```
[1] 0.0212
```



```r
fit0 <- lm(DV ~ 1, data=dfCRp)        ## fit 0-model
E    <- residuals(fit0)               ## residuals
Er   <- E / sqrt(1-hatvalues(fit0))   ## rescaled residuals
Yhat <- fitted(fit0)                  ## prediction

getAnova <- function(dat, idx) {
    Ystar <- Yhat + Er[idx]
    anBS  <- anova(lm(Ystar ~ IV, data=dat))
    anBS["IV", "F value"]
}

library(boot)
nR       <- 999
(bsAnova <- boot(dfCRp, statistic=getAnova, R=nR))
```

```

ORDINARY NONPARAMETRIC BOOTSTRAP


Call:
boot(data = dfCRp, statistic = getAnova, R = nR)


Bootstrap Statistics :
    original  bias    std. error
t1*    3.328  -2.296      0.8058
```

```r
Fstar    <- bsAnova$t
(pValBS  <- (sum(Fstar >= Fbase) + 1) / (length(Fstar) + 1))
```

```
[1] 0.018
```



```r
plot(Fstar, ecdf(Fstar)(Fstar), col="gray60", pch=1, xlab="f* bzw. f",
     ylab="P(F <= f)", main="F*: cumulative rel. freqs and F CDF")
curve(pf(x, P-1, sum(Nj) - P), lwd=2, add=TRUE)
legend(x="topleft", lty=c(NA, 1), pch=c(1, NA), lwd=c(2, 2),
       col=c("gray60", "black"), legend=c("F*", "F"))
```

![plot of chunk rerResamplingBootALM01](../content/assets/figure/rerResamplingBootALM01.png) 


### Wild boostrap

Under the null hypothesis


```r
getAnovaWild <- function(dat, idx) {
    n  <- length(idx)                     ## size of replication
    ## 1st choice for random variate U: Rademacher-variables
    Ur <- sample(c(-1, 1), size=n, replace=TRUE, prob=c(0.5, 0.5))

    ## 2nd option for choosing random variate U
    Uf <- sample(c(-(sqrt(5) - 1)/2, (sqrt(5) + 1)/2), size=n, replace=TRUE,
                 prob=c((sqrt(5) + 1)/(2*sqrt(5)), (sqrt(5) - 1)/(2*sqrt(5))))

    Ystar <- Yhat + (Er*Ur)[idx]          ## for E* with Rademacher-variables
    # Ystar <- Yhat + (Er*Uf)[idx]        ## for E* with 2nd option
    anBS  <- anova(lm(Ystar ~ IV, data=dat))
    anBS["IV", "F value"]
}
```



```r
library(boot)
nR       <- 999
bsAnovaW <- boot(dfCRp, statistic=getAnovaWild, R=nR)
FstarW   <- bsAnovaW$t
(pValBSw <- (sum(FstarW >= Fbase) + 1) / (length(FstarW) + 1))
```

```
[1] 0.023
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:boot))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/resamplingBootALM.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/resamplingBootALM.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/resamplingBootALM.R) - [all posts](https://github.com/dwoll/RExRepos/)
