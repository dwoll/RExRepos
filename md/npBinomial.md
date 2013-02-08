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

[`binom`](http://cran.r-project.org/package=binom)


```r
wants <- c("binom")
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
 0.3413 1.0000 
sample estimates:
probability of success 
                0.7143 
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
 0.272 0.728 
sample estimates:
probability of success 
                   0.5 
```



```r
sum(dbinom(hits:N, N, p=pH0)) + sum(dbinom(0, N, p=pH0))
```

```
[1] 0.01704
```


### Confidence intervals


```r
library(binom)
binom.confint(tab[1], sum(tab))
```

```
          method x n   mean  lower  upper
1  agresti-coull 5 7 0.7143 0.3524 0.9244
2     asymptotic 5 7 0.7143 0.3796 1.0489
3          bayes 5 7 0.6875 0.3523 0.9353
4        cloglog 5 7 0.7143 0.2582 0.9198
5          exact 5 7 0.7143 0.2904 0.9633
6          logit 5 7 0.7143 0.3266 0.9280
7         probit 5 7 0.7143 0.3377 0.9395
8        profile 5 7 0.7143 0.3502 0.9451
9            lrt 5 7 0.7143 0.3502 0.9458
10     prop.test 5 7 0.7143 0.3026 0.9489
11        wilson 5 7 0.7143 0.3589 0.9178
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
X-squared = 50.59, df = 2, p-value = 1.035e-11
alternative hypothesis: two.sided 
sample estimates:
prop 1 prop 2 prop 3 
0.1462 0.1220 0.1797 
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:binom))
try(detach(package:lattice))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/npBinomial.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/npBinomial.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/npBinomial.R) - [all posts](https://github.com/dwoll/RExRepos/)
