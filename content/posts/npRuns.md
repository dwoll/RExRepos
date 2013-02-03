---
layout: post
title: "Runs-test"
categories: [Nonparametric, ClassicalNonparametric]
rerCat: Nonparametric
tags: [Nonparametric, ClassicalNonparametric]
---




Install required packages
-------------------------

[`tseries`](http://cran.r-project.org/package=tseries)


```r
wants <- c("tseries")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Runs-test
-------------------------

### Using `runs.test()` from package `tseries` (asymptotic test)


```r
queue <- factor(c("f", "m", "m", "f", "m", "f", "f", "f"))
library(tseries)
runs.test(queue, alternative="greater")
```

```

	Runs Test

data:  queue 
Standard Normal = 0.206, p-value = 0.4184
alternative hypothesis: greater 
```


### Manual permutation test

#### Exact test


```r
Nj    <- table(queue)
(runs <- rle(levels(queue)[as.numeric(queue)]))
```

```
Run Length Encoding
  lengths: int [1:5] 1 2 1 1 3
  values : chr [1:5] "f" "m" "f" "m" "f"
```

```r
(rr <- length(runs$lengths))
```

```
[1] 5
```

```r
(rr1 <- table(runs$values)[1])
```

```
f 
3 
```

```r
(rr2 <- table(runs$values)[2])
```

```
m 
2 
```



```r
getP <- function(r1, r2, n1, n2) {
    # iterations of a symbol <= total number of this symbol?
    stopifnot(r1 <= n1, r2 <= n2)

    # probability in case r1+r2 is uneven
    p <- (choose(n1-1, r1-1) * choose(n2-1, r2-1)) / choose(n1+n2, n1)

    # probability in case r1+r2 is even: twice the uneven case
    ifelse(((r1+r2) %% 2) == 0, 2*p, p)
}
```



```r
n1    <- Nj[1]
n2    <- Nj[2]
N     <- sum(Nj)
rMin  <- 2
(rMax <- ifelse(n1 == n2, N, 2*min(n1, n2) + 1))
```

```
f 
7 
```



```r
p3.2 <- getP(3, 2, n1, n2)
p2.3 <- getP(2, 3, n1, n2)
p3.3 <- getP(3, 3, n1, n2)
p4.3 <- getP(4, 3, n1, n2)
```


```r
(pGrEq <- p3.2 + p2.3 + p3.3 + p4.3)
```

```
[1] 0.5714
```



```r
p2.2 <- getP(2, 2, n1, n2)
p1.2 <- getP(1, 2, n1, n2)
p2.1 <- getP(2, 1, n1, n2)
p1.1 <- getP(1, 1, n1, n2)
```



```r
(pLess <- p2.2 + p1.2 + p2.1 + p1.1)
```

```
[1] 0.4286
```

```r
pGrEq + pLess
```

```
[1] 1
```


#### Normal approximation


```r
muR   <- 1 + ((2*n1*n2) / N)
varR  <- (2*n1*n2*(2*n1*n2 - N)) / (N^2 * (N-1))
rZ    <- (rr-muR) / sqrt(varR)
(pVal <- 1-pnorm(rZ))
```

```
     f 
0.4184 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:tseries))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npRuns.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npRuns.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npRuns.R) - [all posts](https://github.com/dwoll/RExRepos/)
