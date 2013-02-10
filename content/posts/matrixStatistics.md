---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Descriptive statistics for data in matrices"
categories: [Descriptive]
rerCat: Descriptive
tags: [Matrix, Descriptive]
---




TODO
-------------------------

 - link to matrix, linearAlgebra

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
[1] 96.67
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


Center and scale a matrix
-------------------------

### Using `scale()`


```r
(ctrMat <- scale(mat, center=TRUE, scale=FALSE))
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

```r
colMeans(ctrMat)
```

```
       age     weight     height 
 1.421e-15 -5.684e-15  1.137e-14 
```

```r
(sclMat <- scale(mat, center=TRUE, scale=TRUE))
```

```
         age  weight   height
[1,] -0.6448  1.1441  1.36682
[2,] -0.6448 -0.7299 -0.66205
[3,]  1.6311  1.0455  0.51256
[4,] -0.6448 -0.7299 -0.02136
[5,]  0.3035 -0.7299 -1.19596
attr(,"scaled:center")
   age weight height 
  22.4   83.4  184.2 
attr(,"scaled:scale")
   age weight height 
 5.273 10.139  9.365 
```

```r
apply(sclMat, 2, sd)
```

```
   age weight height 
     1      1      1 
```


### Using `sweep()`


```r
Mj <- rowMeans(mat)
Mk <- colMeans(mat)
sweep(mat, 1, Mj, "-")
```

```
        age  weight height
[1,] -84.67  -8.667  93.33
[2,] -72.00 -15.000  87.00
[3,] -73.67 -10.667  84.33
[4,] -74.00 -17.000  91.00
[5,] -67.00 -15.000  82.00
```

```r
t(scale(t(mat), center=TRUE, scale=FALSE))
```

```
        age  weight height
[1,] -84.67  -8.667  93.33
[2,] -72.00 -15.000  87.00
[3,] -73.67 -10.667  84.33
[4,] -74.00 -17.000  91.00
[5,] -67.00 -15.000  82.00
attr(,"scaled:center")
[1] 103.7  91.0 104.7  93.0  91.0
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


Covariance and correlation matrices
-------------------------

### Covariance matrix

Corrected


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
            age weight   height
age    1.000000 0.4218 0.008101
weight 0.421820 1.0000 0.867822
height 0.008101 0.8678 1.000000
```


Extract the variances from the diagonal


```r
diag(cov(mat))
```

```
   age weight height 
  27.8  102.8   87.7 
```


Uncorrected


```r
(res <- cov.wt(mat, method="ML"))
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
res$cov
```

```
         age weight height
age    22.24  18.04   0.32
weight 18.04  82.24  65.92
height  0.32  65.92  70.16
```


### Correlation matrix


```r
vec <- rnorm(nrow(mat))
cor(mat, vec)
```

```
          [,1]
age    -0.2566
weight -0.8843
height -0.7265
```

```r
cor(vec, mat)
```

```
         age  weight  height
[1,] -0.2566 -0.8843 -0.7265
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/matrixStatistics.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/matrixStatistics.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/matrixStatistics.R) - [all posts](https://github.com/dwoll/RExRepos/)
