---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Combinatorics"
categories: [RBasics]
rerCat: R_Basics
tags: [Combinatorics]
---




TODO
-------------------------

 - link to sets

Install required packages
-------------------------

[`e1071`](http://cran.r-project.org/package=e1071), [`permute`](http://cran.r-project.org/package=permute)


```r
wants <- c("e1071", "permute")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Combinations
-------------------------

### Number of $k$-combinations

${n \choose k}$


```r
myN <- 5
myK <- 4
choose(myN, myK)
```

```
[1] 5
```

```r
factorial(myN) / (factorial(myK)*factorial(myN-myK))
```

```
[1] 5
```


### Enumerate all combinations


```r
combn(c("a", "b", "c", "d", "e"), myK)
```

```
     [,1] [,2] [,3] [,4] [,5]
[1,] "a"  "a"  "a"  "a"  "b" 
[2,] "b"  "b"  "b"  "c"  "c" 
[3,] "c"  "c"  "d"  "d"  "d" 
[4,] "d"  "e"  "e"  "e"  "e" 
```

```r
combn(c(1, 2, 3, 4), 3)
```

```
     [,1] [,2] [,3] [,4]
[1,]    1    1    1    2
[2,]    2    2    3    3
[3,]    3    4    4    4
```



```r
combn(c(1, 2, 3, 4), 3, sum)
```

```
[1] 6 7 8 9
```

```r
combn(c(1, 2, 3, 4), 3, weighted.mean, w=c(0.5, 0.2, 0.3))
```

```
[1] 1.8 2.1 2.3 2.8
```


Permutations
-------------------------

### Number of permutations


```r
factorial(7)
```

```
[1] 5040
```


### Random permutation


```r
set.seed(123)
set <- LETTERS[1:10]
sample(set, length(set), replace=FALSE)
```

```
 [1] "C" "H" "D" "G" "F" "A" "J" "I" "B" "E"
```



```r
library(permute)
shuffle(length(set))
```

```
 [1] 10  5  6  9  1  7  8  4  3  2
```


### Enumerate all permutations

#### All permutations at once


```r
set <- LETTERS[1:3]
len <- length(set)
library(e1071)
(mat <- permutations(len))
```

```
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    2    1    3
[3,]    2    3    1
[4,]    1    3    2
[5,]    3    1    2
[6,]    3    2    1
```

```r
apply(mat, 1, function(x) set[x])
```

```
     [,1] [,2] [,3] [,4] [,5] [,6]
[1,] "A"  "B"  "B"  "A"  "C"  "C" 
[2,] "B"  "A"  "C"  "C"  "A"  "B" 
[3,] "C"  "C"  "A"  "B"  "B"  "A" 
```


#### Each permutation individually


```r
(grp <- rep(letters[1:3], each=3))
```

```
[1] "a" "a" "a" "b" "b" "b" "c" "c" "c"
```

```r
N      <- length(grp)
nPerms <- 100
library(permute)
pCtrl <- permControl(nperm=nPerms, complete=FALSE)
for(i in 1:5) {
    perm <- permute(i, n=N, control=pCtrl)
    print(grp[perm])
}
```

```
[1] "c" "b" "b" "c" "b" "a" "a" "c" "a"
[1] "a" "c" "c" "b" "b" "a" "c" "a" "b"
[1] "a" "a" "a" "c" "b" "c" "c" "b" "b"
[1] "b" "a" "c" "a" "c" "b" "b" "a" "c"
[1] "a" "c" "c" "a" "b" "a" "c" "b" "b"
```


#### Restricted permutations

Permute group membership in a two-way ANOVA design. Here: artificially low number of permutations.


```r
Njk    <- 4              ## cell size
P      <- 2              ## levels factor A
Q      <- 3              ## levels factor B
N      <- Njk*P*Q
nPerms <- 10             ## number of permutations
id     <- 1:(Njk*P*Q)
IV1    <- factor(rep(1:P,  each=Njk*Q))  ## factor A
IV2    <- factor(rep(1:Q, times=Njk*P))  ## factor B
(myDf  <- data.frame(id, IV1, IV2))
```

```
   id IV1 IV2
1   1   1   1
2   2   1   2
3   3   1   3
4   4   1   1
5   5   1   2
6   6   1   3
7   7   1   1
8   8   1   2
9   9   1   3
10 10   1   1
11 11   1   2
12 12   1   3
13 13   2   1
14 14   2   2
15 15   2   3
16 16   2   1
17 17   2   2
18 18   2   3
19 19   2   1
20 20   2   2
21 21   2   3
22 22   2   1
23 23   2   2
24 24   2   3
```

```r

# choose permutation schemes for tests of factor A and B
library(permute)         ## for permControl(), permute()

## only permute across A (within B)
pCtrlA <- permControl(strata=IV2, complete=FALSE, nperm=nPerms)

## only permute across B (within A)
pCtrlB <- permControl(strata=IV1, complete=FALSE, nperm=nPerms)
```


Get permutations for test of factor A


```r
for(i in 1:3) {
    perm <- permute(i, n=N, control=pCtrlA)
    print(myDf[perm, ])
# not shown
}
```


Get permutations for test of factor B


```r
for(i in 1:3) {
    perm <- permute(i, n=N, control=pCtrlB)
    print(myDf[perm, ])
# not shown
}
```


Enumerate all $n$-tuples
-------------------------

All combinations of elements from $n$ different sets (cartesian product)


```r
IV1 <- c("control", "treatment")
IV2 <- c("f", "m")
IV3 <- c(1, 2)
expand.grid(IV1, IV2, IV3)
```

```
       Var1 Var2 Var3
1   control    f    1
2 treatment    f    1
3   control    m    1
4 treatment    m    1
5   control    f    2
6 treatment    f    2
7   control    m    2
8 treatment    m    2
```


Apply a function to all pairs of elements from two sets
-------------------------


```r
outer(1:5, 1:5, FUN="*")
```

```
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    2    3    4    5
[2,]    2    4    6    8   10
[3,]    3    6    9   12   15
[4,]    4    8   12   16   20
[5,]    5   10   15   20   25
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:e1071))
try(detach(package:class))
try(detach(package:permute))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/combinatorics.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/combinatorics.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/combinatorics.R) - [all posts](https://github.com/dwoll/RExRepos/)
