
## @knitr 
Sys.Date()
(myDate <- as.Date("01.11.1974", format="%d.%m.%Y"))
format(myDate, format="%d.%m.%Y")


## @knitr 
(negDate <- as.Date(-374, "1910-12-16"))
as.numeric(negDate)


## @knitr 
Sys.time()
date()


## @knitr 
(myTime <- as.POSIXct("2009-02-07 09:23:02"))
ISOdate(2010, 6, 30, 17, 32, 10, tz="CET")


## @knitr 
format(myTime, "%H:%M:%S")
format(myTime, "%d.%m.%Y")


## @knitr 
charDates <- c("05.08.1972, 03:37", "02.04.1981, 12:44")
(lDates   <- strptime(charDates, format="%d.%m.%Y, %H:%M"))


## @knitr 
lDates$mday
lDates$hour


## @knitr 
weekdays(lDates)
months(lDates)


## @knitr 
(myDate <- as.Date("01.11.1974", format="%d.%m.%Y"))
myDate + 365


## @knitr 
(diffDate <- as.Date("1976-06-19") - myDate)
as.numeric(diffDate)
myDate + diffDate


## @knitr 
lDates + c(60, 120)
(diff21 <- lDates[2] - lDates[1])
lDates[1] + diff21


## @knitr 
seq(ISOdate(2010, 5, 1), ISOdate(2013, 5, 1), by="years")
seq(ISOdate(1997, 10, 22), by="2 weeks", length.out=4)


## @knitr 
secsPerDay <- 60 * 60 * 24
randDates  <- ISOdate(1995, 6, 13) + sample(0:(28*secsPerDay), 100, replace=TRUE)
randWeeks  <- cut(randDates, breaks="week")
summary(randWeeks)


