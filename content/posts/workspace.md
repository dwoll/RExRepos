---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Exploring the workspace"
categories: [RBasics]
rerCat: R_Basics
tags: [Workspace, Environment]
---




The working directory
-------------------------


```r
getwd()
```

```
[1] "D:/daniel_work/workspace/RExRepos/tmp"
```



```r
setwd("d:/daniel/work/r/")
```


Create and remove objects
-------------------------

Create some objects


```r
Aval <- 7
Bval <- 15
Cval <- 10
ls()
```

```
 [1] "Aval"        "Bval"        "Cval"        "dirMd"       "dirR"       
 [6] "dirTmp"      "fIn"         "fName"       "fOut"        "markdEngine"
[11] "siteGen"    
```


List available objects


```r
ls(pattern="C")
```

```
[1] "Cval"
```

```r
exists("Bval")
```

```
[1] TRUE
```

```r
exists("doesNotExist")
```

```
[1] FALSE
```


Remove objects


```r
Aval
```

```
[1] 7
```

```r
rm(Aval)
Aval                             # this will give an error
```

```
Error: Objekt 'Aval' nicht gefunden
```

```r
## rm(list=ls(all.names=TRUE))   # remove all objects from the workspace
```


Show and rename objects
-------------------------

### Show objects


```r
Bval
```

```
[1] 15
```

```r
print(Bval)
```

```
[1] 15
```

```r
(Bval <- 4.5)
```

```
[1] 4.5
```

```r
.Last.value
```

```
[1] "nanoc"
```



```r
get("Bval")
```

```
[1] 4.5
```

```r
varName <- "Bval"
get(varName)
```

```
[1] 4.5
```


### Rename objects


```r
ls()
```

```
 [1] "Bval"        "Cval"        "dirMd"       "dirR"        "dirTmp"     
 [6] "fIn"         "fName"       "fOut"        "markdEngine" "siteGen"    
[11] "varName"    
```

```r
newNameVar <- "varNew"
assign(newNameVar, Bval)
varNew
```

```
[1] 4.5
```


Environments and search path
-------------------------


```r
search()
```

```
 [1] ".GlobalEnv"        "package:stringr"   "package:knitr"    
 [4] "package:grDevices" "package:datasets"  "package:svSocket" 
 [7] "package:TinnR"     "package:R2HTML"    "package:Hmisc"    
[10] "package:survival"  "package:splines"   "package:graphics" 
[13] "package:stats"     "package:methods"   "package:tcltk"    
[16] "package:utils"     "SciViews:TempEnv"  "Autoloads"        
[19] "package:base"     
```


[How R Searches and Finds Stuff](http://obeautifulcode.com/R/How-R-Searches-And-Finds-Stuff/)

Session history
-------------------------

By default, `savehistory()` saves the command history to the file `.Rhistory` in the current working directory.


```r
history()
savehistory("d:/daniel/work/r/history.r")
```


By default, `save.image()` saves all objects in the workspace to the file `.RData` in the current working directory.


```r
save.image("d:/daniel/work/r/objects.Rdata")
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/workspace.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/workspace.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/workspace.R) - [all posts](https://github.com/dwoll/RExRepos/)
