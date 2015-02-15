---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Data transformations"
categories: [RBasics]
rerCat: R_Basics
tags: [RBasics]
---

Data transformations
=========================

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
Warning: imaginäre Teile verworfen in Umwandlung
```

```
[1] 3 3 0 0
```

```r
as.numeric(c("21", "3.141", "abc"))
```

```
Warning: NAs durch Umwandlung erzeugt
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
set.seed(123)
myColors  <- c("red", "green", "blue", "yellow", "black")
(randCols <- sample(myColors, length(myColors), replace=FALSE))
```

```
[1] "green"  "yellow" "black"  "blue"   "red"   
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
 [1] 1 2 3 2 1 2 1 3 3 3 1 3
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
 [1] 2 1 3 2 3 2 1 3 1 2
```

Select random or systematic subsets of vector elements
-------------------------

### Random selection


```r
vec <- rep(c("red", "green", "blue"), 10)
sample(vec, 5, replace=FALSE)
```

```
[1] "blue"  "blue"  "green" "blue"  "blue" 
```


```r
library(car)
some(vec, n=5)
```

```
[1] "red"   "blue"  "green" "blue"  "blue" 
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
character(0)
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
Warning in vec2 * age: Länge des längeren Objektes
 	 ist kein Vielfaches der Länge des kürzeren Objektes
```

```
[1]  36  80 180 192 230  42
```

### Standardize variables


```r
(zAge <- (age - mean(age)) / sd(age))
```

```
[1] -1.1166106 -0.6380632  1.7546739  0.3190316  0.0797579 -0.3987895
```

```r
(zAge <- scale(age))
```

```
           [,1]
[1,] -1.1166106
[2,] -0.6380632
[3,]  1.7546739
[4,]  0.3190316
[5,]  0.0797579
[6,] -0.3987895
attr(,"scaled:center")
[1] 22.66667
attr(,"scaled:scale")
[1] 4.179314
```

```r
as.vector(zAge)
```

```
[1] -1.1166106 -0.6380632  1.7546739  0.3190316  0.0797579 -0.3987895
```

### Move and scale variable


```r
newSd   <- 15
newMean <- 100
(newAge <- (as.vector(zAge)*newSd) + newMean)
```

```
[1]  83.25084  90.42905 126.32011 104.78547 101.19637  94.01816
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
[1] 20.51509 24.39626 25.47521 22.39541 27.14158
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
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/transformData.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/transformData.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/transformData.R) - [all posts](https://github.com/dwoll/RExRepos/)
