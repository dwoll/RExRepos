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

Dependent variable $Y_{\text{ord}}$ with $k=4$ groups, $p=2$ predictor variables


```r
set.seed(123)
N     <- 100
X1    <- rnorm(N, 175, 7)
X2    <- rnorm(N,  30, 8)
Ycont <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Yord  <- cut(Ycont, breaks=quantile(Ycont), include.lowest=TRUE,
             labels=c("--", "-", "+", "++"), ordered=TRUE)
dfOrd <- data.frame(X1, X2, Yord)
```

### Using `vglm()` from package `VGAM`

Model using cumulative logits: $\text{logit}(p(Y \geq g)) = \ln \frac{P(Y \geq g)}{1 - P(Y \geq g)} = \beta_{0_{g}} + \beta_{1} X_{1} + \dots + \beta_{p} X_{p} \quad(g = 2, \ldots, k)$


```r
library(VGAM)
(vglmFit <- vglm(Yord ~ X1 + X2, family=propodds, data=dfOrd))
```

```
Call:
vglm(formula = Yord ~ X1 + X2, family = propodds, data = dfOrd)

Coefficients:
(Intercept):1 (Intercept):2 (Intercept):3            X1            X2 
 -15.61123204  -17.00112492  -18.28506734    0.11197395   -0.09517965 

Degrees of Freedom: 300 Total; 295 Residual
Residual deviance: 249.3579 
Log-likelihood: -124.6789 
```

Equivalent:


```r
vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE, reverse=TRUE), data=dfOrd)
# not shown
```

Adjacent category logits $\ln \frac{P(Y=g)}{P(Y=g-1)}$ with proportional odds assumption


```r
vglm(Yord ~ X1 + X2, family=acat(parallel=TRUE), data=dfOrd)
# not shown
```

Continuation ratio logits $\ln \frac{P(Y=g)}{P(Y < g)}$ with proportional odds assumption (discrete version of Cox proportional hazards model for survival data)


```r
vglm(Yord ~ X1 + X2, family=sratio(parallel=TRUE), data=dfOrd)
# not shown
```

### Using `orm()` from package `rms`

Model $\text{logit}(p(Y \geq g)) = \beta_{0_{g}} + \beta_{1} X_{1} + \dots + \beta_{p} X_{p} \quad(g = 2, \ldots, k)$


```r
library(rms)
(ormFit <- orm(Yord ~ X1 + X2, data=dfOrd))
```

```

Logistic (Proportional Odds) Ordinal Regression Model

orm(formula = Yord ~ X1 + X2, data = dfOrd)

Frequencies of Responses

--  -  + ++ 
25 25 25 25 

                      Model Likelihood          Discrimination          Rank Discrim.    
                         Ratio Test                 Indexes                Indexes       
Obs           100    LR chi2      27.90    R2                  0.260    rho     0.477    
Unique Y        4    d.f.             2    g                   1.176                     
Median Y        2    Pr(> chi2) <0.0001    gr                  3.240                     
max |deriv| 0.003    Score chi2   28.50    |Pr(Y>=median)-0.5| 0.274                     
                     Pr(> chi2) <0.0001                                                  

      Coef     S.E.   Wald Z Pr(>|Z|)
y>=-  -15.6110 5.5109 -2.83  0.0046  
y>=+  -17.0008 5.5508 -3.06  0.0022  
y>=++ -18.2848 5.5863 -3.27  0.0011  
X1      0.1120 0.0314  3.56  0.0004  
X2     -0.0952 0.0272 -3.50  0.0005  
```

### Using `polr()` from package `MASS`

Model $\text{logit}(p(Y \leq g)) = \beta_{0_{g}} - (\beta_{1} X_{1} + \dots + \beta_{p} X_{p}) \quad(g = 1, \ldots, k-1)$


```r
library(MASS)
(polrFit <- polr(Yord ~ X1 + X2, method="logistic", data=dfOrd))
# not shown
```

Profile likelihood based confidence intervals (need to use `MASS:::confint.polr()` instead of `confint()` since other packages are loaded, and method is masked).


```r
exp(MASS:::confint.polr(polrFit))
```

```
Error in eval(expr, envir, enclos): Objekt 'dfOrd' nicht gefunden
```

### Using `clm()` from package `ordinal`

Model $\text{logit}(p(Y \leq g)) = \beta_{0_{g}} - (\beta_{1} X_{1} + \dots + \beta_{p} X_{p}) \quad(g = 1, \ldots, k-1)$


```r
library(ordinal)
(clmFit <- clm(Yord ~ X1 + X2, link="logit", data=dfOrd))
# not shown
```

Predicted category membership
-------------------------

### Predicted category probabilities


```r
PhatCateg <- VGAM::predict(vglmFit, type="response")
head(PhatCateg)
```

```
          --         -         +        ++
1 0.22610471 0.3136747 0.2692008 0.1910199
2 0.32021125 0.3338845 0.2181580 0.1277463
3 0.07320949 0.1675519 0.2930451 0.4661935
4 0.19019915 0.2950991 0.2876648 0.2270369
5 0.12403581 0.2383874 0.3099813 0.3275955
6 0.07534083 0.1711326 0.2950389 0.4584877
```


```r
predict(ormFit, type="fitted.ind")
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
[1] "-"  "-"  "++" "-"  "++" "++"
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
VGAM::predict(vglmFit, dfNew, type="response")
```

```
         --          -          +         ++
1 0.8625341 0.09928134 0.02730933 0.01087521
2 0.5914519 0.26174070 0.10132180 0.04548565
3 0.2038282 0.30301019 0.28089185 0.21226981
```


```r
predict(ormFit,  dfNew, type="fitted.ind")
predict(polrFit, dfNew, type="probs")
predict(clmFit,  subset(dfNew, select=c("X1", "X2"), type="prob"))$fit
# not shown
```

Assess model fit
-------------------------

### Classification table


```r
facHat <- factor(categHat, levels=levels(dfOrd$Yord))
cTab   <- xtabs(~ Yord + facHat, data=dfOrd)
addmargins(cTab)
```

```
     facHat
Yord   --   -   +  ++ Sum
  --   17   4   3   1  25
  -     5  11   2   7  25
  +     1  10   4  10  25
  ++    3   9   2  11  25
  Sum  26  34  11  29 100
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
VGAM::deviance(vglmFit)
```

```
[1] 249.3579
```

```r
VGAM::logLik(vglmFit)
```

```
[1] -124.6789
```

```r
VGAM::AIC(vglmFit)
```

```
[1] 259.3579
```

### McFadden, Cox & Snell and Nagelkerke pseudo $R^{2}$

Log-likelihoods for full model and 0-model without predictors X1, X2


```r
vglm0 <- vglm(Yord ~ 1, family=propodds, data=dfOrd)
LLf   <- VGAM::logLik(vglmFit)
LL0   <- VGAM::logLik(vglm0)
```

McFadden pseudo-$R^2$


```r
as.vector(1 - (LLf / LL0))
```

```
[1] 0.1006315
```

Cox & Snell


```r
as.vector(1 - exp((2/N) * (LL0 - LLf)))
```

```
[1] 0.2434676
```

Nagelkerke


```r
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))
```

```
[1] 0.2596987
```

Coefficient tests and overall model test
-------------------------

### Individual coefficient tests

Estimated standard deviations, z-values and p-values for parameters based on assumption that z-values are asymptotically $N(0, 1)$ distributed.


```r
sumOrd   <- summary(vglmFit)
(coefOrd <- coef(sumOrd))
```

```
                  Estimate Std. Error   z value     Pr(>|z|)
(Intercept):1 -15.61123204 5.41912617 -2.880766 0.0039671060
(Intercept):2 -17.00112492 5.45613579 -3.115964 0.0018334440
(Intercept):3 -18.28506734 5.49803759 -3.325744 0.0008818278
X1              0.11197395 0.03122493  3.586043 0.0003357330
X2             -0.09517965 0.02694012 -3.533007 0.0004108612
```

Approximative Wald-based confidence intervals


```r
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefOrd, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))
```

```
                     [,1]         [,2]
(Intercept):1 -4.98993991 -26.23252417
(Intercept):2 -6.30729528 -27.69495455
(Intercept):3 -7.50911167 -29.06102301
X1             0.17317368   0.05077421
X2            -0.04237798  -0.14798132
```

Tests for other models.


```r
summary(polrFit)
```

```
Error in eval(expr, envir, enclos): Objekt 'dfOrd' nicht gefunden
```

```r
summary(clmFit)
# not shown
```

### Model comparisons - likelihood-ratio tests

Likelihood-ratio-test for predictor `X2`

We need to specify `VGAM::lrtest()` here because after attaching package `mlogit` above, there is another function present with the same name.


```r
vglmR <- vglm(Yord ~ X1, family=propodds, data=dfOrd)
VGAM::lrtest(vglmFit, vglmR)
```

```
Likelihood ratio test

Model 1: Yord ~ X1 + X2
Model 2: Yord ~ X1
  #Df  LogLik Df  Chisq Pr(>Chisq)    
1 295 -124.68                         
2 296 -131.42  1 13.482  0.0002408 ***
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
  #Df  LogLik Df  Chisq Pr(>Chisq)    
1 295 -124.68                         
2 297 -138.63  2 27.901  8.737e-07 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Test assumption of proportional odds (=parallel logits)


```r
vglmP <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE,  reverse=TRUE),
              data=dfOrd)

# vglmNP <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=FALSE, reverse=TRUE),
#                 data=dfOrd)
# VGAM::lrtest(vglmP, vglmNP)
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:ordinal))
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:lattice))
try(detach(package:survival))
try(detach(package:VGAM))
try(detach(package:splines))
try(detach(package:stats4))
try(detach(package:MASS))
try(detach(package:Formula))
try(detach(package:grid))
try(detach(package:SparseM))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionOrdinal.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionOrdinal.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionOrdinal.R) - [all posts](https://github.com/dwoll/RExRepos/)
