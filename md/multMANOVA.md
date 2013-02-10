---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Multivariate analysis of variance (MANOVA)"
categories: [Multivariate]
rerCat: Multivariate
tags: [ANOVA]
---

Multivariate analysis of variance (MANOVA)
=========================

TODO
-------------------------

 - link to multLDA, anovaSStypes

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm)


```r
wants <- c("car", "mvtnorm")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


One-way MANOVA
-------------------------
    

```r
set.seed(123)
P     <- 3
Nj    <- c(15, 25, 20)
Sigma <- matrix(c(16,-2, -2,9), byrow=TRUE, ncol=2)
mu11  <- c(-4,  4)
mu21  <- c( 3,  3)
mu31  <- c( 1, -1)

library(mvtnorm)
Y11 <- round(rmvnorm(Nj[1], mean=mu11, sigma=Sigma))
Y21 <- round(rmvnorm(Nj[2], mean=mu21, sigma=Sigma))
Y31 <- round(rmvnorm(Nj[3], mean=mu31, sigma=Sigma))

dfMan1 <- data.frame(Y =rbind(Y11, Y21, Y31),
                     IV=factor(rep(1:P, Nj)))
```



```r
manRes1 <- manova(cbind(Y.1, Y.2) ~ IV, data=dfMan1)
summary(manRes1, test="Wilks")
```

```
          Df Wilks approx F num Df den Df  Pr(>F)    
IV         2 0.387       17      4    112 6.2e-11 ***
Residuals 57                                         
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```



```r
summary(manRes1, test="Roy")
summary(manRes1, test="Pillai")
summary(manRes1, test="Hotelling-Lawley")
```


Two-way MANOVA
-------------------------


```r
Q    <- 2
mu12 <- c(-1,  4)
mu22 <- c( 4,  8)
mu32 <- c( 4,  0)

library(mvtnorm)
Y12  <- round(rmvnorm(Nj[1], mean=mu12, sigma=Sigma))
Y22  <- round(rmvnorm(Nj[2], mean=mu22, sigma=Sigma))
Y32  <- round(rmvnorm(Nj[3], mean=mu32, sigma=Sigma))

dfMan2 <- data.frame(Y  =rbind(Y11, Y21, Y31, Y12, Y22, Y32),
                     IV1=factor(rep(rep(1:P, Nj), Q)),
                     IV2=factor(rep(1:Q, each=sum(Nj))))
```


### Type I sum of squares


```r
manRes2 <- manova(cbind(Y.1, Y.2) ~ IV1*IV2, data=dfMan2)
summary(manRes2, test="Pillai")
```

```
           Df Pillai approx F num Df den Df  Pr(>F)    
IV1         2  0.819     39.5      4    228 < 2e-16 ***
IV2         1  0.241     17.9      2    113 1.8e-07 ***
IV1:IV2     2  0.146      4.5      4    228  0.0017 ** 
Residuals 114                                          
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```



```r
summary(manRes2, test="Wilks")
summary(manRes2, test="Roy")
summary(manRes2, test="Hotelling-Lawley")
```


### Type II/III sum of squares


```r
library(car)
fitIII <- lm(cbind(Y.1, Y.2) ~ IV1*IV2, data=dfMan2,
             contrasts=list(IV1=contr.sum, IV2=contr.sum))
ManRes <- Manova(fitIII, type="III")
summary(ManRes, multivariate=TRUE)
```

```

Type III MANOVA Tests:

Sum of squares and products for error:
       Y.1    Y.2
Y.1 1658.0 -349.2
Y.2 -349.2  982.9

------------------------------------------
 
Term: (Intercept) 

Sum of squares and products for the hypothesis:
      Y.1   Y.2
Y.1 188.1 412.1
Y.2 412.1 902.9

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df Pr(>F)    
Pillai            1    0.5664    73.81      2    113 <2e-16 ***
Wilks             1    0.4336    73.81      2    113 <2e-16 ***
Hotelling-Lawley  1    1.3064    73.81      2    113 <2e-16 ***
Roy               1    1.3064    73.81      2    113 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV1 

Sum of squares and products for the hypothesis:
       Y.1    Y.2
Y.1 782.98  62.59
Y.2  62.59 891.47

Multivariate Tests: IV1
                 Df test stat approx F num Df den Df Pr(>F)    
Pillai            2    0.8189    39.52      4    228 <2e-16 ***
Wilks             2    0.3356    41.04      4    226 <2e-16 ***
Hotelling-Lawley  2    1.5197    42.55      4    224 <2e-16 ***
Roy               2    1.1020    62.81      2    114 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV2 

Sum of squares and products for the hypothesis:
      Y.1   Y.2
Y.1 193.3 116.3
Y.2 116.3  69.9

Multivariate Tests: IV2
                 Df test stat approx F num Df den Df   Pr(>F)    
Pillai            1    0.2043    14.51      2    113 2.47e-06 ***
Wilks             1    0.7957    14.51      2    113 2.47e-06 ***
Hotelling-Lawley  1    0.2568    14.51      2    113 2.47e-06 ***
Roy               1    0.2568    14.51      2    113 2.47e-06 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV1:IV2 

Sum of squares and products for the hypothesis:
       Y.1    Y.2
Y.1  39.73 -69.37
Y.2 -69.37 158.57

Multivariate Tests: IV1:IV2
                 Df test stat approx F num Df den Df   Pr(>F)    
Pillai            2    0.1455    4.472      4    228 0.001693 ** 
Wilks             2    0.8553    4.591      4    226 0.001391 ** 
Hotelling-Lawley  2    0.1681    4.708      4    224 0.001147 ** 
Roy               2    0.1620    9.237      2    114 0.000192 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:mvtnorm))
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multMANOVA.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multMANOVA.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multMANOVA.R) - [all posts](https://github.com/dwoll/RExRepos/)
