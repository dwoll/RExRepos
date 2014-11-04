---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Moderated and mediated linear regression"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression]
---

Moderated and mediated linear regression
=========================

TODO
-------------------------

 - link to regression, regressionDiag

Install required packages
-------------------------

[`mediation`](http://cran.r-project.org/package=mediation), [`multilevel`](http://cran.r-project.org/package=multilevel), [`rockchalk`](http://cran.r-project.org/package=rockchalk)


```r
wants <- c("mediation", "multilevel", "rockchalk")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```
    
Moderated regression
-------------------------


```r
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- abs(rnorm(N, 60, 30))
M  <- rnorm(N,  30, 8)
Y  <- 0.5*X1 - 0.3*M - 0.4*X2 + 10 + rnorm(N, 0, 3)
```


```r
X1c    <- c(scale(X1, center=TRUE, scale=FALSE))
Mc     <- c(scale(M,  center=TRUE, scale=FALSE))
fitMod <- lm(Y ~ X1c + Mc + X1c:Mc)
coef(summary(fitMod))
```

```
              Estimate Std. Error   t value     Pr(>|t|)
(Intercept) 65.4617132 1.19492420 54.783151 3.154328e-74
X1c          0.6086687 0.19071197  3.191560 1.912979e-03
Mc          -0.3591561 0.15821174 -2.270097 2.543797e-02
X1c:Mc      -0.0377977 0.02323204 -1.626964 1.070227e-01
```



```r
library(rockchalk)
ps  <- plotSlopes(fitMod, plotx="X1c", modx="Mc", modxVals="std.dev")
```

![plot of chunk moderation](../content/assets/figure/moderation-1.png) 

```r
(ts <- testSlopes(ps))
```

```
Values of Mc INSIDE this interval:
        lo         hi 
-62.927712   5.172316 
cause the slope of (b1 + b2*Mc)X1c to be statistically significant
```

```
$hypotests
       "Mc"     slope Std. Error  t value    Pr(>|t|)
(m-sd) -7.6 0.8959312   0.280258 3.196809 0.001881830
(m)     0.0 0.6086687   0.190712 3.191560 0.001912979
(m+sd)  7.6 0.3214062   0.237796 1.351605 0.179677937

$jn
$jn$a
       X1c:Mc 
-0.0006979488 

$jn$b
        X1c 
-0.04031031 

$jn$c
      X1c 
0.2271698 

$jn$inroot
        X1c 
0.002259132 

$jn$roots
        lo         hi 
-62.927712   5.172316 


$pso
$call
plotSlopes.lm(model = fitMod, plotx = "X1c", modx = "Mc", modxVals = "std.dev")

$newdata
        X1c   Mc      fit
1 -16.79702 -7.6 53.14232
2 -16.79702  0.0 55.23789
3 -16.79702  7.6 57.33346
4  14.67849 -7.6 81.34222
5  14.67849  0.0 74.39605
6  14.67849  7.6 67.44989

$modxVals
(m-sd)    (m) (m+sd) 
  -7.6    0.0    7.6 

$col
(m-sd)    (m) (m+sd) 
     1      2      3 

$lty
(m-sd)    (m) (m+sd) 
     1      2      3 

attr(,"class")
[1] "plotSlopes" "rockchalk" 

attr(,"class")
[1] "testSlopes"
```

```r
plot(ts)
```

![plot of chunk moderation](../content/assets/figure/moderation-2.png) 

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
     Min       1Q   Median       3Q      Max 
-12.4088  -3.5870   0.0208   3.5566  12.6895 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)   
(Intercept) -1.69901   13.52495  -0.126  0.90029   
X            0.05606    0.12139   0.462  0.64525   
M            0.32752    0.11343   2.887  0.00479 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 5.183 on 97 degrees of freedom
Multiple R-squared:  0.2223,	Adjusted R-squared:  0.2063 
F-statistic: 13.86 on 2 and 97 DF,  p-value: 5.066e-06
```

### Sobel test


```r
library(multilevel)
sobel(dfMed$X, dfMed$M, dfMed$Y)
```

```
$`Mod1: Y~X`
              Estimate Std. Error    t value     Pr(>|t|)
(Intercept) -9.8283102 13.7149511 -0.7166129 4.753174e-01
pred         0.3311861  0.0779808  4.2470206 4.933825e-05

$`Mod2: Y~X+M`
               Estimate Std. Error    t value    Pr(>|t|)
(Intercept) -1.69900547 13.5249478 -0.1256201 0.900292638
pred         0.05606161  0.1213932  0.4618182 0.645245742
med          0.32751615  0.1134279  2.8874394 0.004788962

$`Mod3: M~X`
               Estimate  Std. Error   t value     Pr(>|t|)
(Intercept) -24.8210806 11.78103163 -2.106868 3.768266e-02
pred          0.8400333  0.06698488 12.540641 4.315325e-22

$Indirect.Effect
[1] 0.2751245

$SE
[1] 0.09777623

$z.value
[1] 2.813817

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
ACME             0.2731       0.0685       0.4673    0.01
ADE              0.0577      -0.1790       0.2946    0.67
Total Effect     0.3307       0.1782       0.4917    0.00
Prop. Mediated   0.8303       0.1934       1.8214    0.01

Sample Size Used: 100 


Simulations: 999 
```


```r
plot(fitMed)
```

![plot of chunk rerRegressionModMed01](../content/assets/figure/rerRegressionModMed01-1.png) 

#### Estimation via nonparametric bootstrap


```r
fitMedBoot <- mediate(fitM, fitY, boot=TRUE, sims=999, treat="X", mediator="M")
summary(fitMedBoot)
```

```

Causal Mediation Analysis 

Nonparametric Bootstrap Confidence Intervals with the Percentile Method

               Estimate 95% CI Lower 95% CI Upper p-value
ACME             0.2751       0.0685       0.4681    0.02
ADE              0.0561      -0.1809       0.3059    0.67
Total Effect     0.3312       0.1374       0.5008    0.00
Prop. Mediated   0.8307       0.1890       2.0355    0.02

Sample Size Used: 100 


Simulations: 999 
```

Useful packages
-------------------------

More complex structural equation models are supported by packages [`sem`](http://cran.r-project.org/package=sem), [`OpenMx`](http://openmx.psyc.virginia.edu/), and [`lavaan`](http://cran.r-project.org/package=lavaan). More packages can be found in CRAN task view [Psychometric Models](http://cran.r-project.org/web/views/Psychometrics.html).

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:rockchalk))
try(detach(package:mediation))
try(detach(package:Matrix))
try(detach(package:lpSolve))
try(detach(package:multilevel))
try(detach(package:MASS))
try(detach(package:nlme))
try(detach(package:sandwich))
try(detach(package:mvtnorm))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionModMed.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionModMed.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionModMed.R) - [all posts](https://github.com/dwoll/RExRepos/)
