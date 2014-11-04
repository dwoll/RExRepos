---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Sum, product, and range of data"
categories: [Descriptive]
rerCat: Descriptive
tags: [Descriptive]
---




Sums, differences, and products
-------------------------

### Sum and cumulative sum


```r
age <- c(17, 30, 30, 25, 23, 21)
sum(age)
```

```
[1] 146
```

```r
cumsum(age)
```

```
[1]  17  47  77 102 125 146
```

### Successive differences


```r
diff(age)
```

```
[1] 13  0 -5 -2 -2
```

```r
diff(age, lag=2)
```

```
[1] 13 -5 -7 -4
```

### Product and cumulative product


```r
prod(age)
```

```
[1] 184747500
```

```r
cumprod(age)
```

```
[1]        17       510     15300    382500   8797500 184747500
```

```r
factorial(5)
```

```
[1] 120
```

Minimum, maximum and range
-------------------------

### Get the minimum, maximum and range


```r
min(age)
```

```
[1] 17
```

```r
max(age)
```

```
[1] 30
```

```r
range(c(17, 30, 30, 25, 23, 21))
```

```
[1] 17 30
```

```r
diff(range(c(17, 30, 30, 25, 23, 21)))
```

```
[1] 13
```

### Identify the minimum and maximum elements


```r
which.max(age)
```

```
[1] 2
```

Identify element closest to a value


```r
vec <- c(-5, -8, -2, 10, 9)
val <- 0
which.min(abs(vec-val))
```

```
[1] 3
```

### Pairwise minimum and maximum


```r
vec1 <- c(5, 2, 0, 7)
vec2 <- c(3, 3, 9, 2)
pmax(vec1, vec2)
```

```
[1] 5 3 9 7
```

```r
pmin(vec1, vec2)
```

```
[1] 3 2 0 2
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/sumProdRange.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/sumProdRange.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/sumProdRange.R) - [all posts](https://github.com/dwoll/RExRepos/)
