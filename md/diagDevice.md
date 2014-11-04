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


```r
pdf("pdf_test.pdf")
plot(1:10, rnorm(10))
dev.off()
```


```r
plot(1:10, rnorm(10))
dev.copy(jpeg, filename="copied.jpg", quality=90)
graphics.off()
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/diagDevice.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/diagDevice.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/diagDevice.R) - [all posts](https://github.com/dwoll/RExRepos/)
