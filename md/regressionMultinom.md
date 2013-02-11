---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Multinomial regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression, GLM]
---

Multinomial regression
=========================

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
exp(coef(vglmFitMN))
```

```
(Intercept):1 (Intercept):2 (Intercept):3          X1:1          X1:2 
    1.184e-10     4.131e-14     4.062e-16     1.165e+00     1.234e+00 
         X1:3          X2:1          X2:2          X2:3 
    1.261e+00     8.908e-01     8.207e-01     8.462e-01 
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
PhatCateg <- predict(vglmFitMN, type="response")
head(PhatCateg)
```

```
       --      -      +     ++
1 0.19038 0.2966 0.2834 0.2296
2 0.33363 0.3023 0.1752 0.1889
3 0.02115 0.2065 0.3437 0.4286
4 0.13549 0.2961 0.2881 0.2803
5 0.06174 0.2513 0.3720 0.3150
6 0.02202 0.2108 0.3277 0.4395
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
cTab   <- table(dfMN$Ycateg, facHat, dnn=c("Ycateg", "facHat"))
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
deviance(vglmFitMN)
```

```
[1] 240.7
```

```r
logLik(vglmFitMN)
```

```
[1] -120.3
```

```r
AIC(vglmFitMN)
```

```
[1] 258.7
```


### McFadden, Cox & Snell and Nagelkerke pseudo $R^{2}$

Log-likelihoods for full model and 0-model without predictors X1, X2


```r
vglm0 <- vglm(Ycateg ~ 1, family=multinomial(refLevel=1), data=dfMN)
LLf   <- logLik(vglmFitMN)
LL0   <- logLik(vglm0)
```


McFadden pseudo-$R^2$


```r
as.vector(1 - (LLf / LL0))
```

```
[1] 0.132
```


Cox & Snell


```r
as.vector(1 - exp((2/N) * (LL0 - LLf)))
```

```
[1] 0.3065
```


Nagelkerke


```r
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))
```

```
[1] 0.3269
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
predict(vglmFitMN, dfNew, type="response")
```

```
      --      -      +     ++
1 0.5350 0.2503 0.1007 0.1140
2 0.3515 0.3116 0.1290 0.2079
3 0.2268 0.3103 0.2268 0.2361
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
sumMN   <- summary(vglmFitMN)
(coefMN <- coef(sumMN))
```

```
              Estimate Std. Error z value
(Intercept):1 -22.8571   10.27167  -2.225
(Intercept):2 -30.8176   10.93523  -2.818
(Intercept):3 -35.4397   11.06665  -3.202
X1:1            0.1526    0.06113   2.497
X1:2            0.2106    0.06513   3.233
X1:3            0.2320    0.06565   3.533
X2:1           -0.1157    0.04696  -2.463
X2:2           -0.1976    0.05415  -3.649
X2:3           -0.1670    0.05258  -3.175
```


Approximative Wald-based confidence intervals


```r
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefMN, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))
```

```
                   [,1]      [,2]
(Intercept):1  -2.72504 -42.98925
(Intercept):2  -9.38491 -52.25023
(Intercept):3 -13.74950 -57.12998
X1:1            0.27245   0.03283
X1:2            0.33820   0.08290
X1:3            0.36067   0.10330
X2:1           -0.02363  -0.20771
X2:2           -0.09148  -0.30372
X2:3           -0.06391  -0.27003
```


p-values for two-sided paramter tests based on assumption that z-values are asymptotically $N(0, 1)$ distributed


```r
2*(1 - pnorm(abs(coefMN[ , "z value"])))
```

```
(Intercept):1 (Intercept):2 (Intercept):3          X1:1          X1:2 
    0.0260637     0.0048295     0.0013629     0.0125217     0.0012257 
         X1:3          X2:1          X2:2          X2:3 
    0.0004103     0.0137718     0.0002629     0.0014960 
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
  #Df LogLik Df Chisq Pr(>Chisq)    
1 291   -120                        
2 294   -130  3  20.3    0.00014 ***
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
  #Df LogLik Df Chisq Pr(>Chisq)    
1 291   -120                        
2 297   -139  6  36.6    2.1e-06 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:mlogit))
try(detach(package:MASS))
try(detach(package:Formula))
try(detach(package:statmod))
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
