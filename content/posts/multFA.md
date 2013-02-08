---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Exploratory factor analysis"
categories: [Multivariate]
rerCat: Multivariate
tags: [FactorAnalysis]
---




Install required packages
-------------------------

[`GPArotation`](http://cran.r-project.org/package=GPArotation), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`psych`](http://cran.r-project.org/package=psych)


```r
wants <- c("GPArotation", "mvtnorm", "psych")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Factor analysis
-------------------------

### Simulate data

True matrix of loadings


```r
N <- 200
P <- 6
Q <- 2
(Lambda <- matrix(c(0.7,-0.4, 0.8,0, -0.2,0.9, -0.3,0.4, 0.3,0.7, -0.8,0.1),
                  nrow=P, ncol=Q, byrow=TRUE))
```

```
     [,1] [,2]
[1,]  0.7 -0.4
[2,]  0.8  0.0
[3,] -0.2  0.9
[4,] -0.3  0.4
[5,]  0.3  0.7
[6,] -0.8  0.1
```


Non correlated factors


```r
set.seed(1.234)
library(mvtnorm)
Kf <- diag(Q)
mu <- c(5, 15)
FF <- rmvnorm(N, mean=mu,        sigma=Kf)
E  <- rmvnorm(N, mean=rep(0, P), sigma=diag(P))
X  <- FF %*% t(Lambda) + E
```


### Using `factanal()`


```r
(fa <- factanal(X, factors=2, scores="regression"))
```

```

Call:
factanal(x = X, factors = 2, scores = "regression")

Uniquenesses:
[1] 0.635 0.636 0.402 0.790 0.680 0.734

Loadings:
     Factor1 Factor2
[1,] -0.578  -0.177 
[2,] -0.585   0.146 
[3,]  0.441   0.635 
[4,]  0.449         
[5,] -0.132   0.550 
[6,]  0.514         

               Factor1 Factor2
SS loadings      1.355   0.768
Proportion Var   0.226   0.128
Cumulative Var   0.226   0.354

Test of the hypothesis that 2 factors are sufficient.
The chi square statistic is 3.21 on 4 degrees of freedom.
The p-value is 0.524 
```


### Using `fa()` from package `psych` with rotation

Rotation uses package `GPArotation`


```r
library(psych)
corMat <- cor(X)
(faPC  <- fa(r=corMat, nfactors=2, n.obs=N, rotate="varimax"))
```

```
Factor Analysis using method =  minres
Call: fa(r = corMat, nfactors = 2, n.obs = N, rotate = "varimax")
Standardized loadings (pattern matrix) based upon correlation matrix
    MR1   MR2   h2   u2
1 -0.58 -0.18 0.37 0.63
2 -0.58  0.15 0.36 0.64
3  0.44  0.62 0.58 0.42
4  0.45  0.09 0.21 0.79
5 -0.13  0.56 0.33 0.67
6  0.51 -0.05 0.27 0.73

                       MR1  MR2
SS loadings           1.36 0.77
Proportion Var        0.23 0.13
Cumulative Var        0.23 0.35
Proportion Explained  0.64 0.36
Cumulative Proportion 0.64 1.00

Test of the hypothesis that 2 factors are sufficient.

The degrees of freedom for the null model are  15  and the objective function was  0.72 with Chi Square of  141.7
The degrees of freedom for the model are 4  and the objective function was  0.02 

The root mean square of the residuals (RMSR) is  0.02 
The df corrected root mean square of the residuals is  0.06 

The harmonic number of observations is  200 with the empirical chi square  3.02  with prob <  0.55 
The total number of observations was  200  with MLE Chi Square =  3.21  with prob <  0.52 

Tucker Lewis Index of factoring reliability =  1.024
RMSEA index =  0  and the 90 % confidence intervals are  NA 0.097
BIC =  -17.98
Fit based upon off diagonal values = 0.99
Measures of factor score adequacy             
                                                MR1  MR2
Correlation of scores with factors             0.82 0.76
Multiple R square of scores with factors       0.67 0.58
Minimum correlation of possible factor scores  0.34 0.16
```


Factor scores
-------------------------


```r
bartlett <- fa$scores
head(bartlett)
```

```
     Factor1  Factor2
[1,] -0.4199 -0.10818
[2,]  1.3778  1.15775
[3,] -0.5545 -0.48421
[4,] -0.4000  1.39614
[5,] -1.3699 -0.69253
[6,] -0.8303  0.06557
```



```r
anderson <- factor.scores(x=X, f=faPC, method="Anderson")
head(anderson$scores)
```

```
         MR1     MR2
[1,] -0.5035 -0.1182
[2,]  1.6013  1.3819
[3,] -0.6492 -0.5649
[4,] -0.5952  1.8418
[5,] -1.6249 -0.7934
[6,] -1.0224  0.2039
```


Visualize loadings
-------------------------


```r
factor.plot(faPC, cut=0.5)
```

![plot of chunk rerMultFA01](../content/assets/figure/rerMultFA011.png) 

```r
fa.diagram(faPC)
```

![plot of chunk rerMultFA01](../content/assets/figure/rerMultFA012.png) 


Determine number of factors
-------------------------

Parallel analysis and a "very simple structure" analysis provide help in selecting the number of factors. Again, package `psych` has the required functions. `vss()` takes the polychoric correlation matrix as an argument.


```r
fa.parallel(X)                     # parallel analysis
```

![plot of chunk rerMultFA02](../content/assets/figure/rerMultFA021.png) 

```
Parallel analysis suggests that the number of factors =  3  and the number of components =  2 
```

```r
vss(X, n.obs=N, rotate="varimax")  # very simple structure
```

![plot of chunk rerMultFA02](../content/assets/figure/rerMultFA022.png) 

```

Very Simple Structure
Call: VSS(x = x, n = n, rotate = rotate, diagonal = diagonal, fm = fm, 
    n.obs = n.obs, plot = plot, title = title)
VSS complexity 1 achieves a maximimum of 0.54  with  2  factors
VSS complexity 2 achieves a maximimum of 0.69  with  4  factors

The Velicer MAP criterion achieves a minimum of NA  with  1  factors
 
Velicer MAP
[1] 0.06 0.11 0.21 0.41 1.00   NA

Very Simple Structure Complexity 1
[1] 0.48 0.54 0.47 0.52 0.49 0.49

Very Simple Structure Complexity 2
[1] 0.00 0.66 0.67 0.69 0.63 0.63
```


Useful packages
-------------------------

For confirmatory factor analysis (CFA), see packages [`sem`](http://cran.r-project.org/package=sem), [`OpenMx`](http://openmx.psyc.virginia.edu/), and [`lavaan`](http://cran.r-project.org/package=lavaan) which implement structural equation models. More packages can be found in CRAN task view [Psychometric Models](http://cran.r-project.org/web/views/Psychometrics.html).

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:psych))
try(detach(package:GPArotation))
try(detach(package:mvtnorm))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multFA.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multFA.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multFA.R) - [all posts](https://github.com/dwoll/RExRepos/)
