---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
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
set.seed(123)
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
        1         2         3 
0.2500000 0.4166667 0.3333333 

Group means:
         DV1        DV2
1 -3.9300600  3.6858137
2  3.0763419  3.2682592
3  0.8326377 -0.8284297

Coefficients of linear discriminants:
           LD1         LD2
DV1 0.30281673 -0.02978952
DV2 0.01135247 -0.34212141

Proportion of trace:
   LD1    LD2 
0.6019 0.3981 
```


```r
ldaP <- lda(IV ~ DV1 + DV2, CV=TRUE, data=Ydf)
head(ldaP$posterior)
```

```
           1          2          3
1 0.87692334 0.03892749 0.08414917
2 0.05948677 0.77916960 0.16134364
3 0.75783381 0.22929176 0.01287443
4 0.23218561 0.16280484 0.60500954
5 0.87531088 0.02860185 0.09608726
6 0.15145306 0.71535330 0.13319364
```


```r
ldaPred <- predict(ldaRes, Ydf)
ld      <- ldaPred$x
head(ld)
```

```
          LD1         LD2
1 -2.02645465 -0.30063936
2  0.51103261 -0.64927925
3 -1.29829423 -2.28573892
4 -0.74102145  0.72661802
5 -2.16732369 -0.07970205
6  0.09253344 -0.93543324
```

### Predicted classification


```r
cls <- ldaPred$class
head(cls)
```

```
[1] 1 2 1 3 1 2
Levels: 1 2 3
```


```r
cTab <- table(IV, cls, dnn=c("IV", "ldaPred"))
addmargins(cTab)
```

```
     ldaPred
IV     1  2  3 Sum
  1    9  4  2  15
  2    3 19  3  25
  3    1  4 15  20
  Sum 13 27 20  60
```

```r
sum(diag(cTab)) / sum(cTab)
```

```
[1] 0.7166667
```


```r
anova(lm(ld[ , 1] ~ IV))
```

```
Analysis of Variance Table

Response: ld[, 1]
          Df Sum Sq Mean Sq F value    Pr(>F)    
IV         2 42.074  21.037  21.037 1.437e-07 ***
Residuals 57 57.000   1.000                      
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
anova(lm(ld[ , 2] ~ IV))
```

```
Analysis of Variance Table

Response: ld[, 2]
          Df Sum Sq Mean Sq F value    Pr(>F)    
IV         2 27.831  13.916  13.916 1.198e-05 ***
Residuals 57 57.000   1.000                      
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
        1         2         3 
0.2500000 0.4166667 0.3333333 

Group means:
         DV1        DV2
1 -3.9300600  3.6858137
2  3.0763419  3.2682592
3  0.8326377 -0.8284297

Coefficients of linear discriminants:
           LD1        LD2
DV1  0.1597400 -0.2562351
DV2 -0.3714238 -0.2406715

Proportion of trace:
   LD1    LD2 
0.5715 0.4285 
```

```r
predict(ldaRob)$class
```

```
 [1] 1 2 1 3 1 2 1 1 3 2 1 1 3 2 1 2 2 2 2 2 2 1 3 2 2 2 2 2 1 2 2 3 1 2 2
[36] 3 2 2 3 2 3 3 3 3 2 2 3 3 2 3 3 3 3 3 2 3 3 3 3 3
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
        1         2         3 
0.2500000 0.4166667 0.3333333 

Group means:
         DV1        DV2
1 -3.9300600  3.6858137
2  3.0763419  3.2682592
3  0.8326377 -0.8284297
```

```r
predict(qdaRes)$class
```

```
 [1] 1 2 1 3 1 2 1 1 3 1 1 1 3 2 1 2 2 2 2 2 2 1 2 2 2 2 2 2 1 2 2 3 1 2 2
[36] 3 2 2 3 2 3 3 3 2 2 2 3 2 2 3 3 3 3 3 3 3 3 3 3 3
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
