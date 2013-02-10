---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Moderated and mediated linear regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression]
---




TODO
-------------------------

 - link to regression, regressionDiag

Install required packages
-------------------------

[`mediation`](http://cran.r-project.org/package=mediation), [`multilevel`](http://cran.r-project.org/package=multilevel), [`QuantPsyc`](http://cran.r-project.org/package=QuantPsyc)


```r
wants <- c("mediation", "multilevel", "QuantPsyc")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

    
Moderated regression
-------------------------


```r
set.seed(123)
N <- 100
X <- rnorm(N, 175, 7)
M <- rnorm(N,  30, 8)
Y <- 0.5*X - 0.3*M + 10 + rnorm(N, 0, 3)
dfRegr <- data.frame(X, M, Y)
```



```r
Xc <- c(scale(dfRegr$X, center=TRUE, scale=FALSE))
Mc <- c(scale(dfRegr$M, center=TRUE, scale=FALSE))
fitMod <- lm(Y ~ Xc + Mc + Xc:Mc, data=dfRegr)
summary(fitMod)
```

```

Call:
lm(formula = Y ~ Xc + Mc + Xc:Mc, data = dfRegr)

Residuals:
   Min     1Q Median     3Q    Max 
-5.616 -2.033 -0.326  1.769  6.950 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 89.45659    0.28442  314.52  < 2e-16 ***
Xc           0.45289    0.04530   10.00  < 2e-16 ***
Mc          -0.28173    0.03755   -7.50  3.2e-11 ***
Xc:Mc        0.00852    0.00613    1.39     0.17    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Residual standard error: 2.84 on 96 degrees of freedom
Multiple R-squared: 0.639,	Adjusted R-squared: 0.628 
F-statistic: 56.7 on 3 and 96 DF,  p-value: <2e-16 
```


Only valid for models with exactly one predictor, one moderator, and one predicted variable. Function will appear to work in more complex models, but results will then be wrong.


```r
library(QuantPsyc)
sim.slopes(fitMod, Mc)
```

```
           INT  Slope      SE    LCL    UCL
at zHigh 87.28 0.5188 0.07060 0.3787 0.6590
at zMean 89.46 0.4529 0.04530 0.3630 0.5428
at zLow  91.64 0.3870 0.06019 0.2675 0.5064
```


Mediation analysis
-------------------------

### Simulate data


```r
N <- 100
X <- rnorm(N, 175, 7)
M <- 0.7*X + rnorm(N, 0, 5)
Y <- 0.4*M + rnorm(N, 0, 5)
dfMed <- data.frame(X, M, Y)
```



```r
fit <- lm(Y ~ X + M, data=dfMed)
summary(fit)
```

```

Call:
lm(formula = Y ~ X + M, data = dfMed)

Residuals:
    Min      1Q  Median      3Q     Max 
-13.869  -2.588  -0.017   3.445  14.097 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   9.3822    11.1750    0.84    0.403    
X            -0.1916     0.0908   -2.11    0.037 *  
M             0.5945     0.0939    6.33  7.6e-09 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Residual standard error: 4.62 on 97 degrees of freedom
Multiple R-squared: 0.347,	Adjusted R-squared: 0.334 
F-statistic: 25.8 on 2 and 97 DF,  p-value: 1.04e-09 
```


### Sobel test


```r
library(multilevel)
sobel(dfMed$X, dfMed$M, dfMed$Y)
```

```
$`Mod1: Y~X`
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  11.0579   13.21242  0.8369 0.404667
pred          0.2167    0.07554  2.8688 0.005047

$`Mod2: Y~X+M`
            Estimate Std. Error t value  Pr(>|t|)
(Intercept)   9.3822   11.17501  0.8396 4.032e-01
pred         -0.1916    0.09078 -2.1107 3.737e-02
med           0.5945    0.09391  6.3300 7.609e-09

$`Mod3: M~X`
            Estimate Std. Error t value  Pr(>|t|)
(Intercept)   2.8188   12.01663  0.2346 8.150e-01
pred          0.6869    0.06871  9.9975 1.226e-16

$Indirect.Effect
[1] 0.4083

$SE
[1] 0.07635

$z.value
[1] 5.348

$N
[1] 100
```


### Using package `mediation`

Also useful for much more complicated situations.

#### Estimation via quasi-Bayesian approximation


```r
fitM <- lm(M ~ X,     data=dfMed)
fitY <- lm(Y ~ X + M, data=dfMed)

library(mediation)
fitMed <- mediate(fitM, fitY, sims=999, treat="X", mediator="M")
summary(fitMed)
```

```

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                         Estimate 95% CI Lower 95% CI Upper p-value
Mediation Effect           0.4076       0.2637       0.5651    0.00
Direct Effect             -0.1899      -0.3623      -0.0128    0.03
Total Effect               0.2177       0.0660       0.3672    0.01
Proportion via Mediation   1.8360       1.0324       5.4378    0.15

Sample Size Used: 100 


Simulations: 999 
```



```r
plot(fitMed)
```

![plot of chunk rerRegressionModMed01](content/assets/figure/rerRegressionModMed01.png) 


#### Estimation via nonparametric bootstrap


```r
fitMedBoot <- mediate(fitM, fitY, boot=TRUE, sims=999, treat="X", mediator="M")
summary(fitMedBoot)
```

```

Causal Mediation Analysis 

Confidence Intervals Based on Nonparametric Bootstrap

                         Estimate 95% CI Lower 95% CI Upper p-value
Mediation Effect           0.4083       0.2598       0.5507    0.00
Direct Effect             -0.1916      -0.3257      -0.0417    0.01
Total Effect               0.2167       0.0791       0.3506    0.00
Proportion via Mediation   1.8842       1.1362       4.6463    0.09

Sample Size Used: 100 


Simulations: 999 
```


Useful packages
-------------------------

More complex structural equation models are supported by packages [`sem`](http://cran.r-project.org/package=sem), [`OpenMx`](http://openmx.psyc.virginia.edu/), and [`lavaan`](http://cran.r-project.org/package=lavaan). More packages can be found in CRAN task view [Psychometric Models](http://cran.r-project.org/web/views/Psychometrics.html).

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:QuantPsyc))
try(detach(package:boot))
try(detach(package:mediation))
try(detach(package:Matrix))
try(detach(package:lpSolve))
try(detach(package:lattice))
try(detach(package:multilevel))
try(detach(package:MASS))
try(detach(package:nlme))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionModMed.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionModMed.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionModMed.R) - [all posts](https://github.com/dwoll/RExRepos/)
