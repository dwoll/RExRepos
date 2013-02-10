---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Binary logistic regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression, GLM]
---

Binary logistic regression
=========================

TODO
-------------------------

 - link to associationOrder for `pROC`, regressionOrdinal, regressionMultinom, regressionDiag for outliers, collinearity, crossvalidation

Install required packages
-------------------------

[`rms`](http://cran.r-project.org/package=rms)


```r
wants <- c("rms")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Descriptive model fit
-------------------------

### Simulate data
    

```r
set.seed(123)
N     <- 100
X1    <- rnorm(N, 175, 7)
X2    <- rnorm(N,  30, 8)
Y     <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Yfac  <- cut(Y, breaks=c(-Inf, median(Y), Inf), labels=c("lo", "hi"))
dfLog <- data.frame(X1, X2, Yfac)
```



```r
cdplot(Yfac ~ X1, data=dfLog)
```

![plot of chunk rerRegressionLogistic01](content/assets/figure/rerRegressionLogistic011.png) 

```r
cdplot(Yfac ~ X2, data=dfLog)
```

![plot of chunk rerRegressionLogistic01](content/assets/figure/rerRegressionLogistic012.png) 


### Fit the model


```r
(glmFit <- glm(Yfac ~ X1 + X2,
               family=binomial(link="logit"), data=dfLog))
```

```

Call:  glm(formula = Yfac ~ X1 + X2, family = binomial(link = "logit"), 
    data = dfLog)

Coefficients:
(Intercept)           X1           X2  
    -17.979        0.121       -0.110  

Degrees of Freedom: 99 Total (i.e. Null);  97 Residual
Null Deviance:	    139 
Residual Deviance: 116 	AIC: 122 
```


Odds ratios


```r
exp(coef(glmFit))
```

```
(Intercept)          X1          X2 
  1.555e-08   1.128e+00   8.958e-01 
```


Profile likelihood based confidence intervals for odds ratios


```r
exp(confint(glmFit))
```

```
                2.5 %   97.5 %
(Intercept) 1.076e-14 0.004975
X1          1.049e+00 1.225711
X2          8.316e-01 0.955545
```


### Fit the model based on a matrix of counts


```r
N      <- 100
x1     <- rnorm(N, 100, 15)
x2     <- rnorm(N, 10, 3)
total  <- sample(40:60, N, replace=TRUE)
hits   <- rbinom(N, total, prob=0.4)
hitMat <- cbind(hits, total-hits)
glm(hitMat ~ X1 + X2, family=binomial(link="logit"))
```

```

Call:  glm(formula = hitMat ~ X1 + X2, family = binomial(link = "logit"))

Coefficients:
(Intercept)           X1           X2  
   -1.08326      0.00363      0.00121  

Degrees of Freedom: 99 Total (i.e. Null);  97 Residual
Null Deviance:	    86.3 
Residual Deviance: 85.6 	AIC: 521 
```


### Fit the model based on relative frequencies


```r
relHits <- hits/total
glm(relHits ~ X1 + X2, weights=total, family=binomial(link="logit"))
```

```

Call:  glm(formula = relHits ~ X1 + X2, family = binomial(link = "logit"), 
    weights = total)

Coefficients:
(Intercept)           X1           X2  
   -1.08326      0.00363      0.00121  

Degrees of Freedom: 99 Total (i.e. Null);  97 Residual
Null Deviance:	    86.3 
Residual Deviance: 85.6 	AIC: 521 
```


### Fitted logits and probabilities


```r
logitHat <- predict(glmFit, type="link")
plot(logitHat, pch=16, col=c("red", "blue")[unclass(dfLog$Yfac)])
abline(h=0)
```

![plot of chunk rerRegressionLogistic02](content/assets/figure/rerRegressionLogistic02.png) 



```r
Phat <- fitted(glmFit)
Phat <- predict(glmFit, type="response")
head(Phat)
```

```
     1      2      3      4      5      6 
0.4920 0.3533 0.7938 0.5451 0.6818 0.7862 
```

```r
mean(Phat)
```

```
[1] 0.5
```

```r
prop.table(table(dfLog$Yfac))
```

```

 lo  hi 
0.5 0.5 
```


Assess model fit
-------------------------

### Classification table


```r
thresh <- 0.5
Yhat   <- cut(Phat, breaks=c(-Inf, thresh, Inf), labels=c("lo", "hi"))
cTab   <- table(Yfac, Yhat)
addmargins(cTab)
```

```
     Yhat
Yfac   lo  hi Sum
  lo   31  19  50
  hi   20  30  50
  Sum  51  49 100
```


Correct classification rate


```r
sum(diag(cTab)) / sum(cTab)
```

```
[1] 0.61
```


### log-Likelihood, AUC, Somers' $D_{xy}$, Nagelkerke's pseudo $R^{2}$

Deviance, log-likelihood and AIC


```r
deviance(glmFit)
```

```
[1] 115.9
```

```r
logLik(glmFit)
```

```
'log Lik.' -57.96 (df=3)
```

```r
AIC(glmFit)
```

```
[1] 121.9
```


Nagelkerke's pseudo-$R^{2}$ (R2), area under the ROC-Kurve (C), Somers' $D_{xy}$ (Dxy), Goodman & Kruskal's $\gamma$ (gamma), Kendall's $\tau$ (tau-a)


```r
library(rms)
lrm(Yfac ~ X1 + X2, data=dfLog)
```

```

Logistic Regression Model

lrm(formula = Yfac ~ X1 + X2, data = dfLog)

                      Model Likelihood     Discrimination    Rank Discrim.    
                         Ratio Test            Indexes          Indexes       
Obs           100    LR chi2      22.71    R2       0.271    C       0.745    
 lo            50    d.f.             2    g        1.313    Dxy     0.490    
 hi            50    Pr(> chi2) <0.0001    gr       3.716    gamma   0.491    
max |deriv| 9e-06                          gp       0.263    tau-a   0.247    
                                           Brier    0.201                     

          Coef     S.E.   Wald Z Pr(>|Z|)
Intercept -17.9793 6.7859 -2.65  0.0081  
X1          0.1205 0.0394  3.06  0.0022  
X2         -0.1100 0.0352 -3.13  0.0018  
```


For plotting the ROC-curve, see `pROC` in associationOrder

### McFadden, Cox & Snell and Nagelkerke pseudo $R^{2}$

Log-likelihoods for full model and 0-model without predictors X1, X2


```r
glm0 <- update(glmFit, . ~ 1)
LLf  <- logLik(glmFit)
LL0  <- logLik(glm0)
```


McFadden pseudo-$R^2$


```r
as.vector(1 - (LLf / LL0))
```

```
[1] 0.1638
```


Cox & Snell


```r
as.vector(1 - exp((2/N) * (LL0 - LLf)))
```

```
[1] 0.2032
```


Nagelkerke


```r
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))
```

```
[1] 0.2709
```


### Crossvalidation

`cv.glm()` function from package `boot`, see crossvalidation

### Apply model to new data


```r
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7), X2=rnorm(Nnew, 100, 15))
predict(glmFit, newdata=dfNew, type="response")
```

```
        1         2         3 
1.123e-02 9.971e-05 5.175e-04 
```


Coefficient tests and overall model test
-------------------------

### Individual coefficient tests

Wald-tests for parameters


```r
summary(glmFit)
```

```

Call:
glm(formula = Yfac ~ X1 + X2, family = binomial(link = "logit"), 
    data = dfLog)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.1514  -0.9741   0.0572   0.9872   1.6639  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)   
(Intercept) -17.9793     6.7859   -2.65   0.0081 **
X1            0.1205     0.0394    3.06   0.0022 **
X2           -0.1100     0.0352   -3.13   0.0018 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 138.63  on 99  degrees of freedom
Residual deviance: 115.92  on 97  degrees of freedom
AIC: 121.9

Number of Fisher Scoring iterations: 4
```


Or see `lrm()` above

### Model comparisons - likelihood-ratio tests


```r
anova(glm0, glmFit, test="Chisq")
```

```
Analysis of Deviance Table

Model 1: Yfac ~ 1
Model 2: Yfac ~ X1 + X2
  Resid. Df Resid. Dev Df Deviance Pr(>Chi)    
1        99        139                         
2        97        116  2     22.7  1.2e-05 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```



```r
drop1(glmFit, test="Chi")
```

```
Single term deletions

Model:
Yfac ~ X1 + X2
       Df Deviance AIC  LRT Pr(>Chi)    
<none>         116 122                  
X1      1      127 131 11.1  0.00086 ***
X2      1      128 132 12.1  0.00050 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Or see `lrm()` above

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:survival))
try(detach(package:splines))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionLogistic.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionLogistic.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionLogistic.R) - [all posts](https://github.com/dwoll/RExRepos/)
