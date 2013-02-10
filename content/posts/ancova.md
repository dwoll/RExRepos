---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Analysis of covariance (ANCOVA)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA, Regression]
---




TODO
-------------------------

 - link to anovaSStypes

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`effects`](http://cran.r-project.org/package=effects), [`multcomp`](http://cran.r-project.org/package=multcomp)


```r
wants <- c("car", "effects", "multcomp")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Test the effects of group membership and of covariate
-------------------------

### Visually assess the data


```r
SSRIpre  <- c(18, 16, 16, 15, 14, 20, 14, 21, 25, 11)
SSRIpost <- c(12,  0, 10,  9,  0, 11,  2,  4, 15, 10)
PlacPre  <- c(18, 16, 15, 14, 20, 25, 11, 25, 11, 22)
PlacPost <- c(11,  4, 19, 15,  3, 14, 10, 16, 10, 20)
WLpre    <- c(15, 19, 10, 29, 24, 15,  9, 18, 22, 13)
WLpost   <- c(17, 25, 10, 22, 23, 10,  2, 10, 14,  7)
```



```r
P     <- 3
Nj    <- rep(length(SSRIpre), times=P)
dfAnc <- data.frame(IV=factor(rep(1:P, Nj), labels=c("SSRI", "Placebo", "WL")),
                    DVpre=c(SSRIpre,   PlacPre,  WLpre),
                    DVpost=c(SSRIpost, PlacPost, WLpost))
```



```r
plot(DVpre  ~ IV, data=dfAnc, main="Pre-scores per group")
```

![plot of chunk rerAncova01](content/assets/figure/rerAncova011.png) 

```r
plot(DVpost ~ IV, data=dfAnc, main="Post-Scores per group")
```

![plot of chunk rerAncova01](content/assets/figure/rerAncova012.png) 


### Type I sum of squares


```r
fitFull <- lm(DVpost ~ IV + DVpre, data=dfAnc)
fitGrp  <- lm(DVpost ~ IV,         data=dfAnc)
fitRegr <- lm(DVpost ~      DVpre, data=dfAnc)
```



```r
anova(fitFull)
```

```
Analysis of Variance Table

Response: DVpost
          Df Sum Sq Mean Sq F value Pr(>F)   
IV         2    240   120.2    4.13 0.0276 * 
DVpre      1    313   313.4   10.77 0.0029 **
Residuals 26    756    29.1                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Type II/III sum of squares

Since no interaction is present in the model, SS type II and III are equivalent here.

#### Using `Anova()` from package `car`


```r
library(car)                       # for Anova()
fitFiii <- lm(DVpost ~ IV + DVpre,
              contrasts=list(IV=contr.sum), data=dfAnc)
Anova(fitFiii, type="III")
```

```
Anova Table (Type III tests)

Response: DVpost
            Sum Sq Df F value Pr(>F)   
(Intercept)      0  1    0.00 0.9910   
IV             217  2    3.73 0.0376 * 
DVpre          313  1   10.77 0.0029 **
Residuals      756 26                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


#### Using model comparisons for SS type II


```r
anova(fitRegr, fitFull)
```

```
Analysis of Variance Table

Model 1: DVpost ~ DVpre
Model 2: DVpost ~ IV + DVpre
  Res.Df RSS Df Sum of Sq    F Pr(>F)  
1     28 973                           
2     26 756  2       217 3.73  0.038 *
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```

```r
anova(fitGrp, fitFull)
```

```
Analysis of Variance Table

Model 1: DVpost ~ IV
Model 2: DVpost ~ IV + DVpre
  Res.Df  RSS Df Sum of Sq    F Pr(>F)   
1     27 1070                            
2     26  756  1       313 10.8 0.0029 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```


### Test individual regression coefficients


```r
(sumRes <- summary(fitFull))
```

```

Call:
lm(formula = DVpost ~ IV + DVpre, data = dfAnc)

Residuals:
    Min      1Q  Median      3Q     Max 
-10.684  -3.961   0.645   3.877   9.967 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)   
(Intercept)   -3.670      3.752   -0.98   0.3370   
IVPlacebo      4.448      2.416    1.84   0.0770 . 
IVWL           6.442      2.413    2.67   0.0129 * 
DVpre          0.645      0.197    3.28   0.0029 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Residual standard error: 5.39 on 26 degrees of freedom
Multiple R-squared: 0.423,	Adjusted R-squared: 0.356 
F-statistic: 6.35 on 3 and 26 DF,  p-value: 0.00225 
```

```r
confint(fitFull)
```

```
               2.5 % 97.5 %
(Intercept) -11.3837  4.043
IVPlacebo    -0.5178  9.414
IVWL          1.4812 11.403
DVpre         0.2412  1.049
```


### Vsisualize ANCOVA coefficients


```r
coeffs    <- coef(sumRes)
iCeptSSRI <- coeffs[1, 1]
iCeptPlac <- coeffs[2, 1] + iCeptSSRI
iCeptWL   <- coeffs[3, 1] + iCeptSSRI
slopeAll  <- coeffs[4, 1]
```



```r
xLims <- c(0, max(dfAnc$DVpre))
yLims <- c(min(iCeptSSRI, iCeptPlac, iCeptWL), max(dfAnc$DVpost))

plot(DVpost ~ DVpre, data=dfAnc, xlim=xLims, ylim=yLims,
     pch=rep(c(3, 17, 19), Nj), col=rep(c("red", "green", "blue"), Nj),
     main="Data and group-wise regression lines")
legend(x="topleft", legend=levels(dfAnc$IV), pch=c(3, 17, 19),
       col=c("red", "green", "blue"))
abline(iCeptSSRI, slopeAll, col="red")
abline(iCeptPlac, slopeAll, col="green")
abline(iCeptWL,   slopeAll, col="blue")
```

![plot of chunk rerAncova02](content/assets/figure/rerAncova02.png) 


Effect size estimate
-------------------------

### $\hat{\omega}^{2}$ for the group effect

Using SS type II


```r
anRes <- anova(fitRegr, fitFull)
dfGrp <- anRes[2, "Df"]
dfE   <- anRes[2, "Res.Df"]
MSgrp <- anRes[2, "Sum of Sq"] / dfGrp
MSE   <- anRes[2, "RSS"] / dfE
SST   <- sum(anova(fitFull)[ , "Sum Sq"])

(omegaSqHat <- dfGrp*(MSgrp - MSE) / (SST + MSE))
```

```
[1] 0.1187
```


Planned comparisons between groups
-------------------------

### Adjusted group means


```r
aovAncova <- aov(DVpost ~ IV + DVpre, data=dfAnc)
library(effects)                    # for effect()
YMjAdj <- effect("IV", aovAncova)
summary(YMjAdj)
```

```

 IV effect
IV
   SSRI Placebo      WL 
  7.537  11.985  13.978 

 Lower 95 Percent Confidence Limits
IV
   SSRI Placebo      WL 
  4.028   8.476  10.473 

 Upper 95 Percent Confidence Limits
IV
   SSRI Placebo      WL 
  11.05   15.49   17.48 
```


### Planned comparisons


```r
cMat <- rbind("SSRI-Placebo"  = c(-1,  1, 0),
              "SSRI-WL"       = c(-1,  0, 1),
              "SSRI-0.5(P+WL)"= c(-2,  1, 1))
```



```r
library(multcomp)                    # for glht()
aovAncova <- aov(DVpost ~ IV + DVpre, data=dfAnc)
summary(glht(aovAncova, linfct=mcp(IV=cMat), alternative="greater"),
        test=adjusted("none"))
```

```

	 Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: User-defined Contrasts


Fit: aov(formula = DVpost ~ IV + DVpre, data = dfAnc)

Linear Hypotheses:
                    Estimate Std. Error t value Pr(>t)   
SSRI-Placebo <= 0       4.45       2.42    1.84 0.0385 * 
SSRI-WL <= 0            6.44       2.41    2.67 0.0065 **
SSRI-0.5(P+WL) <= 0    10.89       4.18    2.60 0.0075 **
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
(Adjusted p values reported -- none method)
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:effects))
try(detach(package:colorspace))
try(detach(package:lattice))
try(detach(package:grid))
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

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/ancova.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/ancova.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/ancova.R) - [all posts](https://github.com/dwoll/RExRepos/)
