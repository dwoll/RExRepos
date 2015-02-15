---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Matrices and arrays"
categories: [RBasics]
rerCat: R_Basics
tags: [Matrix, Array]
---

Matrices and arrays
=========================

TODO
-------------------------

 - link to matrixArithmetic

Matrices
-------------------------

### Create a matrix using `matrix()`


```r
age <- c(17, 30, 30, 25, 23, 21)
matrix(age, nrow=3, ncol=2, byrow=FALSE)
```

```
     [,1] [,2]
[1,]   17   25
[2,]   30   23
[3,]   30   21
```

```r
(ageMat <- matrix(age, nrow=2, ncol=3, byrow=TRUE))
```

```
     [,1] [,2] [,3]
[1,]   17   30   30
[2,]   25   23   21
```

### Combine rows and columns to a matrix


```r
age    <- c(19, 19, 31, 19, 24)
weight <- c(95, 76, 94, 76, 76)
height <- c(197, 178, 189, 184, 173)
rbind(age, weight, height)
```

```
       [,1] [,2] [,3] [,4] [,5]
age      19   19   31   19   24
weight   95   76   94   76   76
height  197  178  189  184  173
```

```r
cbind(age, weight, height)
```

```
     age weight height
[1,]  19     95    197
[2,]  19     76    178
[3,]  31     94    189
[4,]  19     76    184
[5,]  24     76    173
```

### Information about matrices


```r
dim(ageMat)
```

```
[1] 2 3
```

```r
nrow(ageMat)
```

```
[1] 2
```

```r
ncol(ageMat)
```

```
[1] 3
```

```r
prod(dim(ageMat))
```

```
[1] 6
```

### Transpose matrices


```r
t(ageMat)
```

```
     [,1] [,2]
[1,]   17   25
[2,]   30   23
[3,]   30   21
```


```r
as.matrix(1:3)
```

```
     [,1]
[1,]    1
[2,]    2
[3,]    3
```

```r
c(ageMat)
```

```
[1] 17 25 30 23 30 21
```

### Rows and columns


```r
P       <- 2
Q       <- 3
(pqMat  <- matrix(1:(P*Q), nrow=P, ncol=Q))
```

```
     [,1] [,2] [,3]
[1,]    1    3    5
[2,]    2    4    6
```

```r
(rowMat <- row(pqMat))
```

```
     [,1] [,2] [,3]
[1,]    1    1    1
[2,]    2    2    2
```

```r
(colMat <- col(pqMat))
```

```
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    1    2    3
```


```r
cbind(rowIdx=c(rowMat), colIdx=c(colMat), val=c(pqMat))
```

```
     rowIdx colIdx val
[1,]      1      1   1
[2,]      2      1   2
[3,]      1      2   3
[4,]      2      2   4
[5,]      1      3   5
[6,]      2      3   6
```


```r
mat <- matrix(sample(1:10, 16, replace=TRUE), 4, 4)
upper.tri(mat)
```

```
      [,1]  [,2]  [,3]  [,4]
[1,] FALSE  TRUE  TRUE  TRUE
[2,] FALSE FALSE  TRUE  TRUE
[3,] FALSE FALSE FALSE  TRUE
[4,] FALSE FALSE FALSE FALSE
```

```r
lower.tri(mat)
```

```
      [,1]  [,2]  [,3]  [,4]
[1,] FALSE FALSE FALSE FALSE
[2,]  TRUE FALSE FALSE FALSE
[3,]  TRUE  TRUE FALSE FALSE
[4,]  TRUE  TRUE  TRUE FALSE
```

### Extract and change elements

Row and column indices


```r
ageMat <- matrix(sample(16:35, 6, replace=TRUE), nrow=2, ncol=3)
ageMat[2, 2]
```

```
[1] 32
```

```r
ageMat[2, 2] <- 24
ageMat[2, 2]
```

```
[1] 24
```

```r
ageMat[2,  ]
```

```
[1] 19 24 18
```

```r
ageMat[ , 1]
```

```
[1] 26 19
```

```r
ageMat[ ,  ]
```

```
     [,1] [,2] [,3]
[1,]   26   28   26
[2,]   19   24   18
```

```r
ageMat[ , 1, drop=FALSE]
```

```
     [,1]
[1,]   26
[2,]   19
```

```r
ageMat[ , 2:3]
```

```
     [,1] [,2]
[1,]   28   26
[2,]   24   18
```

```r
ageMat[ , c(1, 3)]
```

```
     [,1] [,2]
[1,]   26   26
[2,]   19   18
```

Index vector


```r
idxVec <- c(1, 3, 4)
ageMat[idxVec]
```

```
[1] 26 28 24
```

Index matrix


```r
ageMatNew   <- ageMat
(replaceMat <- matrix(c(11, 21, 12, 22), nrow=2, ncol=2))
```

```
     [,1] [,2]
[1,]   11   12
[2,]   21   22
```

```r
ageMatNew[ , c(1, 3)] <- replaceMat
ageMatNew
```

```
     [,1] [,2] [,3]
[1,]   11   28   12
[2,]   21   24   22
```

Logical index matrix


```r
(idxMatLog <- ageMat >= 25)
```

```
      [,1]  [,2]  [,3]
[1,]  TRUE  TRUE  TRUE
[2,] FALSE FALSE FALSE
```

```r
ageMat[idxMatLog]
```

```
[1] 26 28 26
```


```r
(idxMatNum <- which(idxMatLog, arr.ind=TRUE))
```

```
     row col
[1,]   1   1
[2,]   1   2
[3,]   1   3
```

```r
ageMat[idxMatNum]
```

```
[1] 26 28 26
```

```r
(idxMat <- arrayInd(idxVec, dim(ageMat)))
```

```
     [,1] [,2]
[1,]    1    1
[2,]    1    2
[3,]    2    2
```

Also see `help(Extract)`

### Sort matrices


```r
age    <- c(19, 19, 31, 19, 24)
weight <- c(95, 76, 94, 76, 76)
height <- c(197, 178, 189, 184, 173)
mat    <- cbind(age, weight, height)
(rowOrder1 <- order(mat[ , "age"]))
```

```
[1] 1 2 4 5 3
```

```r
mat[rowOrder1, ]
```

```
     age weight height
[1,]  19     95    197
[2,]  19     76    178
[3,]  19     76    184
[4,]  24     76    173
[5,]  31     94    189
```


```r
rowOrder2 <- order(mat[ , "age"], partial=mat[ , "weight"])
mat[rowOrder2, ]
```

```
     age weight height
[1,]  19     76    178
[2,]  19     76    184
[3,]  19     95    197
[4,]  24     76    173
[5,]  31     94    189
```


```r
rowOrder3 <- order(mat[ , "weight"], -mat[ , "height"])
mat[rowOrder3, ]
```

```
     age weight height
[1,]  19     76    184
[2,]  19     76    178
[3,]  24     76    173
[4,]  31     94    189
[5,]  19     95    197
```

Arrays
-------------------------

### Create arrays


```r
(myArr1 <- array(1:12, c(2, 3, 2),
                 dimnames=list(row=c("f", "m"), column=c("CG", "WL", "T"),
                               layer=c("high", "low"))))
```

```
, , layer = high

   column
row CG WL T
  f  1  3 5
  m  2  4 6

, , layer = low

   column
row CG WL  T
  f  7  9 11
  m  8 10 12
```

### Extract and change elements


```r
myArr1[1, 3, 2]
```

```
[1] 11
```

```r
myArr1[2, 1, 2] <- 19
myArr2 <- myArr1*2
myArr2[ , , "high"]
```

```
   column
row CG WL  T
  f  2  6 10
  m  4  8 12
```

### Transpose arrays

Switch rows and columns


```r
aperm(myArr1, c(2, 1, 3))
```

```
, , layer = high

      row
column f m
    CG 1 2
    WL 3 4
    T  5 6

, , layer = low

      row
column  f  m
    CG  7 19
    WL  9 10
    T  11 12
```

Switch rows and layers


```r
aperm(myArr1, c(3, 2, 1))
```

```
, , row = f

      column
layer  CG WL  T
  high  1  3  5
  low   7  9 11

, , row = m

      column
layer  CG WL  T
  high  2  4  6
  low  19 10 12
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/matrix.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/matrix.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/matrix.R) - [all posts](https://github.com/dwoll/RExRepos/)
