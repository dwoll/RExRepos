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
set.seed(123)
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
2      8 cond1
3      5 cond1
4      9 cond1
5      6 cond3
6      5 cond3
7     10 cond3
8      5 cond3
```

```r
str(res)
```

```
'data.frame':	8 obs. of  2 variables:
 $ values: int  3 8 5 9 6 5 10 5
 $ ind   : Factor w/ 2 levels "cond1","cond3": 1 1 1 1 2 2 2 2
```

### Long format -> wide format


```r
unstack(res)
```

```
  cond1 cond3
1     3     6
2     8     5
3     5    10
4     9     5
```


```r
res$IVnew <- factor(sample(rep(c("A", "B"), Nj), 2*Nj, replace=FALSE))
res$DVnew <- sample(100:200, 2*Nj)
head(res)
```

```
  values   ind IVnew DVnew
1      3 cond1     B   189
2      8 cond1     A   169
3      5 cond1     A   163
4      9 cond1     A   197
5      6 cond3     B   198
6      5 cond3     B   168
```

```r
unstack(res, DVnew ~ IVnew)
```

```
    A   B
1 169 189
2 163 198
3 197 168
4 151 155
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
1  1     A -1.56  0.70 -0.03
2  2     B  0.79 -0.47  0.27
3  3     A -0.50 -1.07  0.37
4  4     B -2.97 -0.22 -0.69
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
1   1     A     1 -1.56
5   1     A     2  0.70
9   1     A     3 -0.03
2   2     B     1  0.79
6   2     B     2 -0.47
10  2     B     3  0.27
3   3     A     1 -0.50
7   3     A     2 -1.07
11  3     A     3  0.37
4   4     B     1 -2.97
8   4     B     2 -0.22
12  4     B     3 -0.69
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
1.A.1  1     A     1 -1.56
1.A.2  1     A     2  0.70
1.A.3  1     A     3 -0.03
2.B.1  2     B     1  0.79
2.B.2  2     B     2 -0.47
2.B.3  2     B     3  0.27
3.A.1  3     A     1 -0.50
3.A.2  3     A     2 -1.07
3.A.3  3     A     3  0.37
4.B.1  4     B     1 -2.97
4.B.2  4     B     2 -0.22
4.B.3  4     B     3 -0.69
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
  id IVbtw  DV.1  DV.2  DV.3
1  1     A -1.56  0.70 -0.03
2  2     B  0.79 -0.47  0.27
3  3     A -0.50 -1.07  0.37
4  4     B -2.97 -0.22 -0.69
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
1.1  1   1  9.68  9.39
2.1  2   1  8.31  9.24
3.1  3   1  5.72  8.61
4.1  4   1 10.51  9.58
1.2  1   2 13.85 12.47
2.2  2   2 12.41 19.34
3.2  3   2 14.79 17.42
4.2  4   2 14.76 12.75
1.3  1   3 14.64 14.19
2.3  2   3 14.38 14.07
3.3  3   3 14.11 16.56
4.3  4   3 12.88 14.83
```


```r
dfL2 <- reshape(dfL1, varying=c("IV2-1", "IV2-2"),
				direction="long", timevar="IV2",
				idvar=c("id", "IV1"), v.names="DV")
head(dfL2)
```

```
      id IV1 IV2    DV
1.1.1  1   1   1  9.68
2.1.1  2   1   1  8.31
3.1.1  3   1   1  5.72
4.1.1  4   1   1 10.51
1.2.1  1   2   1 13.85
2.2.1  2   2   1 12.41
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
