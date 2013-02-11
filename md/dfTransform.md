---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Transform data frames"
categories: [DataFrames]
rerCat: Data_Frames
tags: [DataFrames]
---

Transform data frames
=========================

TODO
-------------------------

 - link to strings for `grep()`, dfSplitMerge, dfReshape

Add variables to a data frame
-------------------------


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
1  1   f     T  29 111      4    FALSE
2  2   m    CG  30  93      1     TRUE
3  3   f    WL  27  84      2     TRUE
4  4   m     T  28  97      2     TRUE
5  5   m    CG  23  85      5     TRUE
6  6   f    CG  20  89      3    FALSE
```

```r
myDf4 <- transform(myDf3, rSq=rating^2)
head(myDf4)
```

```
  id sex group age  IQ rating isSingle rSq
1  1   f     T  29 111      4    FALSE  16
2  2   m    CG  30  93      1     TRUE   1
3  3   f    WL  27  84      2     TRUE   4
4  4   m     T  28  97      2     TRUE   4
5  5   m    CG  23  85      5     TRUE  25
6  6   f    CG  20  89      3    FALSE   9
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
1  1   f  29 111      4
2  2   m  30  93      1
3  3   f  27  84      2
4  4   m  28  97      2
5  5   m  23  85      5
6  6   f  20  89      3
```



```r
delVars         <- c("sex", "IQ")
dfTemp[delVars] <- list(NULL)
head(dfTemp)
```

```
  id age rating
1  1  29      4
2  2  30      1
3  3  27      2
4  4  28      2
5  5  23      5
6  6  20      3
```


Sort data frames
-------------------------


```r
(idx1 <- order(myDf1$rating))
```

```
 [1]  2  3  4  6 10  1 12  5  7  8  9 11
```

```r
myDf1[idx1, ]
```

```
   id sex group age  IQ rating
2   2   m    CG  30  93      1
3   3   f    WL  27  84      2
4   4   m     T  28  97      2
6   6   f    CG  20  89      3
10 10   f     T  32 102      3
1   1   f     T  29 111      4
12 12   f    WL  26 119      4
5   5   m    CG  23  85      5
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
11 11   m     T  18  83      5
```

```r
(idx2 <- order(myDf1$group, myDf1$IQ))
```

```
 [1]  5  6  2  9 11  4 10  1  8  3  7 12
```

```r
myDf1[idx2, ]
```

```
   id sex group age  IQ rating
5   5   m    CG  23  85      5
6   6   f    CG  20  89      3
2   2   m    CG  30  93      1
9   9   m    CG  30 113      5
11 11   m     T  18  83      5
4   4   m     T  28  97      2
10 10   f     T  32 102      3
1   1   f     T  29 111      4
8   8   m    WL  34  75      5
3   3   f    WL  27  84      2
7   7   m    WL  35  91      5
12 12   f    WL  26 119      4
```

```r
(idx3 <- order(myDf1$group, -myDf1$rating))
```

```
 [1]  5  9  6  2 11  1 10  4  7  8 12  3
```

```r
myDf1[idx3, ]
```

```
   id sex group age  IQ rating
5   5   m    CG  23  85      5
9   9   m    CG  30 113      5
6   6   f    CG  20  89      3
2   2   m    CG  30  93      1
11 11   m     T  18  83      5
1   1   f     T  29 111      4
10 10   f     T  32 102      3
4   4   m     T  28  97      2
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
12 12   f    WL  26 119      4
3   3   f    WL  27  84      2
```


Select subsets of data
-------------------------

### Select cases and variables using index vectors


```r
(idxLog <- myDf1$sex == "f")
```

```
 [1]  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE
[12]  TRUE
```

```r
(idxNum <- which(idxLog))
```

```
[1]  1  3  6 10 12
```

```r
myDf1[idxNum, ]
```

```
   id sex group age  IQ rating
1   1   f     T  29 111      4
3   3   f    WL  27  84      2
6   6   f    CG  20  89      3
10 10   f     T  32 102      3
12 12   f    WL  26 119      4
```



```r
(idx2 <- (myDf1$sex == "m") & (myDf1$rating > 2))
```

```
 [1] FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE
[12] FALSE
```

```r
myDf1[which(idx2), ]
```

```
   id sex group age  IQ rating
5   5   m    CG  23  85      5
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
11 11   m     T  18  83      5
```



```r
(idx3 <- (myDf1$IQ < 90) | (myDf1$IQ > 110))
```

```
 [1]  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE
[12]  TRUE
```

```r
myDf1[which(idx3), ]
```

```
   id sex group age  IQ rating
1   1   f     T  29 111      4
3   3   f    WL  27  84      2
5   5   m    CG  23  85      5
6   6   f    CG  20  89      3
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
11 11   m     T  18  83      5
12 12   f    WL  26 119      4
```



```r
myDf1[1:3, c("group", "IQ")]
```

```
  group  IQ
1     T 111
2    CG  93
3    WL  84
```

```r
myDf1[1:3, 2:4]
```

```
  sex group age
1   f     T  29
2   m    CG  30
3   f    WL  27
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
1   29  111    4
2   30   93    1
3   27   84    2
```


See `?Extract` for help on this topic.

### Select cases and variables using `subset()`


```r
subset(myDf1, sex == "f")
```

```
   id sex group age  IQ rating
1   1   f     T  29 111      4
3   3   f    WL  27  84      2
6   6   f    CG  20  89      3
10 10   f     T  32 102      3
12 12   f    WL  26 119      4
```

```r
subset(myDf1, sex == "f", select=-2)
```

```
   id group age  IQ rating
1   1     T  29 111      4
3   3    WL  27  84      2
6   6    CG  20  89      3
10 10     T  32 102      3
12 12    WL  26 119      4
```

```r
subset(myDf1, (sex == "m") & (rating > 2))
```

```
   id sex group age  IQ rating
5   5   m    CG  23  85      5
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
11 11   m     T  18  83      5
```

```r
subset(myDf1, (IQ < 90) | (IQ > 110))
```

```
   id sex group age  IQ rating
1   1   f     T  29 111      4
3   3   f    WL  27  84      2
5   5   m    CG  23  85      5
6   6   f    CG  20  89      3
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
11 11   m     T  18  83      5
12 12   f    WL  26 119      4
```

```r
subset(myDf1, group %in% c("CG", "WL"))
```

```
   id sex group age  IQ rating
2   2   m    CG  30  93      1
3   3   f    WL  27  84      2
5   5   m    CG  23  85      5
6   6   f    CG  20  89      3
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
12 12   f    WL  26 119      4
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
  id sex group age IQ rating
4  4   m     T  28 NA      2
5  5   m    CG  23 85     NA
```

```r
head(na.omit(myDfNA))
```

```
  id sex group age  IQ rating
1  1   f     T  29 111      4
2  2   m    CG  30  93      1
3  3   f    WL  27  84      2
6  6   f    CG  20  89      3
7  7   m    WL  35  91      5
8  8   m    WL  34  75      5
```


Useful packages
-------------------------

Package [`plyr`](http://cran.r-project.org/package=plyr) provides very handy functions for the split-apply-combine approach to aggregating data frames. In order to work with data frames like with a database, use [`sqldf`](http://cran.r-project.org/package=sqldf). You can then use standard SQL commands to select data. This is useful for extremely large datasets where `sqldf` provides increased performance.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dfTransform.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dfTransform.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dfTransform.R) - [all posts](https://github.com/dwoll/RExRepos/)
