---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Split-plot-factorial ANOVA (SPF-p.q design)"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---




TODO
-------------------------

 - link to anovaSPFpqr, anovaMixed, dfReshape

Traditional univariate analysis and multivariate approach.

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`multcomp`](http://cran.r-project.org/package=multcomp)


```r
wants <- c("car", "multcomp")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Two-way SPF-$p \cdot q$ ANOVA
-------------------------

### Using `aov()` with data in long format


```r
set.seed(1.234)
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
summary(aov(DV ~ IVbtw*IVwth + Error(id/IVwth), data=dfSPFpqL))
```

```

Error: id
          Df Sum Sq Mean Sq F value  Pr(>F)    
IVbtw      2    226   113.2    11.4 0.00026 ***
Residuals 27    268     9.9                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

Error: id:IVwth
            Df Sum Sq Mean Sq F value  Pr(>F)    
IVwth        2    114    56.8    9.00 0.00042 ***
IVbtw:IVwth  4     23     5.8    0.91 0.46327    
Residuals   54    341     6.3                    
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

               SS num Df Error SS den Df     F  Pr(>F)    
(Intercept)  88.6      1      268     27  8.92 0.00593 ** 
IVbtw       226.4      2      268     27 11.40 0.00026 ***
IVwth       113.7      2      341     54  9.00 0.00042 ***
IVbtw:IVwth  23.1      4      341     54  0.91 0.46327    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 


Mauchly Tests for Sphericity

            Test statistic p-value
IVwth                0.842   0.107
IVbtw:IVwth          0.842   0.107


Greenhouse-Geisser and Huynh-Feldt Corrections
 for Departure from Sphericity

            GG eps Pr(>F[GG])    
IVwth        0.863    0.00086 ***
IVbtw:IVwth  0.863    0.45322    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

            HF eps Pr(>F[HF])    
IVwth        0.917    0.00065 ***
IVbtw:IVwth  0.917    0.45737    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
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

            Df     F num Df den Df  Pr(>F)  G-G Pr  H-F Pr
(Intercept)  1  8.92      1     27 0.00593 0.00593 0.00593
IVbtw        2 11.40      2     27 0.00026 0.00026 0.00026
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

Greenhouse-Geisser epsilon: 0.8634
Huynh-Feldt epsilon:        0.9170

            Df    F num Df den Df Pr(>F) G-G Pr H-F Pr
(Intercept)  1 9.00      2     54  0.000  0.001  0.001
IVbtw        2 0.91      4     54  0.463  0.453  0.457
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
W = 0.8418, p-value = 0.1067
```


Effect size estimates: generalized $\hat{\eta}_{g}^{2}$
-------------------------


```r
(anRes <- anova(lm(DV ~ IVbtw*IVwth*id, data=dfSPFpqL)))
```

```
Analysis of Variance Table

Response: DV
            Df Sum Sq Mean Sq F value Pr(>F)
IVbtw        2    226   113.2               
IVwth        2    114    56.8               
id          27    268     9.9               
IVbtw:IVwth  4     23     5.8               
IVwth:id    54    341     6.3               
Residuals    0      0                       
```



```r
SSEtot <- anRes["id", "Sum Sq"] + anRes["IVwth:id", "Sum Sq"]
SSbtw  <- anRes["IVbtw", "Sum Sq"]
SSwth  <- anRes["IVwth", "Sum Sq"]
SSI    <- anRes["IVbtw:IVwth", "Sum Sq"]
```



```r
(gEtaSqB <- SSbtw / (SSbtw + SSEtot))
```

```
[1] 0.2709
```

```r
(gEtaSqW <- SSwth / (SSwth + SSEtot))
```

```
[1] 0.1573
```

```r
(gEtaSqI <- SSI   / (SSI   + SSEtot))
```

```
[1] 0.03648
```


Or from function `ezANOVA()` from package [`ez`](http://cran.r-project.org/package=ez)

Simple effects
-------------------------

Separate error terms

### Between-subjects effect at a fixed level of the within-subjects factor


```r
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==1)))
```

```
            Df Sum Sq Mean Sq F value Pr(>F)  
IVbtw        2   53.4   26.69    3.24  0.055 .
Residuals   27  222.7    8.25                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```

```r
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==2)))
```

```
            Df Sum Sq Mean Sq F value Pr(>F)   
IVbtw        2   71.6    35.8    6.04 0.0068 **
Residuals   27  160.1     5.9                  
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
```

```r
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==3)))
```

```
            Df Sum Sq Mean Sq F value Pr(>F)   
IVbtw        2    124    62.3    7.42 0.0027 **
Residuals   27    226     8.4                  
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
Residuals  9    102    11.4               

Error: id:IVwth
          Df Sum Sq Mean Sq F value Pr(>F)
IVwth      2   40.4    20.2    2.52   0.11
Residuals 18  144.0     8.0               
```

```r
summary(aov(DV ~ IVwth + Error(id/IVwth), data=dfSPFpqL,
        subset=(IVbtw=="B")))
```

```

Error: id
          Df Sum Sq Mean Sq F value Pr(>F)
Residuals  9   72.8    8.08               

Error: id:IVwth
          Df Sum Sq Mean Sq F value Pr(>F)   
IVwth      2   87.6    43.8    6.83 0.0062 **
Residuals 18  115.5     6.4                  
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
Residuals  9   92.8    10.3               

Error: id:IVwth
          Df Sum Sq Mean Sq F value Pr(>F)
IVwth      2    8.8    4.38    0.96    0.4
Residuals 18   81.7    4.54               
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
-0.5*(A+B)+C <= 0   -3.207      0.705   -4.55      1
A-C <= 0            -3.795      0.814   -4.66      1
(Adjusted p values reported -- none method)
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:multcomp))
try(detach(package:mvtnorm))
try(detach(package:car))
try(detach(package:survival))
try(detach(package:splines))
try(detach(package:nnet))
try(detach(package:MASS))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaSPFpq.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaSPFpq.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaSPFpq.R) - [all posts](https://github.com/dwoll/RExRepos/)
