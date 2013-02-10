---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Getting help and documentation"
categories: [RBasics]
rerCat: R_Basics
tags: [Help, Documentation]
---

Getting help and documentation
=========================

Install required packages
-------------------------

[`sos`](http://cran.r-project.org/package=sos)


```r
wants <- c("sos")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


R's own help system
-------------------------

### Help system for R functions


```r
help.start()
help(round)
?round
?"/"
# not shown (opens browser window)
```



```r
args(round)
```

```
function (x, digits = 0) 
NULL
```

```r
example(round)
```

```

round> round(.5 + -2:4) # IEEE rounding: -2  0  0  2  2  4  4
[1] -2  0  0  2  2  4  4

round> ( x1 <- seq(-2, 4, by = .5) )
 [1] -2.0 -1.5 -1.0 -0.5  0.0  0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0

round> round(x1) #-- IEEE rounding !
 [1] -2 -2 -1  0  0  0  1  2  2  2  3  4  4

round> x1[trunc(x1) != floor(x1)]
[1] -1.5 -0.5

round> x1[round(x1) != floor(x1 + .5)]
[1] -1.5  0.5  2.5

round> (non.int <- ceiling(x1) != floor(x1))
 [1] FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE
[12]  TRUE FALSE

round> x2 <- pi * 100^(-1:3)

round> round(x2, 3)
[1] 3.100e-02 3.142e+00 3.142e+02 3.142e+04 3.142e+06

round> signif(x2, 3)
[1] 3.14e-02 3.14e+00 3.14e+02 3.14e+04 3.14e+06
```


### Getting help without knowing the function name


```r
help.search("mean")
# not shown (opens browser window)
```



```r
apropos("mean")
```

```
 [1] ".colMeans"       ".rowMeans"       "colMeans"       
 [4] "kmeans"          "mean"            "Mean"           
 [7] "Mean.areg.boot"  "mean.data.frame" "mean.Date"      
[10] "mean.default"    "mean.difftime"   "mean.POSIXct"   
[13] "mean.POSIXlt"    "rowMeans"        "smean.cl.boot"  
[16] "smean.cl.normal" "smean.sd"        "smean.sdl"      
[19] "weighted.mean"   "wtd.mean"       
```



```r
library(sos)                  # for findFn()
findFn("Petal.Length")
# not shown (opens browser window)
```


Online search, mailing lists and Q&A sites
-------------------------

 * [RSeek](http://www.rseek.org/): Search engine for R-related content
 * [R mailing lists](http://tolstoy.newcastle.edu.au/R/): Archive and search (especially R-help, also see the [posting guide](http://www.r-project.org/posting-guide.html))
 * [Stack Overflow: R](http://stackoverflow.com/tags/R) Q&A site - the technical side of using R
 * [CrossValidated: R](http://stats.stackexchange.com/tags/R) Q&A site - the statistical side of using R

Online documentation
-------------------------

### Introductory websites and texts

 * [Quick-R](http://www.statmethods.net/)
 * [Cookbook for R](http://www.cookbook-r.com/)
 * [Longhow Lam: Intro to R](http://www.splusbook.com/RIntro/RCourse.pdf) (pdf)

### Official documentation

 * [R FAQ](http://cran.at.r-project.org/doc/FAQ/R-FAQ.html) (frequently asked questions)
 * [R for Windows FAQ](http://cran.at.r-project.org/bin/windows/base/rw-FAQ.html)
 * [R Installation and Administration](http://cran.at.r-project.org/doc/manuals/R-admin.html)
 * [R Data Import/Export](http://cran.at.r-project.org/doc/manuals/R-data.html)

Books
-------------------------

### Introductory statistics

 * Dalgaard, P. (2008). Introductory Statistics with R (2nd ed.). London, UK: Springer. [URL](http://www.biostat.ku.dk/~pd/ISwR.html)
 * Maindonald, J. & Braun, W. J. (2010). Data Analysis and Graphics Using R: An Example-Based Approach (3rd ed.). Cambridge, UK: Cambridge University Press. [URL](http://maths.anu.edu.au/~johnm/r-book/daagur3.html)
 * Wollschlaeger, D. (2012). Grundlagen der Datenanalyse mit R (2nd ed.). Heidelberg: Springer. [URL](http://www.uni-kiel.de/psychologie/dwoll/r/)
 
### Specialized and advanced statistical topics

 * Chihara, L. & Hesterberg, T. (2011). Mathematical Statistics with Resampling and R. Hoboken, NJ: Wiley. [URL](https://sites.google.com/site/chiharahesterberg/)
 * Everitt, B. S. & Hothorn, T. (2010). A Handbook of Statistical Analysis Using R (2nd ed.). Boca Raton, FL: Chapman & Hall/CRC.
 * Everitt, B. S. & Hothorn, T. (2011). An Introduction to Applied Multivariate Analysis with R. New York, NY: Springer.
 * Fox, J. & Weisberg, S. (2011). An R Companion to Applied Regression (2nd ed.). Thousand Oaks, CA: Sage. [URL](http://socserv.socsci.mcmaster.ca/jfox/Books/Companion/)
 * Harrell, F. (2001). Regression Modeling Strategies. New York, NY: Springer. [URL](http://biostat.mc.vanderbilt.edu/wiki/Main/RmS)
 * Pinheiro, J. C. & Bates, D. M. (2000). Mixed-Effects Models in S and S-PLUS. New York, NY: Springer.
 * Shumway, R. H. & Stoffer, D. S. (2011). Time Series Analysis and Its Applications (3rd ed.). New York, NY: Springer. [URL](http://www.stat.pitt.edu/stoffer/tsa3/)
 * Venables, W. N. & Ripley, B. D. (2002). Modern Applied Statistics with S (4th ed.). New York, NY: Springer. [URL](http://www.stats.ox.ac.uk/pub/MASS4/)

### Diagrams

 * Murrell, P. (2011). R Graphics (2nd ed.). Boca Raton, FL: Chapman & Hall/CRC. [URL](http://www.stat.auckland.ac.nz/~paul/RG2e/)
 * Sarkar, D. (2008). Lattice: Multivariate Data Visualization with R. New York, NY: Springer. [URL](http://lmdvr.r-forge.r-project.org/)
 * Wickham, H. (2009). ggplot2: Elegant Graphics for Data Analysis. New York, NY: Springer. [URL](http://had.co.nz/ggplot2/book/)

### Programming with R

 * Chambers, J. M. (2008). Software for Data Analysis: Programming with R. New York, NY: Springer. [URL](http://stat.stanford.edu/~jmc4/Rbook/)
 * [Hadley Wickham: devtools wiki](https://github.com/hadley/devtools/wiki)
 
### Transition from other statistical software packages

 * Muenchen, R. A. (2011). R for SAS and SPSS Users (2nd ed.). New York, NY: Springer. [URL](http://r4stats.com/)
 * Muenchen, R. A. & Hilbe, J. M. (2010). R for Stata Users. New York, NY: Springer. [URL](http://r4stats.com/)


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:sos))
try(detach(package:brew))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/helpDocs.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/helpDocs.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/helpDocs.R) - [all posts](https://github.com/dwoll/RExRepos/)
