---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Arithmetic with matrices"
categories: [RBasics]
rerCat: R_Basics
tags: [Matrix]
---




TODO
-------------------------

 - link to linearAlgebra

Sums and means
-------------------------


```r
age    <- c(19, 19, 31, 19, 24)
weight <- c(95, 76, 94, 76, 76)
height <- c(197, 178, 189, 184, 173)
(mat   <- cbind(age, weight, height))
```

```
     age weight height
[1,]  19     95    197
[2,]  19     76    178
[3,]  31     94    189
[4,]  19     76    184
[5,]  24     76    173
```


```r
sum(mat)
```

```
[1] 1450
```

```r
rowSums(mat)
```

```
[1] 311 273 314 279 273
```

```r
mean(mat)
```

```
[1] 96.66667
```

```r
colMeans(mat)
```

```
   age weight height 
  22.4   83.4  184.2 
```

Apply any arithmetic function to rows or columns
-------------------------


```r
apply(mat, 2, sum)
```

```
   age weight height 
   112    417    921 
```

```r
apply(mat, 1, max)
```

```
[1] 197 178 189 184 173
```

```r
apply(mat, 1, range)
```

```
     [,1] [,2] [,3] [,4] [,5]
[1,]   19   19   31   19   24
[2,]  197  178  189  184  173
```

```r
apply(mat, 2, mean, trim=0.1)
```

```
   age weight height 
  22.4   83.4  184.2 
```

Matrix algebra
-------------------------


```r
Mj <- rowMeans(mat)
Mk <- colMeans(mat)
sweep(mat, 1, Mj, "-")
```

```
           age     weight   height
[1,] -84.66667  -8.666667 93.33333
[2,] -72.00000 -15.000000 87.00000
[3,] -73.66667 -10.666667 84.33333
[4,] -74.00000 -17.000000 91.00000
[5,] -67.00000 -15.000000 82.00000
```

```r
t(scale(t(mat), center=TRUE, scale=FALSE))
```

```
           age     weight   height
[1,] -84.66667  -8.666667 93.33333
[2,] -72.00000 -15.000000 87.00000
[3,] -73.66667 -10.666667 84.33333
[4,] -74.00000 -17.000000 91.00000
[5,] -67.00000 -15.000000 82.00000
attr(,"scaled:center")
[1] 103.6667  91.0000 104.6667  93.0000  91.0000
```

```r
sweep(mat, 2, Mk, "-")
```

```
      age weight height
[1,] -3.4   11.6   12.8
[2,] -3.4   -7.4   -6.2
[3,]  8.6   10.6    4.8
[4,] -3.4   -7.4   -0.2
[5,]  1.6   -7.4  -11.2
```

```r
scale(mat, center=TRUE, scale=FALSE)
```

```
      age weight height
[1,] -3.4   11.6   12.8
[2,] -3.4   -7.4   -6.2
[3,]  8.6   10.6    4.8
[4,] -3.4   -7.4   -0.2
[5,]  1.6   -7.4  -11.2
attr(,"scaled:center")
   age weight height 
  22.4   83.4  184.2 
```

Covariance and correlation matrices
-------------------------


```r
cov(mat)
```

```
         age weight height
age    27.80  22.55    0.4
weight 22.55 102.80   82.4
height  0.40  82.40   87.7
```

```r
cor(mat)
```

```
               age    weight      height
age    1.000000000 0.4218204 0.008100984
weight 0.421820411 1.0000000 0.867822404
height 0.008100984 0.8678224 1.000000000
```

```r
cov.wt(mat, method="ML")
```

```
$cov
         age weight height
age    22.24  18.04   0.32
weight 18.04  82.24  65.92
height  0.32  65.92  70.16

$center
   age weight height 
  22.4   83.4  184.2 

$n.obs
[1] 5
```

```r
diag(cov(mat))
```

```
   age weight height 
  27.8  102.8   87.7 
```


```r
vec <- rnorm(nrow(mat))
cor(mat, vec)
```

```
             [,1]
age    -0.2023892
weight -0.8061148
height -0.8889682
```

```r
cor(vec, mat)
```

```
            age     weight     height
[1,] -0.2023892 -0.8061148 -0.8889682
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/matrixArithmetic.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/matrixArithmetic.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/matrixArithmetic.R) - [all posts](https://github.com/dwoll/RExRepos/)
