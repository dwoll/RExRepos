---
layout: post
title: "Linear discriminant analysis (LDA)"
categories: [Multivariate]
rerCat: Multivariate
tags: [LDA, QDA]
---




TODO
-------------------------

 - link to regressionLogistic, regressionOrdinal, regressionMultinom

Install required packages
-------------------------

[`mvtnorm`](http://cran.r-project.org/package=mvtnorm), [`MASS`](http://cran.r-project.org/package=MASS)


```r
wants <- c("mvtnorm", "MASS")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Conventional LDA
-------------------------

### Simulate data


```r
set.seed(1.234)
library(mvtnorm)
Nj    <- c(15, 25, 20)
Sigma <- matrix(c(16,-2, -2,9), byrow=TRUE, ncol=2)
mu1   <- c(-4,  4)
mu2   <- c( 3,  3)
mu3   <- c( 1, -1)
Y1    <- rmvnorm(Nj[1], mean=mu1, sigma=Sigma)
Y2    <- rmvnorm(Nj[2], mean=mu2, sigma=Sigma)
Y3    <- rmvnorm(Nj[3], mean=mu3, sigma=Sigma)
Y     <- rbind(Y1, Y2, Y3)
IV    <- factor(rep(1:length(Nj), Nj))
Ydf   <- data.frame(IV, DV1=Y[ , 1], DV2=Y[ , 2])
```


### Run the analysis


```r
library(MASS)
(ldaRes <- lda(IV ~ DV1 + DV2, data=Ydf))
```

```
Call:
lda(IV ~ DV1 + DV2, data = Ydf)

Prior probabilities of groups:
     1      2      3 
0.2500 0.4167 0.3333 

Group means:
     DV1     DV2
1 -2.984  3.6785
2  3.565  3.2337
3  1.365 -0.6325

Coefficients of linear discriminants:
         LD1      LD2
DV1  0.28284 -0.05889
DV2 -0.03164 -0.36631

Proportion of trace:
   LD1    LD2 
0.5339 0.4661 
```



```r
ldaP <- lda(IV ~ DV1 + DV2, CV=TRUE, data=Ydf)
head(ldaP$posterior)
```

```
       1       2        3
1 0.9167 0.04174 0.041590
2 0.9702 0.02725 0.002569
3 0.4400 0.17206 0.387928
4 0.6369 0.30935 0.053697
5 0.4723 0.28621 0.241529
6 0.1470 0.74852 0.104470
```



```r
ldaPred <- predict(ldaRes, Ydf)
ld      <- ldaPred$x
head(ld)
```

```
      LD1     LD2
1 -2.2755 -0.5226
2 -2.7613 -2.0157
3 -1.0118  0.4347
4 -1.1058 -1.2647
5 -0.8221 -0.1521
6  0.1206 -1.0225
```


### Predicted classification


```r
cls <- ldaPred$class
head(cls)
```

```
[1] 1 1 1 1 1 2
Levels: 1 2 3
```



```r
cTab <- table(IV, cls, dnn=c("IV", "ldaPred"))
addmargins(cTab)
```

```
     ldaPred
IV     1  2  3 Sum
  1    9  3  3  15
  2    3 19  3  25
  3    2  4 14  20
  Sum 14 26 20  60
```

```r
sum(diag(cTab)) / sum(cTab)
```

```
[1] 0.7
```



```r
anova(lm(ld[ , 1] ~ IV))
```

```
Analysis of Variance Table

Response: ld[, 1]
          Df Sum Sq Mean Sq F value  Pr(>F)    
IV         2   33.2    16.6    16.6 2.1e-06 ***
Residuals 57   57.0     1.0                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```

```r
anova(lm(ld[ , 2] ~ IV))
```

```
Analysis of Variance Table

Response: ld[, 2]
          Df Sum Sq Mean Sq F value  Pr(>F)    
IV         2     29    14.5    14.5 8.2e-06 ***
Residuals 57     57     1.0                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```



```r
priorP <- rep(1/nlevels(IV), nlevels(IV))
ldaEq  <- lda(IV ~ DV1 + DV2, prior=priorP, data=Ydf)
```


Robust LDA
-------------------------


```r
library(MASS)
(ldaRob <- lda(IV ~ DV1 + DV2, method="mve", data=Ydf))
```

```
Call:
lda(IV ~ DV1 + DV2, data = Ydf, method = "mve")

Prior probabilities of groups:
     1      2      3 
0.2500 0.4167 0.3333 

Group means:
     DV1     DV2
1 -2.984  3.6785
2  3.565  3.2337
3  1.365 -0.6325

Coefficients of linear discriminants:
        LD1     LD2
DV1  0.2252 -0.2423
DV2 -0.4062 -0.2653

Proportion of trace:
   LD1    LD2 
0.6547 0.3453 
```

```r
predict(ldaRob)$class
```

```
 [1] 1 1 1 1 1 2 3 2 1 1 1 3 1 3 1 2 2 1 2 2 2 2 3 2 2 2 3 2 3 2 2 2 2 1 2
[36] 2 3 1 2 2 3 3 3 3 3 1 2 3 3 3 3 3 1 2 2 3 3 3 3 3
Levels: 1 2 3
```


Quadratic Discriminant Analysis
-------------------------


```r
library(MASS)
(qdaRes <- qda(IV ~ DV1 + DV2, data=Ydf))
```

```
Call:
qda(IV ~ DV1 + DV2, data = Ydf)

Prior probabilities of groups:
     1      2      3 
0.2500 0.4167 0.3333 

Group means:
     DV1     DV2
1 -2.984  3.6785
2  3.565  3.2337
3  1.365 -0.6325
```

```r
predict(qdaRes)$class
```

```
 [1] 1 1 1 1 1 2 3 2 1 1 2 3 1 1 1 2 2 1 2 2 2 2 3 2 2 2 3 2 3 2 2 2 2 1 2
[36] 2 2 1 2 2 3 3 3 3 3 1 2 2 3 3 3 3 1 2 2 3 3 3 3 3
Levels: 1 2 3
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:MASS))
try(detach(package:mvtnorm))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multLDA.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multLDA.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multLDA.R) - [all posts](https://github.com/dwoll/RExRepos/)
