---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Vectors"
categories: [RBasics]
rerCat: R_Basics
tags: [Vector]
---




TODO
-------------------------

 - link to generateData, transformData

Create vectors
-------------------------

### Empty vectors


```r
numeric(4)
```

```
[1] 0 0 0 0
```

```r
character(3)
```

```
[1] "" "" ""
```

```r
logical(5)
```

```
[1] FALSE FALSE FALSE FALSE FALSE
```

### Create and combine vectors

Numeric vectors


```r
(age <- c(18, 20, 30, 24, 23, 21))
```

```
[1] 18 20 30 24 23 21
```

```r
addAge  <- c(27, 21, 19)
(ageNew <- c(age, addAge))
```

```
[1] 18 20 30 24 23 21 27 21 19
```

```r
append(age, c(17, 31))
```

```
[1] 18 20 30 24 23 21 17 31
```

Character vectors


```r
charVec1 <- c("Z", "Y", "X")
(charVec2 <- c(charVec1, "T", "S", "R"))
```

```
[1] "Z" "Y" "X" "T" "S" "R"
```

```r
LETTERS[c(1, 2, 3)]
```

```
[1] "A" "B" "C"
```

```r
letters[c(5, 9, 13)]
```

```
[1] "e" "i" "m"
```

```r
(chars <- c("ipsum", "dolor", "sit"))
```

```
[1] "ipsum" "dolor" "sit"  
```

Information about vectors


```r
length(age)
```

```
[1] 6
```

```r
length(chars)
```

```
[1] 3
```

```r
nchar(chars)
```

```
[1] 5 5 3
```

Extract and change vector elements
-------------------------

### Extract elements with a numeric index


```r
age[4]
```

```
[1] 24
```

```r
age[4] <- 22
age
```

```
[1] 18 20 30 22 23 21
```

Get and change the last element


```r
(ageLast <- age[length(age)])
```

```
[1] 21
```

```r
age[length(age) + 1]
```

```
[1] NA
```

A vector does not need a name for getting one of its values


```r
c(11, 12, 13, 14)[2]
```

```
[1] 12
```

### Extract elements with index vectors

Get elements


```r
idx <- c(1, 2, 4)
age[idx]
```

```
[1] 18 20 22
```

```r
age[c(3, 5, 6)]
```

```
[1] 30 23 21
```

```r
age[c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6)]
```

```
 [1] 18 18 20 20 30 30 22 22 23 23 21 21
```

```r
age[c(4, NA, 1)]
```

```
[1] 22 NA 18
```

Change elements


```r
age[idx] <- c(17, 30, 25)
age
```

```
[1] 17 30 30 25 23 21
```

### Exclude elements


```r
age[-3]
```

```
[1] 17 30 25 23 21
```

```r
age[c(-1, -2, -4)]
```

```
[1] 30 23 21
```

```r
age[-c(1, 2, 4)]
```

```
[1] 30 23 21
```

```r
age[-idx]
```

```
[1] 30 23 21
```

Also see `help(Extract)`

Types of values in vectors
-------------------------


```r
charVec4 <- "word"
numVec   <- c(10, 20, 30)
(combVec <- c(charVec4, numVec))
```

```
[1] "word" "10"   "20"   "30"  
```

```r
mode(combVec)
```

```
[1] "character"
```

Named elements
-------------------------


```r
(namedVec1 <- c(elem1="first", elem2="second"))
```

```
   elem1    elem2 
 "first" "second" 
```

```r
namedVec1["elem1"]
```

```
  elem1 
"first" 
```

```r
(namedVec2 <- c(val1=10, val2=-12, val3=33))
```

```
val1 val2 val3 
  10  -12   33 
```

```r
names(namedVec2)
```

```
[1] "val1" "val2" "val3"
```

```r
names(namedVec2) <- c("A", "B", "C")
namedVec2
```

```
  A   B   C 
 10 -12  33 
```

Delete elements
-------------------------


```r
vec <- c(10, 20, 30, 40, 50)
vec <- vec[c(-4, -5)]
vec
```

```
[1] 10 20 30
```

```r
vec <- c(1, 2, 3, 4, 5)
length(vec) <- 3
vec
```

```
[1] 1 2 3
```

Vector valued comparisons
-------------------------

### Simple comparisons


```r
age <- c(17, 30, 30, 24, 23, 21)
age < 24
```

```
[1]  TRUE FALSE FALSE FALSE  TRUE  TRUE
```

```r
x <- c(2, 4, 8)
y <- c(3, 4, 5)
x == y
```

```
[1] FALSE  TRUE FALSE
```

```r
x < y
```

```
[1]  TRUE FALSE FALSE
```

Information about elements satisfying some condition


```r
res <- age > 30
any(res)
```

```
[1] FALSE
```

```r
any(age < 18)
```

```
[1] TRUE
```

```r
all(x == y)
```

```
[1] FALSE
```

```r
res <- age < 24
sum(res)
```

```
[1] 3
```

```r
which(age < 24)
```

```
[1] 1 5 6
```

```r
length(which(age < 24))
```

```
[1] 3
```

Checking for equality of vectors


```r
x <- c(4, 5, 6)
y <- c(4, 5, 6)
z <- c(1, 2, 3)
all.equal(x, y)
```

```
[1] TRUE
```

```r
all.equal(y, z)
```

```
[1] "Mean relative difference: 0.6"
```

```r
isTRUE(all.equal(y, z))
```

```
[1] FALSE
```

### Combine multiple logical comparisons


```r
(age <= 20) | (age >= 30)
```

```
[1]  TRUE  TRUE  TRUE FALSE FALSE FALSE
```

```r
(age > 20) & (age < 30)
```

```
[1] FALSE FALSE FALSE  TRUE  TRUE  TRUE
```

Logical index vectors
-------------------------

### Simple and combined selection criteria


```r
age[c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE)]
```

```
[1] 17 30 24 21
```

```r
(idx <- (age <= 20) | (age >= 30))
```

```
[1]  TRUE  TRUE  TRUE FALSE FALSE FALSE
```

```r
age[idx]
```

```
[1] 17 30 30
```

```r
age[(age >= 30) | (age <= 20)]
```

```
[1] 17 30 30
```

### The recycling rule


```r
age[c(TRUE, FALSE)]
```

```
[1] 17 30 23
```

```r
age[c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)]
```

```
[1] 17 30 23
```

### Convert logical index vectors to numerical ones

Problem:


```r
vecNA   <- c(-3, 2, 0, NA, -7, 5)
(logIdx <- vecNA > 0)
```

```
[1] FALSE  TRUE FALSE    NA FALSE  TRUE
```

```r
vecNA[logIdx]
```

```
[1]  2 NA  5
```

Solution:


```r
(numIdx <- which(logIdx))
```

```
[1] 2 6
```

```r
vecNA[numIdx]
```

```
[1] 2 5
```

```r
seq(along=logIdx) %in% numIdx
```

```
[1] FALSE  TRUE FALSE FALSE FALSE  TRUE
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/vector.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/vector.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/vector.R) - [all posts](https://github.com/dwoll/RExRepos/)
