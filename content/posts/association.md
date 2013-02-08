---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Association tests and measures for unordered categorical variables"
categories: [Descriptive]
rerCat: Descriptive
tags: [Association]
---




TODO
-------------------------

 - link to correlation, associationOrder, diagCategorical

Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin), [`epitools`](http://cran.r-project.org/package=epitools), [`vcd`](http://cran.r-project.org/package=vcd)


```r
wants <- c("coin", "epitools", "vcd")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


$(2 \times 2)$-tables
-------------------------

### Fisher's exact test


```r
disease <- factor(rep(c("no", "yes"),   c(10, 5)))
diagN   <- rep(c("isHealthy", "isIll"), c( 8, 2))
diagY   <- rep(c("isHealthy", "isIll"), c( 1, 4))
diagT   <- factor(c(diagN, diagY))
contT1  <- table(disease, diagT)
addmargins(contT1)
```

```
       diagT
disease isHealthy isIll Sum
    no          8     2  10
    yes         1     4   5
    Sum         9     6  15
```



```r
fisher.test(contT1, alternative="greater")
```

```

	Fisher's Exact Test for Count Data

data:  contT1 
p-value = 0.04695
alternative hypothesis: true odds ratio is greater than 1 
95 percent confidence interval:
 1.031   Inf 
sample estimates:
odds ratio 
      12.5 
```


### Prevalence, sensitivity, specificity, CCR, $F$-score


```r
TN <- c11 <- contT1[1, 1]       ## true negative
TP <- c22 <- contT1[2, 2]       ## true positive / hit
FP <- c12 <- contT1[1, 2]       ## false positive
FN <- c21 <- contT1[2, 1]       ## false negative / miss
```



```r
(prevalence <- sum(contT1[2, ]) / sum(contT1))
```

```
[1] 0.3333
```



```r
(sensitivity <- recall <- TP / (TP+FN))
```

```
[1] 0.8
```



```r
(specificity <- TN / (TN+FP))
```

```
[1] 0.8
```



```r
(relevance <- precision <- TP / (TP+FP))
```

```
[1] 0.6667
```


Correct classification rate (CCR)


```r
(CCR <- sum(diag(contT1)) / sum(contT1))
```

```
[1] 0.8
```


$F$-score


```r
(Fval <- 1 / mean(1 / c(precision, recall)))
```

```
[1] 0.7273
```


### Odds ratio, Yule's $Q$ and risk ratio

#### Odds ratio


```r
library(vcd)                          ## for oddsratio()
(OR <- oddsratio(contT1, log=FALSE))  ## odds ratio
```

```
[1] 16
```

```r
(ORln <- oddsratio(contT1))           ## log odds ratio
```

```
[1] 2.773
```



```r
summary(ORln)            ## significance test log OR
```

```
     Log Odds Ratio Std. Error z value Pr(>|z|)   
[1,]           2.77       1.19    2.34   0.0097 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```



```r
(CIln <- confint(ORln))  ## confidence interval log OR
```

```
        lwr   upr
[1,] 0.4481 5.097
```

```r
exp(CIln)                ## confidence interval OR (not log)
```

```
       lwr   upr
[1,] 1.565 163.5
```


#### Yule's $Q$


```r
(Q <- (c11*c22 - c12*c21) / (c11*c22 + c12*c21))  ## Yule's Q
```

```
[1] 0.8824
```

```r
(OR-1) / (OR+1)          ## alternative calculation given OR
```

```
[1] 0.8824
```


#### Risk ratio


```r
library(epitools)
riskratio(contT1, method="small")
```

```
$data
       diagT
disease isHealthy isIll Total
  no            8     2    10
  yes           1     4     5
  Total         9     6    15

$measure
       risk ratio with 95% C.I.
disease estimate  lower upper
    no     1.000     NA    NA
    yes    2.933 0.7877 10.92

$p.value
       two-sided
disease midp.exact fisher.exact chi.square
    no          NA           NA         NA
    yes    0.04895      0.08891    0.02535

$correction
[1] FALSE

attr(,"method")
[1] "small sample-adjusted UMLE & normal approx (Wald) CI"
```


$(r \times c)$-tables
-------------------------

### $\chi^{2}$-test


```r
set.seed(1.234)
N        <- 50
smokes   <- factor(sample(c("no", "yes"), N, replace=TRUE))
siblings <- factor(round(abs(rnorm(N, 1, 0.5))))
cTab     <- table(smokes, siblings)
addmargins(cTab)
```

```
      siblings
smokes  0  1  2 Sum
   no   2 18  3  23
   yes  4 19  4  27
   Sum  6 37  7  50
```



```r
chisq.test(cTab)
```

```

	Pearson's Chi-squared test

data:  cTab 
X-squared = 0.5199, df = 2, p-value = 0.7711
```


Also for higher-order tables

### Measures of association: $\phi$, Cramer's $V$, contingency coefficient


```r
DV1  <- cut(c(100, 76, 56, 99, 50, 62, 36, 69, 55,  17), breaks=3,
            labels=LETTERS[1:3])
DV2  <- cut(c(42,  74, 22, 99, 73, 44, 10, 68, 19, -34), breaks=3,
            labels=LETTERS[1:3])
cTab <- table(DV1, DV2)
addmargins(cTab)
```

```
     DV2
DV1    A  B  C Sum
  A    2  0  0   2
  B    0  3  2   5
  C    0  1  2   3
  Sum  2  4  4  10
```



```r
library(vcd)
assocstats(cTab)
```

```
                    X^2 df P(> X^2)
Likelihood Ratio 10.549  4 0.032126
Pearson          10.667  4 0.030577

Phi-Coefficient   : 1.033 
Contingency Coeff.: 0.718 
Cramer's V        : 0.73 
```


Cochran-Mantel-Haenszel test for three-way tables
-------------------------


```r
N    <- 10
myDf <- data.frame(work =factor(sample(c("home", "office"), N, replace=TRUE)),
                   sex  =factor(sample(c("f", "m"),         N, replace=TRUE)),
                   group=factor(sample(c("A", "B"), 10, replace=TRUE)))
tab3 <- xtabs(~ work + sex + group, data=myDf)
```



```r
library(coin)
cmh_test(tab3, distribution=approximate(B=9999))
```

```

	Approximative Generalized Cochran-Mantel-Haenszel Test

data:  sex by
	 work (home, office) 
	 stratified by group 
chi-squared = 0.1556, p-value = 1
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:vcd))
try(detach(package:colorspace))
try(detach(package:MASS))
try(detach(package:grid))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/association.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/association.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/association.R) - [all posts](https://github.com/dwoll/RExRepos/)
