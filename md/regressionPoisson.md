---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Poisson-regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression, GLM]
---

Poisson-regression
=========================



Install required packages
-------------------------

[`lmtest`](http://cran.r-project.org/package=lmtest), [`MASS`](http://cran.r-project.org/package=MASS), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`pscl`](http://cran.r-project.org/package=pscl), [`sandwich`](http://cran.r-project.org/package=sandwich), [`VGAM`](http://cran.r-project.org/package=VGAM)


```r
wants <- c("lmtest", "MASS", "mvtnorm", "pscl", "sandwich", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Poisson regression
-------------------------
    
### Simulate data
    

```r
library(mvtnorm)
set.seed(123)
N     <- 200
sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,8), byrow=TRUE, ncol=3)
mu    <- c(-3, 2, 4)
XY    <- rmvnorm(N, mean=mu, sigma=sigma)
Y     <- round(XY[ , 3] - 1.5)
Y[Y < 0] <- 0
dfCount <- data.frame(X1=XY[ , 1], X2=XY[ , 2], Y)
```

### Using `glm()`


```r
glmFitP <- glm(Y ~ X1 + X2, family=poisson(link="log"), data=dfCount)
summary(glmFitP)
```

```

Call:
glm(formula = Y ~ X1 + X2, family = poisson(link = "log"), data = dfCount)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-3.3237  -1.2454  -0.2932   0.8200   2.9249  

Coefficients:
              Estimate Std. Error z value Pr(>|z|)    
(Intercept)  1.932e-01  1.032e-01   1.872   0.0612 .  
X1          -2.549e-01  2.260e-02 -11.281   <2e-16 ***
X2          -8.653e-05  1.149e-02  -0.008   0.9940    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for poisson family taken to be 1)

    Null deviance: 494.5  on 199  degrees of freedom
Residual deviance: 356.2  on 197  degrees of freedom
AIC: 838.43

Number of Fisher Scoring iterations: 5
```

Change factors for rate parameter $\lambda$


```r
exp(coef(glmFitP))
```

```
(Intercept)          X1          X2 
  1.2130876   0.7749815   0.9999135 
```

Profile likelihood based confidence intervals for change factors


```r
exp(confint(glmFitP))
```

```
                2.5 %    97.5 %
(Intercept) 0.9877265 1.4802870
X1          0.7412874 0.8099532
X2          0.9776288 1.0226470
```

### Using `vglm()` from package `VGAM`


```r
library(VGAM)
summary(vglmFit <- vglm(Y ~ X1 + X2, family=poissonff, data=dfCount))
# not shown
```

### Analyse event rates

`offset` is the exposure $\ln(t)$


```r
Nt   <- 100
Ti   <- sample(20:40, Nt, replace=TRUE)
Xt   <- rnorm(Nt, 100, 15)
Yt   <- rbinom(Nt, size=Ti, prob=0.5)
glm(Yt ~ Xt, family=poisson(link="log"), offset=log(Ti))
```

```

Call:  glm(formula = Yt ~ Xt, family = poisson(link = "log"), offset = log(Ti))

Coefficients:
(Intercept)           Xt  
    -0.5466      -0.0017  

Degrees of Freedom: 99 Total (i.e. Null);  98 Residual
Null Deviance:	    51.74 
Residual Deviance: 50.73 	AIC: 502.6
```

Overdispersion
-------------------------

### Adjusted Poisson-regression

Same parameter estimates as in Poisson model, but different standard errors, hence different p-values


```r
glmFitQP <- glm(Y ~ X1 + X2, family=quasipoisson(link="log"), data=dfCount)
summary(glmFitQP)
```

```

Call:
glm(formula = Y ~ X1 + X2, family = quasipoisson(link = "log"), 
    data = dfCount)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-3.3237  -1.2454  -0.2932   0.8200   2.9249  

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)  1.932e-01  1.297e-01   1.490    0.138    
X1          -2.549e-01  2.839e-02  -8.979   <2e-16 ***
X2          -8.653e-05  1.443e-02  -0.006    0.995    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for quasipoisson family taken to be 1.578522)

    Null deviance: 494.5  on 199  degrees of freedom
Residual deviance: 356.2  on 197  degrees of freedom
AIC: NA

Number of Fisher Scoring iterations: 5
```

Using `vglm()` from package `VGAM`


```r
library(VGAM)
vglm(Y ~ X1 + X2, family=quasipoissonff, data=dfCount)
# not shown
```

### Heteroscedasticity consistent standard errors

Same parameter estimates as in Poisson model, but different standard errors, hence different p-values


```r
library(sandwich)
hcSE <- vcovHC(glmFitP, type="HC0")

library(lmtest)
coeftest(glmFitP, vcov=hcSE)
```

```

z test of coefficients:

               Estimate  Std. Error z value Pr(>|z|)    
(Intercept)  0.19316888  0.13268996  1.4558   0.1455    
X1          -0.25491612  0.02698458 -9.4467   <2e-16 ***
X2          -0.00008653  0.01319493 -0.0066   0.9948    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Negative binomial regression

Using `glm.nb()` from package `MASS`


```r
library(MASS)
glmFitNB <- glm.nb(Y ~ X1 + X2, data=dfCount)
summary(glmFitNB)
```

```

Call:
glm.nb(formula = Y ~ X1 + X2, data = dfCount, init.theta = 5.181857797, 
    link = log)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-2.7695  -1.0533  -0.2315   0.6472   2.4427  

Coefficients:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.166025   0.125963   1.318    0.187    
X1          -0.261257   0.029119  -8.972   <2e-16 ***
X2           0.002651   0.014735   0.180    0.857    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

(Dispersion parameter for Negative Binomial(5.1819) family taken to be 1)

    Null deviance: 345.33  on 199  degrees of freedom
Residual deviance: 256.60  on 197  degrees of freedom
AIC: 824.58

Number of Fisher Scoring iterations: 1

              Theta:  5.18 
          Std. Err.:  1.79 

 2 x log-likelihood:  -816.58 
```

Using `vglm()` from package `VGAM`


```r
library(VGAM)
vglm(Y ~ X1 + X2, family=negbinomial, data=dfCount)
# not shown
```

### Test the negative binomial model against the Poisson model


```r
library(pscl)
odTest(glmFitNB)
```

```
Error in eval(expr, envir, enclos): Objekt 'dfCount' nicht gefunden
```

Zero-inflated Regression models
-------------------------

### Zero-inflated Poisson regression


```r
library(pscl)
ziFitP <- zeroinfl(Y ~ X1 + X2 | 1, dist="poisson", data=dfCount)
summary(ziFitP)
```

```

Call:
zeroinfl(formula = Y ~ X1 + X2 | 1, data = dfCount, dist = "poisson")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-1.6788 -0.8887 -0.1755  0.7678  3.3165 

Count model coefficients (poisson with log link):
             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.456827   0.124391   3.672  0.00024 ***
X1          -0.216984   0.025879  -8.385  < 2e-16 ***
X2          -0.002068   0.012180  -0.170  0.86516    

Zero-inflation model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  -1.8868     0.2927  -6.446 1.15e-10 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 10 
Log-likelihood: -402.4 on 4 Df
```

Using `vglm()` from package `VGAM`


```r
library(VGAM)
vglm(Y ~ X1 + X2, family=zipoissonff, data=dfCount)
# not shown
```

Vuong-Test using `vuong()` from package `pscl`: Poisson model against zero-inflated Poisson model


```r
library(pscl)
vuong(ziFitP, glmFitP)
```

```
[1] 2.649159
          Raw AIC-corrected BIC-corrected 
     2.045272      2.044531      1.653019 
[1] 0.4775593
[1] 13.81317 13.80817 11.16401
Vuong Non-Nested Hypothesis Test-Statistic: 
(test-statistic is asymptotically distributed N(0,1) under the
 null that the models are indistinguishible)
-------------------------------------------------------------
              Vuong z-statistic             H_A  p-value
Raw                    2.045272 model1 > model2 0.020414
AIC-corrected          2.044531 model1 > model2 0.020451
BIC-corrected          1.653019 model1 > model2 0.049163
```

### Zero-inflated negative binomial regression


```r
ziFitNB <- zeroinfl(Y ~ X1 + X2 | 1, dist="negbin", data=dfCount)
summary(ziFitNB)
```

```

Call:
zeroinfl(formula = Y ~ X1 + X2 | 1, data = dfCount, dist = "negbin")

Pearson residuals:
    Min      1Q  Median      3Q     Max 
-1.6352 -0.8709 -0.1633  0.7424  3.3172 

Count model coefficients (negbin with log link):
             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.426760   0.136718   3.121   0.0018 ** 
X1          -0.222478   0.028374  -7.841 4.48e-15 ***
X2          -0.001403   0.012926  -0.109   0.9135    
Log(theta)   3.474664   1.443439   2.407   0.0161 *  

Zero-inflation model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)   -1.973      0.341  -5.786  7.2e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Theta = 32.287 
Number of iterations in BFGS optimization: 26 
Log-likelihood: -402.1 on 5 Df
```

Using `vglm()` from package `VGAM`


```r
library(VGAM)
vglm(Y ~ X1 + X2, family=zinegbinomial, data=dfCount)
# not shown
```

Vuong-Test using `vuong()` from package `pscl`: negative binomial model against zero-inflated negative binomial model


```r
library(pscl)
vuong(ziFitNB, glmFitNB)
```

```
[1] 2.649159
          Raw AIC-corrected BIC-corrected 
    1.6121411     1.6108359     0.9206495 
[1] 0.2708982
[1] 6.176240 6.171240 3.527081
Vuong Non-Nested Hypothesis Test-Statistic: 
(test-statistic is asymptotically distributed N(0,1) under the
 null that the models are indistinguishible)
-------------------------------------------------------------
              Vuong z-statistic             H_A  p-value
Raw                   1.6121411 model1 > model2 0.053466
AIC-corrected         1.6108359 model1 > model2 0.053608
BIC-corrected         0.9206495 model1 > model2 0.178617
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:VGAM))
try(detach(package:sandwich))
try(detach(package:lmtest))
try(detach(package:zoo))
try(detach(package:pscl))
try(detach(package:mvtnorm))
try(detach(package:lattice))
try(detach(package:splines))
try(detach(package:stats4))
try(detach(package:MASS))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionPoisson.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionPoisson.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionPoisson.R) - [all posts](https://github.com/dwoll/RExRepos/)
