---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Time and date"
categories: [RBasics]
rerCat: R_Basics
tags: [TimeDate]
---




Create and format date values
-------------------------

### Class `Date`


```r
Sys.Date()
```

```
[1] "2013-02-11"
```

```r
(myDate <- as.Date("01.11.1974", format="%d.%m.%Y"))
```

```
[1] "1974-11-01"
```

```r
format(myDate, format="%d.%m.%Y")
```

```
[1] "01.11.1974"
```


### Internal representation


```r
(negDate <- as.Date(-374, "1910-12-16"))
```

```
[1] "1909-12-07"
```

```r
as.numeric(negDate)
```

```
[1] -21940
```


Time values
-------------------------

### Class `POSIXct`


```r
Sys.time()
```

```
[1] "2013-02-11 11:57:12 CET"
```

```r
date()
```

```
[1] "Mon Feb 11 11:57:12 2013"
```



```r
(myTime <- as.POSIXct("2009-02-07 09:23:02"))
```

```
[1] "2009-02-07 09:23:02 CET"
```

```r
ISOdate(2010, 6, 30, 17, 32, 10, tz="CET")
```

```
[1] "2010-06-30 17:32:10 CEST"
```



```r
format(myTime, "%H:%M:%S")
```

```
[1] "09:23:02"
```

```r
format(myTime, "%d.%m.%Y")
```

```
[1] "07.02.2009"
```


### Class `POSIXlt`


```r
charDates <- c("05.08.1972, 03:37", "02.04.1981, 12:44")
(lDates   <- strptime(charDates, format="%d.%m.%Y, %H:%M"))
```

```
[1] "1972-08-05 03:37:00" "1981-04-02 12:44:00"
```



```r
lDates$mday
```

```
[1] 5 2
```

```r
lDates$hour
```

```
[1]  3 12
```



```r
weekdays(lDates)
```

```
[1] "Samstag"    "Donnerstag"
```

```r
months(lDates)
```

```
[1] "August" "April" 
```


Time and date arithmetic
-------------------------

### Sum and difference of time-date values


```r
(myDate <- as.Date("01.11.1974", format="%d.%m.%Y"))
```

```
[1] "1974-11-01"
```

```r
myDate + 365
```

```
[1] "1975-11-01"
```



```r
(diffDate <- as.Date("1976-06-19") - myDate)
```

```
Time difference of 596 days
```

```r
as.numeric(diffDate)
```

```
[1] 596
```

```r
myDate + diffDate
```

```
[1] "1976-06-19"
```



```r
lDates + c(60, 120)
```

```
[1] "1972-08-05 03:38:00 CET"  "1981-04-02 12:46:00 CEST"
```

```r
(diff21 <- lDates[2] - lDates[1])
```

```
Time difference of 3162 days
```

```r
lDates[1] + diff21
```

```
[1] "1981-04-02 12:44:00 CEST"
```


### Systematically and randomly generate time-date values


```r
seq(ISOdate(2010, 5, 1), ISOdate(2013, 5, 1), by="years")
```

```
[1] "2010-05-01 12:00:00 GMT" "2011-05-01 12:00:00 GMT"
[3] "2012-05-01 12:00:00 GMT" "2013-05-01 12:00:00 GMT"
```

```r
seq(ISOdate(1997, 10, 22), by="2 weeks", length.out=4)
```

```
[1] "1997-10-22 12:00:00 GMT" "1997-11-05 12:00:00 GMT"
[3] "1997-11-19 12:00:00 GMT" "1997-12-03 12:00:00 GMT"
```



```r
secsPerDay <- 60 * 60 * 24
randDates  <- ISOdate(1995, 6, 13) + sample(0:(28*secsPerDay), 100, replace=TRUE)
randWeeks  <- cut(randDates, breaks="week")
summary(randWeeks)
```

```
1995-06-12 1995-06-19 1995-06-26 1995-07-03 1995-07-10 
        24         24         22         25          5 
```


Useful packages
-------------------------

Packages [`timeDate`](http://cran.r-project.org/package=timeDate) and [`lubridate`](http://cran.r-project.org/package=lubridate) provide more functions for efficiently and consistently handling times and dates. More packages can be found in CRAN task view [Time Series](http://cran.r-project.org/web/views/TimeSeries.html).

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/timeDate.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/timeDate.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/timeDate.R) - [all posts](https://github.com/dwoll/RExRepos/)
