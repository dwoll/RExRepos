---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Basic arithmetic and logic"
categories: [RBasics]
rerCat: R_Basics
tags: [Arithmetic, Logic]
---

Basic arithmetic and logic
=========================

TODO
-------------------------

 - link to vector

R as a pocket calculator
-------------------------

### Arithmetic operators


```r
3 + 7
```

```
[1] 10
```

```r
9 / 3
```

```
[1] 3
```

```r
9 * (3+2)
```

```
[1] 45
```

```r
12^2 + 1.5*10
```

```
[1] 159
```

```r
10 %/% 3
```

```
[1] 3
```

```r
10 %% 3
```

```
[1] 1
```

Also see `help(Syntax)` for operator precendence / associativity: This determines the order in which computations are carried out when multiple operators are present.

Using operators as functions


```r
"/"(1, 10)
```

```
[1] 0.1
```

```r
"+"(2, 3)
```

```
[1] 5
```

### Standard math functions


```r
sqrt(4)
```

```
[1] 2
```

```r
sin(pi/2)
```

```
[1] 1
```

```r
abs(-4)
```

```
[1] 4
```

```r
log10(100)
```

```
[1] 2
```

```r
exp(1)
```

```
[1] 2.718282
```

### Rounding numbers


```r
round(1.271)
```

```
[1] 1
```

```r
round(pi, digits=3)
```

```
[1] 3.142
```

```r
ceiling(1.2)
```

```
[1] 2
```

```r
floor(3.7)
```

```
[1] 3
```

```r
trunc(22.913)
```

```
[1] 22
```

### Complex numbers


```r
exp(1)^((0+1i)*pi)
```

```
[1] -1+0i
```

```r
exp(1)^(-pi/2) - (0+1i)^(0+1i)
```

```
[1] 0+0i
```

```r
sqrt(-1)
```

```
[1] NaN
```

```r
sqrt(-1+0i)
```

```
[1] 0+1i
```

### Special values


```r
.Machine$integer.max
```

```
[1] 2147483647
```

```r
.Machine$double.eps
```

```
[1] 2.220446e-16
```


```r
1/0
```

```
[1] Inf
```

```r
is.infinite(1/0)
```

```
[1] TRUE
```

```r
0/0
```

```
[1] NaN
```

```r
is.nan(0/0)
```

```
[1] TRUE
```

```r
NULL
is.null(NULL)
```

```
[1] TRUE
```

### Using variables (objects)


```r
x1 <- 2
x2 <- 10
x3 <- -7
x1 * 2
```

```
[1] 4
```

```r
x2^x1 + x3
```

```
[1] 93
```

Logic
-------------------------

### Logical values


```r
TRUE
```

```
[1] TRUE
```

```r
FALSE
```

```
[1] FALSE
```

```r
!TRUE
```

```
[1] FALSE
```

```r
!FALSE
```

```
[1] TRUE
```


```r
isTRUE(TRUE)
```

```
[1] TRUE
```

```r
isTRUE(FALSE)
```

```
[1] FALSE
```

### Logical comparisons


```r
TRUE == TRUE
```

```
[1] TRUE
```

```r
TRUE == FALSE
```

```
[1] FALSE
```

```r
TRUE != TRUE
```

```
[1] FALSE
```

```r
TRUE != FALSE
```

```
[1] TRUE
```

```r
TRUE & TRUE
```

```
[1] TRUE
```

```r
TRUE & FALSE
```

```
[1] FALSE
```

```r
FALSE & FALSE
```

```
[1] FALSE
```

```r
FALSE & TRUE
```

```
[1] FALSE
```

```r
TRUE | TRUE
```

```
[1] TRUE
```

```r
TRUE | FALSE
```

```
[1] TRUE
```

```r
FALSE | FALSE
```

```
[1] FALSE
```

```r
FALSE | TRUE
```

```
[1] TRUE
```

```r
xor(TRUE, FALSE)
```

```
[1] TRUE
```

```r
xor(TRUE, TRUE)
```

```
[1] FALSE
```

Short-circuit logical comparisons with vectors


```r
c(TRUE,  FALSE, FALSE) && c(TRUE,  TRUE, FALSE)
```

```
[1] TRUE
```

```r
c(FALSE, FALSE, TRUE)  || c(FALSE, TRUE, FALSE)
```

```
[1] FALSE
```

### Arithmetic comparisons


```r
4 < 8
```

```
[1] TRUE
```

```r
7 < 3
```

```
[1] FALSE
```

```r
4 > 4
```

```
[1] FALSE
```

```r
4 >= 4
```

```
[1] TRUE
```

### Checking whether any or all elements are `TRUE`


```r
any(c(FALSE, FALSE, FALSE))
```

```
[1] FALSE
```

```r
any(c(FALSE, FALSE, TRUE))
```

```
[1] TRUE
```

```r
all(c(TRUE, TRUE, FALSE))
```

```
[1] FALSE
```

```r
any(c(TRUE, TRUE, TRUE))
```

```
[1] TRUE
```

In an empty vector, there is no element that is `FALSE`, therefore:


```r
all(numeric(0))
```

```
[1] TRUE
```

In an empty vector, you cannot pick an element that is `TRUE`, therefore:


```r
any(numeric(0))
```

```
[1] FALSE
```

Numeric representations
-------------------------

### Integers vs. decimal numbers


```r
4L == 4
```

```
[1] TRUE
```

```r
identical(4L, 4)
```

```
[1] FALSE
```

### Floating point arithmetic


```r
0.1 + 0.2 == 0.3
```

```
[1] FALSE
```

```r
1 %/% 0.1
```

```
[1] 10
```

```r
sin(pi)
```

```
[1] 1.224647e-16
```

```r
1 - ((1/49) * 49)
```

```
[1] 1.110223e-16
```

```r
1 - ((1/48) * 48)
```

```
[1] 0
```

[What every computer scientist should know about floating-point arithmetic](http://docs.sun.com/source/806-3568/ncg_goldberg.html)

### Checking decimal numbers for equality


```r
isTRUE(all.equal(0.123450001, 0.123450000))
```

```
[1] TRUE
```

```r
0.123400001 == 0.123400000
```

```
[1] FALSE
```

```r
all.equal(0.12345001, 0.12345000)
```

```
[1] "Mean relative difference: 8.100445e-08"
```

```r
isTRUE(all.equal(0.12345001,  0.12345000))
```

```
[1] FALSE
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/arithmeticLogic.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/arithmeticLogic.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/arithmeticLogic.R) - [all posts](https://github.com/dwoll/RExRepos/)
