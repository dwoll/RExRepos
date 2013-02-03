---
layout: post
title: "Linear algebra calculations"
categories: [Multivariate]
rerCat: Multivariate
tags: [Multivariate]
---




Install required packages
-------------------------

[`expm`](http://cran.r-project.org/package=expm), [`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`pracma`](http://cran.r-project.org/package=pracma)


```r
wants <- c("expm", "mvtnorm", "pracma")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Matrix algebra
-------------------------

### Transpose


```r
N  <- 4
Q  <- 2
(X <- matrix(c(20, 26, 10, 19, 29, 27, 20, 12), nrow=N, ncol=Q))
```

```
     [,1] [,2]
[1,]   20   29
[2,]   26   27
[3,]   10   20
[4,]   19   12
```

```r
t(X)
```

```
     [,1] [,2] [,3] [,4]
[1,]   20   26   10   19
[2,]   29   27   20   12
```


### Extracting the diagnoal and creating a diagonal matrix


```r
diag(cov(X))
```

```
[1] 43.58 59.33
```

```r
diag(1:3)
```

```
     [,1] [,2] [,3]
[1,]    1    0    0
[2,]    0    2    0
[3,]    0    0    3
```

```r
diag(2)
```

```
     [,1] [,2]
[1,]    1    0
[2,]    0    1
```


### Multiplication


```r
(Xc <- diag(N) - matrix(rep(1/N, N^2), nrow=N))
```

```
      [,1]  [,2]  [,3]  [,4]
[1,]  0.75 -0.25 -0.25 -0.25
[2,] -0.25  0.75 -0.25 -0.25
[3,] -0.25 -0.25  0.75 -0.25
[4,] -0.25 -0.25 -0.25  0.75
```

```r
(Xdot <- Xc %*% X)
```

```
      [,1] [,2]
[1,]  1.25    7
[2,]  7.25    5
[3,] -8.75   -2
[4,]  0.25  -10
```

```r
(SSP <- t(Xdot) %*% Xdot)
```

```
      [,1] [,2]
[1,] 130.8   60
[2,]  60.0  178
```

```r
crossprod(Xdot)
```

```
      [,1] [,2]
[1,] 130.8   60
[2,]  60.0  178
```



```r
(1/(N-1)) * SSP
```

```
      [,1]  [,2]
[1,] 43.58 20.00
[2,] 20.00 59.33
```

```r
(S <- cov(X))
```

```
      [,1]  [,2]
[1,] 43.58 20.00
[2,] 20.00 59.33
```

```r
Ds <- diag(1/sqrt(diag(S)))
Ds %*% S %*% Ds
```

```
       [,1]   [,2]
[1,] 1.0000 0.3933
[2,] 0.3933 1.0000
```

```r
cov2cor(S)
```

```
       [,1]   [,2]
[1,] 1.0000 0.3933
[2,] 0.3933 1.0000
```



```r
b <- 2
a <- c(-2, 1)
sweep(b*X, 2, a, "+")
```

```
     [,1] [,2]
[1,]   38   59
[2,]   50   55
[3,]   18   41
[4,]   36   25
```

```r
colLens <- sqrt(colSums(X^2))
sweep(X, 2, colLens, "/")
```

```
       [,1]   [,2]
[1,] 0.5101 0.6307
[2,] 0.6632 0.5872
[3,] 0.2551 0.4350
[4,] 0.4846 0.2610
```

```r
X %*% diag(1/colLens)
```

```
       [,1]   [,2]
[1,] 0.5101 0.6307
[2,] 0.6632 0.5872
[3,] 0.2551 0.4350
[4,] 0.4846 0.2610
```


### Power


```r
B <- cbind(c(1,1,1), c(0,2,0), c(0,0,2))
B %*% B %*% B
```

```
     [,1] [,2] [,3]
[1,]    1    0    0
[2,]    7    8    0
[3,]    7    0    8
```

```r
library(expm)
B %^% 3
```

```
     [,1] [,2] [,3]
[1,]    1    0    0
[2,]    7    8    0
[3,]    7    0    8
```


### Cross product


```r
a <- c(1, 2, 3)
b <- c(4, 5, 6)
library(pracma)
cross(a, b)
```

```
[1] -3  6 -3
```


Solving linear equations and calculating the inverse
-------------------------

### Inverse


```r
Y     <- matrix(c(1, 1, 1, -1), nrow=2)
(Yinv <- solve(Y))
```

```
     [,1] [,2]
[1,]  0.5  0.5
[2,]  0.5 -0.5
```

```r
Y %*% Yinv
```

```
     [,1] [,2]
[1,]    1    0
[2,]    0    1
```


### Moore-Penrose generalized inverse


```r
library(MASS)
gInv <- ginv(X)
zapsmall(gInv %*% X)
```

```
     [,1] [,2]
[1,]    1    0
[2,]    0    1
```


### Solving linear equations


```r
A  <- matrix(c(9, 1, -5, 0), nrow=2)
b  <- c(5, -3)
(x <- solve(A, b))
```

```
[1] -3.0 -6.4
```

```r
A %*% x
```

```
     [,1]
[1,]    5
[2,]   -3
```


Norms and distances of matrices and vectors
-------------------------

### Norm


```r
a1 <- c(3, 4, 1, 8, 2)
sqrt(crossprod(a1))
```

```
      [,1]
[1,] 9.695
```

```r
sqrt(sum(a1^2))
```

```
[1] 9.695
```



```r
a2 <- c(6, 9, 10, 8, 7)
A  <- cbind(a1, a2)
sqrt(diag(crossprod(A)))
```

```
    a1     a2 
 9.695 18.166 
```

```r
sqrt(colSums(A^2))
```

```
    a1     a2 
 9.695 18.166 
```



```r
norm(A, type="F")
```

```
[1] 20.59
```

```r
sqrt(crossprod(c(A)))
```

```
      [,1]
[1,] 20.59
```


### Distance

Length of difference vector


```r
set.seed(1.234)
B <- matrix(sample(-20:20, 12, replace=TRUE), ncol=3)
sqrt(crossprod(B[1, ] - B[2, ]))
```

```
      [,1]
[1,] 36.58
```



```r
dist(B, diag=TRUE, upper=TRUE)
```

```
      1     2     3     4
1  0.00 36.58 36.85 37.60
2 36.58  0.00 10.20 24.29
3 36.85 10.20  0.00 17.83
4 37.60 24.29 17.83  0.00
```


### Mahalanobis-transformation


```r
library(mvtnorm)
N     <- 100
mu    <- c(-3, 2, 4)
sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,9), byrow=TRUE, ncol=3)
Y     <- round(rmvnorm(N, mean=mu, sigma=sigma))
```



```r
ctr   <- colMeans(Y)
S     <- cov(Y)
Seig  <- eigen(S)
sqrtD <- sqrt(Seig$values)
SsqrtInv <- Seig$vectors %*% diag(1/sqrtD) %*% t(Seig$vectors)

Xdot  <- sweep(Y, 2, ctr, "-")
Xmt   <- t(SsqrtInv %*% t(Xdot))
zapsmall(cov(Xmt))
```

```
     [,1] [,2] [,3]
[1,]    1    0    0
[2,]    0    1    0
[3,]    0    0    1
```

```r
colMeans(Xmt)
```

```
[1] 2.848e-17 3.308e-17 9.853e-17
```


### Mahalanobis-distance


```r
ideal <- c(1, 2, 3)
y1    <- Y[1, ]
y2    <- Y[2, ]
mat   <- rbind(y1, y2)
```



```r
mahalanobis(mat, ideal, S)
```

```
   y1    y2 
3.157 7.695 
```



```r
Sinv <- solve(S)
t(y1-ideal) %*% Sinv %*% (y1-ideal)
```

```
      [,1]
[1,] 3.157
```

```r
t(y2-ideal) %*% Sinv %*% (y2-ideal)
```

```
      [,1]
[1,] 7.695
```



```r
mDist <- mahalanobis(Y, ideal, S)
min(mDist)
```

```
[1] 0.4971
```

```r
(idxMin <- which.min(mDist))
```

```
[1] 52
```

```r
Y[idxMin, ]
```

```
[1] 1 4 2
```



```r
idealM <- t(SsqrtInv %*% (ideal - ctr))
crossprod(Xmt[1, ] - t(idealM))
```

```
      [,1]
[1,] 3.157
```

```r
crossprod(Xmt[2, ] - t(idealM))
```

```
      [,1]
[1,] 7.695
```


Trace, determinant, rank, null space, condition index
-------------------------

### Trace


```r
(A <- matrix(c(9, 1, 1, 4), nrow=2))
```

```
     [,1] [,2]
[1,]    9    1
[2,]    1    4
```

```r
sum(diag(A))
```

```
[1] 13
```

```r
sum(diag(t(A) %*% A))
```

```
[1] 99
```

```r
sum(diag(A %*% t(A)))
```

```
[1] 99
```

```r
sum(A^2)
```

```
[1] 99
```


### Determinant


```r
det(A)
```

```
[1] 35
```

```r
B <- matrix(c(-3, 4, -1, 7), nrow=2)
all.equal(det(A %*% B), det(A) * det(B))
```

```
[1] TRUE
```

```r
det(diag(1:4))
```

```
[1] 24
```

```r
Ainv <- solve(A)
all.equal(1/det(A), det(Ainv))
```

```
[1] TRUE
```


### Rank


```r
qrA <- qr(A)
qrA$rank
```

```
[1] 2
```



```r
(eigA <- eigen(A))
```

```
$values
[1] 9.193 3.807

$vectors
        [,1]    [,2]
[1,] -0.9820  0.1891
[2,] -0.1891 -0.9820
```

```r
zapsmall(eigA$vectors %*% t(eigA$vectors))
```

```
     [,1] [,2]
[1,]    1    0
[2,]    0    1
```

```r
sum(eigA$values)
```

```
[1] 13
```

```r
prod(eigA$values)
```

```
[1] 35
```


### Null space (kernel)


```r
library(MASS)
Xnull <- Null(X)
t(X) %*% Xnull
```

```
           [,1]      [,2]
[1,] -2.762e-15 1.443e-15
[2,] -2.609e-15 4.441e-16
```


### Condition index


```r
X <- matrix(c(20, 26, 10, 19, 29, 27, 20, 12, 17, 23, 27, 25), nrow=4)
kappa(X, exact=TRUE)
```

```
[1] 7.932
```

```r
Xplus <- solve(t(X) %*% X) %*% t(X)
base::norm(X, type="2") * base::norm(Xplus, type="2")
```

```
[1] 7.932
```



```r
evX <- eigen(t(X) %*% X)$values
sqrt(max(evX) / min(evX[evX >= .Machine$double.eps]))
```

```
[1] 7.932
```

```r
sqrt(evX / min(evX[evX >= .Machine$double.eps]))
```

```
[1] 7.932 1.503 1.000
```


Matrix decompositions
-------------------------

### Eigenvalues and eigenvectors


```r
X  <- matrix(c(20, 26, 10, 19, 29, 27, 20, 12, 17, 23, 27, 25), nrow=4)
(S <- cov(X))
```

```
       [,1]   [,2]   [,3]
[1,]  43.58  20.00 -14.00
[2,]  20.00  59.33 -23.33
[3,] -14.00 -23.33  18.67
```

```r
eigS <- eigen(S)
G    <- eigS$vectors
D    <- diag(eigS$values)
G %*% D %*% t(G)
```

```
       [,1]   [,2]   [,3]
[1,]  43.58  20.00 -14.00
[2,]  20.00  59.33 -23.33
[3,] -14.00 -23.33  18.67
```


### Singular value decomposition


```r
svdX <- svd(X)
all.equal(X, svdX$u %*% diag(svdX$d) %*% t(svdX$v))
```

```
[1] TRUE
```

```r
all.equal(sqrt(eigen(t(X) %*% X)$values), svdX$d)
```

```
[1] TRUE
```


### Cholesky decomposition


```r
R <- chol(S)
all.equal(S, t(R) %*% R)
```

```
[1] TRUE
```


### $QR$-decomposition


```r
qrX <- qr(X)
Q   <- qr.Q(qrX)
R   <- qr.R(qrX)
all.equal(X, Q %*% R)
```

```
[1] TRUE
```


### Square-root


```r
library(expm)
sqrtm(S)
```

```
$B
       [,1]   [,2]   [,3]
[1,]  6.373  1.294 -1.139
[2,]  1.294  7.328 -1.989
[3,] -1.139 -1.989  3.663

$Binv
        [,1]     [,2]    [,3]
[1,]  0.1682 -0.01820 0.04240
[2,] -0.0182  0.16202 0.08232
[3,]  0.0424  0.08232 0.33091

$k
[1] 7

$acc
[1] 2.313e-10
```



```r
sqrtD <- diag(sqrt(eigS$values))
(A <- G %*% sqrtD %*% t(G))
```

```
       [,1]   [,2]   [,3]
[1,]  6.373  1.294 -1.139
[2,]  1.294  7.328 -1.989
[3,] -1.139 -1.989  3.663
```

```r
A %*% A
```

```
       [,1]   [,2]   [,3]
[1,]  43.58  20.00 -14.00
[2,]  20.00  59.33 -23.33
[3,] -14.00 -23.33  18.67
```


### $X = N N^{t}$


```r
N <- eigS$vectors %*% sqrt(diag(eigS$values))
N %*% t(N)
```

```
       [,1]   [,2]   [,3]
[1,]  43.58  20.00 -14.00
[2,]  20.00  59.33 -23.33
[3,] -14.00 -23.33  18.67
```


Orthogonal projections
-------------------------

### Direct implementation of $(X^{t} X)^{-1} X^{t}$


```r
X    <- matrix(c(20, 26, 10, 19, 29, 27, 20, 12, 17, 23, 27, 25), nrow=4)
ones <- rep(1, nrow(X))
P1   <- ones %*% solve(t(ones) %*% ones) %*% t(ones)
P1x  <- P1 %*% X
head(P1x)
```

```
      [,1] [,2] [,3]
[1,] 18.75   22   23
[2,] 18.75   22   23
[3,] 18.75   22   23
[4,] 18.75   22   23
```



```r
a  <- ones / sqrt(crossprod(ones))
P2 <- a %*% t(a)
all.equal(P1, P2)
```

```
[1] TRUE
```



```r
IP1  <- diag(nrow(X)) - P1
IP1x <- IP1 %*% X
all.equal(IP1x, sweep(X, 2, colMeans(X), "-"))
```

```
[1] TRUE
```



```r
A   <- cbind(c(1, 0, 0), c(0, 1, 0))
P3  <- A %*% solve(t(A) %*% A) %*% t(A)
Px3 <- t(P3 %*% t(X))
Px3[1:3, ]
```

```
     [,1] [,2] [,3]
[1,]   20   29    0
[2,]   26   27    0
[3,]   10   20    0
```


### Numerically stable implementation using the $QR$-decomposition


```r
qrX   <- qr(X)
Q     <- qr.Q(qrX)
R     <- qr.R(qrX)
Xplus <- solve(t(X) %*% X) %*% t(X)
all.equal(Xplus, solve(R) %*% t(Q))
```

```
[1] TRUE
```

```r
all.equal(X %*% Xplus, tcrossprod(Q))
```

```
[1] TRUE
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:MASS))
try(detach(package:expm))
try(detach(package:Matrix))
try(detach(package:lattice))
try(detach(package:pracma))
try(detach(package:mvtnorm))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/linearAlgebra.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/linearAlgebra.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/linearAlgebra.R) - [all posts](https://github.com/dwoll/RExRepos/)
