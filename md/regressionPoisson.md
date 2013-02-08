---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Poisson-regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression, GLM]
---







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
    

{% highlight r %}
library(mvtnorm)
set.seed(1.234)
N     <- 200
sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,8), byrow=TRUE, ncol=3)
mu    <- c(-3, 2, 4)
XY    <- rmvnorm(N, mean=mu, sigma=sigma)
Y     <- round(XY[ , 3] - 1.5)
Y[Y < 0] <- 0
dfCount <- data.frame(X1=XY[ , 1], X2=XY[ , 2], Y)
{% endhighlight %}


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
-3.229  -1.414  -0.298   0.795   2.917  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.08668    0.10111    0.86     0.39    
X1          -0.24945    0.02138  -11.67   <2e-16 ***
X2           0.00503    0.01142    0.44     0.66    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for poisson family taken to be 1)

    Null deviance: 520.82  on 199  degrees of freedom
Residual deviance: 380.55  on 197  degrees of freedom
AIC: 816.5

Number of Fisher Scoring iterations: 5
```


Change factors for rate parameter $ \lambda $


```r
exp(coef(glmFitP))
```

```
(Intercept)          X1          X2 
     1.0905      0.7792      1.0050 
```


Profile likelihood based confidence intervals for change factors


```r
exp(confint(glmFitP))
```

```
             2.5 % 97.5 %
(Intercept) 0.8916 1.3254
X1          0.7472 0.8126
X2          0.9828 1.0278
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
   -0.59656     -0.00084  

Degrees of Freedom: 99 Total (i.e. Null);  98 Residual
Null Deviance:	    53.3 
Residual Deviance: 53.1 	AIC: 507 
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
-3.229  -1.414  -0.298   0.795   2.917  

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.08668    0.13303    0.65     0.52    
X1          -0.24945    0.02813   -8.87  4.5e-16 ***
X2           0.00503    0.01502    0.34     0.74    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for quasipoisson family taken to be 1.731)

    Null deviance: 520.82  on 199  degrees of freedom
Residual deviance: 380.55  on 197  degrees of freedom
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
(Intercept)  0.08668    0.13380    0.65     0.52    
X1          -0.24945    0.02889   -8.63   <2e-16 ***
X2           0.00503    0.01504    0.33     0.74    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Negative binomial regression

Using `glm.nb()` from package `MASS`


{% highlight r %}
library(MASS)
glmFitNB <- glm.nb(Y ~ X1 + X2, data=dfCount)
summary(glmFitNB)
{% endhighlight %}



{% highlight text %}

Call:
glm.nb(formula = Y ~ X1 + X2, data = dfCount, init.theta = 3.276759193, 
    link = log)

Deviance Residuals: 
   Min      1Q  Median      3Q     Max  
-2.517  -1.281  -0.223   0.567   2.143  

Coefficients:
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.05641    0.13131    0.43     0.67    
X1          -0.25777    0.03030   -8.51   <2e-16 ***
X2           0.00565    0.01596    0.35     0.72    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for Negative Binomial(3.277) family taken to be 1)

    Null deviance: 326.95  on 199  degrees of freedom
Residual deviance: 248.19  on 197  degrees of freedom
AIC: 789

Number of Fisher Scoring iterations: 1

              Theta:  3.277 
          Std. Err.:  0.936 

 2 x log-likelihood:  -780.981 
{% endhighlight %}


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
Error: object 'dfCount' not found
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
-1.499 -0.953 -0.192  0.758  3.051 

Count model coefficients (poisson with log link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.42063    0.12175    3.45  0.00055 ***
X1          -0.20294    0.02456   -8.26  < 2e-16 ***
X2           0.00677    0.01225    0.55  0.58064    

Zero-inflation model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)   -1.502      0.256   -5.87  4.4e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Number of iterations in BFGS optimization: 9 
Log-likelihood: -388 on 4 Df
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
Vuong Non-Nested Hypothesis Test-Statistic: 2.355 
(test-statistic is asymptotically distributed N(0,1) under the
 null that the models are indistinguishible)
in this case:
model1 > model2, with p-value 0.009262 
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
-1.415 -0.907 -0.199  0.677  2.863 

Count model coefficients (negbin with log link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)  0.33048    0.14583    2.27  0.02343 *  
X1          -0.21917    0.02982   -7.35    2e-13 ***
X2           0.00671    0.01410    0.48  0.63413    
Log(theta)   2.34399    0.62744    3.74  0.00019 ***

Zero-inflation model coefficients (binomial with logit link):
            Estimate Std. Error z value Pr(>|z|)    
(Intercept)   -1.743      0.355   -4.91  9.2e-07 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Theta = 10.423 
Number of iterations in BFGS optimization: 20 
Log-likelihood: -386 on 5 Df
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
Vuong Non-Nested Hypothesis Test-Statistic: 1.445 
(test-statistic is asymptotically distributed N(0,1) under the
 null that the models are indistinguishible)
in this case:
model1 > model2, with p-value 0.07426 
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
