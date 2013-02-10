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

[`lmtest`](http://cran.r-project.org/package=lmtest), [`MASS`](http://cran.r-project.org/package=MASS), [`pscl`](http://cran.r-project.org/package=pscl), [`sandwich`](http://cran.r-project.org/package=sandwich), [`VGAM`](http://cran.r-project.org/package=VGAM)


```r
wants <- c("lmtest", "MASS", "pscl", "sandwich", "VGAM")
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
   Min      1Q  Median      3Q     Max  
-3.324  -1.245  -0.293   0.820   2.925  

Coefficients:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  1.93e-01   1.03e-01    1.87    0.061 .  
X1          -2.55e-01   2.26e-02  -11.28   <2e-16 ***
X2          -8.65e-05   1.15e-02   -0.01    0.994    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for poisson family taken to be 1)

    Null deviance: 494.5  on 199  degrees of freedom
Residual deviance: 356.2  on 197  degrees of freedom
AIC: 838.4

Number of Fisher Scoring iterations: 5
```


Change factors for rate parameter $ \lambda $


```r
exp(coef(glmFitP))
```

```
(Intercept)          X1          X2 
     1.2131      0.7750      0.9999 
```


Profile likelihood based confidence intervals for change factors


```r
exp(confint(glmFitP))
```

```
             2.5 % 97.5 %
(Intercept) 0.9877  1.480
X1          0.7413  0.810
X2          0.9776  1.023
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
Null Deviance:	    51.7 
Residual Deviance: 50.7 	AIC: 503 
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
   Min      1Q  Median      3Q     Max  
-3.324  -1.245  -0.293   0.820   2.925  

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)  1.93e-01   1.30e-01    1.49     0.14    
X1          -2.55e-01   2.84e-02   -8.98   <2e-16 ***
X2          -8.65e-05   1.44e-02   -0.01     1.00    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for quasipoisson family taken to be 1.579)

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

             Estimate Std. Error z value Pr(>|z|)    
(Intercept)  1.93e-01   1.33e-01    1.46     0.15    
X1          -2.55e-01   2.70e-02   -9.45   <2e-16 ***
X2          -8.65e-05   1.32e-02   -0.01     0.99    
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
   Min      1Q  Median      3Q     Max  
-2.769  -1.053  -0.232   0.647   2.443  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.16602    0.12596    1.32     0.19    
X1          -0.26126    0.02912   -8.97   <2e-16 ***
X2           0.00265    0.01473    0.18     0.86    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for Negative Binomial(5.182) family taken to be 1)

    Null deviance: 345.33  on 199  degrees of freedom
Residual deviance: 256.60  on 197  degrees of freedom
AIC: 824.6

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
Error: Objekt 'dfCount' nicht gefunden
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
   Min     1Q Median     3Q    Max 
-1.679 -0.889 -0.175  0.768  3.317 

Count model coefficients (poisson with log link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.45683    0.12439    3.67  0.00024 ***
X1          -0.21698    0.02588   -8.38  < 2e-16 ***
X2          -0.00207    0.01218   -0.17  0.86516    

Zero-inflation model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)   -1.887      0.293   -6.45  1.1e-10 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 10 
Log-likelihood: -402 on 4 Df
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
Vuong Non-Nested Hypothesis Test-Statistic: 2.045 
(test-statistic is asymptotically distributed N(0,1) under the
 null that the models are indistinguishible)
in this case:
model1 > model2, with p-value 0.02041 
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
   Min     1Q Median     3Q    Max 
-1.635 -0.871 -0.163  0.742  3.317 

Count model coefficients (negbin with log link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)   0.4268     0.1367    3.12   0.0018 ** 
X1           -0.2225     0.0284   -7.84  4.5e-15 ***
X2           -0.0014     0.0129   -0.11   0.9135    
Log(theta)    3.4747     1.4434    2.41   0.0161 *  

Zero-inflation model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)   -1.973      0.341   -5.79  7.2e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Theta = 32.287 
Number of iterations in BFGS optimization: 26 
Log-likelihood: -402 on 5 Df
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
Vuong Non-Nested Hypothesis Test-Statistic: 1.612 
(test-statistic is asymptotically distributed N(0,1) under the
 null that the models are indistinguishible)
in this case:
model1 > model2, with p-value 0.05347 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:sandwich))
try(detach(package:lmtest))
try(detach(package:zoo))
try(detach(package:pscl))
try(detach(package:mvtnorm))
try(detach(package:coda))
try(detach(package:lattice))
try(detach(package:gam))
try(detach(package:splines))
try(detach(package:vcd))
try(detach(package:grid))
try(detach(package:colorspace))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionPoisson.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionPoisson.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionPoisson.R) - [all posts](https://github.com/dwoll/RExRepos/)
