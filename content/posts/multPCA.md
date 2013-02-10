---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Principal components analysis"
categories: [Multivariate]
rerCat: Multivariate
tags: [PCA]
---




Install required packages
-------------------------

[`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`psych`](http://cran.r-project.org/package=psych), [`robustbase`](http://cran.r-project.org/package=robustbase), [`pcaPP`](http://cran.r-project.org/package=pcaPP)


```r
wants <- c("mvtnorm", "psych", "robustbase", "pcaPP")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


PCA
-------------------------
    
### Using `prcomp()`


```r
set.seed(123)
library(mvtnorm)
Sigma <- matrix(c(4, 2, 2, 3), ncol=2)
mu    <- c(1, 2)
N     <- 50
X     <- rmvnorm(N, mean=mu, sigma=Sigma)
```



```r
(pca <- prcomp(X))
```

```
Standard deviations:
[1] 2.115 1.100

Rotation:
        PC1     PC2
[1,] 0.6877 -0.7259
[2,] 0.7259  0.6877
```



```r
summary(pca)
```

```
Importance of components:
                         PC1   PC2
Standard deviation     2.115 1.100
Proportion of Variance 0.787 0.213
Cumulative Proportion  0.787 1.000
```

```r
pca$sdev^2 / sum(diag(cov(X)))
```

```
[1] 0.7871 0.2129
```



```r
plot(pca)
```

![plot of chunk rerMultPCA01](content/assets/figure/rerMultPCA01.png) 


For rotated principal components, see `principal()` from package [`psych`](http://cran.r-project.org/package=psych).

### Using `princomp()`


```r
(pcaPrin <- princomp(X))
```

```
Call:
princomp(x = X)

Standard deviations:
Comp.1 Comp.2 
 2.094  1.089 

 2  variables and  50 observations.
```

```r
(G <- pcaPrin$loadings)
```

```

Loadings:
     Comp.1 Comp.2
[1,]  0.688 -0.726
[2,]  0.726  0.688

               Comp.1 Comp.2
SS loadings       1.0    1.0
Proportion Var    0.5    0.5
Cumulative Var    0.5    1.0
```

```r
pc <- pcaPrin$scores
head(pc)
```

```
     Comp.1  Comp.2
[1,] -1.633  0.4595
[2,]  2.503 -1.4578
[3,]  2.625  1.1630
[4,] -1.499 -1.3124
[5,] -2.191  0.4319
[6,]  2.381 -0.9130
```


### Illustration


```r
Gscl <- G %*% diag(pca$sdev)
ctr  <- colMeans(X)
xMat <- rbind(ctr[1] - Gscl[1, ], ctr[1])
yMat <- rbind(ctr[2] - Gscl[2, ], ctr[2])
ab1  <- solve(cbind(1, xMat[ , 1]), yMat[ , 1])
ab2  <- solve(cbind(1, xMat[ , 2]), yMat[ , 2])
```



```r
plot(X, xlab="x", ylab="y", pch=20, asp=1,
     main="Data und principal components")
abline(coef=ab1, lwd=2, col="gray")
abline(coef=ab2, lwd=2, col="gray")
matlines(xMat, yMat, lty=1, lwd=6, col="blue")
points(ctr[1], ctr[2], pch=16, col="red", cex=3)
legend(x="topleft", legend=c("data", "PC axes", "SDs of PC", "centroid"),
       pch=c(20, NA, NA, 16), lty=c(NA, 1, 1, NA), lwd=c(NA, 2, 2, NA),
       col=c("black", "gray", "blue", "red"), bg="white")
```

![plot of chunk rerMultPCA02](content/assets/figure/rerMultPCA02.png) 


### Approximate data by their principal components

#### Full reproduction using all principal components


```r
Hs   <- scale(pc)
BHs  <- t(Gscl %*% t(Hs))
repr <- sweep(BHs, 2, ctr, "+")
all.equal(X, repr)
```

```
[1] TRUE
```

```r
sum((X-repr)^2)
```

```
[1] 1.925e-29
```


#### Approximation using only the first principal component


```r
BHs1  <- t(Gscl[ , 1] %*% t(Hs[ , 1]))
repr1 <- sweep(BHs1, 2, ctr, "+")
sum((X-repr1)^2)
```

```
[1] 59.28
```

```r
qr(scale(repr1, center=TRUE, scale=FALSE))$rank
```

```
[1] 1
```



```r
plot(X, xlab="x", ylab="y", pch=20, asp=1, main="Data und approximation")
abline(coef=ab1, lwd=2, col="gray")
abline(coef=ab2, lwd=2, col="gray")
segments(X[ , 1], X[ , 2], repr1[ , 1], repr1[ , 2])
points(repr1, pch=1, lwd=2, col="blue", cex=2)
points(ctr[1], ctr[2], pch=16, col="red", cex=3)
legend(x="topleft", legend=c("data", "PC axes", "centroid", "approximation"),
       pch=c(20, NA, 16, 1), lty=c(NA, 1, NA, NA), lwd=c(NA, 2, NA, 2),
       col=c("black", "gray", "red", "blue"), bg="white")
```

![plot of chunk rerMultPCA03](content/assets/figure/rerMultPCA03.png) 


### Approximate the covariance matrix using principal components


```r
Gscl %*% t(Gscl)
```

```
      [,1]  [,2]
[1,] 2.753 1.629
[2,] 1.629 2.930
```

```r
cov(X)
```

```
      [,1]  [,2]
[1,] 2.753 1.629
[2,] 1.629 2.930
```

```r
Gscl[ , 1] %*% t(Gscl[ , 1])
```

```
      [,1]  [,2]
[1,] 2.116 2.233
[2,] 2.233 2.357
```


Robust PCA
-------------------------


```r
library(robustbase)
princomp(X, cov=covMcd(X))
```

```
Call:
princomp(x = X, covmat = covMcd(X))

Standard deviations:
Comp.1 Comp.2 
 2.467  1.047 

 2  variables and  50 observations.
```



```r
library(pcaPP)
PCAproj(X, k=ncol(X), method="qn")
```

```
Call:
PCAproj(x = X, k = ncol(X), method = "qn")

Standard deviations:
Comp.1 Comp.2 
 2.101  1.171 

 2  variables and  50 observations.
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:pcaPP))
try(detach(package:mvtnorm))
try(detach(package:psych))
try(detach(package:robustbase))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multPCA.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multPCA.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multPCA.R) - [all posts](https://github.com/dwoll/RExRepos/)
