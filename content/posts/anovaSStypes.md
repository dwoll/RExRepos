---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Sum of squares type I, II, and III"
categories: [Univariate, ANOVA]
rerCat: Univariate
tags: [ANOVA]
---




TODO
-------------------------

 - link to anovaCRFpq, ancova, multMANOVA, multRegression

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car)


```r
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Background
-------------------------

Non-orthogonal factorial between-subjects designs typically result from non-proportional unequal cell sizes. Proportional unequal cell sizes are present when $n_{jk}/n_{jk'} = n_{j'k}/n_{j'k'}$ and $n_{jk}/n_{j'k} = n_{jk'}/n_{j'k'}$ for all $j, j', k, k'$ holds.

In the non-proportional case, so-called type I, II, or III sums of squares can give different results in an ANOVA for all tests but the highest interaction effect. "Types of SS" is a misnomer: The SS of an effect is the sum of squared differences between the predicted values from the least-squares fit of a restricted model and the prediction from the least-squares fit of a more general model. What differs between the "types of SS" is the choice for the restricted and more general model when testing an effect. Orthogonal designs obscure these differences because then all SS types will be equal.

SAS and SPSS use SS type III as their default, while functions that ship with base R use type I. This can lead to different results when analyzing the same data with different statistics packages.

A thorough resource on the topic is chapter 7 of Maxwell & Delaney (2004). Designing Experiments and Analyzing Data. A Model Comparison Perspective. Mahwah, NJ: Lawrence Erlbaum.

Hypotheses for main effects
-------------------------

Hypotheses for main effects as tested by different SS types in a non-proportional unbalanced two-factorial between-subjects design (IV A with $P$ groups, B with $Q$ groups).

 - Cell expected values
    - $\mu_{jk} \quad 1 \leq j \leq P, \quad 1 \leq k \leq Q$
 - Unweighted marginal expected values:
    - $\mu_{j.} := \frac{1}{Q} \sum_{k=1}^{Q} \mu_{jk} \quad 1 \leq j \leq P$
    - $\mu_{.k} := \frac{1}{P} \sum_{j=1}^{P} \mu_{jk} \quad 1 \leq k \leq Q$
 - Cell sizes
    - $n_{jk} \quad 1 \leq j \leq P, \quad 1 \leq k \leq Q$
 - Total marginal cell sizes
    - $n_{j+} := \sum_{k=1}^{Q} n_{jk} \quad 1 \leq j \leq P$
    - $n_{+k} := \sum_{j=1}^{P} n_{jk} \quad 1 \leq k \leq Q$

Null-Hypotheses SS type I (A entered before B):

A: $\sum_{k=1}^{Q} \frac{n_{1k}}{n_{1+}} \cdot \mu_{1k} = \ldots = \sum_{k=1}^{Q} \frac{n_{jk}}{n_{j+}} \cdot \mu_{jk} = \ldots = \sum_{k=1}^{Q} \frac{n_{Pk}}{n_{P+}} \cdot \mu_{Pk}$

B: $\sum_{j=1}^{P}(n_{jk} - \frac{n^{2}_{jk}}{n_{j+}}) \cdot \mu_{jk} = \sum_{k' \neq k} \sum_{j=1}^{P}(\frac{n_{jk} \cdot n_{jk'}}{n_{j+}}) \cdot \mu_{jk'} \qquad \forall \, k = 1, \ldots, Q-1$

Null-Hypotheses SS type II:

A: $\sum_{k=1}^{Q}(n_{jk} - \frac{n^{2}_{jk}}{n_{+k}}) \cdot \mu_{jk} = \sum_{j' \neq j} \sum_{k=1}^{Q}(\frac{n_{jk} \cdot n_{j'k}}{n_{+k}}) \cdot \mu_{j'k} \qquad \forall \, j = 1, \ldots, P-1$

B: $\sum_{j=1}^{P}(n_{jk} - \frac{n^{2}_{jk}}{n_{j+}}) \cdot \mu_{jk} = \sum_{k' \neq k} \sum_{j=1}^{P}(\frac{n_{jk} \cdot n_{jk'}}{n_{j+}}) \cdot \mu_{jk'} \qquad \forall \,k = 1, \ldots, Q-1$

Null-Hypotheses SS type III (with effect- or orthogonal coding method):

A: $\mu_{1.} = \ldots = \mu_{j.} = \ldots = \mu_{P.}$
B: $\mu_{.1} = \ldots = \mu_{.k} = \ldots = \mu_{.Q}$

Data set with non-proportional unequal cell sizes
-------------------------


```r
P    <- 3
Q    <- 3
g11  <- c(41, 43, 50)
g12  <- c(51, 43, 53, 54, 46)
g13  <- c(45, 55, 56, 60, 58, 62, 62)
g21  <- c(56, 47, 45, 46, 49)
g22  <- c(58, 54, 49, 61, 52, 62)
g23  <- c(59, 55, 68, 63)
g31  <- c(43, 56, 48, 46, 47)
g32  <- c(59, 46, 58, 54)
g33  <- c(55, 69, 63, 56, 62, 67)
dfMD <- data.frame(IV1=factor(rep(1:P, c(3+5+7, 5+6+4, 5+4+6))),
                   IV2=factor(rep(rep(1:Q, P), c(3,5,7, 5,6,4, 5,4,6))),
                   DV =c(g11, g12, g13, g21, g22, g23, g31, g32, g33))
```


```r
xtabs(~ IV1 + IV2, data=dfMD)
```

```
   IV2
IV1 1 2 3
  1 3 5 7
  2 5 6 4
  3 5 4 6
```

SS type I (sequential sum of squares)
-------------------------

Type I sum of squares have the following properties:

 - They use sequential model comparisons that conform to the principle of marginality (higher order terms are entered after all corresponding lower order terms).
 - Due to the sequential nature of the model comparisons, they depend on the order of model terms.
 - The individual effect SS sum to the total effect SS
 - They test for the equality of weighted marginal expected values (see above).
   -> the hypotheses take the empirical cell sizes into account
 - They do not depend on the contrast coding scheme used for categorical variables.

### Factor order matters


```r
anova(lm(DV ~ IV1 + IV2 + IV1:IV2, data=dfMD))
```

```
Analysis of Variance Table

Response: DV
          Df  Sum Sq Mean Sq F value    Pr(>F)    
IV1        2  101.11   50.56  1.8102    0.1782    
IV2        2 1253.19  626.59 22.4357 4.711e-07 ***
IV1:IV2    4   14.19    3.55  0.1270    0.9717    
Residuals 36 1005.42   27.93                      
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
anova(lm(DV ~ IV2 + IV1 + IV1:IV2, data=dfMD))
```

```
Analysis of Variance Table

Response: DV
          Df  Sum Sq Mean Sq F value    Pr(>F)    
IV2        2 1115.82  557.91 19.9764 1.458e-06 ***
IV1        2  238.48  119.24  4.2695   0.02168 *  
IV2:IV1    4   14.19    3.55  0.1270   0.97170    
Residuals 36 1005.42   27.93                      
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Sequential model comparisons


```r
SS.I1 <- anova(lm(DV ~ 1,                 data=dfMD),
               lm(DV ~ IV1,               data=dfMD))
SS.I2 <- anova(lm(DV ~ IV1,               data=dfMD),
               lm(DV ~ IV1+IV2,           data=dfMD))
SS.Ii <- anova(lm(DV ~ IV1+IV2,           data=dfMD),
               lm(DV ~ IV1+IV2 + IV1:IV2, data=dfMD))
```


```r
SS.I1[2, "Sum of Sq"]
```

```
[1] 101.1111
```

```r
SS.I2[2, "Sum of Sq"]
```

```
[1] 1253.189
```

```r
SS.Ii[2, "Sum of Sq"]
```

```
[1] 14.18714
```

### Total SS $=$ sum of effect SS


```r
SST <- anova(lm(DV ~ 1,       data=dfMD),
             lm(DV ~ IV1*IV2, data=dfMD))
SST[2, "Sum of Sq"]
```

```
[1] 1368.487
```

```r
SS.I1[2, "Sum of Sq"] + SS.I2[2, "Sum of Sq"] + SS.Ii[2, "Sum of Sq"]
```

```
[1] 1368.487
```

SS type II
-------------------------

Type II sum of squares have the following properties:

 - They test model comparisons that conform to the principle of marginality.
 - They do not depend on the order of model terms.
 - They test hypotheses about weighted cell expected values (see above).
   -> the hypotheses take the empirical cell sizes into account
 - The individual effect SS do not sum to the total effect SS.
 - The result does not depend on the coding scheme for categorical variables.

### Using `Anova()` from package `car`


```r
library(car)
Anova(lm(DV ~ IV1*IV2, data=dfMD), type="II")
```

```
Anova Table (Type II tests)

Response: DV
           Sum Sq Df F value    Pr(>F)    
IV1        238.48  2  4.2695   0.02168 *  
IV2       1253.19  2 22.4357 4.711e-07 ***
IV1:IV2     14.19  4  0.1270   0.97170    
Residuals 1005.42 36                      
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Using model comparisons


```r
SS.II1 <- anova(lm(DV ~     IV2,         data=dfMD),
                lm(DV ~ IV1+IV2,         data=dfMD))
SS.II2 <- anova(lm(DV ~ IV1,             data=dfMD),
                lm(DV ~ IV1+IV2,         data=dfMD))
SS.IIi <- anova(lm(DV ~ IV1+IV2,         data=dfMD),
                lm(DV ~ IV1+IV2+IV1:IV2, data=dfMD))
```


```r
SS.II1[2, "Sum of Sq"]
```

```
[1] 238.4826
```

```r
SS.II2[2, "Sum of Sq"]
```

```
[1] 1253.189
```

```r
SS.IIi[2, "Sum of Sq"]
```

```
[1] 14.18714
```

### Total SS $\neq$ sum of effect SS


```r
SST <- anova(lm(DV ~ 1,       data=dfMD),
             lm(DV ~ IV1*IV2, data=dfMD))
SST[2, "Sum of Sq"]
```

```
[1] 1368.487
```

```r
SS.II1[2, "Sum of Sq"] + SS.II2[2, "Sum of Sq"] + SS.IIi[2, "Sum of Sq"]
```

```
[1] 1505.859
```

SS type III
-------------------------

Type III sum of squares have the following properties:

 - They test model comparisons that violate the principle of marginality when testing main effects.
 - They do not depend on the order of model terms.
 - The individual effect SS do not sum to the total effect SS.
 - They test for the equality of unweighted marginal expected values (see above).
   -> the hypotheses do not take empirical cell sizes into account
 - These hypotheses are only tested when using effect- or orthogonal coding for categorical variables (e.g., Helmert).

### Using `Anova()` from package `car`


```r
# options(contrasts=c(unordered="contr.sum",       ordered="contr.poly"))
```


```r
# options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))
```


```r
fitIII <- lm(DV ~ IV1 + IV2 + IV1:IV2, data=dfMD,
             contrasts=list(IV1=contr.sum, IV2=contr.sum))
```


```r
library(car)
Anova(fitIII, type="III")
```

```
Anova Table (Type III tests)

Response: DV
            Sum Sq Df   F value    Pr(>F)    
(Intercept) 121174  1 4338.7178 < 2.2e-16 ***
IV1            205  2    3.6658   0.03556 *  
IV2           1181  2   21.1452 8.447e-07 ***
IV1:IV2         14  4    0.1270   0.97170    
Residuals     1005 36                        
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

### Model comparisons using `drop1()`

The model comparisons for main effects with SS type III cannot be done using `anova()` due to the violation of marginality principle - `anova()` automatically includes all lower-order terms for the interactions it finds. This would be the comparison:


```r
# A: lm(DV ~     IV2 + IV1:IV2) vs. lm(DV ~ IV1 + IV2 + IV1:IV2)
```


```r
# B: lm(DV ~ IV1     + IV1:IV2) vs. lm(DV ~ IV1 + IV2 + IV1:IV2)
```

In contrast, `drop1()` drops each term in turn even if marginality is violated, so it gives SS type III.


```r
drop1(fitIII, ~ ., test="F")
```

```
Single term deletions

Model:
DV ~ IV1 + IV2 + IV1:IV2
        Df Sum of Sq    RSS    AIC F value    Pr(>F)    
<none>               1005.4 157.79                      
IV1      2    204.76 1210.2 162.13  3.6658   0.03556 *  
IV2      2   1181.11 2186.5 188.75 21.1452 8.447e-07 ***
IV1:IV2  4     14.19 1019.6 150.42  0.1270   0.97170    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


```r
drop1(fitIII, ~ ., test="F")
```

```
Single term deletions

Model:
DV ~ IV1 + IV2 + IV1:IV2
        Df Sum of Sq    RSS    AIC F value    Pr(>F)    
<none>               1005.4 157.79                      
IV1      2    204.76 1210.2 162.13  3.6658   0.03556 *  
IV2      2   1181.11 2186.5 188.75 21.1452 8.447e-07 ***
IV1:IV2  4     14.19 1019.6 150.42  0.1270   0.97170    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/anovaSStypes.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/anovaSStypes.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/anovaSStypes.R) - [all posts](https://github.com/dwoll/RExRepos/)
