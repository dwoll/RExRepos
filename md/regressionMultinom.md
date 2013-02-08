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
set.seed(1.234)
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
    1.491e-08     1.246e-13     4.273e-13     1.109e+00     1.209e+00 
         X1:3          X2:1          X2:2          X2:3 
    1.218e+00     1.003e+00     8.914e-01     8.113e-01 
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
       --      -       +       ++
1 0.29508 0.2071 0.23880 0.259029
2 0.22444 0.2873 0.28971 0.198575
3 0.28820 0.1727 0.23076 0.308355
4 0.05806 0.2064 0.43949 0.296019
5 0.11309 0.1581 0.33633 0.392485
6 0.57840 0.3742 0.04024 0.007153
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
[1] "--" "+"  "++" "+"  "++" "--"
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
   --   11   7   2   5  25
   -     9   8   7   1  25
   +     4   5   8   8  25
   ++    3   1   6  15  25
   Sum  27  21  23  29 100
```


Correct classification rate


```r
(CCR <- sum(diag(cTab)) / sum(cTab))
```

```
[1] 0.42
```


### Deviance, log-likelihood and AIC


```r
deviance(vglmFitMN)
```

```
[1] 237.1
```

```r
logLik(vglmFitMN)
```

```
[1] -118.5
```

```r
AIC(vglmFitMN)
```

```
[1] 255.1
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
[1] 0.1449
```


Cox & Snell


```r
as.vector(1 - exp((2/N) * (LL0 - LLf)))
```

```
[1] 0.3308
```


Nagelkerke


```r
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))
```

```
[1] 0.3529
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
       --      -      +      ++
1 0.18607 0.2963 0.3173 0.20035
2 0.07901 0.1204 0.3371 0.46351
3 0.42022 0.3708 0.1479 0.06108
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
                Estimate Std. Error  z value
(Intercept):1 -18.021040    9.17703 -1.96371
(Intercept):2 -29.714058    9.91960 -2.99549
(Intercept):3 -28.481182   10.22013 -2.78677
X1:1            0.103098    0.05367  1.92084
X1:2            0.189790    0.05808  3.26756
X1:3            0.196861    0.06025  3.26762
X2:1            0.003073    0.03917  0.07846
X2:2           -0.114971    0.04778 -2.40627
X2:3           -0.209150    0.05678 -3.68354
```


Approximative Wald-based confidence intervals


```r
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefMN, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))
```

```
                   [,1]      [,2]
(Intercept):1  -0.03439 -36.00769
(Intercept):2 -10.27200 -49.15611
(Intercept):3  -8.45010 -48.51227
X1:1            0.20829  -0.00210
X1:2            0.30363   0.07595
X1:3            0.31494   0.07878
X2:1            0.07984  -0.07369
X2:2           -0.02132  -0.20862
X2:3           -0.09786  -0.32044
```


p-values for two-sided paramter tests based on assumption that z-values are asymptotically $N(0, 1)$ distributed


```r
2*(1 - pnorm(abs(coefMN[ , "z value"])))
```

```
(Intercept):1 (Intercept):2 (Intercept):3          X1:1          X1:2 
     0.049564      0.002740      0.005324      0.054751      0.001085 
         X1:3          X2:1          X2:2          X2:3 
     0.001085      0.937461      0.016116      0.000230 
```



```r
summary(mnFit)
summary(mlogitFit)
# not shown
```


### Model comparisons - likelihood-ratio tests

Likelihood-ratio-test for predictor `X2`


```r
vglmFitR <- vglm(Ycateg ~ X1, family=multinomial(refLevel=1), data=dfMN)
VGAM::lrtest(vglmFitMN, vglmFitR)
```

```
Likelihood ratio test

Model 1: Ycateg ~ X1 + X2
Model 2: Ycateg ~ X1
  #Df LogLik Df Chisq Pr(>Chisq)    
1 291   -118                        
2 294   -131  3  25.6    1.1e-05 ***
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
1 291   -118                        
2 297   -139  6  40.2    4.2e-07 ***
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
