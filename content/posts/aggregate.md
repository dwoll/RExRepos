---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Aggregate data"
categories: [Descriptive]
rerCat: Descriptive
tags: [Aggregate]
---




Separate descriptive statistics for each group
-------------------------


```r
Njk   <- 2
P     <- 2
Q     <- 3
IQ    <- round(rnorm(Njk*P*Q, mean=100, sd=15))
sex   <- factor(rep(c("f", "m"),       times=Q*Njk))
group <- factor(rep(c("T", "WL", "CG"), each=P*Njk))
table(sex, group)
```

```
   group
sex CG T WL
  f  2 2  2
  m  2 2  2
```

### `ave()`


```r
ave(IQ, sex, FUN=mean)
```

```
 [1] 97.33333 98.00000 97.33333 98.00000 97.33333 98.00000 97.33333
 [8] 98.00000 97.33333 98.00000 97.33333 98.00000
```

### `tapply()`


```r
tapply(IQ, group, FUN=mean)
```

```
    CG      T     WL 
 96.75  93.75 102.50 
```

```r
tapply(IQ, list(sex, group), FUN=mean)
```

```
     CG    T  WL
f  91.5 92.5 108
m 102.0 95.0  97
```

Aggregate data frames
-------------------------

### Simulate data


```r
set.seed(123)
N      <- 12
sex    <- sample(c("f", "m"), N, replace=TRUE)
group  <- sample(rep(c("CG", "WL", "T"), 4), N, replace=FALSE)
age    <- sample(18:35, N, replace=TRUE)
IQ     <- round(rnorm(N, mean=100, sd=15))
rating <- round(runif(N, min=0, max=6))
(myDf1 <- data.frame(id=1:N, sex, group, age, IQ, rating))
```

```
   id sex group age  IQ rating
1   1   f     T  29 111      4
2   2   m    CG  30  93      1
3   3   f    WL  27  84      2
4   4   m     T  28  97      2
5   5   m    CG  23  85      5
6   6   f    CG  20  89      3
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
10 10   f     T  32 102      3
11 11   m     T  18  83      5
12 12   f    WL  26 119      4
```

### Apply the same function to different variables in a data frame


```r
lapply(myDf1[ , c("age", "IQ", "rating")], mean)
```

```
$age
[1] 27.66667

$IQ
[1] 95.16667

$rating
[1] 3.666667
```

```r
sapply(myDf1[ , c("age", "IQ", "rating")], range)
```

```
     age  IQ rating
[1,]  18  75      1
[2,]  35 119      5
```


```r
(numIdx <- sapply(myDf1, is.numeric))
```

```
    id    sex  group    age     IQ rating 
  TRUE  FALSE  FALSE   TRUE   TRUE   TRUE 
```

```r
dataNum <- myDf1[ , numIdx]
head(dataNum)
```

```
  id age  IQ rating
1  1  29 111      4
2  2  30  93      1
3  3  27  84      2
4  4  28  97      2
5  5  23  85      5
6  6  20  89      3
```

### Apply the same function to pairs of variables from two data frames


```r
N    <- 100
x1   <- rnorm(N, 10, 10)
y1   <- rnorm(N, 10, 10)
x2   <- x1 + rnorm(N, 5, 4)
y2   <- y1 + rnorm(N, 10, 4)
tDf1 <- data.frame(x1, y1)
tDf2 <- data.frame(x2, y2)
```


```r
mapply(t.test, tDf1, tDf2, MoreArgs=list(alternative="less", var.equal=TRUE))
```

```
            x1                                     
statistic   -4.245912                              
parameter   198                                    
p.value     1.672906e-05                           
conf.int    Numeric,2                              
estimate    Numeric,2                              
null.value  0                                      
alternative "less"                                 
method      " Two Sample t-test"                   
data.name   "dots[[1L]][[1L]] and dots[[2L]][[1L]]"
            y1                                     
statistic   -6.568381                              
parameter   198                                    
p.value     2.19182e-10                            
conf.int    Numeric,2                              
estimate    Numeric,2                              
null.value  0                                      
alternative "less"                                 
method      " Two Sample t-test"                   
data.name   "dots[[1L]][[2L]] and dots[[2L]][[2L]]"
```

### Separate descriptive statistics for each group for many variables


```r
(splitRes <- split(myDf1, myDf1$group))
```

```
$CG
  id sex group age  IQ rating
2  2   m    CG  30  93      1
5  5   m    CG  23  85      5
6  6   f    CG  20  89      3
9  9   m    CG  30 113      5

$T
   id sex group age  IQ rating
1   1   f     T  29 111      4
4   4   m     T  28  97      2
10 10   f     T  32 102      3
11 11   m     T  18  83      5

$WL
   id sex group age  IQ rating
3   3   f    WL  27  84      2
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
12 12   f    WL  26 119      4
```

```r
sapply(splitRes, function(x) mean(x$IQ))
```

```
   CG     T    WL 
95.00 98.25 92.25 
```


```r
tapply(myDf1$IQ, myDf1$group, FUN=mean)
```

```
   CG     T    WL 
95.00 98.25 92.25 
```


```r
numDf <- subset(myDf1, select=c("age", "IQ", "rating"))
aggregate(numDf, list(myDf1$sex, myDf1$group), FUN=mean)
```

```
  Group.1 Group.2      age    IQ   rating
1       f      CG 20.00000  89.0 3.000000
2       m      CG 27.66667  97.0 3.666667
3       f       T 30.50000 106.5 3.500000
4       m       T 23.00000  90.0 3.500000
5       f      WL 26.50000 101.5 3.000000
6       m      WL 34.50000  83.0 5.000000
```

```r
aggregate(cbind(age, IQ, rating) ~ sex + group, FUN=mean, data=myDf1)
```

```
  sex group      age    IQ   rating
1   f    CG 20.00000  89.0 3.000000
2   m    CG 27.66667  97.0 3.666667
3   f     T 30.50000 106.5 3.500000
4   m     T 23.00000  90.0 3.500000
5   f    WL 26.50000 101.5 3.000000
6   m    WL 34.50000  83.0 5.000000
```

```r
aggregate(cbind(age, IQ, rating) ~ 1, FUN=mean, data=myDf1)
```

```
       age       IQ   rating
1 27.66667 95.16667 3.666667
```


```r
by(numDf, list(myDf1$sex, myDf1$group), FUN=function(x) sapply(x, mean))
```

```
: f
: CG
   age     IQ rating 
    20     89      3 
-------------------------------------------------------- 
: m
: CG
      age        IQ    rating 
27.666667 97.000000  3.666667 
-------------------------------------------------------- 
: f
: T
   age     IQ rating 
  30.5  106.5    3.5 
-------------------------------------------------------- 
: m
: T
   age     IQ rating 
  23.0   90.0    3.5 
-------------------------------------------------------- 
: f
: WL
   age     IQ rating 
  26.5  101.5    3.0 
-------------------------------------------------------- 
: m
: WL
   age     IQ rating 
  34.5   83.0    5.0 
```

Useful packages
-------------------------

Package [`dplyr`](http://cran.r-project.org/package=dplyr) provides more functions for efficiently as well as consistently transforming and aggregating data.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/aggregate.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/aggregate.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/aggregate.R) - [all posts](https://github.com/dwoll/RExRepos/)
