---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Create and analyze data frames"
categories: [DataFrames]
rerCat: Data_Frames
tags: [DataFrames]
---




TODO
-------------------------

 - link to dfTransform

 Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car)


```r
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Create and analyze data frames
-------------------------

### Create data frames

From existing variables


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

### Analyze the structure of data frames


```r
dim(myDf1)
```

```
[1] 12  6
```

```r
nrow(myDf1)
```

```
[1] 12
```

```r
ncol(myDf1)
```

```
[1] 6
```

```r
summary(myDf1)
```

```
       id        sex   group       age              IQ        
 Min.   : 1.00   f:5   CG:4   Min.   :18.00   Min.   : 75.00  
 1st Qu.: 3.75   m:7   T :4   1st Qu.:25.25   1st Qu.: 84.75  
 Median : 6.50         WL:4   Median :28.50   Median : 92.00  
 Mean   : 6.50                Mean   :27.67   Mean   : 95.17  
 3rd Qu.: 9.25                3rd Qu.:30.50   3rd Qu.:104.25  
 Max.   :12.00                Max.   :35.00   Max.   :119.00  
     rating     
 Min.   :1.000  
 1st Qu.:2.750  
 Median :4.000  
 Mean   :3.667  
 3rd Qu.:5.000  
 Max.   :5.000  
```

```r
str(myDf1)
```

```
'data.frame':	12 obs. of  6 variables:
 $ id    : int  1 2 3 4 5 6 7 8 9 10 ...
 $ sex   : Factor w/ 2 levels "f","m": 1 2 1 2 2 1 2 2 2 1 ...
 $ group : Factor w/ 3 levels "CG","T","WL": 2 1 3 2 1 1 3 3 1 2 ...
 $ age   : int  29 30 27 28 23 20 35 34 30 32 ...
 $ IQ    : num  111 93 84 97 85 89 91 75 113 102 ...
 $ rating: num  4 1 2 2 5 3 5 5 5 3 ...
```


```r
head(myDf1)
```

```
  id sex group age  IQ rating
1  1   f     T  29 111      4
2  2   m    CG  30  93      1
3  3   f    WL  27  84      2
4  4   m     T  28  97      2
5  5   m    CG  23  85      5
6  6   f    CG  20  89      3
```

```r
tail(myDf1)
```

```
   id sex group age  IQ rating
7   7   m    WL  35  91      5
8   8   m    WL  34  75      5
9   9   m    CG  30 113      5
10 10   f     T  32 102      3
11 11   m     T  18  83      5
12 12   f    WL  26 119      4
```


```r
library(car)
some(myDf1, n=5)
```

```
  id sex group age  IQ rating
1  1   f     T  29 111      4
3  3   f    WL  27  84      2
4  4   m     T  28  97      2
5  5   m    CG  23  85      5
6  6   f    CG  20  89      3
```


```r
View(myDf1)
fix(myDf1)
# not shown
```

### Data types in data frames


```r
fac   <- c("CG", "T1", "T2")
DV1   <- c(14, 22, 18)
DV2   <- c("red", "blue", "blue")
myDf2 <- data.frame(fac, DV1, DV2, stringsAsFactors=FALSE)
str(myDf2)
```

```
'data.frame':	3 obs. of  3 variables:
 $ fac: chr  "CG" "T1" "T2"
 $ DV1: num  14 22 18
 $ DV2: chr  "red" "blue" "blue"
```


```r
fac   <- as.factor(fac)
myDf3 <- data.frame(fac, DV1, DV2, stringsAsFactors=FALSE)
str(myDf3)
```

```
'data.frame':	3 obs. of  3 variables:
 $ fac: Factor w/ 3 levels "CG","T1","T2": 1 2 3
 $ DV1: num  14 22 18
 $ DV2: chr  "red" "blue" "blue"
```

### Names of cases and variables


```r
dimnames(myDf1)
```

```
[[1]]
 [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10" "11" "12"

[[2]]
[1] "id"     "sex"    "group"  "age"    "IQ"     "rating"
```

```r
names(myDf1)
```

```
[1] "id"     "sex"    "group"  "age"    "IQ"     "rating"
```

```r
names(myDf1)[3]
```

```
[1] "group"
```

```r
names(myDf1)[3] <- "fac"
names(myDf1)
```

```
[1] "id"     "sex"    "fac"    "age"    "IQ"     "rating"
```

```r
names(myDf1)[names(myDf1) == "fac"] <- "group"
names(myDf1)
```

```
[1] "id"     "sex"    "group"  "age"    "IQ"     "rating"
```


```r
(rows <- paste("Z", 1:12, sep=""))
```

```
 [1] "Z1"  "Z2"  "Z3"  "Z4"  "Z5"  "Z6"  "Z7"  "Z8"  "Z9"  "Z10" "Z11"
[12] "Z12"
```

```r
rownames(myDf1) <- rows
head(myDf1)
```

```
   id sex group age  IQ rating
Z1  1   f     T  29 111      4
Z2  2   m    CG  30  93      1
Z3  3   f    WL  27  84      2
Z4  4   m     T  28  97      2
Z5  5   m    CG  23  85      5
Z6  6   f    CG  20  89      3
```

Select and change observations
-------------------------


```r
myDf1[[3]][2]
```

```
[1] CG
Levels: CG T WL
```

```r
myDf1$rating
```

```
 [1] 4 1 2 2 5 3 5 5 5 3 5 4
```

```r
myDf1$age[4]
```

```
[1] 28
```

```r
myDf1$IQ[10:12] <- c(99, 110, 89)
myDf1[3, 4]
```

```
[1] 27
```

```r
myDf1[4, "group"]
```

```
[1] T
Levels: CG T WL
```

```r
myDf1[2, ]
```

```
   id sex group age IQ rating
Z2  2   m    CG  30 93      1
```

```r
myDf1[, "age"]
```

```
 [1] 29 30 27 28 23 20 35 34 30 32 18 26
```

```r
myDf1[1:5, 4, drop=FALSE]
```

```
   age
Z1  29
Z2  30
Z3  27
Z4  28
Z5  23
```

See dfTransform for selecting subsets of data

Work with variables from a data frame
-------------------------


```r
with(myDf1, tapply(IQ, group, FUN=mean))
```

```
    CG      T     WL 
 95.00 104.25  84.75 
```

```r
xtabs(~ sex + group, data=myDf1)
```

```
   group
sex CG T WL
  f  1 2  2
  m  3 2  2
```

```r
IQ[3]
```

```
[1] 84
```

```r
attach(myDf1)
IQ[3]
```

```
[1] 84
```

```r
search()[1:4]
```

```
[1] ".GlobalEnv"      "myDf1"           "package:car"     "package:stringr"
```


```r
IQ[3] <- 130; IQ[3]
```

```
[1] 130
```

```r
myDf1$IQ[3]
```

```
[1] 84
```

```r
detach(myDf1)
IQ
```

```
 [1] 111  93 130  97  85  89  91  75 113 102  83 119
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dataFrames.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dataFrames.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dataFrames.R) - [all posts](https://github.com/dwoll/RExRepos/)
