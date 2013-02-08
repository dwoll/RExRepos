---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Assess univariate and multivariate normality"
categories: [Univariate]
rerCat: Univariate
tags: [ANOVA, tTests]
---




Install required packages
-------------------------

[`energy`](http://cran.r-project.org/package=energy), [`ICS`](http://cran.r-project.org/package=ICS), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`nortest`](http://cran.r-project.org/package=nortest), [`QuantPsyc`](http://cran.r-project.org/package=QuantPsyc), [`tseries`](http://cran.r-project.org/package=tseries)


```r
wants <- c("energy", "ICS", "mvtnorm", "nortest", "QuantPsyc", "tseries")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Univariate normality
-------------------------

### QQ-plot


```r
set.seed(1.234)
DV <- rnorm(20, mean=1.5, sd=3)
qqnorm(DV, pch=20, cex=2)
qqline(DV, col="gray60", lwd=2)
```

![plot of chunk rerNormality01](../content/assets/figure/rerNormality01.png) 


### Shapiro-Wilk-test

Composite null hypothesis: any normal distribution


```r
shapiro.test(DV)
```

```

	Shapiro-Wilk normality test

data:  DV 
W = 0.9533, p-value = 0.4195
```


### Anderson-Darling-test

Composite null hypothesis: any normal distribution


```r
library(nortest)
ad.test(DV)
```

```

	Anderson-Darling normality test

data:  DV 
A = 0.2918, p-value = 0.5704
```


### Cramer-von-Mises-test

Composite null hypothesis: any normal distribution


```r
library(nortest)
cvm.test(DV)
```

```

	Cramer-von Mises normality test

data:  DV 
W = 0.0402, p-value = 0.6588
```


### Shapiro-Francia-test

Composite null hypothesis: any normal distribution


```r
library(nortest)
sf.test(DV)
```

```

	Shapiro-Francia normality test

data:  DV 
W = 0.9475, p-value = 0.2818
```


### Jarque-Bera-test

Composite null hypothesis: any normal distribution


```r
library(tseries)
jarque.bera.test(DV)
```

```

	Jarque Bera Test

data:  DV 
X-squared = 2.073, df = 2, p-value = 0.3547
```


### Kolmogorov-Smirnov-test

Exact null hypothesis: fully specified normal distribution


```r
ks.test(DV, "pnorm", mean=1, sd=2, alternative="two.sided")
```

```

	One-sample Kolmogorov-Smirnov test

data:  DV 
D = 0.3216, p-value = 0.0243
alternative hypothesis: two-sided 
```


### Lilliefors-test

Composite null hypothesis: any normal distribution


```r
library(nortest)
lillie.test(DV)
```

```

	Lilliefors (Kolmogorov-Smirnov) normality test

data:  DV 
D = 0.1105, p-value = 0.7535
```


### Pearson $\chi^{2}$-test

Tests weaker null hypothesis (any distribution with the same probabilities for the given class intervals).

Wrong: `pearson.test()` does not use grouped ML-estimate or maximum $\chi^{2}$-estimate


```r
library(nortest)
pearson.test(DV, n.classes=6, adjust=TRUE)
```

```

	Pearson chi-square normality test

data:  DV 
P = 0.4, p-value = 0.9402
```


Multivariate normality
-------------------------

### Energy-test


```r
mu    <- c(2, 4, 5)
Sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,9), byrow=TRUE, ncol=3)
library(mvtnorm)
X <- rmvnorm(100, mu, Sigma)
```



```r
library(energy)                    # for mvnorm.etest()
mvnorm.etest(X)
```

```

	Energy test of multivariate normality: estimated parameters

data:  x, sample size 100, dimension 3, replicates 999 
E-statistic = 0.7563, p-value = 0.7548
```


### Mardia-Kurtosis-test


```r
library(QuantPsyc)                 # for mult.norm()
mn <- mult.norm(X, chicrit=0.001)
mn$mult.test
```

```
         Beta-hat   kappa  p-val
Skewness   0.3525  5.8750 0.8257
Kurtosis  14.3929 -0.5542 0.5794
```


### Kurtosis- and skew-test

#### Kurtosis-test


```r
library(ICS)
mvnorm.kur.test(X)
```

```

	Multivariate Normality Test Based on Kurtosis

data:  X 
W = 3.679, w1 = 1.12, df1 = 5.00, w2 = 1.60, df2 = 1.00, p-value =
0.7981
```


#### Skew-test

```r
library(ICS)
X <- rmvnorm(100, c(2, 4, 5))
mvnorm.skew.test(X)
```

```

	Multivariate Normality Test Based on Skewness

data:  X 
U = 1.457, df = 3, p-value = 0.6922
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:nortest))
try(detach(package:QuantPsyc))
try(detach(package:tseries))
try(detach(package:energy))
try(detach(package:boot))
try(detach(package:MASS))
try(detach(package:ICS))
try(detach(package:mvtnorm))
try(detach(package:survey))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/normality.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/normality.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/normality.R) - [all posts](https://github.com/dwoll/RExRepos/)
