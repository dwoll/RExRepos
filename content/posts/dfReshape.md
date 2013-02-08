---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Reshape data frames: wide and long format"
categories: [DataFrames]
rerCat: Data_Frames
tags: [DataFrames]
---




Using `stack()` for data frames with a simple structure
-------------------------

### Wide format -> long format


```r
set.seed(1.234)
Nj     <- 4
cond1  <- sample(1:10, Nj, replace=TRUE)
cond2  <- sample(1:10, Nj, replace=TRUE)
cond3  <- sample(1:10, Nj, replace=TRUE)
dfTemp <- data.frame(cond1, cond2, cond3)
(res   <- stack(dfTemp, select=c("cond1", "cond3")))
```

```
  values   ind
1      3 cond1
2      4 cond1
3      6 cond1
4     10 cond1
5      7 cond3
6      1 cond3
7      3 cond3
8      2 cond3
```

```r
str(res)
```

```
'data.frame':	8 obs. of  2 variables:
 $ values: int  3 4 6 10 7 1 3 2
 $ ind   : Factor w/ 2 levels "cond1","cond3": 1 1 1 1 2 2 2 2
```


### Long format -> wide format


```r
unstack(res)
```

```
  cond1 cond3
1     3     7
2     4     1
3     6     3
4    10     2
```



```r
res$IVnew <- factor(sample(rep(c("A", "B"), Nj), 2*Nj, replace=FALSE))
res$DVnew <- sample(100:200, 2*Nj)
head(res)
```

```
  values   ind IVnew DVnew
1      3 cond1     B   194
2      4 cond1     A   121
3      6 cond1     A   164
4     10 cond1     A   112
5      7 cond3     B   125
6      1 cond3     B   137
```

```r
unstack(res, DVnew ~ IVnew)
```

```
    A   B
1 121 194
2 164 125
3 112 137
4 101 135
```


Using `reshape()` for more complex data frames
-------------------------

### One within variable

#### Simulate data


```r
Nj      <- 2
P       <- 2
Q       <- 3
id      <- 1:(P*Nj)
DV_t1   <- round(rnorm(P*Nj, -1, 1), 2)
DV_t2   <- round(rnorm(P*Nj,  0, 1), 2)
DV_t3   <- round(rnorm(P*Nj,  1, 1), 2)
IVbtw   <- factor(rep(c("A", "B"), Nj))
(dfWide <- data.frame(id, IVbtw, DV_t1, DV_t2, DV_t3))
```

```
  id IVbtw DV_t1 DV_t2 DV_t3
1  1     A  0.12  0.82  1.07
2  2     B -1.04  0.59 -0.99
3  3     A -1.02  0.92  1.62
4  4     B -0.06  0.78  0.94
```



```r
idL    <- rep(id, Q)
DVl    <- c(DV_t1, DV_t2, DV_t3)
IVwth  <- factor(rep(1:3, each=P*Nj))
IVbtwL <- rep(IVbtw, times=Q)
dfLong <- data.frame(id=idL, IVbtw=IVbtwL, IVwth=IVwth, DV=DVl)
dfLong[order(dfLong$id), ]
```

```
   id IVbtw IVwth    DV
1   1     A     1  0.12
5   1     A     2  0.82
9   1     A     3  1.07
2   2     B     1 -1.04
6   2     B     2  0.59
10  2     B     3 -0.99
3   3     A     1 -1.02
7   3     A     2  0.92
11  3     A     3  1.62
4   4     B     1 -0.06
8   4     B     2  0.78
12  4     B     3  0.94
```


#### Wide format -> long format


```r
resLong <- reshape(dfWide, varying=c("DV_t1", "DV_t2", "DV_t3"),
                   direction="long", idvar=c("id", "IVbtw"),
                   v.names="DV", timevar="IVwth")
resLong[order(resLong$id), ]
```

```
      id IVbtw IVwth    DV
1.A.1  1     A     1  0.12
1.A.2  1     A     2  0.82
1.A.3  1     A     3  1.07
2.B.1  2     B     1 -1.04
2.B.2  2     B     2  0.59
2.B.3  2     B     3 -0.99
3.A.1  3     A     1 -1.02
3.A.2  3     A     2  0.92
3.A.3  3     A     3  1.62
4.B.1  4     B     1 -0.06
4.B.2  4     B     2  0.78
4.B.3  4     B     3  0.94
```



```r
resLong$IVwth <- factor(resLong$IVwth)
all.equal(dfLong, resLong, check.attributes=FALSE)
```

```
[1] TRUE
```


#### Long format -> wide format


```r
reshape(dfLong, v.names="DV", timevar="IVwth", idvar=c("id", "IVbtw"),
        direction="wide")
```

```
  id IVbtw  DV.1 DV.2  DV.3
1  1     A  0.12 0.82  1.07
2  2     B -1.04 0.59 -0.99
3  3     A -1.02 0.92  1.62
4  4     B -0.06 0.78  0.94
```


### Two within variables

#### Simulate data


```r
Nj   <- 4
id   <- 1:Nj
t_11 <- round(rnorm(Nj,  8, 2), 2)
t_21 <- round(rnorm(Nj, 13, 2), 2)
t_31 <- round(rnorm(Nj, 13, 2), 2)
t_12 <- round(rnorm(Nj, 10, 2), 2)
t_22 <- round(rnorm(Nj, 15, 2), 2)
t_32 <- round(rnorm(Nj, 15, 2), 2)
dfW  <- data.frame(id, t_11, t_21, t_31, t_12, t_22, t_32)
```


#### Wide format -> long format


```r
(dfL1 <- reshape(dfW, varying=list(c("t_11", "t_21", "t_31"),
                                   c("t_12", "t_22", "t_32")),
                 direction="long", timevar="IV1", idvar="id",
                 v.names=c("IV2-1", "IV2-2")))
```

```
    id IV1 IV2-1 IV2-2
1.1  1   1  7.69 12.20
2.1  2   1  5.06 11.53
3.1  3   1  7.04  9.67
4.1  4   1  8.84  9.49
1.2  1   2 15.72 16.39
2.2  2   2 12.79 16.11
3.2  3   2 13.78 13.62
4.2  4   2 12.89 13.59
1.3  1   3 10.25 15.73
2.3  2   3 12.17 16.54
3.3  3   3 12.21 14.78
4.3  4   3 12.88 16.76
```



```r
dfL2 <- reshape(dfL1, varying=c("IV2-1", "IV2-2"),
				direction="long", timevar="IV2",
				idvar=c("id", "IV1"), v.names="DV")
head(dfL2)
```

```
      id IV1 IV2    DV
1.1.1  1   1   1  7.69
2.1.1  2   1   1  5.06
3.1.1  3   1   1  7.04
4.1.1  4   1   1  8.84
1.2.1  1   2   1 15.72
2.2.1  2   2   1 12.79
```


#### Long format -> wide format


```r
dfW1 <- reshape(dfL2, v.names="DV", timevar="IV1",
                idvar=c("id", "IV2"), direction="wide")
```



```r
dfW2 <- reshape(dfW1, v.names=c("DV.1", "DV.2", "DV.3"),
                timevar="IV2", idvar="id", direction="wide")

all.equal(dfW, dfW2, check.attributes=FALSE)
```

```
[1] TRUE
```


Useful packages
-------------------------

Package [`reshape2`](http://cran.r-project.org/package=reshape2) provides functions `melt()` and `cast()` for an integrated approach to reshaping data frames.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dfReshape.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dfReshape.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dfReshape.R) - [all posts](https://github.com/dwoll/RExRepos/)
