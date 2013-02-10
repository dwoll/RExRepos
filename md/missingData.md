---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Deal with missing data"
categories: [Descriptive]
rerCat: Descriptive
tags: [Descriptive]
---

Deal with missing data
=========================

Identify missing data with `is.na()`
-------------------------

### Find out which and how many observations have missing data

In R, missing values are coded as `NA` (not available)


```r
vec <- c(2, 5, 7)
vec[5]
```

```
[1] NA
```



```r
(vec1 <- c(10, 20, NA, 40, 50, NA))
```

```
[1] 10 20 NA 40 50 NA
```

```r
length(vec1)
```

```
[1] 6
```


Identify missing values with `is.na()`


```r
is.na(vec1)
```

```
[1] FALSE FALSE  TRUE FALSE FALSE  TRUE
```

```r
any(is.na(vec1))
```

```
[1] TRUE
```

```r
which(is.na(vec1))
```

```
[1] 3 6
```

```r
sum(is.na(vec1))
```

```
[1] 2
```


### Identify missing data in matrices


```r
vec2   <- c(NA, 7, 9, 10, 1, 8)
(matNA <- rbind(vec1, vec2))
```

```
     [,1] [,2] [,3] [,4] [,5] [,6]
vec1   10   20   NA   40   50   NA
vec2   NA    7    9   10    1    8
```

```r
is.na(matNA)
```

```
      [,1]  [,2]  [,3]  [,4]  [,5]  [,6]
vec1 FALSE FALSE  TRUE FALSE FALSE  TRUE
vec2  TRUE FALSE FALSE FALSE FALSE FALSE
```


Behavior of `NA` in different situations
-------------------------

### Missing data in index vectors


```r
LETTERS[c(1, NA, 3)]
```

```
[1] "A" NA  "C"
```


### Missing data in factors


```r
factor(LETTERS[c(1, NA, 3)])
```

```
[1] A    <NA> C   
Levels: A C
```

```r
factor(LETTERS[c(1, NA, 3)], exclude=NULL)
```

```
[1] A    <NA> C   
Levels: A C <NA>
```


### Missing data in logical expressions


```r
NA & TRUE
```

```
[1] NA
```

```r
TRUE | NA
```

```
[1] TRUE
```



```r
vecNA   <- c(-3, 2, 0, NA, -7, 5)
(logIdx <- vecNA > 0)
```

```
[1] FALSE  TRUE FALSE    NA FALSE  TRUE
```

```r
vecNA[logIdx]
```

```
[1]  2 NA  5
```

```r
vecNA[which(logIdx)]
```

```
[1] 2 5
```


Code missing values as `NA`
-------------------------

When data is entered in other applications (spreadsheets, SPSS, etc.), missing values are often coded as a reserved numeric value, e.g., 99 or 9999. These values need to be replaced with `NA`.

### In vectors


```r
vec <- c(30, 25, 23, 21, -999, 999)
is.na(vec) <- vec %in% c(-999, 999)
vec
```

```
[1] 30 25 23 21 NA NA
```


### In matrices


```r
(mat <- matrix(c(30, 25, 23, 21, -999, 999), nrow=2, ncol=3))
```

```
     [,1] [,2] [,3]
[1,]   30   23 -999
[2,]   25   21  999
```

```r
is.na(mat) <- mat %in% c(-999, 999)
mat
```

```
     [,1] [,2] [,3]
[1,]   30   23   NA
[2,]   25   21   NA
```


Statistical analysis with missing data
-------------------------

### In vectors


```r
vecNA <- c(-3, 2, 0, NA, -7, 5)
mean(vecNA)
```

```
[1] NA
```



```r
goodIdx <- !is.na(vecNA)
mean(vecNA[goodIdx])
```

```
[1] -0.6
```

```r
sd(na.omit(vecNA))
```

```
[1] 4.615
```

```r
sum(vecNA, na.rm=TRUE)
```

```
[1] -3
```


### In matrices


```r
ageNA  <- c(18, NA, 27, 22)
DV1    <- c(NA, 1, 5, -3)
DV2    <- c(9, 4, 2, 7)
(matNA <- cbind(ageNA, DV1, DV2))
```

```
     ageNA DV1 DV2
[1,]    18  NA   9
[2,]    NA   1   4
[3,]    27   5   2
[4,]    22  -3   7
```



```r
apply(matNA, 1, FUN=mean)
```

```
[1]     NA     NA 11.333  8.667
```

```r
apply(matNA, 1, FUN=mean, na.rm=TRUE)
```

```
[1] 13.500  2.500 11.333  8.667
```


### Casewise deletion of missing data


```r
(rowNAidx <- apply(is.na(matNA), 1, any))
```

```
[1]  TRUE  TRUE FALSE FALSE
```

```r
matNA[!rowNAidx, ]
```

```
     ageNA DV1 DV2
[1,]    27   5   2
[2,]    22  -3   7
```



```r
na.omit(matNA)
```

```
     ageNA DV1 DV2
[1,]    27   5   2
[2,]    22  -3   7
attr(,"na.action")
[1] 2 1
attr(,"class")
[1] "omit"
```

```r
colMeans(na.omit(matNA))
```

```
ageNA   DV1   DV2 
 24.5   1.0   4.5 
```



```r
cov(matNA, use="complete.obs")
```

```
      ageNA DV1   DV2
ageNA  12.5  20 -12.5
DV1    20.0  32 -20.0
DV2   -12.5 -20  12.5
```

```r
all(cov(matNA, use="complete.obs") == cov(na.omit(matNA)))
```

```
[1] TRUE
```


Set casewise deletion as a permanent option for statistical functions (another choice is `"na.fail"`)


```r
options(na.action="na.omit")
```


### Pairwise deletion of missing data


```r
rowMeans(matNA)
```

```
[1]     NA     NA 11.333  8.667
```

```r
rowMeans(mat, na.rm=TRUE)
```

```
[1] 26.5 23.0
```

```r
cov(matNA, use="pairwise.complete.obs")
```

```
       ageNA DV1     DV2
ageNA  20.33  20 -16.000
DV1    20.00  16 -10.000
DV2   -16.00 -10   9.667
```


Useful packages
-------------------------

Multiple imputation is supported by functions in packages [`Hmisc`](http://cran.r-project.org/package=Hmisc), [`Amelia II`](http://cran.r-project.org/package=Amelia), and [`mice`](http://cran.r-project.org/package=mice).

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/missingData.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/missingData.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/missingData.R) - [all posts](https://github.com/dwoll/RExRepos/)
