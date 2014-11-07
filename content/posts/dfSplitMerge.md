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
set.seed(123)
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


```r
(lDf <- split(myDf, myDf$group))
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
split(myDf, list(myDf$group, myDf$sex))
```

```
$CG.f
  id sex group age IQ rating
6  6   f    CG  20 89      3

$T.f
   id sex group age  IQ rating
1   1   f     T  29 111      4
10 10   f     T  32 102      3

$WL.f
   id sex group age  IQ rating
3   3   f    WL  27  84      2
12 12   f    WL  26 119      4

$CG.m
  id sex group age  IQ rating
2  2   m    CG  30  93      1
5  5   m    CG  23  85      5
9  9   m    CG  30 113      5

$T.m
   id sex group age IQ rating
4   4   m     T  28 97      2
11 11   m     T  18 83      5

$WL.m
  id sex group age IQ rating
7  7   m    WL  35 91      5
8  8   m    WL  34 75      5
```

```r
unsplit(lDf, myDf$group)
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
11 11   m     T  18  83      5
12 12   f    WL  26 119      4
13 13   f    CG  18 116      4
14 14   f    WL  31 101      4
15 15   m     T  21  99      1
```

Check with `duplicated()` and `unique()` for duplicate cases.

### Different variables from the same cases

Data frames like from normalized data base.


```r
(IDDV <- data.frame(ID=factor(rep(1:3, each=2)),
                    DV=round(rnorm(6, 100, 15))))
```

```
  ID  DV
1  1 108
2  1  99
3  2  95
4  2  94
5  3  90
6  3  97
```

```r
(IV <- data.frame(ID=factor(1:3),
                  IV=factor(c("A", "B", "A")),
                  sex=factor(c("f", "f", "m"))))
```

```
  ID IV sex
1  1  A   f
2  2  B   f
3  3  A   m
```

```r
merge(IDDV, IV)
```

```
  ID  DV IV sex
1  1 108  A   f
2  1  99  A   f
3  2  95  B   f
4  2  94  B   f
5  3  90  A   m
6  3  97  A   m
```


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

Package [`dplyr`](http://cran.r-project.org/package=dplyr) provides very handy functions for the split-apply-combine approach to aggregating data frames.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dfSplitMerge.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dfSplitMerge.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dfSplitMerge.R) - [all posts](https://github.com/dwoll/RExRepos/)
