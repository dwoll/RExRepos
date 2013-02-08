---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Character strings"
categories: [RBasics]
rerCat: R_Basics
tags: [Strings]
---




Create strings from existing objects
-------------------------
    

```r
randVals <- round(rnorm(5), 2)
toString(randVals)
```

```
[1] "0.91, 1, -0.13, -2, -0.74"
```



```r
formatC(c(1, 2.345), width=5, format="f")
```

```
[1] "1.0000" "2.3450"
```


Create new strings and control their output
-------------------------

### Create and format strings


```r
length("ABCDEF")
```

```
[1] 1
```

```r
nchar("ABCDEF")
```

```
[1] 6
```

```r
nchar(c("A", "BC", "DEF"))
```

```
[1] 1 2 3
```



```r
paste("group", LETTERS[1:5], sep="_")
```

```
[1] "group_A" "group_B" "group_C" "group_D" "group_E"
```

```r
paste(1:5, palette()[1:5], sep=": ")
```

```
[1] "1: black"  "2: red"    "3: green3" "4: blue"   "5: cyan"  
```

```r
paste(1:5, letters[1:5], sep=".", collapse=" ")
```

```
[1] "1.a 2.b 3.c 4.d 5.e"
```



```r
N     <- 20
gName <- "A"
mVal  <- 14.2
sprintf("For %d particpants in group %s, the mean was %f", N, gName, mVal)
```

```
[1] "For 20 particpants in group A, the mean was 14.200000"
```

```r
sprintf("%.3f", 1.23456)
```

```
[1] "1.235"
```


### String output with `cat()` and `print()`


```r
cVar <- "A string"
cat(cVar, "with\n", 4, "\nwords\n", sep="+")
```

```
A string+with
+4+
words
```



```r
print(cVar, quote=FALSE)
```

```
[1] A string
```

```r
noquote(cVar)
```

```
[1] A string
```


Manipulate strings
-------------------------


```r
tolower(c("A", "BC", "DEF"))
```

```
[1] "a"   "bc"  "def"
```

```r
toupper(c("ghi", "jk", "i"))
```

```
[1] "GHI" "JK"  "I"  
```



```r
strReverse <- function(x) { sapply(lapply(strsplit(x, NULL), rev), paste, collapse="") }
strReverse(c("Lorem", "ipsum", "dolor", "sit"))
```

```
[1] "meroL" "muspi" "rolod" "tis"  
```



```r
substring(c("ABCDEF", "GHIJK", "LMNO", "PQR"), first=4, last=5)
```

```
[1] "DE" "JK" "O"  ""  
```



```r
strsplit(c("abc_def_ghi", "jkl_mno"), split="_")
```

```
[[1]]
[1] "abc" "def" "ghi"

[[2]]
[1] "jkl" "mno"
```

```r
strsplit("Xylophon", split=NULL)
```

```
[[1]]
[1] "X" "y" "l" "o" "p" "h" "o" "n"
```


Find substrings
-------------------------

### Basic pattern matching


```r
match(c("abc", "de", "f", "h"), c("abcde", "abc", "de", "fg", "ih"))
```

```
[1]  2  3 NA NA
```

```r
pmatch(c("abc", "de", "f", "h"), c("abcde", "abc", "de", "fg", "ih"))
```

```
[1]  2  3  4 NA
```


### Create and use regular expressions

See `?regex`


```r
grep( "A[BC][[:blank:]]", c("AB ", "AB", "AC ", "A "))
```

```
[1] 1 3
```

```r
grepl("A[BC][[:blank:]]", c("AB ", "AB", "AC ", "A "))
```

```
[1]  TRUE FALSE  TRUE FALSE
```



```r
pat    <- "[[:upper:]]+"
txt    <- c("abcDEFG", "ABCdefg", "abcdefg")
(start <- regexpr(pat, txt))
```

```
[1]  4  1 -1
attr(,"match.length")
[1]  4  3 -1
attr(,"useBytes")
[1] TRUE
```



```r
len <- attr(start, "match.length")
end <- start + len - 1
substring(txt, start, end)
```

```
[1] "DEFG" "ABC"  ""    
```



```r
glob2rx("asdf*.txt")
```

```
[1] "^asdf.*\\.txt$"
```


Replace substrings
-------------------------


```r
charVec <- c("ABCDEF", "GHIJK", "LMNO", "PQR")
substring(charVec, 4, 5) <- c("..", "xx", "++", "**"); charVec
```

```
[1] "ABC..F" "GHIxx"  "LMN+"   "PQR"   
```



```r
sub("em", "XX", "Lorem ipsum dolor sit Lorem ipsum")
```

```
[1] "LorXX ipsum dolor sit Lorem ipsum"
```

```r
gsub("em", "XX", "Lorem ipsum dolor sit Lorem ipsum")
```

```
[1] "LorXX ipsum dolor sit LorXX ipsum"
```


Evaluate strings as instructions
-------------------------


```r
obj1 <- parse(text="3 + 4")
obj2 <- parse(text=c("vec <- c(1, 2, 3)", "vec^2"))
eval(obj1)
```

```
[1] 7
```

```r
eval(obj2)
```

```
[1] 1 4 9
```


Useful packages
-------------------------

Package [`stringr`](http://cran.r-project.org/package=stringr) provides more functions for efficiently and consistently handling character strings.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/strings.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/strings.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/strings.R) - [all posts](https://github.com/dwoll/RExRepos/)
