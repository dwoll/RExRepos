---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Linear discriminant analysis (LDA)"
categories: [Multivariate]
rerCat: Multivariate
tags: [LDA, QDA]
---

Linear discriminant analysis (LDA)
=========================

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
     1      2      3 
0.2500 0.4167 0.3333 

Group means:
      DV1     DV2
1 -3.9301  3.6858
2  3.0763  3.2683
3  0.8326 -0.8284

Coefficients of linear discriminants:
        LD1      LD2
DV1 0.30282 -0.02979
DV2 0.01135 -0.34212

Proportion of trace:
   LD1    LD2 
0.6019 0.3981 
```



```r
ldaP <- lda(IV ~ DV1 + DV2, CV=TRUE, data=Ydf)
head(ldaP$posterior)
```

```
        1       2       3
1 0.87692 0.03893 0.08415
2 0.05949 0.77917 0.16134
3 0.75783 0.22929 0.01287
4 0.23219 0.16280 0.60501
5 0.87531 0.02860 0.09609
6 0.15145 0.71535 0.13319
```



```r
ldaPred <- predict(ldaRes, Ydf)
ld      <- ldaPred$x
head(ld)
```

```
       LD1     LD2
1 -2.02645 -0.3006
2  0.51103 -0.6493
3 -1.29829 -2.2857
4 -0.74102  0.7266
5 -2.16732 -0.0797
6  0.09253 -0.9354
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
[1] 0.7167
```



```r
anova(lm(ld[ , 1] ~ IV))
```

```
Analysis of Variance Table

Response: ld[, 1]
          Df Sum Sq Mean Sq F value  Pr(>F)    
IV         2   42.1      21      21 1.4e-07 ***
Residuals 57   57.0       1                    
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
IV         2   27.8    13.9    13.9 1.2e-05 ***
Residuals 57   57.0     1.0                    
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
1 -3.9301  3.6858
2  3.0763  3.2683
3  0.8326 -0.8284

Coefficients of linear discriminants:
        LD1     LD2
DV1  0.1597 -0.2562
DV2 -0.3714 -0.2407

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
     1      2      3 
0.2500 0.4167 0.3333 

Group means:
      DV1     DV2
1 -3.9301  3.6858
2  3.0763  3.2683
3  0.8326 -0.8284
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
