---
layout: post
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
       id        sex   group       age             IQ       
 Min.   : 1.00   f:6   CG:4   Min.   :18.0   Min.   : 70.0  
 1st Qu.: 3.75   m:6   T :4   1st Qu.:23.5   1st Qu.: 96.8  
 Median : 6.50         WL:4   Median :25.0   Median :103.5  
 Mean   : 6.50                Mean   :25.7   Mean   :100.1  
 3rd Qu.: 9.25                3rd Qu.:28.5   3rd Qu.:109.8  
 Max.   :12.00                Max.   :33.0   Max.   :114.0  
     rating    
 Min.   :1.00  
 1st Qu.:2.00  
 Median :3.00  
 Mean   :3.25  
 3rd Qu.:5.00  
 Max.   :5.00  
```

```r
str(myDf1)
```

```
'data.frame':	12 obs. of  6 variables:
 $ id    : int  1 2 3 4 5 6 7 8 9 10 ...
 $ sex   : Factor w/ 2 levels "f","m": 1 1 2 2 1 2 2 2 2 1 ...
 $ group : Factor w/ 3 levels "CG","T","WL": 2 3 3 3 2 1 2 1 2 1 ...
 $ age   : int  22 24 18 24 33 24 26 28 26 21 ...
 $ IQ    : num  112 109 114 112 101 70 109 99 98 78 ...
 $ rating: num  5 2 3 2 4 2 3 5 1 5 ...
```



```r
head(myDf1)
```

```
  id sex group age  IQ rating
1  1   f     T  22 112      5
2  2   f    WL  24 109      2
3  3   m    WL  18 114      3
4  4   m    WL  24 112      2
5  5   f     T  33 101      4
6  6   m    CG  24  70      2
```

```r
tail(myDf1)
```

```
   id sex group age  IQ rating
7   7   m     T  26 109      3
8   8   m    CG  28  99      5
9   9   m     T  26  98      1
10 10   f    CG  21  78      5
11 11   f    WL  32  93      2
12 12   f    CG  30 106      5
```



```r
library(car)
some(myDf1, n=5)
```

```
   id sex group age  IQ rating
4   4   m    WL  24 112      2
5   5   f     T  33 101      4
7   7   m     T  26 109      3
9   9   m     T  26  98      1
12 12   f    CG  30 106      5
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
Z1  1   f     T  22 112      5
Z2  2   f    WL  24 109      2
Z3  3   m    WL  18 114      3
Z4  4   m    WL  24 112      2
Z5  5   f     T  33 101      4
Z6  6   m    CG  24  70      2
```


Select and change observations
-------------------------


```r
myDf1[[3]][2]
```

```
[1] WL
Levels: CG T WL
```

```r
myDf1$rating
```

```
 [1] 5 2 3 2 4 2 3 5 1 5 2 5
```

```r
myDf1$age[4]
```

```
[1] 24
```

```r
myDf1$IQ[10:12] <- c(99, 110, 89)
myDf1[3, 4]
```

```
[1] 18
```

```r
myDf1[4, "group"]
```

```
[1] WL
Levels: CG T WL
```

```r
myDf1[2, ]
```

```
   id sex group age  IQ rating
Z2  2   f    WL  24 109      2
```

```r
myDf1[, "age"]
```

```
 [1] 22 24 18 24 33 24 26 28 26 21 32 30
```

```r
myDf1[1:5, 4, drop=FALSE]
```

```
   age
Z1  22
Z2  24
Z3  18
Z4  24
Z5  33
```


See dfTransform for selecting subsets of data

Work with variables from a data frame
-------------------------


```r
with(myDf1, tapply(IQ, group, FUN=mean))
```

```
    CG      T     WL 
 89.25 105.00 111.25 
```

```r
xtabs(~ sex + group, data=myDf1)
```

```
   group
sex CG T WL
  f  2 2  2
  m  2 2  2
```

```r
IQ[3]
```

```
[1] 114
```

```r
attach(myDf1)
IQ[3]
```

```
[1] 114
```

```r
search()[1:4]
```

```
[1] ".GlobalEnv"   "myDf1"        "package:car"  "package:nnet"
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
[1] 114
```

```r
detach(myDf1)
IQ
```

```
 [1] 112 109 130 112 101  70 109  99  98  78  93 106
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dataFrames.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dataFrames.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dataFrames.R) - [all posts](https://github.com/dwoll/RExRepos/)
