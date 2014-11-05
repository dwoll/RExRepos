---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Multinomial regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression, GLM]
---




TODO
-------------------------

 - link to regressionLogistic, regressionOrdinal

Install required packages
-------------------------

[`mlogit`](http://cran.r-project.org/package=mlogit), [`nnet`](http://cran.r-project.org/package=nnet), [`VGAM`](http://cran.r-project.org/package=VGAM)


```r
wants <- c("mlogit", "nnet", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Multinomial regression
----------------------

### Simulate data
    

```r
set.seed(123)
N      <- 100
X1     <- rnorm(N, 175, 7)
X2     <- rnorm(N,  30, 8)
Ycont  <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Ycateg <- cut(Ycont, breaks=quantile(Ycont), include.lowest=TRUE,
              labels=c("--", "-", "+", "++"), ordered=FALSE)
dfMN   <- data.frame(X1, X2, Ycateg)
```

### Using `vglm()` from package `VGAM`

Estimator based on likelihood-inference


```r
library(VGAM)
vglmFitMN <- vglm(Ycateg ~ X1 + X2, family=multinomial(refLevel=1), data=dfMN)
```

Odds ratios


```r
exp(VGAM::coef(vglmFitMN))
```

```
(Intercept):1 (Intercept):2 (Intercept):3          X1:1          X1:2 
 1.183772e-10  4.131415e-14  4.061779e-16  1.164906e+00  1.234359e+00 
         X1:3          X2:1          X2:2          X2:3 
 1.261100e+00  8.907694e-01  8.206984e-01  8.462248e-01 
```

### Using `multinom()` from package `nnet`

Estimator based on neural networks -> slightly different results than `vglm()`, `mlogit()`


```r
library(nnet)
(mnFit <- multinom(Ycateg ~ X1 + X2, data=dfMN))
# not shown
```

### Using `mlogit()` from package `mlogit`

Uses person-choice (long) format, so data frame has to be reshaped with `mlogit.data()`


```r
library(mlogit)
dfMNL <- mlogit.data(dfMN, choice="Ycateg", shape="wide", varying=NULL)
(mlogitFit <- mlogit(Ycateg ~ 0 | X1 + X2, reflevel="--", data=dfMNL))
# not shown
```

Predicted category membership
-------------------------

### Predicted category probabilities


```r
PhatCateg <- VGAM::predict(vglmFitMN, type="response")
head(PhatCateg)
```

```
          --         -         +        ++
1 0.19037931 0.2966176 0.2834440 0.2295591
2 0.33362746 0.3022576 0.1751682 0.1889468
3 0.02114807 0.2064772 0.3437437 0.4286311
4 0.13548641 0.2961053 0.2880800 0.2803283
5 0.06174357 0.2512944 0.3720063 0.3149558
6 0.02202100 0.2108382 0.3276685 0.4394723
```


```r
predict(mnFit, type="probs")
fitted(mlogitFit, outcome=FALSE)
# not shown
```

### Predicted categories


```r
categHat <- levels(dfMN$Ycateg)[max.col(PhatCateg)]
head(categHat)
```

```
[1] "-"  "--" "++" "-"  "+"  "++"
```


```r
predCls <- predict(mnFit, type="class")
head(predCls)
# not shown
```

Assess model fit
-------------------------

### Classification table


```r
facHat <- factor(categHat, levels=levels(dfMN$Ycateg))
cTab   <- xtabs(~ Ycateg + facHat, data=dfMN)
addmargins(cTab)
```

```
      facHat
Ycateg  --   -   +  ++ Sum
   --   17   2   6   0  25
   -     6   8   7   4  25
   +     3   8   8   6  25
   ++    4   6   5  10  25
   Sum  30  24  26  20 100
```

Correct classification rate


```r
(CCR <- sum(diag(cTab)) / sum(cTab))
```

```
[1] 0.43
```

### Deviance, log-likelihood and AIC


```r
VGAM::deviance(vglmFitMN)
```

```
[1] 240.6621
```

```r
VGAM::logLik(vglmFitMN)
```

```
[1] -120.3311
```

```r
VGAM::AIC(vglmFitMN)
```

```
[1] 258.6621
```

### McFadden, Cox & Snell and Nagelkerke pseudo $R^{2}$

Log-likelihoods for full model and 0-model without predictors X1, X2


```r
vglm0 <- vglm(Ycateg ~ 1, family=multinomial(refLevel=1), data=dfMN)
LLf   <- VGAM::logLik(vglmFitMN)
LL0   <- VGAM::logLik(vglm0)
```

McFadden pseudo-$R^2$


```r
as.vector(1 - (LLf / LL0))
```

```
[1] 0.1319948
```

Cox & Snell


```r
as.vector(1 - exp((2/N) * (LL0 - LLf)))
```

```
[1] 0.3064745
```

Nagelkerke


```r
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))
```

```
[1] 0.3269061
```

Apply regression model to new data
-------------------------

### Simulate new data

`predict.mlogit()` requires a new data frame in long format. Therefore also add new (irrelevant) categorical responses to enable reshaping the data frame with `mlogit.data()`.


```r
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7),
                    X2=rnorm(Nnew,  30, 8),
                    Ycateg=factor(sample(c("--", "-", "+", "++"), Nnew, TRUE),
                                  levels=c("--", "-", "+", "++")))
```

### Predicted class probabilities


```r
VGAM::predict(vglmFitMN, dfNew, type="response")
```

```
         --         -         +        ++
1 0.5350090 0.2503223 0.1006906 0.1139781
2 0.3514914 0.3116345 0.1289991 0.2078750
3 0.2268449 0.3102686 0.2268189 0.2360677
```


```r
predict(mnFit, dfNew, type="probs")

dfNewL <- mlogit.data(dfNew, choice="Ycateg", shape="wide", varying=NULL)
predict(mlogitFit, dfNewL)
# not shown
```

Coefficient tests and overall model test
-------------------------

### Individual coefficient tests

Estimated standard deviations and z-values for parameters


```r
sumMN   <- VGAM::summary(vglmFitMN)
(coefMN <- VGAM::coef(sumMN))
```

```
                 Estimate  Std. Error   z value
(Intercept):1 -22.8571447 10.27166961 -2.225261
(Intercept):2 -30.8175714 10.93523124 -2.818191
(Intercept):3 -35.4397403 11.06665231 -3.202390
X1:1            0.1526408  0.06112749  2.497090
X1:2            0.2105521  0.06512916  3.232839
X1:3            0.2319840  0.06565479  3.533391
X2:1           -0.1156697  0.04695990 -2.463160
X2:2           -0.1975995  0.05414592 -3.649389
X2:3           -0.1669702  0.05258129 -3.175468
```

Approximative Wald-based confidence intervals


```r
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefMN, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))
```

```
                      [,1]         [,2]
(Intercept):1  -2.72504220 -42.98924720
(Intercept):2  -9.38491201 -52.25023079
(Intercept):3 -13.74950036 -57.12998028
X1:1            0.27244848   0.03283314
X1:2            0.33820287   0.08290125
X1:3            0.36066505   0.10330300
X2:1           -0.02363003  -0.20770946
X2:2           -0.09147549  -0.30372360
X2:3           -0.06391275  -0.27002761
```

p-values for two-sided paramter tests based on assumption that z-values are asymptotically $N(0, 1)$ distributed


```r
2*(1 - pnorm(abs(coefMN[ , "z value"])))
```

```
(Intercept):1 (Intercept):2 (Intercept):3          X1:1          X1:2 
 0.0260637291  0.0048295056  0.0013629219  0.0125217285  0.0012256681 
         X1:3          X2:1          X2:2          X2:3 
 0.0004102658  0.0137718475  0.0002628643  0.0014959522 
```


```r
summary(mnFit)
summary(mlogitFit)
# not shown
```

### Model comparisons - likelihood-ratio tests

Likelihood-ratio-test for predictor `X2`

We need to specify `VGAM::lrtest()` here because after attaching package `mlogit` above, there is another function present with the same name.


```r
vglmFitR <- vglm(Ycateg ~ X1, family=multinomial(refLevel=1), data=dfMN)
VGAM::lrtest(vglmFitMN, vglmFitR)
```

```
Likelihood ratio test

Model 1: Ycateg ~ X1 + X2
Model 2: Ycateg ~ X1
  #Df  LogLik Df  Chisq Pr(>Chisq)    
1 291 -120.33                         
2 294 -130.50  3 20.332  0.0001448 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Likelihood-ratio-test for the full model against the 0-model without predictors (just intercept)


```r
VGAM::lrtest(vglmFitMN, vglm0)
```

```
Likelihood ratio test

Model 1: Ycateg ~ X1 + X2
Model 2: Ycateg ~ 1
  #Df  LogLik Df  Chisq Pr(>Chisq)    
1 291 -120.33                         
2 297 -138.63  6 36.597   2.11e-06 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:mlogit))
try(detach(package:Formula))
try(detach(package:maxLik))
try(detach(package:miscTools))
try(detach(package:nnet))
try(detach(package:VGAM))
try(detach(package:splines))
try(detach(package:stats4))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionMultinom.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionMultinom.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionMultinom.R) - [all posts](https://github.com/dwoll/RExRepos/)
