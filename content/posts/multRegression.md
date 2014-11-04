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
             Y1        Y2      
(Intercept)  23.08395  16.32336
X1            0.12078  -0.03185
X2           -0.24223  -0.31782
X3           -0.41913   0.19836
```


```r
coef(lm(Y1 ~ X1 + X2 + X3, data=dfRegr))
```

```
(Intercept)          X1          X2          X3 
 23.0839518   0.1207848  -0.2422273  -0.4191290 
```

```r
coef(lm(Y2 ~ X1 + X2 + X3, data=dfRegr))
```

```
(Intercept)          X1          X2          X3 
16.32335532 -0.03185035 -0.31782397  0.19836272 
```

Coefficient tests and overall model test
-------------------------

### Type I sum of squares


```r
summary(manova(fit), test="Hotelling-Lawley")
```

```
          Df Hotelling-Lawley approx F num Df den Df    Pr(>F)    
X1         1            0.760    36.12      2     95 2.158e-12 ***
X2         1            5.910   280.74      2     95 < 2.2e-16 ***
X3         1           35.086  1666.58      2     95 < 2.2e-16 ***
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
X1  1   0.04655     2.32      2     95 0.1039    
X2  1   0.86848   313.66      2     95 <2e-16 ***
X3  1   0.97229  1666.58      2     95 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multRegression.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multRegression.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multRegression.R) - [all posts](https://github.com/dwoll/RExRepos/)
