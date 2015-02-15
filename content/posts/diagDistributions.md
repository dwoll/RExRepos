---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Visualize univariate and bivariate distributions"
categories: [Diagrams, SpecificDiagrams]
rerCat: Diagrams
tags: [Diagrams]
---




TODO
-------------------------

 - link to diagCategorical, diagScatter, diagMultivariate, diagAddElements, diagBounding
 - new R 2.15.1+ `qqplot()` options `distribution` and `probs`

Install required packages
-------------------------

[`car`](http://cran.r-project.org/package=car), [`hexbin`](http://cran.r-project.org/package=hexbin)


```r
wants <- c("car", "hexbin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Histograms
-------------------------

### Histogram with absolute class frequencies
    

```r
set.seed(123)
x <- rnorm(200, 175, 10)
hist(x, xlab="x", ylab="N", breaks="FD")
```

![plot of chunk rerDiagDistributions01](../content/assets/figure/rerDiagDistributions01-1.png) 

### Add individual values and normal probability density function


```r
hist(x, freq=FALSE, xlab="x", ylab="relative frequency",
     breaks="FD", main="Histogram und normal PDF")
rug(jitter(x))
curve(dnorm(x, mean(x), sd(x)), lwd=2, col="blue", add=TRUE)
```

![plot of chunk rerDiagDistributions02](../content/assets/figure/rerDiagDistributions02-1.png) 

### Add estimated probability density function


```r
hist(x, freq=FALSE, xlab="x", breaks="FD",
     main="Histogram and density estimate")
lines(density(x), lwd=2, col="blue")
rug(jitter(x))
```

![plot of chunk rerDiagDistributions03](../content/assets/figure/rerDiagDistributions03-1.png) 

To compare the histograms from two groups, see `histbackback()` from package [`Hmisc`](http://cran.r-project.org/package=Hmisc).

Stem and leaf plot
-------------------------


```r
y <- rnorm(100, mean=175, sd=7)
stem(y)
```

```

  The decimal point is 1 digit(s) to the right of the |

  15 | 669
  16 | 134
  16 | 5566777789
  17 | 0011112222233333334444444
  17 | 5555566666677777788888888999
  18 | 0000000001111233334444
  18 | 55667779
  19 | 2
```

Boxplot
-------------------------


```r
Nj <- 40
P  <- 3
DV <- rnorm(P*Nj, mean=100, sd=15)
IV <- gl(P, Nj, labels=c("Control", "Group A", "Group B"))
```


```r
boxplot(DV ~ IV, ylab="Score", col=c("red", "blue", "green"),
        main="Boxplot of scores in 3 groups")
stripchart(DV ~ IV, pch=16, col="darkgray", vert=TRUE, add=TRUE)
```

![plot of chunk rerDiagDistributions04](../content/assets/figure/rerDiagDistributions04-1.png) 


```r
xC <- DV[IV == "Control"]
xA <- DV[IV == "Group A"]
boxplot(xC, xA)
```

![plot of chunk rerDiagDistributions05](../content/assets/figure/rerDiagDistributions05-1.png) 

Dotchart
-------------------------


```r
Nj  <- 5
DV1 <- rnorm(Nj, 20, 2)
DV2 <- rnorm(Nj, 25, 2)
DV  <- c(DV1, DV2)
IV  <- gl(2, Nj)
Mj  <- tapply(DV, IV, FUN=mean)
```


```r
dotchart(DV, gdata=Mj, pch=16, color=rep(c("red", "blue"), each=Nj),
         gcolor="black", labels=rep(LETTERS[1:Nj], 2), groups=IV,
		 xlab="AV", ylab="group",
         main="individual results and means from 2 groups")
```

![plot of chunk rerDiagDistributions06](../content/assets/figure/rerDiagDistributions06-1.png) 

Stripchart
-------------------------


```r
Nj   <- 25
P    <- 4
dice <- sample(1:6, P*Nj, replace=TRUE)
IV   <- gl(P, Nj)
```


```r
stripchart(dice ~ IV, xlab="Result", ylab="group", pch=1, col="blue",
           main="Dice results: 4 groups", sub="jitter-method", method="jitter")
```

![plot of chunk rerDiagDistributions07](../content/assets/figure/rerDiagDistributions07-1.png) 

```r
stripchart(dice ~ IV, xlab="Result", ylab="group", pch=16, col="red",
           main="Dice results: 4 groups", sub="stack-method", method="stack")
```

![plot of chunk rerDiagDistributions07](../content/assets/figure/rerDiagDistributions07-2.png) 

QQ-plot
-------------------------


```r
DV1 <- rnorm(200)
DV2 <- rf(200, df1=3, df2=15)
qqplot(DV1, DV2, xlab="quantile N(0, 1)", ylab="quantile F(3, 15)",
       main="Comparison of quantiles from N(0, 1) and F(3, 15)")
```

![plot of chunk rerDiagDistributions08](../content/assets/figure/rerDiagDistributions08-1.png) 


```r
height <- rnorm(100, mean=175, sd=7)
qqnorm(height)
qqline(height, col="red", lwd=2)
```

![plot of chunk rerDiagDistributions09](../content/assets/figure/rerDiagDistributions09-1.png) 

Empirical cumulative distribution function
-------------------------


```r
vec <- round(rnorm(10), 1)
Fn  <- ecdf(vec)
plot(Fn, main="Empirical cumulative distribution function")
curve(pnorm, add=TRUE, col="gray", lwd=2)
```

![plot of chunk rerDiagDistributions10](../content/assets/figure/rerDiagDistributions10-1.png) 

Joint distribution of two variables in separate groups
-------------------------

### Simulate data


```r
N  <- 200
P  <- 2
x  <- rnorm(N, 100, 15)
y  <- 0.5*x + rnorm(N, 0, 10)
IV <- gl(P, N/P, labels=LETTERS[1:P])
```

### Identify group membership by plot symbol and color


```r
plot(x, y, pch=c(4, 16)[unclass(IV)], lwd=2,
     col=c("black", "blue")[unclass(IV)],
     main="Joint distribution per group")
legend(x="topleft", legend=c("group A", "group B"),
       pch=c(4, 16), col=c("black", "blue"))
```

![plot of chunk rerDiagDistributions11](../content/assets/figure/rerDiagDistributions11-1.png) 

### Add distribution ellipse

Pooled groups


```r
library(car)
dataEllipse(x, y, xlab="x", ylab="y", asp=1, levels=0.5, lwd=2, center.pch=16,
            col="blue", main="Joint distribution of two variables")
legend(x="bottomright", legend=c("Data", "centroid", "distribution ellipse"),
       pch=c(1, 16, NA), lty=c(NA, NA, 1), col=c("black", "blue", "blue"))
```

![plot of chunk rerDiagDistributions12](../content/assets/figure/rerDiagDistributions12-1.png) 

Joint distribution of two variables with many observations
-------------------------

### Using transparency


```r
N  <- 5000
xx <- rnorm(N, 100, 15)
yy <- 0.4*xx + rnorm(N, 0, 10)
plot(xx, yy, pch=16, col=rgb(0, 0, 1, 0.3))
```

![plot of chunk rerDiagDistributions13](../content/assets/figure/rerDiagDistributions13-1.png) 

### Smooth scatter plot

Based on a 2-D kernel density estimate


```r
smoothScatter(xx, yy, bandwidth=4)
```

![plot of chunk rerDiagDistributions14](../content/assets/figure/rerDiagDistributions14-1.png) 

### Hexagonal 2-D binning


```r
library(hexbin)
res <- hexbin(xx, yy, xbins=20)
plot(res)
```

![plot of chunk rerDiagDistributions15](../content/assets/figure/rerDiagDistributions15-1.png) 

```r
summary(res)
```

```
'hexbin' object from call: hexbin(x = xx, y = yy, xbins = 20) 
n = 5000  points in	nc = 214  hexagon cells in grid dimensions  26 by 21 
      cell           count             xcm              ycm        
 Min.   :  9.0   Min.   :  1.00   Min.   : 44.83   Min.   :-5.868  
 1st Qu.:156.2   1st Qu.:  2.00   1st Qu.: 81.19   1st Qu.:23.484  
 Median :240.5   Median :  8.00   Median :101.46   Median :40.020  
 Mean   :241.7   Mean   : 23.36   Mean   :101.18   Mean   :40.089  
 3rd Qu.:324.8   3rd Qu.: 31.00   3rd Qu.:120.83   3rd Qu.:56.395  
 Max.   :499.0   Max.   :133.00   Max.   :157.78   Max.   :90.498  
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:car))
try(detach(package:hexbin))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/diagDistributions.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/diagDistributions.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/diagDistributions.R) - [all posts](https://github.com/dwoll/RExRepos/)
