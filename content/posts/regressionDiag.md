---
layout: post
title: "Regression diagnostics"
categories: [Univariate, Regression]
rerCat: Univariate
tags: [Regression]
---







TODO
-------------------------

 - link to regression, regressionLogistic

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`lmtest`](http://cran.r-project.org/package=lmtest), [`mvoutlier`](http://cran.r-project.org/package=mvoutlier), [`perturb`](http://cran.r-project.org/package=perturb), [`robustbase`](http://cran.r-project.org/package=robustbase), [`tseries`](http://cran.r-project.org/package=tseries)


```r
wants <- c("car", "lmtest", "mvoutlier", "perturb", "robustbase", "tseries")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Extreme values and outliers
-------------------------
    
### Univariate assessment of outliers
    

{% highlight r %}
set.seed(1.234)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- 0.3*X1 - 0.2*X2 + rnorm(N, 0, 5)
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 5)
dfRegr <- data.frame(X1, X2, X3, Y)
{% endhighlight %}



```r
library(robustbase)
xyMat <- data.matrix(dfRegr)
robXY <- covMcd(xyMat)
XYz   <- scale(xyMat, center=robXY$center, scale=sqrt(diag(robXY$cov)))
summary(XYz)
```

```
       X1                X2                X3                Y          
 Min.   :-2.6127   Min.   :-1.8597   Min.   :-2.6709   Min.   :-2.2947  
 1st Qu.:-0.6963   1st Qu.:-0.6241   1st Qu.:-0.6985   1st Qu.:-0.6727  
 Median :-0.0189   Median :-0.1607   Median : 0.0440   Median :-0.0141  
 Mean   :-0.0245   Mean   :-0.0244   Mean   : 0.0049   Mean   : 0.0069  
 3rd Qu.: 0.6245   3rd Qu.: 0.5025   3rd Qu.: 0.7050   3rd Qu.: 0.6429  
 Max.   : 2.5293   Max.   : 2.2698   Max.   : 2.4814   Max.   : 2.3276  
```


### Multivariate assessment of outliers


```r
mahaSq <- mahalanobis(xyMat, center=robXY$center, cov=robXY$cov)
summary(sqrt(mahaSq))
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  0.547   1.310   1.740   1.840   2.320   3.610 
```


### Multivariate outlier


```r
library(mvoutlier)
aqRes <- aq.plot(xyMat)
```

```
Projection to the first and second robust principal components.
Proportion of total variation (explained variance): 0.6126
```

![plot of chunk rerRegressionDiag01](../content/assets/figure/rerRegressionDiag01.png) 

```r
which(aqRes$outliers)
```

```
integer(0)
```


Leverage and influence
-------------------------


```r
fit <- lm(Y ~ X1 + X2 + X3, data=dfRegr)
h   <- hatvalues(fit)
summary(h)
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.0114  0.0222  0.0359  0.0400  0.0522  0.1200 
```



```r
cooksDst <- cooks.distance(fit)
summary(cooksDst)
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
0.00000 0.00094 0.00309 0.01250 0.01230 0.17200 
```



```r
inflRes <- influence.measures(fit)
summary(inflRes)
```

```
Potentially influential observations of
	 lm(formula = Y ~ X1 + X2 + X3, data = dfRegr) :

   dfb.1_ dfb.X1 dfb.X2 dfb.X3 dffit   cov.r   cook.d hat  
14 -0.22   0.16   0.09   0.11  -0.26    1.13_*  0.02   0.10
45 -0.30   0.33   0.20  -0.29  -0.56    0.81_*  0.07   0.04
61  0.75  -0.61  -0.22  -0.26  -0.86_*  0.83_*  0.17   0.09
74 -0.06   0.10  -0.04  -0.13  -0.15    1.13_*  0.01   0.09
95  0.05  -0.03   0.02  -0.06  -0.10    1.13_*  0.00   0.08
```



```r
library(car)
influenceIndexPlot(fit)
```

![plot of chunk rerRegressionDiag02](../content/assets/figure/rerRegressionDiag02.png) 


Checking model assumptions using residuals
-------------------------


```r
Estnd <- rstandard(fit)
Estud <- rstudent(fit)
```


### Normality assumption


```r
par(mar=c(5, 4.5, 4, 2)+0.1)
hist(Estud, main="Histogram studentized residals", breaks="FD", freq=FALSE)
curve(dnorm(x, mean=0, sd=1), col="red", lwd=2, add=TRUE)
```

![plot of chunk rerRegressionDiag03](../content/assets/figure/rerRegressionDiag03.png) 



```r
qqPlot(Estud, distribution="norm", pch=20, main="QQ-Plot studentized residuals")
qqline(Estud, col="red", lwd=2)
```

![plot of chunk rerRegressionDiag04](../content/assets/figure/rerRegressionDiag04.png) 



```r
shapiro.test(Estud)
```

```

	Shapiro-Wilk normality test

data:  Estud 
W = 0.9798, p-value = 0.1284
```


### Independence and homoscedasticity assumption

#### Spread-level plot


```r
spreadLevelPlot(fit, pch=20)
```

![plot of chunk rerRegressionDiag05](../content/assets/figure/rerRegressionDiag05.png) 

```

Suggested power transformation:  0.6374 
```


#### Durbin-Watson-test for autocorrelation


```r
durbinWatsonTest(fit)
```

```
 lag Autocorrelation D-W Statistic p-value
   1         0.03852         1.911    0.67
 Alternative hypothesis: rho != 0
```


#### Statistical tests for heterocedasticity

Breusch-Pagan-Test


```r
library(lmtest)
bptest(fit)
```

```

	studentized Breusch-Pagan test

data:  fit 
BP = 1.472, df = 3, p-value = 0.6887
```


Score-test for non-constant error variance


```r
ncvTest(fit)
```

```
Error: object 'dfRegr' not found
```


### Linearity assumption

White-test


```r
library(tseries)
white.test(dfRegr$X1, dfRegr$Y)
```

```

	White Neural Network Test

data:  dfRegr$X1 and dfRegr$Y 
X-squared = 0.8764, df = 2, p-value = 0.6452
```



```r
white.test(dfRegr$X2, dfRegr$Y)
white.test(dfRegr$X3, dfRegr$Y)
# not run
```


### Response transformations


```r
lamObj  <- powerTransform(fit, family="bcPower")
(lambda <- coef(lamObj))
```

```
  Y1 
1.49 
```

```r
yTrans <- bcPower(dfRegr$Y, lambda)
```


Multicollinearity
-------------------------

### Pairwise correlations between predictor variables


```r
X   <- data.matrix(subset(dfRegr, select=c("X1", "X2", "X3")))
(Rx <- cor(X))
```

```
           X1         X2      X3
X1  1.0000000 -0.0009943  0.3411
X2 -0.0009943  1.0000000 -0.3080
X3  0.3410580 -0.3080062  1.0000
```


### Variance inflation factor


```r
vif(fit)
```

```
   X1    X2    X3 
1.147 1.120 1.267 
```


### Condition indexes

$\kappa$


```r
fitScl <- lm(scale(Y) ~ scale(X1) + scale(X2) + scale(X3), data=dfRegr)
kappa(fitScl, exact=TRUE)
```

```
[1] 1.643
```



```r
library(perturb)
colldiag(fit, scale=TRUE, center=FALSE)
```

```
Condition
Index	Variance Decomposition Proportions
          intercept X1    X2    X3   
1   1.000 0.000     0.000 0.003 0.001
2   8.437 0.001     0.001 0.720 0.044
3  23.685 0.044     0.027 0.277 0.912
4  80.709 0.955     0.972 0.000 0.044
```


### Using package `perturb`


```r
attach(dfRegr)
pRes <- perturb(fit, pvars=c("X1", "X2", "X3"), prange=c(1, 1, 1))
```

```
Error: object 'dfRegr' not found
```

```r
summary(pRes)
```

```
Error: error in evaluating the argument 'object' in selecting a method for
function 'summary': Error: object 'pRes' not found
```

```r
detach(dfRegr)
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:tseries))
try(detach(package:lmtest))
try(detach(package:zoo))
try(detach(package:perturb))
try(detach(package:mvoutlier))
try(detach(package:robCompositions))
try(detach(package:compositions))
try(detach(package:rgl))
try(detach(package:tensorA))
try(detach(package:energy))
try(detach(package:boot))
try(detach(package:rrcov))
try(detach(package:pcaPP))
try(detach(package:robustbase))
try(detach(package:mvtnorm))
try(detach(package:sgeostat))
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/regressionDiag.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/regressionDiag.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/regressionDiag.R) - [all posts](https://github.com/dwoll/RExRepos/)
