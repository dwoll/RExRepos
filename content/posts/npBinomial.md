---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Binomial test and chi^2-test for proportions"
categories: [Nonparametric, ClassicalNonparametric]
rerCat: Nonparametric
tags: [Nonparametric, ClassicalNonparametric]
---




Install required packages
-------------------------

[`DescTools`](http://cran.r-project.org/package=DescTools)


```r
wants <- c("DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Binomial test
-------------------------
    
### One-sided


```r
DV   <- factor(c("+", "+", "-", "+", "-", "+", "+"), levels=c("+", "-"))
N    <- length(DV)
(tab <- table(DV))
```

```
DV
+ - 
5 2 
```

```r
pH0 <- 0.25
binom.test(tab, p=pH0, alternative="greater", conf.level=0.95)
```

```

	Exact binomial test

data:  tab
number of successes = 5, number of trials = 7, p-value = 0.01288
alternative hypothesis: true probability of success is greater than 0.25
95 percent confidence interval:
 0.3412614 1.0000000
sample estimates:
probability of success 
             0.7142857 
```

### Two-sided


```r
N    <- 20
hits <- 10
binom.test(hits, N, p=pH0, alternative="two.sided")
```

```

	Exact binomial test

data:  hits and N
number of successes = 10, number of trials = 20, p-value = 0.01704
alternative hypothesis: true probability of success is not equal to 0.25
95 percent confidence interval:
 0.2719578 0.7280422
sample estimates:
probability of success 
                   0.5 
```


```r
sum(dbinom(hits:N, N, p=pH0)) + sum(dbinom(0, N, p=pH0))
```

```
[1] 0.01703563
```

### Confidence intervals


```r
library(DescTools)
BinomCI(tab[1], sum(tab), method="wilson")
```

```
           est    lwr.ci    upr.ci
[1,] 0.7142857 0.3589345 0.9177811
```

$\chi^{2}$-test for proportions
-------------------------


```r
total <- c(4000, 5000, 3000)
hits  <- c( 585,  610,  539)
prop.test(hits, total)
```

```

	3-sample test for equality of proportions without continuity
	correction

data:  hits out of total
X-squared = 50.5873, df = 2, p-value = 1.035e-11
alternative hypothesis: two.sided
sample estimates:
   prop 1    prop 2    prop 3 
0.1462500 0.1220000 0.1796667 
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:DescTools))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npBinomial.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npBinomial.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npBinomial.R) - [all posts](https://github.com/dwoll/RExRepos/)
