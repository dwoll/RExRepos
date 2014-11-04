---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Split-plot-factorial ANOVA (SPF-p.q design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---

Split-plot-factorial ANOVA (SPF-p.q design)
=========================

TODO
-------------------------

 - link to anovaSPFpqr, anovaMixed, dfReshape

Traditional univariate analysis and multivariate approach.

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`DescTools`](http://cran.r-project.org/package=DescTools), [`multcomp`](http://cran.r-project.org/package=multcomp)


```r
wants <- c("car", "DescTools", "multcomp")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Two-way SPF-$p \cdot q$ ANOVA
-------------------------

### Using `aov()` with data in long format


```r
set.seed(123)
Nj   <- 10
P    <- 3
Q    <- 3
muJK <- c(rep(c(1,-1,-2), Nj), rep(c(2,1,-1), Nj), rep(c(3,3,0), Nj))
dfSPFpqL <- data.frame(id=factor(rep(1:(P*Nj), times=Q)),
                       IVbtw=factor(rep(LETTERS[1:P], times=Q*Nj)),
                       IVwth=factor(rep(1:Q, each=P*Nj)),
                       DV=rnorm(Nj*P*Q, muJK, 3))
```


```r
aovSPFpq <- aov(DV ~ IVbtw*IVwth + Error(id/IVwth), data=dfSPFpqL)
summary(aovSPFpq)
```

```

Error: id
          Df Sum Sq Mean Sq F value   Pr(>F)    
IVbtw      2  178.4   89.21   14.92 4.33e-05 ***
Residuals 27  161.5    5.98                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Error: id:IVwth
            Df Sum Sq Mean Sq F value   Pr(>F)    
IVwth        2  131.0   65.50   8.446 0.000643 ***
IVbtw:IVwth  4   43.4   10.85   1.399 0.246589    
Residuals   54  418.8    7.75                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Using `Anova()` from package `car` with data in wide format


```r
dfSPFpqW <- reshape(dfSPFpqL, v.names="DV", timevar="IVwth",
                    idvar=c("id", "IVbtw"), direction="wide")
```


```r
library(car)
fitSPFpq   <- lm(cbind(DV.1, DV.2, DV.3) ~ IVbtw, data=dfSPFpqW)
inSPFpq    <- data.frame(IVwth=gl(Q, 1))
AnovaSPFpq <- Anova(fitSPFpq, idata=inSPFpq, idesign=~IVwth)
summary(AnovaSPFpq, multivariate=FALSE, univariate=TRUE)
```

```

Univariate Type II Repeated-Measures ANOVA Assuming Sphericity

                 SS num Df Error SS den Df       F    Pr(>F)    
(Intercept)  60.859      1   161.46     27 10.1769 0.0035871 ** 
IVbtw       178.416      2   161.46     27 14.9174 4.326e-05 ***
IVwth       130.999      2   418.76     54  8.4464 0.0006433 ***
IVbtw:IVwth  43.407      4   418.76     54  1.3994 0.2465888    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


Mauchly Tests for Sphericity

            Test statistic p-value
IVwth              0.98096 0.77892
IVbtw:IVwth        0.98096 0.77892


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

             GG eps Pr(>F[GG])    
IVwth       0.98132  0.0007035 ***
IVbtw:IVwth 0.98132  0.2473928    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

              HF eps   Pr(>F[HF])
IVwth       1.057498 0.0006432656
IVbtw:IVwth 1.057498 0.2465887981
```

### Using `anova.mlm()` and `mauchly.test()` with data in wide format


```r
anova(fitSPFpq, M=~1, X=~0, idata=inSPFpq, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~0


Contrasts spanned by
~1

Greenhouse-Geisser epsilon: 1
Huynh-Feldt epsilon:        1

            Df      F num Df den Df    Pr(>F)    G-G Pr    H-F Pr
(Intercept)  1 10.177      1     27 0.0035871 0.0035871 0.0035871
IVbtw        2 14.917      2     27 0.0000433 0.0000433 0.0000433
Residuals   27                                                   
```

```r
anova(fitSPFpq, M=~IVwth, X=~1, idata=inSPFpq, test="Spherical")
```

```
Analysis of Variance Table


Contrasts orthogonal to
~1


Contrasts spanned by
~IVwth

Greenhouse-Geisser epsilon: 0.9813
Huynh-Feldt epsilon:        1.0575

            Df      F num Df den Df   Pr(>F)   G-G Pr   H-F Pr
(Intercept)  1 8.4464      2     54 0.000643 0.000703 0.000643
IVbtw        2 1.3994      4     54 0.246589 0.247393 0.246589
Residuals   27                                                
```


```r
mauchly.test(fitSPFpq, M=~IVwth, X=~1, idata=inSPFpq)
```

```

	Mauchly's test of sphericity
	Contrasts orthogonal to
	~1

	Contrasts spanned by
	~IVwth


data:  SSD matrix from lm(formula = cbind(DV.1, DV.2, DV.3) ~ IVbtw, data = dfSPFpqW)
W = 0.981, p-value = 0.7789
```

Effect size estimates: generalized $\hat{\eta}_{g}^{2}$
-------------------------


```r
library(DescTools)
EtaSq(aovSPFpq, type=1)
```

```
                eta.sq eta.sq.part eta.sq.gen
IVbtw       0.19121909  0.52493969 0.23517935
IVwth       0.14039994  0.23828548 0.18418939
IVbtw:IVwth 0.04652234  0.09392166 0.06960453
```

Simple effects
-------------------------

Separate error terms

### Between-subjects effect at a fixed level of the within-subjects factor


```r
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==1)))
```

```
            Df Sum Sq Mean Sq F value Pr(>F)  
IVbtw        2  81.81   40.90   4.694 0.0178 *
Residuals   27 235.26    8.71                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==2)))
```

```
            Df Sum Sq Mean Sq F value Pr(>F)  
IVbtw        2  37.15  18.577   2.814 0.0776 .
Residuals   27 178.24   6.601                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==3)))
```

```
            Df Sum Sq Mean Sq F value  Pr(>F)   
IVbtw        2  102.9   51.43   8.329 0.00152 **
Residuals   27  166.7    6.17                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Within-subjects effect at a fixed level of the between-subjects factor


```r
summary(aov(DV ~ IVwth + Error(id/IVwth), data=dfSPFpqL,
        subset=(IVbtw=="A")))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   22.6   2.511               

Error: id:IVwth
          Df Sum Sq Mean Sq F value Pr(>F)  
IVwth      2  46.99   23.49   3.512 0.0516 .
Residuals 18 120.41    6.69                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
summary(aov(DV ~ IVwth + Error(id/IVwth), data=dfSPFpqL,
        subset=(IVbtw=="B")))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9  23.14   2.571               

Error: id:IVwth
          Df Sum Sq Mean Sq F value  Pr(>F)   
IVwth      2  111.4   55.71   8.153 0.00301 **
Residuals 18  123.0    6.83                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
summary(aov(DV ~ IVwth + Error(id/IVwth), data=dfSPFpqL,
        subset=(IVbtw=="C")))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9  115.7   12.86               

Error: id:IVwth
          Df Sum Sq Mean Sq F value Pr(>F)
IVwth      2   16.0   7.998   0.821  0.456
Residuals 18  175.3   9.742               
```

Planned comparisons for the between-subjects factor
-------------------------


```r
mDf    <- aggregate(DV ~ id + IVbtw, data=dfSPFpqL, FUN=mean)
aovRes <- aov(DV ~ IVbtw, data=mDf)
```

```r
cMat <- rbind("-0.5*(A+B)+C"=c(-1/2, -1/2, 1),
                       "A-C"=c(-1,    0,   1))
```


```r
library(multcomp)
summary(glht(aovRes, linfct=mcp(IVbtw=cMat), alternative="greater"),
        test=adjusted("none"))
```

```

	 Simultaneous Tests for General Linear Hypotheses

Multiple Comparisons of Means: User-defined Contrasts


Fit: aov(formula = DV ~ IVbtw, data = mDf)

Linear Hypotheses:
                  Estimate Std. Error t value Pr(>t)
-0.5*(A+B)+C <= 0  -2.3750     0.5468  -4.343      1
A-C <= 0           -3.4206     0.6314  -5.418      1
(Adjusted p values reported -- none method)
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:DescTools))
try(detach(package:multcomp))
try(detach(package:mvtnorm))
try(detach(package:car))
try(detach(package:survival))
try(detach(package:splines))
try(detach(package:TH.data))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaSPFpq.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaSPFpq.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaSPFpq.R) - [all posts](https://github.com/dwoll/RExRepos/)
