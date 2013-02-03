---
layout: post
title: "Transform data frames"
categories: [DataFrames]
rerCat: Data_Frames
tags: [DataFrames]
---




TODO
-------------------------

 - link to strings for `grep()`, dfSplitMerge, dfReshape

Add variables to a data frame
-------------------------


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



```r
isSingle <- sample(c(TRUE, FALSE), nrow(myDf1), replace=TRUE)
myDf2    <- myDf1
myDf2$isSingle1    <- isSingle
myDf2["isSingle2"] <- isSingle
myDf3 <- cbind(myDf1, isSingle)
head(myDf3)
```

```
  id sex group age  IQ rating isSingle
1  1   f     T  22 112      5     TRUE
2  2   f    WL  24 109      2     TRUE
3  3   m    WL  18 114      3     TRUE
4  4   m    WL  24 112      2    FALSE
5  5   f     T  33 101      4    FALSE
6  6   m    CG  24  70      2     TRUE
```

```r
myDf4 <- transform(myDf3, rSq=rating^2)
head(myDf4)
```

```
  id sex group age  IQ rating isSingle rSq
1  1   f     T  22 112      5     TRUE  25
2  2   f    WL  24 109      2     TRUE   4
3  3   m    WL  18 114      3     TRUE   9
4  4   m    WL  24 112      2    FALSE   4
5  5   f     T  33 101      4    FALSE  16
6  6   m    CG  24  70      2     TRUE   4
```


Remove variables from a data frame
-------------------------


```r
dfTemp       <- myDf1
dfTemp$group <- NULL
head(dfTemp)
```

```
  id sex age  IQ rating
1  1   f  22 112      5
2  2   f  24 109      2
3  3   m  18 114      3
4  4   m  24 112      2
5  5   f  33 101      4
6  6   m  24  70      2
```



```r
delVars         <- c("sex", "IQ")
dfTemp[delVars] <- list(NULL)
head(dfTemp)
```

```
  id age rating
1  1  22      5
2  2  24      2
3  3  18      3
4  4  24      2
5  5  33      4
6  6  24      2
```


Sort data frames
-------------------------


```r
(idx1 <- order(myDf1$rating))
```

```
 [1]  9  2  4  6 11  3  7  5  1  8 10 12
```

```r
myDf1[idx1, ]
```

```
   id sex group age  IQ rating
9   9   m     T  26  98      1
2   2   f    WL  24 109      2
4   4   m    WL  24 112      2
6   6   m    CG  24  70      2
11 11   f    WL  32  93      2
3   3   m    WL  18 114      3
7   7   m     T  26 109      3
5   5   f     T  33 101      4
1   1   f     T  22 112      5
8   8   m    CG  28  99      5
10 10   f    CG  21  78      5
12 12   f    CG  30 106      5
```

```r
(idx2 <- order(myDf1$group, myDf1$IQ))
```

```
 [1]  6 10  8 12  9  5  7  1 11  2  4  3
```

```r
myDf1[idx2, ]
```

```
   id sex group age  IQ rating
6   6   m    CG  24  70      2
10 10   f    CG  21  78      5
8   8   m    CG  28  99      5
12 12   f    CG  30 106      5
9   9   m     T  26  98      1
5   5   f     T  33 101      4
7   7   m     T  26 109      3
1   1   f     T  22 112      5
11 11   f    WL  32  93      2
2   2   f    WL  24 109      2
4   4   m    WL  24 112      2
3   3   m    WL  18 114      3
```

```r
(idx3 <- order(myDf1$group, -myDf1$rating))
```

```
 [1]  8 10 12  6  1  5  7  9  3  2  4 11
```

```r
myDf1[idx3, ]
```

```
   id sex group age  IQ rating
8   8   m    CG  28  99      5
10 10   f    CG  21  78      5
12 12   f    CG  30 106      5
6   6   m    CG  24  70      2
1   1   f     T  22 112      5
5   5   f     T  33 101      4
7   7   m     T  26 109      3
9   9   m     T  26  98      1
3   3   m    WL  18 114      3
2   2   f    WL  24 109      2
4   4   m    WL  24 112      2
11 11   f    WL  32  93      2
```


Select subsets of data
-------------------------

### Select cases and variables using index vectors


```r
(idxLog <- myDf1$sex == "f")
```

```
 [1]  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE  TRUE
[12]  TRUE
```

```r
(idxNum <- which(idxLog))
```

```
[1]  1  2  5 10 11 12
```

```r
myDf1[idxNum, ]
```

```
   id sex group age  IQ rating
1   1   f     T  22 112      5
2   2   f    WL  24 109      2
5   5   f     T  33 101      4
10 10   f    CG  21  78      5
11 11   f    WL  32  93      2
12 12   f    CG  30 106      5
```



```r
(idx2 <- (myDf1$sex == "m") & (myDf1$rating > 2))
```

```
 [1] FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE
[12] FALSE
```

```r
myDf1[which(idx2), ]
```

```
  id sex group age  IQ rating
3  3   m    WL  18 114      3
7  7   m     T  26 109      3
8  8   m    CG  28  99      5
```



```r
(idx3 <- (myDf1$IQ < 90) | (myDf1$IQ > 110))
```

```
 [1]  TRUE FALSE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE
[12] FALSE
```

```r
myDf1[which(idx3), ]
```

```
   id sex group age  IQ rating
1   1   f     T  22 112      5
3   3   m    WL  18 114      3
4   4   m    WL  24 112      2
6   6   m    CG  24  70      2
10 10   f    CG  21  78      5
```



```r
myDf1[1:3, c("group", "IQ")]
```

```
  group  IQ
1     T 112
2    WL 109
3    WL 114
```

```r
myDf1[1:3, 2:4]
```

```
  sex group age
1   f     T  22
2   f    WL  24
3   m    WL  18
```



```r
dfTemp         <- myDf1
(names(dfTemp) <- paste(rep(c("A", "B"), each=3), 100:102, sep=""))
```

```
[1] "A100" "A101" "A102" "B100" "B101" "B102"
```

```r
(colIdx <- grep("^B.*$", names(dfTemp)))
```

```
[1] 4 5 6
```

```r
dfTemp[1:3, colIdx]
```

```
  B100 B101 B102
1   22  112    5
2   24  109    2
3   18  114    3
```


See `?Extract` for help on this topic.

### Select cases and variables using `subset()`


```r
subset(myDf1, sex == "f")
```

```
   id sex group age  IQ rating
1   1   f     T  22 112      5
2   2   f    WL  24 109      2
5   5   f     T  33 101      4
10 10   f    CG  21  78      5
11 11   f    WL  32  93      2
12 12   f    CG  30 106      5
```

```r
subset(myDf1, sex == "f", select=-2)
```

```
   id group age  IQ rating
1   1     T  22 112      5
2   2    WL  24 109      2
5   5     T  33 101      4
10 10    CG  21  78      5
11 11    WL  32  93      2
12 12    CG  30 106      5
```

```r
subset(myDf1, (sex == "m") & (rating > 2))
```

```
  id sex group age  IQ rating
3  3   m    WL  18 114      3
7  7   m     T  26 109      3
8  8   m    CG  28  99      5
```

```r
subset(myDf1, (IQ < 90) | (IQ > 110))
```

```
   id sex group age  IQ rating
1   1   f     T  22 112      5
3   3   m    WL  18 114      3
4   4   m    WL  24 112      2
6   6   m    CG  24  70      2
10 10   f    CG  21  78      5
```

```r
subset(myDf1, group %in% c("CG", "WL"))
```

```
   id sex group age  IQ rating
2   2   f    WL  24 109      2
3   3   m    WL  18 114      3
4   4   m    WL  24 112      2
6   6   m    CG  24  70      2
8   8   m    CG  28  99      5
10 10   f    CG  21  78      5
11 11   f    WL  32  93      2
12 12   f    CG  30 106      5
```


Remove duplicated cases
-------------------------


```r
myDfDouble <- rbind(myDf1, myDf1[sample(1:nrow(myDf1), 4), ])
duplicated(myDfDouble)
```

```
 [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
[12] FALSE  TRUE  TRUE  TRUE  TRUE
```

```r
myDfUnique <- unique(myDfDouble)
```


Treat missing values
-------------------------


```r
myDfNA           <- myDf1
myDfNA$IQ[4]     <- NA
myDfNA$rating[5] <- NA
```



```r
is.na(myDfNA)[1:5, c("age", "IQ", "rating")]
```

```
       age    IQ rating
[1,] FALSE FALSE  FALSE
[2,] FALSE FALSE  FALSE
[3,] FALSE FALSE  FALSE
[4,] FALSE  TRUE  FALSE
[5,] FALSE FALSE   TRUE
```

```r
apply(is.na(myDfNA), 2, any)
```

```
    id    sex  group    age     IQ rating 
 FALSE  FALSE  FALSE  FALSE   TRUE   TRUE 
```

```r
complete.cases(myDfNA)
```

```
 [1]  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
[12]  TRUE
```

```r
subset(myDfNA, !complete.cases(myDfNA))
```

```
  id sex group age  IQ rating
4  4   m    WL  24  NA      2
5  5   f     T  33 101     NA
```

```r
head(na.omit(myDfNA))
```

```
  id sex group age  IQ rating
1  1   f     T  22 112      5
2  2   f    WL  24 109      2
3  3   m    WL  18 114      3
6  6   m    CG  24  70      2
7  7   m     T  26 109      3
8  8   m    CG  28  99      5
```


Useful packages
-------------------------

Package [`plyr`](http://cran.r-project.org/package=plyr) provides very handy functions for the split-apply-combine approach to aggregating data frames.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dfTransform.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dfTransform.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dfTransform.R) - [all posts](https://github.com/dwoll/RExRepos/)
