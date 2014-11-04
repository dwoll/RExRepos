---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Stratified bootstrapping"
categories: [Nonparametric, Resampling]
rerCat: Nonparametric
tags: [Bootstrapping]
---

Stratified bootstrapping
========================================================

TODO
-------------------------

 - link to resamplingBoot

Install required packages
-------------------------

[`boot`](http://cran.r-project.org/package=boot)


```r
wants <- c("boot")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Stratified sampling for two independent groups
-------------------------

### Confidence interval for $\mu_{2} - \mu_{1}$


```r
set.seed(123)
n1  <- 18
n2  <- 21
DVm <- rnorm(n1, 180, 10)
DVf <- rnorm(n2, 175, 6)
tDf <- data.frame(DV=c(DVm, DVf),
                  IV=factor(rep(c("m", "f"), c(n1, n2))))
```

Function to return difference between group means.


```r
getDM <- function(dat, idx) {
    Mfm <- aggregate(DV ~ IV, data=dat, subset=idx, FUN=mean)
    -diff(Mfm$DV)
}
```

Bootstrap with `strata` option for stratification.


```r
library(boot)
bsTind <- boot(tDf, statistic=getDM, strata=tDf$IV, R=999)
boot.ci(bsTind, conf=0.95, type=c("basic", "bca"))
```

```
BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
Based on 999 bootstrap replicates

CALL : 
boot.ci(boot.out = bsTind, conf = 0.95, type = c("basic", "bca"))

Intervals : 
Level      Basic                BCa          
95%   (-11.487,  -1.601 )   (-11.243,  -1.586 )  
Calculations and Intervals on Original Scale
```

Compare with parametric confidence interval


```r
tt <- t.test(DV ~ IV, alternative="two.sided", var.equal=TRUE, data=tDf)
tt$conf.int
```

```
[1] -11.608769  -1.522242
attr(,"conf.level")
[1] 0.95
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:boot))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/resamplingBootStrat.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/resamplingBootStrat.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/resamplingBootStrat.R) - [all posts](https://github.com/dwoll/RExRepos/)
