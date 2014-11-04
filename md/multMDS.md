---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Multidimensional scaling (MDS)"
categories: [Multivariate]
rerCat: Multivariate
tags: [MDS]
---

Multidimensional scaling (MDS)
=========================

Install required packages
-------------------------

[`vegan`](http://cran.r-project.org/package=vegan)


```r
wants <- c("vegan")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

Metric MDS
-------------------------

### Given a distance matrix


```r
cities <- c("Augsburg", "Berlin", "Dresden", "Hamburg", "Hannover",
            "Karlsruhe", "Kiel", "Muenchen", "Rostock", "Stuttgart")
N      <- length(cities)
dstMat <- matrix(numeric(N^2), nrow=N)
##             B   DD   HH    H   KA   KI    M  HRO    S
cityDst <- c(596, 467, 743, 599, 226, 838,  65, 782, 160, ## AUG
                  194, 288, 286, 673, 353, 585, 231, 633, ## B
                       477, 367, 550, 542, 465, 420, 510, ## DD
                            157, 623,  96, 775, 187, 665, ## HH
                                 480, 247, 632, 330, 512, ## H
                                      723, 298, 805,  80, ## KA
                                           872, 206, 752, ## KI
                                                777, 220, ## M
                                                     824) ## HRO

dstMat[upper.tri(dstMat)] <- rev(cityDst)
dstMat <- t(dstMat[ , N:1])[ , N:1]
dstMat[lower.tri(dstMat)] <- t(dstMat)[lower.tri(dstMat)]
dimnames(dstMat) <- list(city=cities, city=cities)
```


```r
(mds <- cmdscale(dstMat, k=2))
```

```
                [,1]       [,2]
Augsburg   399.60802  -70.51443
Berlin    -200.20462 -183.39465
Dresden    -18.47337 -213.01950
Hamburg   -316.39991  130.72245
Hannover  -161.38209  120.21761
Karlsruhe  333.38724  212.12523
Kiel      -409.08703  147.62226
Muenchen   408.55752 -144.46446
Rostock   -401.19605 -126.20651
Stuttgart  365.19030  126.91200
```

### Given object-wise ratings


```r
set.seed(123)
P   <- 3
obj <- matrix(sample(-20:20, N*P, replace=TRUE), ncol=P)
dst <- dist(obj, diag=TRUE, upper=TRUE)
cmdscale(dst, k=2)
# not shown
```

### Plot


```r
xLims <- range(mds[ , 1]) + c(0, 250)
plot(mds, xlim=xLims, xlab="North-South", ylab="East-West", pch=16,
     main="City locations according to MDS")
text(mds[ , 1]+50, mds[ , 2], adj=0, labels=cities)
```

![plot of chunk rerMultMDS01](../content/assets/figure/rerMultMDS01-1.png) 

Non-metric MDS
-------------------------


```r
library(vegan)
(nmMDS <- monoMDS(dstMat, k=2))
```

```

Call:
monoMDS(dist = dstMat, k = 2) 

Non-metric Multidimensional Scaling

10 points, dissimilarity 'unknown'

Dimensions: 2 
Stress:     0.008443353 
Stress type 1, weak ties
Scores scaled to unit root mean square, rotated to principal components
Stopped after 130 iterations: Stress nearly unchanged (ratio > sratmax)
```

```r
scores(nmMDS)
```

```
                 MDS1        MDS2
Augsburg  -1.11072167 -0.08994458
Berlin     0.58049815 -0.50361604
Dresden    0.02006455 -0.74668119
Hamburg    0.85768160  0.32980499
Hannover   0.51135761  0.38091075
Karlsruhe -0.94605107  0.52543389
Kiel       1.09813021  0.38114071
Muenchen  -1.12608597 -0.32982549
Rostock    1.13297156 -0.23682661
Stuttgart -1.01784499  0.28960357
attr(,"pc")
[1] TRUE
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:vegan))
try(detach(package:permute))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/multMDS.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/multMDS.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/multMDS.R) - [all posts](https://github.com/dwoll/RExRepos/)
