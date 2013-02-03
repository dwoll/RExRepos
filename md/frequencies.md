---
layout: post
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
set.seed(1.234)
(myLetters <- sample(LETTERS[1:5], 12, replace=TRUE))
```

```
 [1] "B" "B" "C" "E" "B" "E" "E" "D" "D" "A" "B" "A"
```

```r
(tab <- table(myLetters))
```

```
myLetters
A B C D E 
2 4 1 2 3 
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
4 
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
0.16667 0.33333 0.08333 0.16667 0.25000 
```



```r
cumsum(relFreq)
```

```
     A      B      C      D      E 
0.1667 0.5000 0.5833 0.7500 1.0000 
```


### Counting non-existent categories


```r
letFac <- factor(myLetters, levels=c(LETTERS[1:5], "Q"))
letFac
```

```
 [1] B B C E B E E D D A B A
Levels: A B C D E Q
```

```r
table(letFac)
```

```
letFac
A B C D E Q 
2 4 1 2 3 0 
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
 [1] m f m f m m f m m f
Levels: f m
```

```r
(work <- factor(sample(c("home", "office"), N, replace=TRUE)))
```

```
 [1] office home   home   home   home   home   office home   home   office
Levels: home office
```

```r
(cTab <- table(sex, work))
```

```
   work
sex home office
  f    2      2
  m    5      1
```



```r
summary(cTab)
```

```
Number of cases in table: 10 
Number of factors: 2 
Test for independence of all factors:
	Chisq = 1.3, df = 1, p-value = 0.3
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
1    m office      2
2    f   home      1
3    m   home      4
4    f   home      4
5    m   home      4
6    m   home      0
7    f office      4
8    m   home      2
9    m   home      4
10   f office      3
```



```r
xtabs(~ sex + work, data=persons)
```

```
   work
sex home office
  f    2      2
  m    5      1
```

```r
xtabs(counts ~ sex + work, data=persons)
```

```
   work
sex home office
  f    5      7
  m   14      2
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
   3.5    1.5 
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
  f     2.0    2.0  2.0
  m     5.0    1.0  3.0
  mean  3.5    1.5  2.5
```


### Relative frequencies


```r
(relFreq <- prop.table(cTab))
```

```
   work
sex home office
  f  0.2    0.2
  m  0.5    0.1
```


### Conditional relative frequencies


```r
prop.table(cTab, 1)
```

```
   work
sex   home office
  f 0.5000 0.5000
  m 0.8333 0.1667
```



```r
prop.table(cTab, 2)
```

```
   work
sex   home office
  f 0.2857 0.6667
  m 0.7143 0.3333
```


### Flat contingency tables for more than two variables


```r
(group <- factor(sample(c("A", "B"), 10, replace=TRUE)))
```

```
 [1] B B B B A A B B A B
Levels: A B
```

```r
ftable(work, sex, group, row.vars="work", col.vars=c("sex", "group"))
```

```
       sex   f   m  
       group A B A B
work                
home         0 2 3 2
office       0 2 0 1
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
2    f   home
3    f office
4    f office
5    m   home
6    m   home
7    m   home
8    m   home
9    m   home
10   m office
```


Group-level data frame


```r
as.data.frame(cTab, stringsAsFactors=TRUE)
```

```
  sex   work Freq
1   f   home    2
2   m   home    5
3   f office    2
4   m office    1
```


Percentile rank
-------------------------


```r
(vec <- round(rnorm(10), 2))
```

```
 [1] -0.16 -1.47 -0.48  0.42  1.36 -0.10  0.39 -0.05 -1.38 -0.41
```

```r
Fn <- ecdf(vec)
Fn(vec)
```

```
 [1] 0.5 0.1 0.3 0.9 1.0 0.6 0.8 0.7 0.2 0.4
```

```r
100 * Fn(0.1)
```

```
[1] 70
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
 [1] -1.47 -1.38 -0.48 -0.41 -0.16 -0.10 -0.05  0.39  0.42  1.36
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
