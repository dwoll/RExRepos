---
layout: post
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
set.seed(1.234)
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
-8.777 -1.294  0.007  1.970  7.806 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 89.06026    0.31047  286.86  < 2e-16 ***
Xc           0.48952    0.05108    9.58  1.2e-15 ***
Mc          -0.32037    0.04072   -7.87  5.4e-12 ***
Xc:Mc       -0.01284    0.00795   -1.61     0.11    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Residual standard error: 3.1 on 96 degrees of freedom
Multiple R-squared: 0.639,	Adjusted R-squared: 0.627 
F-statistic: 56.6 on 3 and 96 DF,  p-value: <2e-16 
```


Only valid for models with exactly one predictor, one moderator, and one predicted variable. Function will appear to work in more complex models, but results will then be wrong.


```r
library(QuantPsyc)
sim.slopes(fitMod, Mc)
```

```
           INT  Slope      SE    LCL    UCL
at zHigh 86.61 0.3911 0.08831 0.2158 0.5664
at zMean 89.06 0.4895 0.05108 0.3881 0.5909
at zLow  91.52 0.5879 0.06964 0.4497 0.7261
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
-12.089  -3.066  -0.128   3.509  10.355 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  11.3426    12.2973    0.92  0.35863    
X            -0.0149     0.0922   -0.16  0.87208    
M             0.3269     0.0832    3.93  0.00016 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Residual standard error: 4.84 on 97 degrees of freedom
Multiple R-squared: 0.207,	Adjusted R-squared: 0.191 
F-statistic: 12.7 on 2 and 97 DF,  p-value: 1.28e-05 
```


### Sobel test


```r
library(multilevel)
sobel(dfMed$X, dfMed$M, dfMed$Y)
```

```
$`Mod1: Y~X`
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  10.1248   13.16855  0.7689 0.443824
pred          0.2205    0.07504  2.9392 0.004103

$`Mod2: Y~X+M`
            Estimate Std. Error t value  Pr(>|t|)
(Intercept) 11.34259   12.29728  0.9224 0.3586262
pred        -0.01488    0.09216 -0.1614 0.8720846
med          0.32692    0.08317  3.9307 0.0001589

$`Mod3: M~X`
            Estimate Std. Error t value  Pr(>|t|)
(Intercept)  -3.7250   14.93061 -0.2495 8.035e-01
pred          0.7201    0.08508  8.4645 2.564e-13

$Indirect.Effect
[1] 0.2354

$SE
[1] 0.06604

$z.value
[1] 3.565

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
Mediation Effect           0.2320       0.1040       0.3754    0.00
Direct Effect             -0.0174      -0.2001       0.1644    0.86
Total Effect               0.2145       0.0672       0.3768    0.01
Proportion via Mediation   1.0871       0.4551       3.2314    0.20

Sample Size Used: 100 


Simulations: 999 
```



```r
plot(fitMed)
```

![plot of chunk rerRegressionModMed01](../content/assets/figure/rerRegressionModMed01.png) 


#### Estimation via nonparametric bootstrap


```r
fitMedBoot <- mediate(fitM, fitY, boot=TRUE, sims=999, treat="X", mediator="M")
summary(fitMedBoot)
```

```

Causal Mediation Analysis 

Confidence Intervals Based on Nonparametric Bootstrap

                         Estimate 95% CI Lower 95% CI Upper p-value
Mediation Effect           0.2354       0.1243       0.3847    0.00
Direct Effect             -0.0149      -0.2166       0.1825    0.98
Total Effect               0.2205       0.0440       0.3747    0.00
Proportion via Mediation   1.0675       0.4359       3.6534    0.19

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
