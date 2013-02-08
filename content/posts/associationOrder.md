---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Association tests and measures for ordered categorical variables"
categories: [Descriptive]
rerCat: Descriptive
tags: [Association]
---




TODO
-------------------------

 - link to correlation, association, diagCategorical

Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`polycor`](http://cran.r-project.org/package=polycor), [`pROC`](http://cran.r-project.org/package=pROC), [`rms`](http://cran.r-project.org/package=rms)


```r
wants <- c("coin", "mvtnorm", "polycor", "pROC", "rms")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Linear-by-linear association test
-------------------------


```r
set.seed(1.234)
library(mvtnorm)
N     <- 100
Sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,9), byrow=TRUE, ncol=3)
mu    <- c(-3, 2, 4)
Xdf   <- data.frame(rmvnorm(n=N, mean=mu, sigma=Sigma))
```



```r
lOrd   <- lapply(Xdf, function(x) {
                 cut(x, breaks=quantile(x), include.lowest=TRUE,
                     ordered=TRUE, labels=LETTERS[1:4]) })
dfOrd  <- data.frame(lOrd)
matOrd <- data.matrix(dfOrd)
```



```r
cTab <- xtabs(~ X1 + X3, data=dfOrd)
addmargins(cTab)
```

```
     X3
X1      A   B   C   D Sum
  A     3   3   5  14  25
  B     6   6   7   6  25
  C     6   8   9   2  25
  D    10   8   4   3  25
  Sum  25  25  25  25 100
```

```r
library(coin)
lbl_test(cTab, distribution=approximate(B=9999))
```

```

	Approximative Linear-by-Linear Association Test

data:  X3 (ordered) by X1 (A < B < C < D) 
chi-squared = 14.6, p-value = 1e-04
```


Polychoric and polyserial correlation
-------------------------

### Polychoric correlation


```r
library(polycor)
polychor(dfOrd$X1, dfOrd$X2, ML=TRUE)
```

```
[1] 0.1989
```



```r
polychor(cTab, ML=TRUE)
```

```
[1] -0.4522
```


### Polyserial correlation


```r
library(polycor)
polyserial(Xdf$X2, dfOrd$X3)
```

```
[1] -0.09123
```


### Heterogeneous correlation matrices


```r
library(polycor)
Xdf2   <- rmvnorm(n=N, mean=mu, sigma=Sigma)
dfBoth <- cbind(Xdf2, dfOrd)
hetcor(dfBoth, ML=TRUE)
```

```

Maximum-Likelihood Estimates

Correlations/Type of Correlation:
        1       2       3         X1         X2         X3
1       1 Pearson Pearson Polyserial Polyserial Polyserial
2   0.297       1 Pearson Polyserial Polyserial Polyserial
3  -0.589 -0.0949       1 Polyserial Polyserial Polyserial
X1 0.0405  0.0549  -0.222          1 Polychoric Polychoric
X2  0.133   0.136 -0.0696      0.199          1 Polychoric
X3 0.0748  -0.101   0.098     -0.452     -0.079          1

Standard Errors:
        1      2     3     X1    X2
1                                  
2  0.0916                          
3  0.0659 0.0994                   
X1  0.108  0.109 0.104             
X2  0.106  0.107 0.108  0.113      
X3  0.109  0.107 0.107 0.0965 0.115

n = 100 

P-values for Tests of Bivariate Normality:
        1     2     3    X1    X2
1                                
2   0.204                        
3   0.149 0.665                  
X1  0.141 0.786 0.227            
X2  0.451 0.874 0.146  0.51      
X3 0.0371 0.879 0.156 0.626 0.635
```


Association measures involving categorical and continuous variables
-------------------------

### AUC, Kendall's $\tau_{a}$, Somers' $D_{xy}$, Goodman & Kruskal's $\gamma$

One continuous variable and one dichotomous variable


```r
N   <- 100
x   <- rnorm(N)
y   <- x + rnorm(N, 0, 2)
yDi <- ifelse(y <= median(y), 0, 1)
```

Nagelkerke's pseudo-$R^{2}$ (R2), area under the ROC-Kurve (C), Somers' $D_{xy}$ (Dxy), Goodman & Kruskal's $\gamma$ (gamma), Kendall's $\tau$ (tau-a)


```r
library(rms)
lrm(yDi ~ x)$stats
```

```
       Obs  Max Deriv Model L.R.       d.f.          P          C 
 1.000e+02  2.617e-09  2.877e+00  1.000e+00  8.985e-02  6.010e-01 
       Dxy      Gamma      Tau-a         R2      Brier          g 
 2.020e-01  2.034e-01  1.020e-01  3.781e-02  2.429e-01  3.931e-01 
        gr         gp 
 1.482e+00  9.588e-02 
```


### Area under the ROC-curve (AUC)


```r
library(pROC)
(rocRes <- roc(yDi ~ x, plot=TRUE, ci=TRUE, main="ROC-curve",
               xlab="specificity (TN / (TN+FP))", ylab="sensitivity (TP / (TP+FN))"))
```

```

Call:
roc.formula(formula = yDi ~ x, plot = TRUE, ci = TRUE, main = "ROC-curve",     xlab = "specificity (TN / (TN+FP))", ylab = "sensitivity (TP / (TP+FN))")

Data: x in 50 controls (yDi 0) < 50 cases (yDi 1).
Area under the curve: 0.601
95% CI: 0.488-0.715 (DeLong)
```

```r
rocCI <- ci.se(rocRes)
plot(rocCI, type="shape")
```

![plot of chunk associationOrder01](../content/assets/figure/associationOrder01.png) 


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:pROC))
try(detach(package:plyr))
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:polycor))
try(detach(package:sfsmisc))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/associationOrder.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/associationOrder.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/associationOrder.R) - [all posts](https://github.com/dwoll/RExRepos/)
