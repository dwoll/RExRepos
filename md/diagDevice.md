---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Graphics devices: Opening and saving diagrams"
categories: [Diagrams, BasicDiagrams]
rerCat: Diagrams
tags: [Diagrams]
---

Graphics devices: Opening and saving diagrams
=========================

TODO
-------------------------

 - add regions and margins
 - more device types and options
 - pdf: multiple pages

Install required packages
-------------------------

[`Cairo`](http://cran.r-project.org/package=Cairo)


```r
wants <- c("Cairo")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```

```

The downloaded source packages are in
	'/tmp/RtmpK08rp1/downloaded_packages'
```

Opening and closing a device
-------------------------


```r
dev.new(); dev.new(); dev.new()
dev.list()
```

```
pdf pdf pdf pdf 
  2   3   4   5 
```

```r
dev.cur()
```

```
pdf 
  5 
```

```r
dev.set(3)
```

```
pdf 
  3 
```

```r
dev.set(dev.next())
```

```
pdf 
  4 
```

```r
dev.off()
```

```
pdf 
  5 
```

```r
graphics.off()
```

Saving plots to a graphics file
-------------------------

### Regular R device

`pdf()`, `png()` and `jpeg()` are functions that open a graphics file of the corresponding type. See `?device` for more.


```r
pdf("pdf_test.pdf", width=5, height=5)
plot(1:10, rnorm(10))
dev.off()
```


```r
plot(1:10, rnorm(10))
dev.copy(jpeg, filename="copied.jpg", quality=90)
graphics.off()
```

### Device from package `Cairo`

`Cairo()` has a `dpi` option for choosing the graphics resolution in the output file. Option `type` chooses the type of the graphics file.


```r
library(Cairo)
Cairo(width=5, height=5, units="in", file="Cairo_pdf.pdf", type="pdf",
      bg="white", canvas="white", dpi=120)
plot(1:10, rnorm(10))
dev.off()
```

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:Cairo))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/diagDevice.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/diagDevice.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/diagDevice.R) - [all posts](https://github.com/dwoll/RExRepos/)
