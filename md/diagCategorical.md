---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Diagrams for categorical data"
categories: [Diagrams, SpecificDiagrams]
rerCat: Diagrams
tags: [Diagrams]
---

Diagrams for categorical data
=========================

Install required packages
-------------------------

[`plotrix`](http://cran.r-project.org/package=plotrix)


```r
wants <- c("plotrix")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Barplots
-------------------------

### Simulate data
    

```r
set.seed(123)
dice  <- sample(1:6, 100, replace=TRUE)
(dTab <- table(dice))
```

```
dice
 1  2  3  4  5  6 
17 16 20 14 18 15 
```


###  Simple barplot


```r
barplot(dTab, ylim=c(0, 30), xlab="Result", ylab="N", col="black",
        main="Absolute frequency")
```

![plot of chunk rerDiagCategorical01](content/assets/figure/rerDiagCategorical01.png) 



```r
barplot(prop.table(dTab), ylim=c(0, 0.3), xlab="Result",
        ylab="relative frequency", col="gray50",
		main="Relative frequency")
# not shown
```


### Barplots for contingency tables of two variables

#### Stacked barplot


```r
roll1   <- dice[1:50]
roll2   <- dice[51:100]
rollAll <- rbind(table(roll1), table(roll2))
rownames(rollAll) <- c("first", "second"); rollAll
```

```
       1 2  3 4  5  6
first  8 9  8 7  7 11
second 9 7 12 7 11  4
```

```r

barplot(rollAll, beside=FALSE, legend.text=TRUE, xlab="Result", ylab="N",
        main="Absolute frequency in two samples")
```

![plot of chunk rerDiagCategorical02](content/assets/figure/rerDiagCategorical02.png) 


#### Grouped barplot


```r
barplot(rollAll, beside=TRUE, ylim=c(0, 15), col=c("red", "green"),
        legend.text=TRUE, xlab="Result", ylab="N",
        main="Absolute frequency in two samples")
```

![plot of chunk rerDiagCategorical03](content/assets/figure/rerDiagCategorical03.png) 


Spineplot
-------------------------


```r
N      <- 100
age    <- sample(18:45, N, replace=TRUE)
drinks <- c("beer", "red wine", "white wine")
pref   <- factor(sample(drinks, N, replace=TRUE))
xRange <- round(range(age), -1) + c(-10, 10)
lims   <- c(18, 25, 35, 45)
spineplot(x=age, y=pref, xlab="Age class", ylab="drink", breaks=lims,
          main="Preferred drink by age class")
```

![plot of chunk rerDiagCategorical04](content/assets/figure/rerDiagCategorical04.png) 


Mosaic-plot
-------------------------


```r
ageCls <- cut(age, breaks=lims, labels=LETTERS[1:(length(lims)-1)])
group  <- factor(sample(letters[1:2], N, replace=TRUE))
cTab   <- table(ageCls, pref, group)
mosaicplot(cTab, cex.axis=1)
```

![plot of chunk rerDiagCategorical05](content/assets/figure/rerDiagCategorical05.png) 


Pie-charts
-------------------------

### 2-D pie-chart


```r
dice <- sample(1:6, 100, replace=TRUE)
dTab <- table(dice)
pie(dTab, col=c("blue", "red", "yellow", "pink", "green", "orange"),
    main="Relative frequencies from rolling dice")

dTabFreq <- prop.table(dTab)
textRad  <- 0.5
angles   <- dTabFreq * 2 * pi
csAngles <- cumsum(angles)
csAngles <- csAngles - angles/2
textX    <- textRad * cos(csAngles)
textY    <- textRad * sin(csAngles)
text(x=textX, y=textY, labels=dTabFreq)
```

![plot of chunk rerDiagCategorical06](content/assets/figure/rerDiagCategorical06.png) 


### 3-D pie-chart


```r
library(plotrix)
pie3D(dTab, theta=pi/4, explode=0.1, labels=names(dTab))
```

![plot of chunk rerDiagCategorical07](content/assets/figure/rerDiagCategorical07.png) 


Conditional density plot
-------------------------


```r
N    <- 100
X    <- rnorm(N, 175, 7)
Y    <- 0.5*X + rnorm(N, 0, 6)
Yfac <- cut(Y, breaks=c(-Inf, median(Y), Inf), labels=c("lo", "hi"))
myDf <- data.frame(X, Yfac)
```



```r
cdplot(Yfac ~ X, data=myDf)
```

![plot of chunk rerDiagCategorical08](content/assets/figure/rerDiagCategorical08.png) 


Useful packages
-------------------------

More plot types for categorical data are available in packages [`vcd`](http://cran.r-project.org/package=vcd) and [`vcdExtra`](http://cran.r-project.org/package=vcdExtra).

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:plotrix))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/diagCategorical.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/diagCategorical.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/diagCategorical.R) - [all posts](https://github.com/dwoll/RExRepos/)
