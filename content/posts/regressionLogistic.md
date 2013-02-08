---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Binary logistic regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression, GLM]
---




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
set.seed(1.234)
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

![plot of chunk rerRegressionLogistic01](../content/assets/figure/rerRegressionLogistic011.png) 

```r
cdplot(Yfac ~ X2, data=dfLog)
```

![plot of chunk rerRegressionLogistic01](../content/assets/figure/rerRegressionLogistic012.png) 


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
    -19.485        0.137       -0.154  

Degrees of Freedom: 99 Total (i.e. Null);  97 Residual
Null Deviance:	    139 
Residual Deviance: 106 	AIC: 112 
```


Odds ratios


```r
exp(coef(glmFit))
```

```
(Intercept)          X1          X2 
  3.451e-09   1.147e+00   8.575e-01 
```


Profile likelihood based confidence intervals for odds ratios


```r
exp(confint(glmFit))
```

```
                2.5 %  97.5 %
(Intercept) 7.249e-16 0.00239
X1          1.060e+00 1.25564
X2          7.870e-01 0.92066
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
    0.35804     -0.00428     -0.00152  

Degrees of Freedom: 99 Total (i.e. Null);  97 Residual
Null Deviance:	    91 
Residual Deviance: 90 	AIC: 526 
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
    0.35804     -0.00428     -0.00152  

Degrees of Freedom: 99 Total (i.e. Null);  97 Residual
Null Deviance:	    91 
Residual Deviance: 90 	AIC: 526 
```


### Fitted logits and probabilities


```r
logitHat <- predict(glmFit, type="link")
plot(logitHat, pch=16, col=c("red", "blue")[unclass(dfLog$Yfac)])
abline(h=0)
```

![plot of chunk rerRegressionLogistic02](../content/assets/figure/rerRegressionLogistic02.png) 



```r
Phat <- fitted(glmFit)
Phat <- predict(glmFit, type="response")
head(Phat)
```

```
      1       2       3       4       5       6 
0.49807 0.48815 0.53732 0.76152 0.72098 0.04186 
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
  lo   34  16  50
  hi   13  37  50
  Sum  47  53 100
```


Correct classification rate


```r
sum(diag(cTab)) / sum(cTab)
```

```
[1] 0.71
```


### log-Likelihood, AUC, Somers' $D_{xy}$, Nagelkerke's pseudo $R^{2}$

Deviance, log-likelihood and AIC


```r
deviance(glmFit)
```

```
[1] 106.5
```

```r
logLik(glmFit)
```

```
'log Lik.' -53.25 (df=3)
```

```r
AIC(glmFit)
```

```
[1] 112.5
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
Obs           100    LR chi2      32.14    R2       0.366    C       0.808    
 lo            50    d.f.             2    g        1.658    Dxy     0.616    
 hi            50    Pr(> chi2) <0.0001    gr       5.251    gamma   0.617    
max |deriv| 7e-10                          gp       0.309    tau-a   0.311    
                                           Brier    0.179                     

          Coef     S.E.   Wald Z Pr(>|Z|)
Intercept -19.4847 7.2768 -2.68  0.0074  
X1          0.1367 0.0427  3.21  0.0013  
X2         -0.1538 0.0396 -3.88  0.0001  
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
[1] 0.2318
```


Cox & Snell


```r
as.vector(1 - exp((2/N) * (LL0 - LLf)))
```

```
[1] 0.2749
```


Nagelkerke


```r
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))
```

```
[1] 0.3665
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
3.679e-06 1.028e-04 4.062e-04 
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
-1.7693  -0.9053   0.0086   0.9246   2.5193  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept) -19.4847     7.2767   -2.68   0.0074 ** 
X1            0.1367     0.0427    3.21   0.0013 ** 
X2           -0.1538     0.0396   -3.88   0.0001 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 138.63  on 99  degrees of freedom
Residual deviance: 106.49  on 97  degrees of freedom
AIC: 112.5

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
2        97        106  2     32.1  1.1e-07 ***
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
<none>         106 112                  
X1      1      119 123 12.8  0.00035 ***
X2      1      128 132 21.5  3.5e-06 ***
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
