---
layout: post
title: "Hotelling's T^2-test"
categories: [Multivariate]
rerCat: Multivariate
tags: [tTests]
---




Install required packages
-------------------------

[`ICSNP`](http://cran.r-project.org/package=ICSNP), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm)


```r
wants <- c("ICSNP", "mvtnorm")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


One-sample Hotelling's $T^{2}$-test
-------------------------

### Simulate data


```r
set.seed(1.234)
library(mvtnorm)
Nj    <- c(15, 25)
Sigma <- matrix(c(16,-2, -2,9), byrow=TRUE, ncol=2)
mu1   <- c(-4, 4)
Y1    <- round(rmvnorm(Nj[1], mean=mu1, sigma=Sigma))
```


### Using `HotellingsT2()` from package `ICSNP`


```r
muH0 <- c(-1, 2)
library(ICSNP)
HotellingsT2(Y1, mu=muH0)
```

```

	Hotelling's one sample T2-test

data:  Y1 
T.2 = 5.496, df1 = 2, df2 = 13, p-value = 0.01863
alternative hypothesis: true location is not equal to c(-1,2) 
```


### Using `anova.mlm()`


```r
Y1ctr  <- sweep(Y1, 2, muH0, "-")
(anRes <- anova(lm(Y1ctr ~ 1), test="Hotelling-Lawley"))
```

```
Analysis of Variance Table

            Df Hotelling-Lawley approx F num Df den Df Pr(>F)  
(Intercept)  1            0.846      5.5      2     13  0.019 *
Residuals   14                                                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Hotelling's $T^{2}$-test for two independent samples
-------------------------

### Using `HotellingsT2()` from package `ICSNP`


```r
mu2 <- c(3, 3)
Y2  <- round(rmvnorm(Nj[2], mean=mu2, sigma=Sigma))
Y12 <- rbind(Y1, Y2)
IV  <- factor(rep(1:2, Nj))
```



```r
library(ICSNP)
HotellingsT2(Y12 ~ IV)
```

```

	Hotelling's two sample T2-test

data:  Y12 by IV 
T.2 = 15.88, df1 = 2, df2 = 37, p-value = 1.047e-05
alternative hypothesis: true location difference is not equal to c(0,0) 
```


### Using `anova.mlm()` or `manova()`


```r
anova(lm(Y12 ~ IV), test="Hotelling-Lawley")
```

```
Analysis of Variance Table

            Df Hotelling-Lawley approx F num Df den Df Pr(>F)    
(Intercept)  1            1.705     31.5      2     37  1e-08 ***
IV           1            0.859     15.9      2     37  1e-05 ***
Residuals   38                                                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```

```r
summary(manova(Y12 ~ IV), test="Hotelling-Lawley")
```

```
          Df Hotelling-Lawley approx F num Df den Df Pr(>F)    
IV         1            0.859     15.9      2     37  1e-05 ***
Residuals 38                                                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Hotelling's $T^{2}$-test for two dependent samples
-------------------------

### Simulate data


```r
N    <- 20
P    <- 2
muJK <- c(90, 100, 85, 105)
Sig  <- 15
Y1t0 <- rnorm(N, mean=muJK[1], sd=Sig)
Y1t1 <- rnorm(N, mean=muJK[2], sd=Sig)
Y2t0 <- rnorm(N, mean=muJK[3], sd=Sig)
Y2t1 <- rnorm(N, mean=muJK[4], sd=Sig)
Ydf  <- data.frame(id=factor(rep(1:N, times=P)),
                   Y1=c(Y1t0, Y1t1),
                   Y2=c(Y2t0, Y2t1),
                   IV=factor(rep(1:P, each=N), labels=c("t0", "t1")))
```



```r
dfDiff <- aggregate(cbind(Y1, Y2) ~ id, data=Ydf, FUN=diff)
DVdiff <- data.matrix(dfDiff[ , -1])
muH0   <- c(0, 0)
```


### Using `HotellingsT2()` from package `ICSNP`


```r
library(ICSNP)
HotellingsT2(DVdiff, mu=muH0)
```

```

	Hotelling's one sample T2-test

data:  DVdiff 
T.2 = 12.4, df1 = 2, df2 = 18, p-value = 0.0004111
alternative hypothesis: true location is not equal to c(0,0) 
```


### Using `anova.mlm()`


```r
anova(lm(DVdiff ~ 1), test="Hotelling-Lawley")
```

```
Analysis of Variance Table

            Df Hotelling-Lawley approx F num Df den Df  Pr(>F)    
(Intercept)  1             1.38     12.4      2     18 0.00041 ***
Residuals   19                                                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:ICSNP))
try(detach(package:ICS))
try(detach(package:survey))
try(detach(package:mvtnorm))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multHotelling.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multHotelling.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multHotelling.R) - [all posts](https://github.com/dwoll/RExRepos/)
