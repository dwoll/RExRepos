---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "One-way ANOVA (CR-p design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---




TODO
-------------------------

 - link to normality, varianceHom, regressionDiag, regression for model comparison, resamplingPerm, resamplingBootALM

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`multcomp`](http://cran.r-project.org/package=multcomp)


```r
wants <- c("car", "multcomp")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


CR-$p$ ANOVA
-------------------------

### Simulate data


```r
set.seed(123)
P     <- 4
Nj    <- c(41, 37, 42, 40)
muJ   <- rep(c(-1, 0, 1, 2), Nj)
dfCRp <- data.frame(IV=factor(rep(LETTERS[1:P], Nj)),
                    DV=rnorm(sum(Nj), muJ, 5))
```



```r
plot.design(DV ~ IV, fun=mean, data=dfCRp, main="Group means")
```

![plot of chunk rerAnovaCRp01](../content/assets/figure/rerAnovaCRp01.png) 


### Using `oneway.test()`

#### Assuming variance homogeneity


```r
oneway.test(DV ~ IV, data=dfCRp, var.equal=TRUE)
```

```

	One-way analysis of means

data:  DV and IV 
F = 2.006, num df = 3, denom df = 156, p-value = 0.1154
```


#### Generalized Welch-test without assumption of variance homogeneity


```r
oneway.test(DV ~ IV, data=dfCRp, var.equal=FALSE)
```

```

	One-way analysis of means (not assuming equal variances)

data:  DV and IV 
F = 2.02, num df = 3.0, denom df = 85.5, p-value = 0.1171
```


### Using `aov()`


```r
aovCRp <- aov(DV ~ IV, data=dfCRp)
summary(aovCRp)
```

```
             Df Sum Sq Mean Sq F value Pr(>F)
IV            3    133    44.4    2.01   0.12
Residuals   156   3450    22.1               
```

```r
model.tables(aovCRp, type="means")
```

```
Tables of means
Grand mean
       
0.4319 

 IV 
          A        B      C      D
    -0.8643  0.05185  1.042  1.471
rep 41.0000 37.00000 42.000 40.000
```


### Model comparisons using `anova(lm())`


```r
(anovaCRp <- anova(lm(DV ~ IV, data=dfCRp)))
```

```
Analysis of Variance Table

Response: DV
           Df Sum Sq Mean Sq F value Pr(>F)
IV          3    133    44.4    2.01   0.12
Residuals 156   3450    22.1               
```



```r
anova(lm(DV ~ 1, data=dfCRp), lm(DV ~ IV, data=dfCRp))
```

```
Analysis of Variance Table

Model 1: DV ~ 1
Model 2: DV ~ IV
  Res.Df  RSS Df Sum of Sq    F Pr(>F)
1    159 3583                         
2    156 3450  3       133 2.01   0.12
```



```r
anovaCRp["Residuals", "Sum Sq"]
```

```
[1] 3450
```


Effect size estimates
-------------------------


```r
dfSSb <- anovaCRp["IV",        "Df"]
SSb   <- anovaCRp["IV",        "Sum Sq"]
MSb   <- anovaCRp["IV",        "Mean Sq"]
SSw   <- anovaCRp["Residuals", "Sum Sq"]
MSw   <- anovaCRp["Residuals", "Mean Sq"]
```



```r
(etaSq <- SSb / (SSb + SSw))
```

```
[1] 0.03714
```

```r
(omegaSq <- dfSSb * (MSb-MSw) / (SSb + SSw + MSw))
```

```
[1] 0.01851
```

```r
(f <- sqrt(etaSq / (1-etaSq)))
```

```
[1] 0.1964
```


Or from function `ezANOVA()` from package [`ez`](http://cran.r-project.org/package=ez)

Planned comparisons
-------------------------

### General contrasts using `glht()` from package `multcomp`


```r
cntrMat <- rbind("A-D"          =c(  1,   0,   0,  -1),
                 "1/3*(A+B+C)-D"=c(1/3, 1/3, 1/3,  -1),
                 "B-C"          =c(  0,   1,  -1,   0))
library(multcomp)
summary(glht(aovCRp, linfct=mcp(IV=cntrMat), alternative="less"),
        test=adjusted("none"))
```

```

	 Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: User-defined Contrasts


Fit: aov(formula = DV ~ IV, data = dfCRp)

Linear Hypotheses:
                   Estimate Std. Error t value Pr(<t)  
A-D >= 0             -2.335      1.045   -2.23  0.013 *
1/3*(A+B+C)-D >= 0   -1.394      0.859   -1.62  0.053 .
B-C >= 0             -0.991      1.060   -0.93  0.176  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
(Adjusted p values reported -- none method)
```


### Pairwise $t$-tests


```r
pairwise.t.test(dfCRp$DV, dfCRp$IV, p.adjust.method="bonferroni")
```

```

	Pairwise comparisons using t tests with pooled SD 

data:  dfCRp$DV and dfCRp$IV 

  A    B    C   
B 1.00 -    -   
C 0.40 1.00 -   
D 0.16 1.00 1.00

P value adjustment method: bonferroni 
```


### Tukey's simultaneous confidence intervals


```r
(tHSD <- TukeyHSD(aovCRp))
```

```
  Tukey multiple comparisons of means
    95% family-wise confidence level

Fit: aov(formula = DV ~ IV, data = dfCRp)

$IV
      diff     lwr   upr  p adj
B-A 0.9162 -1.8530 3.685 0.8258
C-A 1.9068 -0.7743 4.588 0.2555
D-A 2.3351 -0.3789 5.049 0.1186
C-B 0.9906 -1.7628 3.744 0.7865
D-B 1.4189 -1.3666 4.204 0.5498
D-C 0.4283 -2.2697 3.126 0.9763
```



```r
plot(tHSD)
```

![plot of chunk rerAnovaCRp02](../content/assets/figure/rerAnovaCRp02.png) 


Assess test assumptions
-------------------------

### Normality


```r
Estud <- rstudent(aovCRp)
qqnorm(Estud, pch=20, cex=2)
qqline(Estud, col="gray60", lwd=2)
```

![plot of chunk rerAnovaCRp03](../content/assets/figure/rerAnovaCRp03.png) 



```r
shapiro.test(Estud)
```

```

	Shapiro-Wilk normality test

data:  Estud 
W = 0.9937, p-value = 0.7149
```


### Variance homogeneity


```r
plot(Estud ~ dfCRp$IV, main="Residuals per group")
```

![plot of chunk rerAnovaCRp04](../content/assets/figure/rerAnovaCRp04.png) 



```r
library(car)
leveneTest(aovCRp)
```

```
Levene's Test for Homogeneity of Variance (center = median)
       Df F value Pr(>F)
group   3    0.86   0.47
      156               
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:multcomp))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaCRp.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaCRp.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaCRp.R) - [all posts](https://github.com/dwoll/RExRepos/)
