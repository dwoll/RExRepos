---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Survival analysis: Kaplan-Meier"
categories: [Univariate, Survival]
rerCat: Univariate
tags: [Survival, KaplanMeier]
---




TODO
-------------------------

 - link to survivalCoxPH, survivalParametric

Install required packages
-------------------------

[`survival`](http://cran.r-project.org/package=survival)


```r
wants <- c("survival")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Simulated right-censored event times with Weibull distribution
-------------------------

Simulated survival time $T$ influenced by time independent covariates $X_{j}$ with effect parameters $\beta_{j}$ under assumption of proportional hazards, stratified by sex.

$T = (-\ln(U) \, b \, e^{-\bf{X} \bf{\beta}})^{\frac{1}{a}}$, where $U \sim \mathcal{U}(0, 1)$, $a$ is the Weibull shape parameter and $b$ is the Weibull scale parameter.


```r
set.seed(123)
N      <- 180                  # number of observations
P      <- 3                    # number of groups
sex    <- factor(sample(c("f", "m"), N, replace=TRUE))  # stratification factor
X      <- rnorm(N, 0, 1)       # continuous covariate
IV     <- factor(rep(LETTERS[1:P], each=N/P))  # factor covariate
IVeff  <- c(0, -1, 1.5)        # effects of factor levels (1 -> reference level)
Xbeta  <- 0.7*X + IVeff[unclass(IV)] + rnorm(N, 0, 2)
weibA  <- 1.5                  # Weibull shape parameter
weibB  <- 100                  # Weibull scale parameter
U      <- runif(N, 0, 1)       # uniformly distributed RV
eventT <- ceiling((-log(U)*weibB*exp(-Xbeta))^(1/weibA))   # simulated event time

# censoring due to study end after 120 days
obsLen <- 120                  # length of observation time
censT  <- rep(obsLen, N)       # censoring time = end of study
obsT   <- pmin(eventT, censT)  # observed censored event times
status <- eventT <= censT      # has event occured?
dfSurv <- data.frame(obsT, status, sex, X, IV)          # data frame
```

Survival data in counting process (start-stop) notation.


```r
library(survival)
dfSurvCP <- survSplit(dfSurv, cut=seq(30, 90, by=30), end="obsT",
                      event="status", start="start", id="ID", zero=0)
```

Plot simulated data


```r
plot(ecdf(eventT), xlim=c(0, 200), main="Cumulative survival distribution",
     xlab="t", ylab="F(t)", cex.lab=1.4)
abline(v=obsLen, col="blue", lwd=2)
text(obsLen-5, 0.2, adj=1, labels="end of study", cex=1.4)
```

![plot of chunk rerSurvivalKM01](../content/assets/figure/rerSurvivalKM01-1.png) 

Kaplan-Meier-Analysis
-------------------------

### Estimate survival-function

Survival function $S(t) = 1-F(t)$, hazard function

$$
\begin{equation*}
\lambda(t) = \lim_{\Delta_{t} \to 0^{+}} \frac{P(t \leq T < t + \Delta_{t} \, | \, T \geq t)}{\Delta_{t}} = \frac{P(t \leq T < t + \Delta_{t}) / \Delta_{t}}{P(T > t)} = \frac{f(t)}{S(t)}, \quad t \geq 0
\end{equation*}
$$


```r
library(survival)                # for Surv(), survfit()
## global estimate
KM0 <- survfit(Surv(obsT, status) ~ 1,  type="kaplan-meier", conf.type="log", data=dfSurv)

## separate estimate for all strata
(KM <- survfit(Surv(obsT, status) ~ IV, type="kaplan-meier", conf.type="log", data=dfSurv))
```

```
Call: survfit(formula = Surv(obsT, status) ~ IV, data = dfSurv, type = "kaplan-meier", 
    conf.type = "log")

     records n.max n.start events median 0.95LCL 0.95UCL
IV=A      60    60      60     53   13.0       8      29
IV=B      60    60      60     46   35.0      20      58
IV=C      60    60      60     58    9.5       4      13
```

Arbitrary quantiles for estimated survival function.


```r
quantile(KM0, probs=c(0.25, 0.5, 0.75), conf.int=FALSE)
```

```
  25   50   75 
 4.0 14.0 46.5 
```

All estimated values for survival function including point-wise confidence interval.


```r
summary(KM0)
```

```
Call: survfit(formula = Surv(obsT, status) ~ 1, data = dfSurv, type = "kaplan-meier", 
    conf.type = "log")

 time n.risk n.event survival std.err lower 95% CI upper 95% CI
    1    180      13    0.928  0.0193       0.8907        0.966
    2    167      11    0.867  0.0253       0.8184        0.918
    3    156      17    0.772  0.0313       0.7133        0.836
    4    139       9    0.722  0.0334       0.6597        0.791
    5    130       4    0.700  0.0342       0.6362        0.770
    6    126       5    0.672  0.0350       0.6070        0.744
    7    121       3    0.656  0.0354       0.5897        0.729
    8    118       4    0.633  0.0359       0.5667        0.708
    9    114       5    0.606  0.0364       0.5382        0.681
   10    109       8    0.561  0.0370       0.4931        0.638
   11    101       4    0.539  0.0372       0.4708        0.617
   12     97       1    0.533  0.0372       0.4652        0.611
   13     96       5    0.506  0.0373       0.4375        0.584
   14     91       3    0.489  0.0373       0.4211        0.568
   15     88       6    0.456  0.0371       0.3883        0.534
   16     82       3    0.439  0.0370       0.3721        0.518
   17     79       2    0.428  0.0369       0.3613        0.507
   19     77       3    0.411  0.0367       0.3452        0.490
   20     74       2    0.400  0.0365       0.3345        0.478
   21     72       3    0.383  0.0362       0.3185        0.461
   23     69       2    0.372  0.0360       0.3079        0.450
   24     67       1    0.367  0.0359       0.3026        0.444
   25     66       1    0.361  0.0358       0.2973        0.439
   27     65       2    0.350  0.0356       0.2868        0.427
   29     63       3    0.333  0.0351       0.2711        0.410
   30     60       2    0.322  0.0348       0.2607        0.398
   32     58       2    0.311  0.0345       0.2503        0.387
   34     56       2    0.300  0.0342       0.2400        0.375
   36     54       1    0.294  0.0340       0.2349        0.369
   38     53       1    0.289  0.0338       0.2297        0.363
   39     52       2    0.278  0.0334       0.2195        0.352
   40     50       1    0.272  0.0332       0.2144        0.346
   41     49       2    0.261  0.0327       0.2042        0.334
   43     47       1    0.256  0.0325       0.1992        0.328
   46     46       1    0.250  0.0323       0.1941        0.322
   47     45       1    0.244  0.0320       0.1891        0.316
   48     44       1    0.239  0.0318       0.1841        0.310
   49     43       1    0.233  0.0315       0.1790        0.304
   50     42       2    0.222  0.0310       0.1691        0.292
   54     40       2    0.211  0.0304       0.1592        0.280
   58     38       2    0.200  0.0298       0.1493        0.268
   64     36       2    0.189  0.0292       0.1396        0.256
   65     34       1    0.183  0.0288       0.1347        0.250
   68     33       1    0.178  0.0285       0.1298        0.243
   69     32       1    0.172  0.0281       0.1250        0.237
   71     31       1    0.167  0.0278       0.1202        0.231
   86     30       1    0.161  0.0274       0.1154        0.225
   91     29       2    0.150  0.0266       0.1059        0.212
  103     27       1    0.144  0.0262       0.1012        0.206
  109     26       1    0.139  0.0258       0.0965        0.200
  111     25       1    0.133  0.0253       0.0919        0.194
  112     24       1    0.128  0.0249       0.0872        0.187
```

### Plot estimated survival function

Global estimate including pointwise confidence intervals.


```r
plot(KM0, main=expression(paste("Kaplan-Meier-estimate ", hat(S)(t), " with CI")),
     xlab="t", ylab="Survival", lwd=2)
```

![plot of chunk rerSurvivalKM02](../content/assets/figure/rerSurvivalKM02-1.png) 

Separate estimates for levels of factor `IV`


```r
plot(KM, main=expression(paste("Kaplan-Meier-estimate ", hat(S)[g](t), " for groups g")),
     xlab="t", ylab="Survival", lwd=2, col=1:3)
legend(x="topright", col=1:3, lwd=2, legend=LETTERS[1:3])
```

![plot of chunk rerSurvivalKM03](../content/assets/figure/rerSurvivalKM03-1.png) 

### Plot cumulative hazard

$\hat{\Lambda}(t)$


```r
plot(KM0, main=expression(paste("Kaplan-Meier-estimate ", hat(Lambda)(t))),
     xlab="t", ylab="cumulative hazard", fun="cumhaz", lwd=2)
```

![plot of chunk rerSurvivalKM04](../content/assets/figure/rerSurvivalKM04-1.png) 

### Log-rank-test for equal survival-functions

Global test


```r
library(survival)
survdiff(Surv(obsT, status) ~ IV, data=dfSurv)
```

```
Call:
survdiff(formula = Surv(obsT, status) ~ IV, data = dfSurv)

      N Observed Expected (O-E)^2/E (O-E)^2/V
IV=A 60       53     49.9     0.196     0.301
IV=B 60       46     71.7     9.220    18.251
IV=C 60       58     35.4    14.402    20.264

 Chisq= 26.1  on 2 degrees of freedom, p= 2.16e-06 
```

Stratified for factor `sex`


```r
library(survival)
survdiff(Surv(obsT, status) ~ IV + strata(sex), data=dfSurv)
```

```
Call:
survdiff(formula = Surv(obsT, status) ~ IV + strata(sex), data = dfSurv)

      N Observed Expected (O-E)^2/E (O-E)^2/V
IV=A 60       53     49.7     0.225     0.345
IV=B 60       46     71.9     9.311    18.516
IV=C 60       58     35.5    14.302    20.127

 Chisq= 26.1  on 2 degrees of freedom, p= 2.12e-06 
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:survival))
try(detach(package:splines))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/survivalKM.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/survivalKM.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/survivalKM.R) - [all posts](https://github.com/dwoll/RExRepos/)
