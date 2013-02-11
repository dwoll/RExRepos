---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Frequency tables"
categories: [Descriptive]
rerCat: Descriptive
tags: [Descriptive]
---




Install required packages
-------------------------

[`epitools`](http://cran.r-project.org/package=epitools)


```r
wants <- c("epitools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Category frequencies for one variable
-------------------------

### Absolute frequencies


```r
set.seed(123)
(myLetters <- sample(LETTERS[1:5], 12, replace=TRUE))
```

```
 [1] "B" "D" "C" "E" "E" "A" "C" "E" "C" "C" "E" "C"
```

```r
(tab <- table(myLetters))
```

```
myLetters
A B C D E 
1 1 5 1 4 
```

```r
names(tab)
```

```
[1] "A" "B" "C" "D" "E"
```

```r
tab["B"]
```

```
B 
1 
```



```r
barplot(tab, main="Counts")
```

![plot of chunk rerFrequencies01](../content/assets/figure/rerFrequencies01.png) 


### (Cumulative) relative frequencies


```r
(relFreq <- prop.table(tab))
```

```
myLetters
      A       B       C       D       E 
0.08333 0.08333 0.41667 0.08333 0.33333 
```



```r
cumsum(relFreq)
```

```
      A       B       C       D       E 
0.08333 0.16667 0.58333 0.66667 1.00000 
```


### Counting non-existent categories


```r
letFac <- factor(myLetters, levels=c(LETTERS[1:5], "Q"))
letFac
```

```
 [1] B D C E E A C E C C E C
Levels: A B C D E Q
```

```r
table(letFac)
```

```
letFac
A B C D E Q 
1 1 5 1 4 0 
```


Counting runs
-------------------------


```r
(vec <- rep(rep(c("f", "m"), 3), c(1, 3, 2, 4, 1, 2)))
```

```
 [1] "f" "m" "m" "m" "f" "f" "m" "m" "m" "m" "f" "m" "m"
```



```r
(res <- rle(vec))
```

```
Run Length Encoding
  lengths: int [1:6] 1 3 2 4 1 2
  values : chr [1:6] "f" "m" "f" "m" "f" "m"
```



```r
length(res$lengths)
```

```
[1] 6
```



```r
inverse.rle(res)
```

```
 [1] "f" "m" "m" "m" "f" "f" "m" "m" "m" "m" "f" "m" "m"
```


Contingency tables for two or more variables
-------------------------

### Absolute frequencies using `table()`


```r
N    <- 10
(sex <- factor(sample(c("f", "m"), N, replace=TRUE)))
```

```
 [1] m m f m f f f m m m
Levels: f m
```

```r
(work <- factor(sample(c("home", "office"), N, replace=TRUE)))
```

```
 [1] office office office office office office home   home   office office
Levels: home office
```

```r
(cTab <- table(sex, work))
```

```
   work
sex home office
  f    1      3
  m    1      5
```



```r
summary(cTab)
```

```
Number of cases in table: 10 
Number of factors: 2 
Test for independence of all factors:
	Chisq = 0.1, df = 1, p-value = 0.7
	Chi-squared approximation may be incorrect
```



```r
barplot(cTab, beside=TRUE, legend.text=rownames(cTab), ylab="absolute frequency")
```

![plot of chunk rerFrequencies02](../content/assets/figure/rerFrequencies02.png) 


### Using `xtabs()`


```r
counts   <- sample(0:5, N, replace=TRUE)
(persons <- data.frame(sex, work, counts))
```

```
   sex   work counts
1    m office      4
2    m office      4
3    f office      0
4    m office      2
5    f office      4
6    f office      1
7    f   home      1
8    m   home      1
9    m office      0
10   m office      2
```



```r
xtabs(~ sex + work, data=persons)
```

```
   work
sex home office
  f    1      3
  m    1      5
```

```r
xtabs(counts ~ sex + work, data=persons)
```

```
   work
sex home office
  f    1      5
  m    1     12
```


### Marginal sums and means


```r
apply(cTab, MARGIN=1, FUN=sum)
```

```
f m 
4 6 
```

```r
colMeans(cTab)
```

```
  home office 
     1      4 
```

```r
addmargins(cTab, c(1, 2), FUN=mean)
```

```
Margins computed over dimensions
in the following order:
1: sex
2: work
```

```
      work
sex    home office mean
  f     1.0    3.0  2.0
  m     1.0    5.0  3.0
  mean  1.0    4.0  2.5
```


### Relative frequencies


```r
(relFreq <- prop.table(cTab))
```

```
   work
sex home office
  f  0.1    0.3
  m  0.1    0.5
```


### Conditional relative frequencies


```r
prop.table(cTab, 1)
```

```
   work
sex   home office
  f 0.2500 0.7500
  m 0.1667 0.8333
```



```r
prop.table(cTab, 2)
```

```
   work
sex  home office
  f 0.500  0.375
  m 0.500  0.625
```


### Flat contingency tables for more than two variables


```r
(group <- factor(sample(c("A", "B"), 10, replace=TRUE)))
```

```
 [1] A A A A A A A B A A
Levels: A B
```

```r
ftable(work, sex, group, row.vars="work", col.vars=c("sex", "group"))
```

```
       sex   f   m  
       group A B A B
work                
home         1 0 0 1
office       3 0 5 0
```


Recovering the original data from contingency tables
-------------------------

Individual-level data frame


```r
library(epitools)
expand.table(cTab)
```

```
   sex   work
1    f   home
2    f office
3    f office
4    f office
5    m   home
6    m office
7    m office
8    m office
9    m office
10   m office
```


Group-level data frame


```r
as.data.frame(cTab, stringsAsFactors=TRUE)
```

```
  sex   work Freq
1   f   home    1
2   m   home    1
3   f office    3
4   m office    5
```


Percentile rank
-------------------------


```r
(vec <- round(rnorm(10), 2))
```

```
 [1]  0.84  0.15 -1.14  1.25  0.43 -0.30  0.90  0.88  0.82  0.69
```

```r
Fn <- ecdf(vec)
Fn(vec)
```

```
 [1] 0.7 0.3 0.1 1.0 0.4 0.2 0.9 0.8 0.6 0.5
```

```r
100 * Fn(0.1)
```

```
[1] 20
```

```r
Fn(sort(vec))
```

```
 [1] 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0
```

```r
knots(Fn)
```

```
 [1] -1.14 -0.30  0.15  0.43  0.69  0.82  0.84  0.88  0.90  1.25
```



```r
plot(Fn, main="cumulative frequencies")
```

![plot of chunk rerFrequencies03](../content/assets/figure/rerFrequencies03.png) 


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:epitools))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/frequencies.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/frequencies.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/frequencies.R) - [all posts](https://github.com/dwoll/RExRepos/)
