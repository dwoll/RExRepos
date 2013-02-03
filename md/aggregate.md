---
layout: post
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
 [1] 109.5  97.0 109.5  97.0 109.5  97.0 109.5  97.0 109.5  97.0 109.5
[12]  97.0
```


### `tapply()`


```r
tapply(IQ, group, FUN=mean)
```

```
    CG      T     WL 
 95.25 113.00 101.50 
```

```r
tapply(IQ, list(sex, group), FUN=mean)
```

```
     CG     T  WL
f 101.0 128.5  99
m  89.5  97.5 104
```


Aggregate data frames
-------------------------

### Simulate data


```r
set.seed(1.234)
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
1   1   f     T  22 112      5
2   2   f    WL  24 109      2
3   3   m    WL  18 114      3
4   4   m    WL  24 112      2
5   5   f     T  33 101      4
6   6   m    CG  24  70      2
7   7   m     T  26 109      3
8   8   m    CG  28  99      5
9   9   m     T  26  98      1
10 10   f    CG  21  78      5
11 11   f    WL  32  93      2
12 12   f    CG  30 106      5
```


### Apply the same function to different variables in a data frame


```r
lapply(myDf1[ , c("age", "IQ", "rating")], mean)
```

```
$age
[1] 25.67

$IQ
[1] 100.1

$rating
[1] 3.25
```

```r
sapply(myDf1[ , c("age", "IQ", "rating")], range)
```

```
     age  IQ rating
[1,]  18  70      1
[2,]  33 114      5
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
1  1  22 112      5
2  2  24 109      2
3  3  18 114      3
4  4  24 112      2
5  5  33 101      4
6  6  24  70      2
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
statistic   -4.291                                 
parameter   198                                    
p.value     1.392e-05                              
conf.int    Numeric,2                              
estimate    Numeric,2                              
null.value  0                                      
alternative "less"                                 
method      " Two Sample t-test"                   
data.name   "dots[[1L]][[1L]] and dots[[2L]][[1L]]"
            y1                                     
statistic   -6.212                                 
parameter   198                                    
p.value     1.514e-09                              
conf.int    Numeric,2                              
estimate    Numeric,2                              
null.value  0                                      
alternative "less"                                 
method      " Two Sample t-test"                   
data.name   "dots[[1L]][[2L]] and dots[[2L]][[2L]]"
```


### Separate descriptive statistics for each group for many variables


```r
tapply(myDf1$IQ, myDf1$group, FUN=mean)
```

```
    CG      T     WL 
 88.25 105.00 107.00 
```



```r
aggregate(myDf1[ , c("age", "IQ", "rating")],
          list(myDf1$sex, myDf1$group), FUN=mean)
```

```
  Group.1 Group.2  age    IQ rating
1       f      CG 25.5  92.0    5.0
2       m      CG 26.0  84.5    3.5
3       f       T 27.5 106.5    4.5
4       m       T 26.0 103.5    2.0
5       f      WL 28.0 101.0    2.0
6       m      WL 21.0 113.0    2.5
```

```r
aggregate(cbind(age, IQ, rating) ~ sex + group, FUN=mean, data=myDf1)
```

```
  sex group  age    IQ rating
1   f    CG 25.5  92.0    5.0
2   m    CG 26.0  84.5    3.5
3   f     T 27.5 106.5    4.5
4   m     T 26.0 103.5    2.0
5   f    WL 28.0 101.0    2.0
6   m    WL 21.0 113.0    2.5
```



```r
by(myDf1[ , c("age", "IQ", "rating")], list(myDf1$sex, myDf1$group), FUN=mean)
```

```
: f
: CG
   age     IQ rating 
  25.5   92.0    5.0 
-------------------------------------------------------- 
: m
: CG
   age     IQ rating 
  26.0   84.5    3.5 
-------------------------------------------------------- 
: f
: T
   age     IQ rating 
  27.5  106.5    4.5 
-------------------------------------------------------- 
: m
: T
   age     IQ rating 
  26.0  103.5    2.0 
-------------------------------------------------------- 
: f
: WL
   age     IQ rating 
    28    101      2 
-------------------------------------------------------- 
: m
: WL
   age     IQ rating 
  21.0  113.0    2.5 
```


Useful packages
-------------------------

Package [`plyr`](http://cran.r-project.org/package=plyr) provides more functions for efficiently and consistently handling character strings.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/aggregate.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/aggregate.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/aggregate.R) - [all posts](https://github.com/dwoll/RExRepos/)
