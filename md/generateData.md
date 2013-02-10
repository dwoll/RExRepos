---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Generate systematic and random data"
categories: [RBasics]
rerCat: R_Basics
tags: [RBasics]
---

Generate systematic and random data
=========================

Empty objects
-------------------------


```r
N <- 5
numeric(N)
```

```
[1] 0 0 0 0 0
```

```r
matrix(numeric(N))
```

```
     [,1]
[1,]    0
[2,]    0
[3,]    0
[4,]    0
[5,]    0
```

```r
character(N)
```

```
[1] "" "" "" "" ""
```

```r
vector(mode="list", length=N)
```

```
[[1]]
NULL

[[2]]
NULL

[[3]]
NULL

[[4]]
NULL

[[5]]
NULL
```


Systematic numerical sequences
-------------------------

### Ordered sequences


```r
20:26
```

```
[1] 20 21 22 23 24 25 26
```

```r
26:20
```

```
[1] 26 25 24 23 22 21 20
```

```r
-4:2
```

```
[1] -4 -3 -2 -1  0  1  2
```

```r
-(4:2)
```

```
[1] -4 -3 -2
```

```r
seq(from=2, to=12, by=2)
```

```
[1]  2  4  6  8 10 12
```

```r
seq(from=2, to=11, by=2)
```

```
[1]  2  4  6  8 10
```

```r
seq(from=0, to=-1, length.out=5)
```

```
[1]  0.00 -0.25 -0.50 -0.75 -1.00
```



```r
age <- c(18, 20, 30, 24, 23, 21)
seq(along=age)
```

```
[1] 1 2 3 4 5 6
```

```r
vec <- numeric(0)
length(vec)
```

```
[1] 0
```

```r
1:length(vec)
```

```
[1] 1 0
```

```r
seq(along=vec)
```

```
integer(0)
```


### Repeated sequences


```r
rep(1:3, times=5)
```

```
 [1] 1 2 3 1 2 3 1 2 3 1 2 3 1 2 3
```

```r
rep(c("A", "B", "C"), times=c(2, 3, 4))
```

```
[1] "A" "A" "B" "B" "B" "C" "C" "C" "C"
```

```r
rep(age, each=2)
```

```
 [1] 18 18 20 20 30 30 24 24 23 23 21 21
```


Random data
-------------------------

Strictly, the data is pseudorandom. There are several options for the random number generator, see `RNGkind()`. Use `set.seed()` to set the state of the RNG. This allows to replicate the following sequence of numbers. Copy `.Random.seed` into your own object to save the current state of the RNG. Don't modify `.Random.seed`.

### Sample from an urn


```r
set.seed(123)
sample(1:6, size=20, replace=TRUE)
```

```
 [1] 2 5 3 6 6 1 4 6 4 3 6 3 5 4 1 6 2 1 2 6
```

```r
sample(c("rot", "gruen", "blau"), size=8, replace=TRUE)
```

```
[1] "blau"  "blau"  "gruen" "blau"  "gruen" "blau"  "gruen" "gruen"
```

```r
x <- c(2, 4, 6, 8)
sample(x[(x %% 4) == 0])
```

```
[1] 4 8
```

```r
sample(x[(x %% 8) == 0])
```

```
[1] 8 7 5 4 1 2 3 6
```


### Data from random variables with different distributions


```r
runif(5, min=1, max=6)
```

```
[1] 2.591 2.158 1.714 3.073 3.069
```

```r
rbinom(20, size=5, prob=0.3)
```

```
 [1] 1 0 0 1 1 1 3 0 1 2 0 2 1 0 2 3 1 2 0 1
```

```r
rchisq(4, df=7)
```

```
[1] 4.103 9.428 9.184 8.623
```

```r
rnorm(6, mean=100, sd=15)
```

```
[1] 108.31  99.07  95.41  94.29  89.58  96.88
```

```r
rt(5, df=5, ncp=1)
```

```
[1] -0.3554  6.6387  2.2657 -0.1390  0.4654
```

```r
rf(5, df1=2, df2=10)
```

```
[1] 1.4005 2.9532 0.4914 7.5094 0.6705
```


See `?Distributions` for more distribution types. Even more information can be found in CRAN task view [Probability Distributions](http://cran.r-project.org/web/views/Distributions.html).

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/generateData.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/generateData.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/generateData.R) - [all posts](https://github.com/dwoll/RExRepos/)
