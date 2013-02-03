---
layout: post
title: "Factors: Representing categorical data"
categories: [RBasics]
rerCat: R_Basics
tags: [RBasics]
---




TODO
-------------------------

 - link to recode for changing factor levels and for transforming continuous variables into factors

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`gdata`](http://cran.r-project.org/package=gdata)


```r
wants <- c("car", "gdata")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Unordered factors
-------------------------

### Create factors from existing variables
    

```r
sex     <- c("m", "f", "f", "m", "m", "m", "f", "f")
(sexFac <- factor(sex))
```

```
[1] m f f m m m f f
Levels: f m
```



```r
factor(c(1, 1, 3, 3, 4, 4), levels=1:5)
```

```
[1] 1 1 3 3 4 4
Levels: 1 2 3 4 5
```

```r
(sexNum <- rbinom(10, size=1, prob=0.5))
```

```
 [1] 1 1 0 1 1 0 0 0 0 1
```

```r
factor(sexNum, labels=c("man", "woman"))
```

```
 [1] woman woman man   woman woman man   man   man   man   woman
Levels: man woman
```

```r
levels(sexFac) <- c("female", "male")
sexFac
```

```
[1] male   female female male   male   male   female female
Levels: female male
```


### Generate factors


```r
(fac1 <- factor(rep(c("A", "B"), c(5, 5))))
```

```
 [1] A A A A A B B B B B
Levels: A B
```

```r
(fac2 <- gl(2, 5, labels=c("less", "more"), ordered=TRUE))
```

```
 [1] less less less less less more more more more more
Levels: less < more
```

```r
sample(fac2, length(fac2), replace=FALSE)
```

```
 [1] more more more less less more more less less less
Levels: less < more
```



```r
expand.grid(IV1=gl(2, 2, labels=c("a", "b")), IV2=gl(3, 1))
```

```
   IV1 IV2
1    a   1
2    a   1
3    b   1
4    b   1
5    a   2
6    a   2
7    b   2
8    b   2
9    a   3
10   a   3
11   b   3
12   b   3
```


### Information about factors


```r
nlevels(sexFac)
```

```
[1] 2
```

```r
summary(sexFac)
```

```
female   male 
     4      4 
```

```r
levels(sexFac)
```

```
[1] "female" "male"  
```

```r
str(sexFac)
```

```
 Factor w/ 2 levels "female","male": 2 1 1 2 2 2 1 1
```



```r
unclass(sexFac)
```

```
[1] 2 1 1 2 2 2 1 1
attr(,"levels")
[1] "female" "male"  
```

```r
unclass(factor(10:15))
```

```
[1] 1 2 3 4 5 6
attr(,"levels")
[1] "10" "11" "12" "13" "14" "15"
```

```r
as.character(sexFac)
```

```
[1] "male"   "female" "female" "male"   "male"   "male"   "female" "female"
```


Joining factors
-------------------------

### Concatenating factors


```r
(fac1 <- factor(sample(LETTERS, 5)))
```

```
[1] M X A G L
Levels: A G L M X
```

```r
(fac2 <- factor(sample(letters, 3)))
```

```
[1] p g k
Levels: g k p
```

```r
(charVec1 <- levels(fac1)[fac1])
```

```
[1] "M" "X" "A" "G" "L"
```

```r
(charVec2 <- levels(fac2)[fac2])
```

```
[1] "p" "g" "k"
```

```r
factor(c(charVec1, charVec2))
```

```
[1] M X A G L p g k
Levels: A g G k L M p X
```


### Repeating factors


```r
rep(fac1, times=2)
```

```
 [1] M X A G L M X A G L
Levels: A G L M X
```


### Crossing two factors


```r
Njk  <- 2
P    <- 2
Q    <- 3
(IV1 <- factor(rep(c("lo", "hi"), each=Njk*Q)))
```

```
 [1] lo lo lo lo lo lo hi hi hi hi hi hi
Levels: hi lo
```

```r
(IV2 <- factor(rep(1:Q, times=Njk*P)))
```

```
 [1] 1 2 3 1 2 3 1 2 3 1 2 3
Levels: 1 2 3
```

```r
interaction(IV1, IV2)
```

```
 [1] lo.1 lo.2 lo.3 lo.1 lo.2 lo.3 hi.1 hi.2 hi.3 hi.1 hi.2 hi.3
Levels: hi.1 lo.1 hi.2 lo.2 hi.3 lo.3
```


Ordered factors
-------------------------


```r
(status <- factor(c("hi", "lo", "hi", "mid")))
```

```
[1] hi  lo  hi  mid
Levels: hi lo mid
```

```r
(ordStat <- ordered(status, levels=c("lo", "mid", "hi")))
```

```
[1] hi  lo  hi  mid
Levels: lo < mid < hi
```

```r
ordStat[1] > ordStat[2]
```

```
[1] TRUE
```


Control the order of factor levels
-------------------------

### Free ordering of group levels


```r
(chars <- rep(LETTERS[1:3], each=5))
```

```
 [1] "A" "A" "A" "A" "A" "B" "B" "B" "B" "B" "C" "C" "C" "C" "C"
```

```r
(fac1 <- factor(chars))
```

```
 [1] A A A A A B B B B B C C C C C
Levels: A B C
```

```r
factor(chars, levels=c("C", "A", "B"))
```

```
 [1] A A A A A B B B B B C C C C C
Levels: C A B
```


### Using `reorder.factor()` from package `gdata`


```r
library(gdata)
(facRe <- reorder.factor(fac1, new.order=c("C", "B", "A")))
```

```
 [1] A A A A A B B B B B C C C C C
Levels: C B A
```


### Reorder group levels according to group statistics


```r
vec <- rnorm(15, rep(c(10, 5, 15), each=5), 3)
tapply(vec, fac1, FUN=mean)
```

```
     A      B      C 
 9.021  2.567 14.872 
```

```r
reorder(fac1, vec, FUN=mean)
```

```
 [1] A A A A A B B B B B C C C C C
Levels: B A C
```


### Relevance of level order for sorting factors


```r
(fac2 <- factor(sample(1:2, 10, replace=TRUE), labels=c("B", "A")))
```

```
 [1] A B B A A B A A A A
Levels: B A
```

```r
sort(fac2)
```

```
 [1] B B B A A A A A A A
Levels: B A
```

```r
sort(as.character(fac2))
```

```
 [1] "A" "A" "A" "A" "A" "A" "A" "B" "B" "B"
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:gdata))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/factors.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/factors.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/factors.R) - [all posts](https://github.com/dwoll/RExRepos/)
