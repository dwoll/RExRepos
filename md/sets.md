---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Sets"
categories: [RBasics]
rerCat: R_Basics
tags: [Sets, Combinatorics]
---

Sets
=========================

TODO
-------------------------

 - link to combinatorics

Install required packages
-------------------------

[`DescTools`](http://cran.r-project.org/package=DescTools), [`sets`](http://cran.r-project.org/package=sets)


```r
wants <- c("DescTools", "sets")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Treating duplicate values
-------------------------


```r
a <- c(4, 5, 6)
b <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
m <- c(2, 1, 3, 2, 1)
n <- c(5, 3, 1, 3, 4, 4)
x <- c(1, 1, 2, 2)
y <- c(2, 1)
```


```r
setequal(x, y)
```

```
[1] TRUE
```

```r
duplicated(c(1, 1, 1, 3, 3, 4, 4))
```

```
[1] FALSE  TRUE  TRUE FALSE  TRUE FALSE  TRUE
```

```r
unique(c(1, 1, 1, 3, 3, 4, 4))
```

```
[1] 1 3 4
```

```r
length(unique(c("A", "B", "C", "C", "B", "B", "A", "C", "C", "A")))
```

```
[1] 3
```

`AllDuplicated()` from package `DescTools` indicates all occurrences of a duplicated value, even the first one.


```r
library(DescTools)
AllDuplicated(c(1, 1, 1, 3, 3, 4, 4))
```

```
[1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE
```

Set operations
-------------------------

### Union

```r
union(m, n)
```

```
[1] 2 1 3 5 4
```

### Intersection


```r
intersect(m, n)
```

```
[1] 1 3
```

### Asymmetric and symmetric difference


```r
setdiff(m, n)
```

```
[1] 2
```

```r
setdiff(n, m)
```

```
[1] 5 4
```

```r
union(setdiff(m, n), setdiff(n, m))
```

```
[1] 2 5 4
```

### Is $e$ an element of set $X$?


```r
is.element(c(29, 23, 30, 17, 30, 10), c(30, 23))
```

```
[1] FALSE  TRUE  TRUE FALSE  TRUE FALSE
```

```r
c("A", "Z", "B") %in% c("A", "B", "C", "D", "E")
```

```
[1]  TRUE FALSE  TRUE
```

### (Proper) subset


```r
(AinB <- all(a %in% b))
```

```
[1] TRUE
```

```r
(BinA <- all(b %in% a))
```

```
[1] FALSE
```

```r
AinB & !BinA
```

```
[1] TRUE
```

Set operations using package `sets`
-------------------------


```r
library(sets)
sa <- set(4, 5, 6)
sb <- set(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
sm <- set(2, 1, 3, 2, 1)
sn <- set(5, 3, 1, 3, 4, 4)
sx <- set(1, 1, 2, 2)
sy <- set(2, 1)
se <- 4

set_is_empty(sa)
```

```
[1] FALSE
```

```r
set_cardinality(sx)
```

```
[1] 2
```

```r
set_power(sm)
```

```
{{}, {1}, {2}, {3}, {1, 2}, {1, 3}, {2, 3}, {1, 2, 3}}
```

```r
set_cartesian(sa, sx)
```

```
{(4, 1), (4, 2), (5, 1), (5, 2), (6, 1), (6, 2)}
```

```r
set_is_equal(sx, sy)
```

```
[1] TRUE
```

```r
set_union(sm, sn)
```

```
{1, 2, 3, 4, 5}
```

```r
set_intersection(sm, sn)
```

```
{1, 3}
```

```r
set_symdiff(sa, sb)
```

```
{1, 2, 3, 7, 8, 9, 10}
```

```r
set_complement(sm, sn)
```

```
{4, 5}
```

```r
set_is_subset(sa, sb)
```

```
[1] TRUE
```

```r
set_is_proper_subset(sa, sb)
```

```
[1] TRUE
```

```r
set_contains_element(sa, se)
```

```
[1] TRUE
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:DescTools))
try(detach(package:sets))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/sets.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/sets.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/sets.R) - [all posts](https://github.com/dwoll/RExRepos/)
