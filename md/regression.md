---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Multiple linear regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression]
---







TODO
-------------------------

 - link to regressionDiag, regressionModMed, crossvalidation, resamplingBootALM

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`leaps`](http://cran.r-project.org/package=leaps), [`lmtest`](http://cran.r-project.org/package=lmtest), [`QuantPsyc`](http://cran.r-project.org/package=QuantPsyc), [`robustbase`](http://cran.r-project.org/package=robustbase), [`sandwich`](http://cran.r-project.org/package=sandwich)


```r
wants <- c("car", "leaps", "lmtest", "QuantPsyc", "robustbase", "sandwich")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Descriptive model fit
-------------------------

### Descriptive model fit


```r
set.seed(1.234)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 7)
dfRegr <- data.frame(X1, X2, X3, Y)
```



```r
(fit12 <- lm(Y ~ X1 + X2, data=dfRegr))
```

```

Call:
lm(formula = Y ~ X1 + X2, data = dfRegr)

Coefficients:
(Intercept)           X1           X2  
     -2.700        0.429       -0.272  
```

```r
lm(scale(Y) ~ scale(X1) + scale(X2), data=dfRegr)
```

```

Call:
lm(formula = scale(Y) ~ scale(X1) + scale(X2), data = dfRegr)

Coefficients:
(Intercept)    scale(X1)    scale(X2)  
   1.09e-16     2.02e-01    -1.57e-01  
```



```r
library(car)
scatter3d(Y ~ X1 + X2, fill=FALSE, data=dfRegr)
```

![plot of chunk rerRegression01](../content/assets/figure/rerRegression01.png) 


### Estimated coefficients, residuals, and fitted values


```r
coef(fit12)
```

```
(Intercept)          X1          X2 
    -2.6999      0.4285     -0.2725 
```

```r
E <- residuals(fit12)
head(E)
```

```
      1       2       3       4       5       6 
  1.546 -27.135  -5.077   2.429  32.845 -19.806 
```

```r
Yhat <- fitted(fit12)
head(Yhat)
```

```
    1     2     3     4     5     6 
63.59 64.58 63.60 68.56 66.54 57.81 
```


### Add and remove predictors


```r
(fit123 <- update(fit12,  . ~ . + X3))
```

```

Call:
lm(formula = Y ~ X1 + X2 + X3, data = dfRegr)

Coefficients:
(Intercept)           X1           X2           X3  
     20.458        0.443       -0.349       -0.379  
```

```r
(fit13 <- update(fit123, . ~ . - X1))
```

```

Call:
lm(formula = Y ~ X2 + X3, data = dfRegr)

Coefficients:
(Intercept)           X2           X3  
     98.350       -0.349       -0.378  
```

```r
(fit1 <- update(fit12,  . ~ . - X2))
```

```

Call:
lm(formula = Y ~ X1, data = dfRegr)

Coefficients:
(Intercept)           X1  
    -10.849        0.429  
```


Assessing model fit
-------------------------

### (Adjusted) $R^{2}$ and residual standard error


```r
sumRes <- summary(fit123)
sumRes$r.squared
```

```
[1] 0.7317
```

```r
sumRes$adj.r.squared
```

```
[1] 0.7233
```

```r
sumRes$sigma
```

```
[1] 7.002
```


### Information criteria AIC and BIC


```r
AIC(fit1)
```

```
[1] 802.3
```

```r
extractAIC(fit1)
```

```
[1]   2.0 516.5
```

```r
extractAIC(fit1, k=log(N))
```

```
[1]   2.0 521.8
```


### Crossvalidation

`cv.glm()` function from package `boot`, see crossvalidation

Coefficient tests and overall model test
-------------------------


```r
summary(fit12)
```

```

Call:
lm(formula = Y ~ X1 + X2, data = dfRegr)

Residuals:
   Min     1Q Median     3Q    Max 
-32.34  -8.01   1.08   9.39  32.85 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)  
(Intercept)   -2.700     36.901   -0.07    0.942  
X1             0.429      0.208    2.06    0.042 *
X2            -0.272      0.170   -1.60    0.113  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Residual standard error: 13 on 97 degrees of freedom
Multiple R-squared: 0.0656,	Adjusted R-squared: 0.0464 
F-statistic: 3.41 on 2 and 97 DF,  p-value: 0.0372 
```

```r
confint(fit12)
```

```
               2.5 %   97.5 %
(Intercept) -75.9386 70.53887
X1            0.0161  0.84097
X2           -0.6109  0.06594
```

```r
vcov(fit12)
```

```
            (Intercept)         X1         X2
(Intercept)   1361.7019 -7.591e+00 -8.695e-01
X1              -7.5909  4.318e-02  3.523e-05
X2              -0.8695  3.523e-05  2.907e-02
```


Variable selection and model comparisons
-------------------------

### Model comparisons

#### Effect of adding a single predictor


```r
add1(fit1, . ~ . + X2 + X3, test="F")
```

```
Single term additions

Model:
Y ~ X1
       Df Sum of Sq   RSS AIC F value Pr(>F)    
<none>              16824 517                   
X2      1       432 16393 516    2.55   0.11    
X3      1     11413  5412 405  204.56 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


#### Effect of adding several predictors


```r
anova(fit1, fit123)
```

```
Analysis of Variance Table

Model 1: Y ~ X1
Model 2: Y ~ X1 + X2 + X3
  Res.Df   RSS Df Sum of Sq   F Pr(>F)    
1     98 16824                            
2     96  4707  2     12118 124 <2e-16 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### All predictor subsets


```r
data(longley)
head(longley)
```

```
     GNP.deflator   GNP Unemployed Armed.Forces Population Year Employed
1947         83.0 234.3      235.6        159.0      107.6 1947    60.32
1948         88.5 259.4      232.5        145.6      108.6 1948    61.12
1949         88.2 258.1      368.2        161.6      109.8 1949    60.17
1950         89.5 284.6      335.1        165.0      110.9 1950    61.19
1951         96.2 329.0      209.9        309.9      112.1 1951    63.22
1952         98.1 347.0      193.2        359.4      113.3 1952    63.64
```

```r
library(leaps)
subs <- regsubsets(GNP.deflator ~ ., data=longley)
summary(subs, matrix.logical=TRUE)
```

```
Subset selection object
Call: FUN(c("./aggregate.Rmd", "./ancova.Rmd", "./anovaCRFpq.Rmd", 
"./anovaCRp.Rmd", "./anovaMixed.Rmd", "./anovaRBFpq.Rmd", "./anovaRBp.Rmd", 
"./anovaSPFpq.Rmd", "./anovaSPFpqr.Rmd", "./anovaSStypes.Rmd", 
"./association.Rmd", "./associationOrder.Rmd", "./combinatorics.Rmd", 
"./correlation.Rmd", "./crossvalidation.Rmd", "./dataFrames.Rmd", 
"./dfReshape.Rmd", "./dfSplitMerge.Rmd", "./dfTransform.Rmd", 
"./diagAddElements.Rmd", "./diagBounding.Rmd", "./diagCategorical.Rmd", 
"./diagDevice.Rmd", "./diagDistributions.Rmd", "./diagFormat.Rmd", 
"./diagMultiple.Rmd", "./diagMultivariate.Rmd", "./diagScatter.Rmd", 
"./diagSplines.Rmd", "./factors.Rmd", "./frequencies.Rmd", "./generateData.Rmd", 
"./interRaterICC.Rmd", "./linearAlgebra.Rmd", "./mean.Rmd", "./multFA.Rmd", 
"./multFApoly.Rmd", "./multHotelling.Rmd", "./multLDA.Rmd", "./multMANOVA.Rmd", 
"./multMDS.Rmd", "./multPCA.Rmd", "./multRegression.Rmd", "./normality.Rmd", 
"./npBinomial.Rmd", "./npBowker.Rmd", "./npCochran.Rmd", "./npKruskalFriedman.Rmd", 
"./npMcNemar.Rmd", "./npRuns.Rmd", "./npStuartMaxwell.Rmd", "./npWilcoxon.Rmd", 
"./recode.Rmd", "./regression.Rmd", "./regressionDiag.Rmd", "./regressionLogistic.Rmd", 
"./regressionModMed.Rmd", "./regressionMultinom.Rmd", "./regressionOrdinal.Rmd", 
"./regressionPoisson.Rmd", "./rerWorkflowJN.Rmd", "./rerWorkflowWP.Rmd", 
"./resamplingBoot.Rmd", "./resamplingBootALM.Rmd", "./resamplingPerm.Rmd", 
"./sets.Rmd", "./strings.Rmd", "./survivalCoxPH.Rmd", "./survivalKM.Rmd", 
"./survivalParametric.Rmd", "./timeDate.Rmd", "./transformData.Rmd", 
"./tTest.Rmd", "./variance.Rmd", "./varianceHom.Rmd")[[54L]], 
    ...)
6 Variables  (and intercept)
             Forced in Forced out
GNP              FALSE      FALSE
Unemployed       FALSE      FALSE
Armed.Forces     FALSE      FALSE
Population       FALSE      FALSE
Year             FALSE      FALSE
Employed         FALSE      FALSE
1 subsets of each size up to 6
Selection Algorithm: exhaustive
           GNP Unemployed Armed.Forces Population  Year Employed
1  ( 1 )  TRUE      FALSE        FALSE      FALSE FALSE    FALSE
2  ( 1 ) FALSE      FALSE         TRUE      FALSE  TRUE    FALSE
3  ( 1 )  TRUE       TRUE        FALSE       TRUE FALSE    FALSE
4  ( 1 )  TRUE       TRUE         TRUE       TRUE FALSE    FALSE
5  ( 1 )  TRUE       TRUE         TRUE       TRUE  TRUE    FALSE
6  ( 1 )  TRUE       TRUE         TRUE       TRUE  TRUE     TRUE
```

```r
plot(subs, scale="bic")
```

![plot of chunk rerRegression02](../content/assets/figure/rerRegression02.png) 



```r
Xmat <- data.matrix(subset(longley, select=c("GNP", "Unemployed", "Population", "Year")))
(leapFits <- leaps(Xmat, longley$GNP.deflator, method="Cp"))
```

```
$which
      1     2     3     4
1  TRUE FALSE FALSE FALSE
1 FALSE FALSE FALSE  TRUE
1 FALSE FALSE  TRUE FALSE
1 FALSE  TRUE FALSE FALSE
2 FALSE  TRUE FALSE  TRUE
2 FALSE FALSE  TRUE  TRUE
2  TRUE FALSE FALSE  TRUE
2  TRUE FALSE  TRUE FALSE
2  TRUE  TRUE FALSE FALSE
2 FALSE  TRUE  TRUE FALSE
3  TRUE  TRUE  TRUE FALSE
3  TRUE FALSE  TRUE  TRUE
3 FALSE  TRUE  TRUE  TRUE
3  TRUE  TRUE FALSE  TRUE
4  TRUE  TRUE  TRUE  TRUE

$label
[1] "(Intercept)" "1"           "2"           "3"           "4"          

$size
 [1] 2 2 2 2 3 3 3 3 3 3 4 4 4 4 5

$Cp
 [1]   9.935  11.077  42.001 793.076   8.961   9.178   9.430  10.983
 [9]  10.985  37.402   3.001   5.963   8.782  10.822   5.000
```



```r
plot(leapFits$size, leapFits$Cp, xlab="model size", pch=20, col="blue",
     ylab="Mallows' Cp", main="Mallows' Cp agains model size")
abline(a=0, b=1)
```

![plot of chunk rerRegression03](../content/assets/figure/rerRegression03.png) 


Apply regression model to new data
-------------------------


```r
X1new <- c(177, 150, 192, 189, 181)
dfNew <- data.frame(X1=X1new)
predict(fit1, dfNew, interval="prediction", level=0.95)
```

```
    fit   lwr   upr
1 65.06 38.92 91.20
2 53.48 25.24 81.72
3 71.49 44.50 98.48
4 70.21 43.50 96.91
5 66.78 40.55 93.00
```

```r
predOrg <- predict(fit1, interval="confidence", level=0.95)
```



```r
hOrd <- order(X1)
par(lend=2)
plot(X1, Y, pch=20, xlab="Predictor", ylab="Dependent variable and prediction",
     xaxs="i", main="Data and regression prediction")

polygon(c(X1[hOrd],             X1[rev(hOrd)]),
        c(predOrg[hOrd, "lwr"], predOrg[rev(hOrd), "upr"]),
        border=NA, col=rgb(0.7, 0.7, 0.7, 0.6))

abline(fit1, col="black")
legend(x="bottomright", legend=c("Data", "prediction", "confidence region"),
       pch=c(20, NA, NA), lty=c(NA, 1, 1), lwd=c(NA, 1, 8),
       col=c("black", "blue", "gray"))
```

![plot of chunk rerRegression04](../content/assets/figure/rerRegression04.png) 


Robust and penalized regression
-------------------------

### Robust regression

Heteroscedasticity-consistent standard errors (modified White estimator):
`hccm()` from package `car` or `vcovHC()` from package `sandwich`.
These standard errors can then be used in combination with function `coeftest()` from package `lmtest()`.


```r
library(car)
library(lmtest)
fitLL <- lm(GNP.deflator ~ ., data=longley)
summary(fitLL)
```

```

Call:
lm(formula = GNP.deflator ~ ., data = longley)

Residuals:
   Min     1Q Median     3Q    Max 
-2.009 -0.515  0.113  0.423  1.550 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)  
(Intercept)  2946.8564  5647.9766    0.52    0.614  
GNP             0.2635     0.1082    2.44    0.038 *
Unemployed      0.0365     0.0302    1.21    0.258  
Armed.Forces    0.0112     0.0155    0.72    0.488  
Population     -1.7370     0.6738   -2.58    0.030 *
Year           -1.4188     2.9446   -0.48    0.641  
Employed        0.2313     1.3039    0.18    0.863  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Residual standard error: 1.19 on 9 degrees of freedom
Multiple R-squared: 0.993,	Adjusted R-squared: 0.988 
F-statistic:  203 on 6 and 9 DF,  p-value: 4.43e-09 
```

```r
coeftest(fitLL, vcov=hccm)
```

```

t test of coefficients:

              Estimate Std. Error t value Pr(>|t|)  
(Intercept)  2946.8564  6750.2987    0.44    0.673  
GNP             0.2635     0.1200    2.20    0.056 .
Unemployed      0.0365     0.0375    0.97    0.355  
Armed.Forces    0.0112     0.0195    0.57    0.582  
Population     -1.7370     0.7859   -2.21    0.054 .
Year           -1.4188     3.5206   -0.40    0.696  
Employed        0.2313     1.5920    0.15    0.888  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```



```r
library(sandwich)
coeftest(fitLL, vcov=vcovHC)
```


 - $M$-estimators: `rlm()` from package `MASS`
 - resistant regression: `lqs()` from package `MASS`

More information can be found in CRAN task view [Robust Statistical Methods](http://cran.r-project.org/web/views/Robust.html).
 
### Penalized regression

#### Ridge regression


```r
library(car)
vif(fitLL)
```

```
         GNP   Unemployed Armed.Forces   Population         Year 
     1214.57        83.96        12.16       230.91      2065.73 
    Employed 
      220.42 
```



```r
library(MASS)
lambdas <- 10^(seq(-8, -1, length.out=200))
lmrFit  <- lm.ridge(GNP.deflator ~ ., lambda=lambdas, data=longley)
select(lmrFit)
```

```
modified HKB estimator is 0.006837 
modified L-W estimator is 0.05267 
smallest value of GCV  at 0.005873 
```



```r
lmrCoef <- coef(lmrFit)
plot(lmrFit, xlab="lambda", ylab="coefficients")
```

![plot of chunk rerRegression05](../content/assets/figure/rerRegression051.png) 

```r
plot(lmrFit$lambda, lmrFit$GCV, type="l", xlab="lambda", ylab="GCV")
```

![plot of chunk rerRegression05](../content/assets/figure/rerRegression052.png) 


See packages [`lars`](http://cran.r-project.org/package=lars) and [`glmnet`](http://cran.r-project.org/package=glmnet) for the LASSO and elastic net methods which combine regularization and selection.

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:QuantPsyc))
try(detach(package:leaps))
try(detach(package:lmtest))
try(detach(package:sandwich))
try(detach(package:zoo))
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regression.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regression.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regression.R) - [all posts](https://github.com/dwoll/RExRepos/)
