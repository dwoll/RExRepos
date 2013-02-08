---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Multivariate analysis of variance (MANOVA)"
categories: [Multivariate]
rerCat: Multivariate
tags: [ANOVA]
---




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
set.seed(1.234)
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
IV         2 0.427     14.8      4    112 9.2e-10 ***
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
IV1         2  0.775     36.0      4    228 < 2e-16 ***
IV2         1  0.157     10.5      2    113 6.6e-05 ***
IV1:IV2     2  0.148      4.6      4    228  0.0014 ** 
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
Y.1 1595.4 -252.1
Y.2 -252.1 1075.2

------------------------------------------
 
Term: (Intercept) 

Sum of squares and products for the hypothesis:
      Y.1    Y.2
Y.1 175.9  422.3
Y.2 422.3 1013.8

Multivariate Tests: (Intercept)
                 Df test stat approx F num Df den Df Pr(>F)    
Pillai            1    0.5501    69.07      2    113 <2e-16 ***
Wilks             1    0.4499    69.07      2    113 <2e-16 ***
Hotelling-Lawley  1    1.2225    69.07      2    113 <2e-16 ***
Roy               1    1.2225    69.07      2    113 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV1 

Sum of squares and products for the hypothesis:
      Y.1   Y.2
Y.1 878.6 148.0
Y.2 148.0 750.3

Multivariate Tests: IV1
                 Df test stat approx F num Df den Df Pr(>F)    
Pillai            2    0.7748    36.05      4    228 <2e-16 ***
Wilks             2    0.3666    36.81      4    226 <2e-16 ***
Hotelling-Lawley  2    1.3417    37.57      4    224 <2e-16 ***
Roy               2    0.9243    52.68      2    114 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV2 

Sum of squares and products for the hypothesis:
      Y.1   Y.2
Y.1 45.68 59.45
Y.2 59.45 77.36

Multivariate Tests: IV2
                 Df test stat approx F num Df den Df  Pr(>F)   
Pillai            1    0.1092    6.927      2    113 0.00145 **
Wilks             1    0.8908    6.927      2    113 0.00145 **
Hotelling-Lawley  1    0.1226    6.927      2    113 0.00145 **
Roy               1    0.1226    6.927      2    113 0.00145 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

------------------------------------------
 
Term: IV1:IV2 

Sum of squares and products for the hypothesis:
       Y.1     Y.2
Y.1 14.558  -7.192
Y.2 -7.192 169.478

Multivariate Tests: IV1:IV2
                 Df test stat approx F num Df den Df   Pr(>F)    
Pillai            2    0.1483    4.566      4    228 0.001448 ** 
Wilks             2    0.8529    4.677      4    226 0.001204 ** 
Hotelling-Lawley  2    0.1710    4.787      4    224 0.001006 ** 
Roy               2    0.1619    9.230      2    114 0.000193 ***
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
