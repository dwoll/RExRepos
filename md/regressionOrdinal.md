---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Ordinal regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression, GLM]
---

Ordinal regression
=========================




TODO
-------------------------

 - link to regressionLogistic, regressionMultinom

Install required packages
-------------------------

[`MASS`](http://cran.r-project.org/package=MASS), [`ordinal`](http://cran.r-project.org/package=ordinal), [`rms`](http://cran.r-project.org/package=rms), [`VGAM`](http://cran.r-project.org/package=VGAM)


```r
wants <- c("MASS", "ordinal", "rms", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Ordinal regression (proportional odds model)
-------------------------
    
### Simulate data

Dependent variable $ Y_{\text{ord}} $ with $ k=4 $ groups, $p=2 $ predictor variables


```r
set.seed(2.234)
N     <- 100
X1    <- rnorm(N, 175, 7)
X2    <- rnorm(N,  30, 8)
Ycont <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Yord  <- cut(Ycont, breaks=quantile(Ycont), include.lowest=TRUE,
             labels=c("--", "-", "+", "++"), ordered=TRUE)
dfOrd <- data.frame(X1, X2, Yord)
```


### Using `vglm()` from package `VGAM`

Model using cumulative logits: $ \text{logit}(p(Y \geq g)) = \ln \frac{P(Y \geq g)}{1 - P(Y \geq g)} = \beta_{0_{g}} + \beta_{1} X_{1} + \dots + \beta_{p} X_{p} \quad(g = 2, \ldots, k) $ 


```r
library(VGAM)
(vglmFit <- vglm(Yord ~ X1 + X2, family=propodds, data=dfOrd))
```

```
Call:
vglm(formula = Yord ~ X1 + X2, family = propodds, data = dfOrd)

Coefficients:
(Intercept):1 (Intercept):2 (Intercept):3            X1            X2 
    -18.51151     -19.95682     -21.42690       0.12771      -0.07902 

Degrees of Freedom: 300 Total; 295 Residual
Residual deviance: 239.6 
Log-likelihood: -119.8 
```


Equivalent:


```r
vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE, reverse=TRUE), data=dfOrd)
# not shown
```


Adjacent category logits $ \ln \frac{P(Y=g)}{P(Y=g-1)} $ with proportional odds assumption


```r
vglm(Yord ~ X1 + X2, family=acat(parallel=TRUE), data=dfOrd)
# not shown
```


Continuation ratio logits $ \ln \frac{P(Y=g)}{P(Y < g)} $ with proportional odds assumption (discrete version of Cox proportional hazards model for survival data)


```r
vglm(Yord ~ X1 + X2, family=sratio(parallel=TRUE), data=dfOrd)
# not shown
```


### Using `lrm()` from package `rms`

Model $ \text{logit}(p(Y \geq g)) = \beta_{0_{g}} + \beta_{1} X_{1} + \dots + \beta_{p} X_{p} \quad(g = 2, \ldots, k) $


```r
library(rms)
(lrmFit <- lrm(Yord ~ X1 + X2, data=dfOrd))
```

```

Logistic Regression Model

lrm(formula = Yord ~ X1 + X2, data = dfOrd)

Frequencies of Responses

--  -  + ++ 
25 25 25 25 

                      Model Likelihood     Discrimination    Rank Discrim.    
                         Ratio Test            Indexes          Indexes       
Obs           100    LR chi2      37.68    R2       0.335    C       0.762    
max |deriv| 1e-06    d.f.             2    g        1.424    Dxy     0.523    
                     Pr(> chi2) <0.0001    gr       4.154    gamma   0.524    
                                           gp       0.288    tau-a   0.396    
                                           Brier    0.173                     

      Coef     S.E.   Wald Z Pr(>|Z|)
y>=-  -18.5116 4.5118 -4.10  <0.0001 
y>=+  -19.9569 4.5663 -4.37  <0.0001 
y>=++ -21.4270 4.6389 -4.62  <0.0001 
X1      0.1277 0.0262  4.88  <0.0001 
X2     -0.0790 0.0244 -3.24  0.0012  
```


### Using `polr()` from package `MASS`

Model $ \text{logit}(p(Y \leq g)) = \beta_{0_{g}} - (\beta_{1} X_{1} + \dots + \beta_{p} X_{p}) \quad(g = 1, \ldots, k-1) $


```r
library(MASS)
(polrFit <- polr(Yord ~ X1 + X2, method="logistic", data=dfOrd))
# not shown
```


Profile likelihood based confidence intervals


```r
exp(confint(polrFit))
```

```
Error: Objekt 'dfOrd' nicht gefunden
```


### Using `clm()` from package `ordinal`

Model $ \text{logit}(p(Y \leq g)) = \beta_{0_{g}} - (\beta_{1} X_{1} + \dots + \beta_{p} X_{p}) \quad(g = 1, \ldots, k-1) $


```r
library(ordinal)
(clmFit <- clm(Yord ~ X1 + X2, link="logit", data=dfOrd))
# not shown
```


Predicted category membership
-------------------------

### Predicted category probabilities


```r
PhatCateg <- predict(vglmFit, type="response")
head(PhatCateg)
```

```
      --      -      +      ++
1 0.5034 0.3080 0.1379 0.05074
2 0.1873 0.3071 0.3153 0.19039
3 0.0437 0.1187 0.2951 0.54246
4 0.2828 0.3431 0.2533 0.12083
5 0.1256 0.2530 0.3474 0.27396
6 0.4277 0.3325 0.1721 0.06759
```



```r
predict(lrmFit, type="fitted.ind")
predict(clmFit, subset(dfOrd, select=c("X1", "X2"), type="prob"))$fit
predict(polrFit, type="probs")
# not shown
```


### Predicted categories


```r
categHat <- levels(dfOrd$Yord)[max.col(PhatCateg)]
head(categHat)
```

```
[1] "--" "+"  "++" "-"  "+"  "--"
```



```r
predict(clmFit, type="class")
predict(polrFit, type="class")
# not shown
```


Apply regression model to new data
-------------------------

### Simulate new data


```r
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7),
                    X2=rnorm(Nnew,  30, 8))
```


### Predicted class probabilities


```r
predict(vglmFit, dfNew, type="response")
```

```
      --      -      +      ++
1 0.1431 0.2716 0.3403 0.24501
2 0.3565 0.3451 0.2094 0.08910
3 0.4373 0.3300 0.1675 0.06517
```



```r
predict(lrmFit,  dfNew, type="fitted.ind")
predict(polrFit, dfNew, type="probs")
predict(clmFit,  subset(dfNew, select=c("X1", "X2"), type="prob"))$fit
# not shown
```


Assess model fit
-------------------------

### Classification table


```r
facHat <- factor(categHat, levels=levels(dfOrd$Yord))
cTab   <- table(dfOrd$Yord, facHat, dnn=c("Yord", "facHat"))
addmargins(cTab)
```

```
     facHat
Yord   --   -   +  ++ Sum
  --   13   8   4   0  25
  -     8   7   9   1  25
  +     4   5   5  11  25
  ++    1   3   3  18  25
  Sum  26  23  21  30 100
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
deviance(vglmFit)
```

```
[1] 239.6
```

```r
logLik(vglmFit)
```

```
[1] -119.8
```

```r
AIC(vglmFit)
```

```
[1] 249.6
```


### McFadden, Cox & Snell and Nagelkerke pseudo $R^{2}$

Log-likelihoods for full model and 0-model without predictors X1, X2


```r
vglm0 <- vglm(Yord ~ 1, family=propodds, data=dfOrd)
LLf   <- logLik(vglmFit)
LL0   <- logLik(vglm0)
```


McFadden pseudo-$R^2$


```r
as.vector(1 - (LLf / LL0))
```

```
[1] 0.1359
```


Cox & Snell


```r
as.vector(1 - exp((2/N) * (LL0 - LLf)))
```

```
[1] 0.3139
```


Nagelkerke


```r
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))
```

```
[1] 0.3349
```


Coefficient tests and overall model test
-------------------------

### Individual coefficient tests

Estimated standard deviations and z-values for parameters


```r
sumOrd   <- summary(vglmFit)
(coefOrd <- coef(sumOrd))
```

```
               Estimate Std. Error z value
(Intercept):1 -18.51151    4.51317  -4.102
(Intercept):2 -19.95682    4.57164  -4.365
(Intercept):3 -21.42690    4.63838  -4.619
X1              0.12771    0.02626   4.864
X2             -0.07902    0.02485  -3.180
```


Approximative Wald-based confidence intervals


```r
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefOrd, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))
```

```
                   [,1]      [,2]
(Intercept):1  -9.66586 -27.35715
(Intercept):2 -10.99658 -28.91707
(Intercept):3 -12.33585 -30.51795
X1              0.17918   0.07625
X2             -0.03033  -0.12772
```


p-values for two-sided paramter tests based on assumption that z-values are asymptotically $N(0, 1)$ distributed


```r
2*(1 - pnorm(abs(coefOrd[ , "z value"])))
```

```
(Intercept):1 (Intercept):2 (Intercept):3            X1            X2 
    4.102e-05     1.269e-05     3.847e-06     1.151e-06     1.471e-03 
```



```r
summary(polrFit)
```

```
Error: Objekt 'dfOrd' nicht gefunden
```

```r
summary(clmFit)
# not shown
```


### Model comparisons - likelihood-ratio tests

Likelihood-ratio-test for predictor `X2`


```r
vglmR <- vglm(Yord ~ X1, family=propodds, data=dfOrd)
VGAM::lrtest(vglmFit, vglmR)
```

```
Likelihood ratio test

Model 1: Yord ~ X1 + X2
Model 2: Yord ~ X1
  #Df LogLik Df Chisq Pr(>Chisq)    
1 295   -120                        
2 296   -125  1  10.9    0.00096 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Likelihood-ratio-test for the full model against the 0-model without predictors (just intercept)


```r
VGAM::lrtest(vglmFit, vglm0)
```

```
Likelihood ratio test

Model 1: Yord ~ X1 + X2
Model 2: Yord ~ 1
  #Df LogLik Df Chisq Pr(>Chisq)    
1 295   -120                        
2 297   -139  2  37.7    6.6e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


Test assumption of proportional odds (=parallel logits)


```r
vglmP <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE,  reverse=TRUE),
              data=dfOrd)

vglmNP <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=FALSE, reverse=TRUE),
                data=dfOrd)
VGAM::lrtest(vglmP, vglmNP)
```

```
Likelihood ratio test

Model 1: Yord ~ X1 + X2
Model 2: Yord ~ X1 + X2
  #Df LogLik Df Chisq Pr(>Chisq)
1 295   -120                    
2 291   -118 -4  2.61       0.63
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:ordinal))
try(detach(package:ucminf))
try(detach(package:Matrix))
try(detach(package:lattice))
try(detach(package:MASS))
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:survival))
try(detach(package:VGAM))
try(detach(package:splines))
try(detach(package:stats4))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionOrdinal.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionOrdinal.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionOrdinal.R) - [all posts](https://github.com/dwoll/RExRepos/)
