---
layout: post
title: "Data transformations"
categories: [RBasics]
rerCat: R_Basics
tags: [RBasics]
---




TODO
-------------------------

 - link to recode, dataFrames

 Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car)


```r
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Convert between data types
-------------------------

### Type hierarchy

Lower types can be uniquely converted to higher types.


```r
tfVec <- c(TRUE, FALSE, FALSE, TRUE)
as.numeric(tfVec)
```

```
[1] 1 0 0 1
```

```r
as.complex(tfVec)
```

```
[1] 1+0i 0+0i 0+0i 1+0i
```

```r
as.character(tfVec)
```

```
[1] "TRUE"  "FALSE" "FALSE" "TRUE" 
```


Higher types cannot be uniquely converted to lower types.


```r
as.logical(c(-1, 0, 1, 2))
```

```
[1]  TRUE FALSE  TRUE  TRUE
```

```r
as.numeric(as.complex(c(3-2i, 3+2i, 0+1i, 0+0i)))
```

```
Warning: imaginary parts discarded in coercion
```

```
[1] 3 3 0 0
```

```r
as.numeric(c("21", "3.141", "abc"))
```

```
Warning: NAs introduced by coercion
```

```
[1] 21.000  3.141     NA
```


Change order of vector elements
-------------------------

### Sort vectors


```r
vec <- c(10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
rev(vec)
```

```
 [1] 20 19 18 17 16 15 14 13 12 11 10
```

```r
vec <- c(10, 12, 1, 12, 7, 16, 6, 19, 10, 19)
sort(vec)
```

```
 [1]  1  6  7 10 10 12 12 16 19 19
```

```r
(idxDec <- order(vec, decreasing=TRUE))
```

```
 [1]  8 10  6  2  4  1  9  5  7  3
```

```r
vec[idxDec]
```

```
 [1] 19 19 16 12 12 10 10  7  6  1
```

```r
sort(c("D", "E", "10", "A", "F", "E", "D", "4", "E", "A"))
```

```
 [1] "10" "4"  "A"  "A"  "D"  "D"  "E"  "E"  "E"  "F" 
```


### Randomly permute vector elements


```r
set.seed(1.234)
myColors  <- c("red", "green", "blue", "yellow", "black")
(randCols <- sample(myColors, length(myColors), replace=FALSE))
```

```
[1] "green"  "black"  "yellow" "blue"   "red"   
```



```r
P   <- 3
Nj  <- c(4, 3, 5)
(IV <- rep(1:P, Nj))
```

```
 [1] 1 1 1 1 2 2 2 3 3 3 3 3
```

```r
(IVrand <- sample(IV, length(IV), replace=FALSE))
```

```
 [1] 3 3 2 2 1 1 3 1 3 1 3 2
```


Randomly place elements in $p$ groups of approximately equal size
-------------------------


```r
x <- c(18, 11, 15, 20, 19, 10, 14, 13, 10, 10)
N <- length(x)
P <- 3
(sample(1:N, N, replace=FALSE) %% P) + 1
```

```
 [1] 2 2 2 3 3 1 2 3 1 1
```


Select random or systematic subsets of vector elements
-------------------------

### Random selection


```r
vec <- rep(c("red", "green", "blue"), 10)
sample(vec, 5, replace=FALSE)
```

```
[1] "blue"  "green" "red"   "green" "red"  
```



```r
library(car)
some(vec, n=5)
```

```
[1] "blue" "blue" "red"  "blue" "blue"
```


### Select every 10th element


```r
selIdx1 <- seq(1, length(vec), by=10)
vec[selIdx1]
```

```
[1] "red"   "green" "blue" 
```


### Select approximately every 10th element


```r
selIdx2 <- rbinom(length(vec), size=1, prob=0.1) == 1
vec[selIdx2]
```

```
[1] "blue"
```


Transform old variables into new ones
-------------------------

### Element-wise arithmetic


```r
age <- c(18, 20, 30, 24, 23, 21)
age/10
```

```
[1] 1.8 2.0 3.0 2.4 2.3 2.1
```

```r
(age/2) + 5
```

```
[1] 14.0 15.0 20.0 17.0 16.5 15.5
```

```r
vec1 <- c(3, 4, 5, 6)
vec2 <- c(-2, 2, -2, 2)
vec1*vec2
```

```
[1]  -6   8 -10  12
```

```r
vec3 <- c(10, 100, 1000, 10000)
(vec1 + vec2) / vec3
```

```
[1] 1e-01 6e-02 3e-03 8e-04
```


### Recycling rule


```r
vec1 <- c(2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24)
vec2 <- c(2, 4, 6, 8, 10)
c(length(age), length(vec1), length(vec2))
```

```
[1]  6 12  5
```

```r
vec1*age
```

```
 [1]  36  80 180 192 230 252 252 320 540 480 506 504
```

```r
vec2*age
```

```
Warning: longer object length is not a multiple of shorter object length
```

```
[1]  36  80 180 192 230  42
```


### Standardize variables


```r
(zAge <- (age - mean(age)) / sd(age))
```

```
[1] -1.11661 -0.63806  1.75467  0.31903  0.07976 -0.39879
```

```r
(zAge <- scale(age))
```

```
         [,1]
[1,] -1.11661
[2,] -0.63806
[3,]  1.75467
[4,]  0.31903
[5,]  0.07976
[6,] -0.39879
attr(,"scaled:center")
[1] 22.67
attr(,"scaled:scale")
[1] 4.179
```

```r
as.vector(zAge)
```

```
[1] -1.11661 -0.63806  1.75467  0.31903  0.07976 -0.39879
```


### Move and scale variable


```r
newSd   <- 15
newMean <- 100
(newAge <- (as.vector(zAge)*newSd) + newMean)
```

```
[1]  83.25  90.43 126.32 104.79 101.20  94.02
```

```r
mean(newAge)
```

```
[1] 100
```

```r
sd(newAge)
```

```
[1] 15
```


### Rank transformation


```r
rank(c(3, 1, 2, 3))
```

```
[1] 3.5 1.0 2.0 3.5
```


### Transform old variables into new ones


```r
height <- c(1.78, 1.91, 1.89, 1.83, 1.64)
weight <- c(65, 89, 91, 75, 73)
(bmi   <- weight / (height^2))
```

```
[1] 20.52 24.40 25.48 22.40 27.14
```



```r
quest1  <- c(FALSE, FALSE, FALSE, TRUE,  FALSE, TRUE, FALSE, TRUE)
quest2  <- c(TRUE,  FALSE, FALSE, FALSE, TRUE,  TRUE, TRUE,  FALSE)
quest3  <- c(TRUE,  TRUE,  TRUE,  TRUE,  FALSE, TRUE, FALSE, FALSE)
(sumVar <- quest1 + quest2 + quest3)
```

```
[1] 2 1 1 2 1 3 1 1
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/transformData.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/transformData.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/transformData.R) - [all posts](https://github.com/dwoll/RExRepos/)
