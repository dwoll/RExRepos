---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Split and merge data frames"
categories: [DataFrames]
rerCat: Data_Frames
tags: [DataFrames]
---




TODO
-------------------------

 - link to dfTransform

Split a data frame according to group membership
-------------------------


```r
set.seed(1.234)
N      <- 12
sex    <- sample(c("f", "m"), N, replace=TRUE)
group  <- sample(rep(c("CG", "WL", "T"), 4), N, replace=FALSE)
age    <- sample(18:35, N, replace=TRUE)
IQ     <- round(rnorm(N, mean=100, sd=15))
rating <- round(runif(N, min=0, max=6))
(myDf  <- data.frame(id=1:N, sex, group, age, IQ, rating))
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



```r
(lDf <- split(myDf, myDf$group))
```

```
$CG
   id sex group age  IQ rating
6   6   m    CG  24  70      2
8   8   m    CG  28  99      5
10 10   f    CG  21  78      5
12 12   f    CG  30 106      5

$T
  id sex group age  IQ rating
1  1   f     T  22 112      5
5  5   f     T  33 101      4
7  7   m     T  26 109      3
9  9   m     T  26  98      1

$WL
   id sex group age  IQ rating
2   2   f    WL  24 109      2
3   3   m    WL  18 114      3
4   4   m    WL  24 112      2
11 11   f    WL  32  93      2
```

```r
split(myDf, list(myDf$group, myDf$sex))
```

```
$CG.f
   id sex group age  IQ rating
10 10   f    CG  21  78      5
12 12   f    CG  30 106      5

$T.f
  id sex group age  IQ rating
1  1   f     T  22 112      5
5  5   f     T  33 101      4

$WL.f
   id sex group age  IQ rating
2   2   f    WL  24 109      2
11 11   f    WL  32  93      2

$CG.m
  id sex group age IQ rating
6  6   m    CG  24 70      2
8  8   m    CG  28 99      5

$T.m
  id sex group age  IQ rating
7  7   m     T  26 109      3
9  9   m     T  26  98      1

$WL.m
  id sex group age  IQ rating
3  3   m    WL  18 114      3
4  4   m    WL  24 112      2
```

```r
unsplit(lDf, myDf$group)
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


Merge data frames
-------------------------

### Different cases for the same variables


```r
(dfNew <- data.frame(id=13:15,
                     group=c("CG", "WL", "T"),
                     sex=c("f", "f", "m"),
                     age=c(18, 31, 21),
                     IQ=c(116, 101, 99),
                     rating=c(4, 4, 1)))
```

```
  id group sex age  IQ rating
1 13    CG   f  18 116      4
2 14    WL   f  31 101      4
3 15     T   m  21  99      1
```

```r
dfComb <- rbind(myDf, dfNew)
dfComb[11:15, ]
```

```
   id sex group age  IQ rating
11 11   f    WL  32  93      2
12 12   f    CG  30 106      5
13 13   f    CG  18 116      4
14 14   f    WL  31 101      4
15 15   m     T  21  99      1
```


Check with `duplicated()` and `unique()` for duplicate cases.

### Different variables from the same cases


```r
(dfA <- data.frame(id=1:4,
                   initials=c("AB", "CD", "EF", "GH"),
                   IV1=c("-", "-", "+", "+"),
                   DV1=c(10, 10, 11, 14)))
```

```
  id initials IV1 DV1
1  1       AB   -  10
2  2       CD   -  10
3  3       EF   +  11
4  4       GH   +  14
```

```r
(dfB <- data.frame(id=1:4,
                   initials=c("AB", "CD", "EF", "GH"),
                   IV2=c("A", "B", "A", "B"),
                   DV2=c(91, 89, 92, 79)))
```

```
  id initials IV2 DV2
1  1       AB   A  91
2  2       CD   B  89
3  3       EF   A  92
4  4       GH   B  79
```



```r
merge(dfA, dfB)
```

```
  id initials IV1 DV1 IV2 DV2
1  1       AB   -  10   A  91
2  2       CD   -  10   B  89
3  3       EF   +  11   A  92
4  4       GH   +  14   B  79
```

```r
merge(dfA, dfB, by.x=c(TRUE, FALSE, FALSE, FALSE),
                by.y=c(TRUE, FALSE, FALSE, FALSE))
```

```
  id initials.x IV1 DV1 initials.y IV2 DV2
1  1         AB   -  10         AB   A  91
2  2         CD   -  10         CD   B  89
3  3         EF   +  11         EF   A  92
4  4         GH   +  14         GH   B  79
```


### Keep cases with partial data


```r
(dfC <- data.frame(id=3:6,
                   initials=c("EF", "GH", "IJ", "KL"),
                   IV2=c("A", "B", "A", "B"),
                   DV2=c(92, 79, 101, 81)))
```

```
  id initials IV2 DV2
1  3       EF   A  92
2  4       GH   B  79
3  5       IJ   A 101
4  6       KL   B  81
```



```r
merge(dfA, dfC)
```

```
  id initials IV1 DV1 IV2 DV2
1  3       EF   +  11   A  92
2  4       GH   +  14   B  79
```

```r
merge(dfA, dfC, all.y=TRUE)
```

```
  id initials  IV1 DV1 IV2 DV2
1  3       EF    +  11   A  92
2  4       GH    +  14   B  79
3  5       IJ <NA>  NA   A 101
4  6       KL <NA>  NA   B  81
```

```r
merge(dfA, dfC, all.x=TRUE, all.y=TRUE)
```

```
  id initials  IV1 DV1  IV2 DV2
1  1       AB    -  10 <NA>  NA
2  2       CD    -  10 <NA>  NA
3  3       EF    +  11    A  92
4  4       GH    +  14    B  79
5  5       IJ <NA>  NA    A 101
6  6       KL <NA>  NA    B  81
```


Useful packages
-------------------------

Package [`plyr`](http://cran.r-project.org/package=plyr) provides very handy functions for the split-apply-combine approach to aggregating data frames.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dfSplitMerge.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dfSplitMerge.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dfSplitMerge.R) - [all posts](https://github.com/dwoll/RExRepos/)
