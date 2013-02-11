---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Scatter plots and line diagrams"
categories: [Diagrams, BasicDiagrams]
rerCat: Diagrams
tags: [Diagrams]
---

Scatter plots and line diagrams
=========================

TODO
-------------------------

 - link to diagAddElements, diagFormat (-> transparency), diagDistributions for `hexbin()` and `smoothScatter()`

Scatter plot
-------------------------

### Simple scatter plot
    

```r
set.seed(123)
N <- 100
x <- rnorm(N, 100, 15)
y <- 0.3*x + rnorm(N, 0, 5)
plot(x, y)
```

![plot of chunk rerDiagScatter01](../content/assets/figure/rerDiagScatter01.png) 



```r
plot(x, y, main="Customized scatter plot", xlim=c(50, 150), ylim=c(10, 50),
     xlab="x axis", ylab="y axis", pch=16, col="darkgray")
```

![plot of chunk rerDiagScatter02](../content/assets/figure/rerDiagScatter02.png) 



```r
plot(y, main="Univeriate scatter plot", ylim=c(10, 50),
     xlab="Index", ylab="y axis", pch=4, lwd=2, col="blue")
```

![plot of chunk rerDiagScatter03](../content/assets/figure/rerDiagScatter03.png) 


### Options for specifying $(x, y)$-coordinate pairs


```r
xy <- cbind(x, y)
plot(xy)
plot(y ~ x)
# not shown
```


### Jittering points

Useful if one variable can take on only a few values, and one plot symbol represents many observations.


```r
z <- sample(0:5, N, replace=TRUE)
plot(z ~ x, pch=1, col="red", cex=1.5, main="Scatter plot")
```

![plot of chunk rerDiagScatter04](../content/assets/figure/rerDiagScatter041.png) 

```r
plot(jitter(z) ~ x, pch=1, col="red", cex=1.5,
     main="Scatter plot with jittered y-coordinate")
```

![plot of chunk rerDiagScatter04](../content/assets/figure/rerDiagScatter042.png) 


### Plot types available with `plot()`


```r
vec <- rnorm(10)
plot(vec, type="p", xlab=NA, main="type p", cex=1.5)
```

![plot of chunk rerDiagScatter05](../content/assets/figure/rerDiagScatter051.png) 

```r
plot(vec, type="l", xlab=NA, main="type l", cex=1.5)
```

![plot of chunk rerDiagScatter05](../content/assets/figure/rerDiagScatter052.png) 

```r
plot(vec, type="b", xlab=NA, main="type b", cex=1.5)
```

![plot of chunk rerDiagScatter05](../content/assets/figure/rerDiagScatter053.png) 

```r
plot(vec, type="o", xlab=NA, main="type o", cex=1.5)
```

![plot of chunk rerDiagScatter05](../content/assets/figure/rerDiagScatter054.png) 

```r
plot(vec, type="s", xlab=NA, main="type s", cex=1.5)
```

![plot of chunk rerDiagScatter05](../content/assets/figure/rerDiagScatter055.png) 

```r
plot(vec, type="h", xlab=NA, main="type h", cex=1.5)
```

![plot of chunk rerDiagScatter05](../content/assets/figure/rerDiagScatter056.png) 


Simultaneously plot several variable pairs
-------------------------


```r
vec <- seq(from=-2*pi, to=2*pi, length.out=50)
mat <- cbind(2*sin(vec), sin(vec-(pi/4)), 0.5*sin(vec-(pi/2)))
matplot(vec, mat, type="b", xlab=NA, ylab=NA, pch=1:3, main="Sine-curves")
```

![plot of chunk rerDiagScatter06](../content/assets/figure/rerDiagScatter06.png) 


Identify observations from plot points
-------------------------


```r
plot(vec)
identify(vec)
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/diagScatter.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/diagScatter.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/diagScatter.R) - [all posts](https://github.com/dwoll/RExRepos/)
