---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Multivariate multiple regression"
categories: [Multivariate]
rerCat: Multivariate
tags: [Multivariate, Regression]
---




TODO
-------------------------

 - link to regressionDiag, anovaSStypes

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car)


```r
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Model fit
-------------------------
    

```r
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N, 30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y1 <- 0.2*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 10)
Y2 <- -0.3*X2 + 0.2*X3 + rnorm(N, 10)
Y  <- cbind(Y1, Y2)
dfRegr <- data.frame(X1, X2, X3, Y1, Y2)
```



```r
(fit <- lm(cbind(Y1, Y2) ~ X1 + X2 + X3, data=dfRegr))
```

```

Call:
lm(formula = cbind(Y1, Y2) ~ X1 + X2 + X3, data = dfRegr)

Coefficients:
             Y1       Y2     
(Intercept)  23.0840  16.3234
X1            0.1208  -0.0319
X2           -0.2422  -0.3178
X3           -0.4191   0.1984
```



```r
coef(lm(Y1 ~ X1 + X2 + X3, data=dfRegr))
```

```
(Intercept)          X1          X2          X3 
    23.0840      0.1208     -0.2422     -0.4191 
```

```r
coef(lm(Y2 ~ X1 + X2 + X3, data=dfRegr))
```

```
(Intercept)          X1          X2          X3 
   16.32336    -0.03185    -0.31782     0.19836 
```


Coefficient tests and overall model test
-------------------------

### Type I sum of squares


```r
summary(manova(fit), test="Hotelling-Lawley")
```

```
          Df Hotelling-Lawley approx F num Df den Df  Pr(>F)    
X1         1              0.8       36      2     95 2.2e-12 ***
X2         1              5.9      281      2     95 < 2e-16 ***
X3         1             35.1     1667      2     95 < 2e-16 ***
Residuals 96                                                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```



```r
summary(manova(fit), test="Wilks")
summary(manova(fit), test="Roy")
summary(manova(fit), test="Pillai")
```


No possibility to use `confint()` for multivariate models.

### Type II/III sum of squares

Since no interaction is present in the model, SS type II and III are equivalent here.


```r
library(car)                           # for Manova()
Manova(fit, type="II")
```

```

Type II MANOVA Tests: Pillai test statistic
   Df test stat approx F num Df den Df Pr(>F)    
X1  1     0.047        2      2     95    0.1    
X2  1     0.868      314      2     95 <2e-16 ***
X3  1     0.972     1667      2     95 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multRegression.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multRegression.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multRegression.R) - [all posts](https://github.com/dwoll/RExRepos/)
