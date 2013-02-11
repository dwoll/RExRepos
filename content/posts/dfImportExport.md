---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Data import and export"
categories: [DataFrames]
rerCat: Data_Frames
tags: [DataFrames]
---




Install required packages
-------------------------

[`foreign`](http://cran.r-project.org/package=foreign), [`RODBC`](http://cran.r-project.org/package=RODBC)


```r
wants <- c("foreign", "RODBC")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Use R for data entry
-------------------------

### Input data with the keyboard


```r
myVar <- c(4, 19, 22)
```


Read data from the console with `scan()`. Lines are terminated by hitting the `Return` key, `scan()` quits when `Return` is hit on a blank line.


```r
vec     <- scan()
charVec <- scan(what="character")
# not shown
```


### R's own graphical data editor


```r
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
myDf <- edit(myDf)
fix(myDf)
# not shown
```


Create an empty data frame


```r
newDf <- edit(data.frame())
# not shown
```


Save R data to file
-------------------------

### Create a log-file for commands and output


```r
sink("d:/daniel/logfile.txt", split=TRUE)
# not shown
```


### Save and read R objects in text format


```r
dump("myDf", file="dumpMyDf.txt")
source("dumpMyDf.txt")
# not shown
```


### Save data frame to a text file


```r
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
write.table(myDf, file="data.txt", row.names=FALSE)
# not shown
```


Read in data in text format
-------------------------

### Read text data from a local file

If reading from a file, check with `getwd()` that you are in the correct directory - or specify full file path.

To read a raw text file, use `readLines()`. The result is a character vector with one element per line.


```r
readLines(file="data.txt")
# not shown
```


If the result should be a data frame, use `read.table()`.


```r
read.table(file="data.txt", header=TRUE)
read.table(file="data.txt", header=FALSE)
read.table(file="data.txt", sep="\t")
read.table(file="data.txt", stringsAsFactors=FALSE)
# not shown
```


To read comma-separated-value files, use `read.csv()`, for fixed-with-files `read.fwf()`.

### Read text data from other sources

The described R functions can also read data from standard-input (if R is used in batch mode via `Rscript.exe`), from the clipboard, or directly from an online source.


```r
read.table(file=stdin(), header=TRUE)
read.table(file="clipboard", header=TRUE))
read.table(file="http://www.uni-kiel.de/psychologie/dwoll/data.txt", header=TRUE)
# not shown
```


Read and write data in R binary format
-------------------------


```r
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
save(myDf, file="data.RData")
load("data.RData")
# not shown
```


Exchange data with other statistics software and spreadsheets
-------------------------

### Exchange data with SPSS, SAS and Stata

One option is to use text files (tab-separated or comma-separated) to exchange data with other statistics software packages.

Another option to exchange data with SPSS, SAS and Stata is the `foreign` package.


```r
library(foreign)
read.spss(file="data.sav", use.value.labels=TRUE, to.data.frame=FALSE,
          trim.factor.names=FALSE)
# not shown
```



```r
write.foreign(df=myDf, datafile="d:/daniel/dataGoesHere.dat",
              codefile="d:/daniel/syntaxGoesHere.sps", package="SPSS")
# not shown
```


To read these files with SPSS, you may have to modify the created `.sps` syntax file: First write down the full path to the data file in the first line because SPSS' current working directory is probably not where that file is located. You may also have to make SPSS recognize the `.` as a decimal point if it's a german SPSS installation.

```
SET LOCALE='English'.
```

To set SPSS back to using a `,` as a decimal point:

```
SET LOCALE='German'.
```

Exchanging data with SAS and Stata works the same way.

### Use SPSS essentials for R

If you have SPSS available, install the "Essentials for R" add-in ([instructions pdf](ftp://public.dhe.ibm.com/software/analytics/spss/documentation/statistics/21.0/en/rplugin/InstallationDocuments/Windows/Essentials_for_R_Installation_Instructions.pdf)). This allows you to run R within SPSS. The add-in includes an R package with functions that transfer the active SPSS data frame to R (and back) - including labeled factor levels, dates and German umlauts. Once installed, you can use it like this in the SPSS syntax window:

```
BEGIN PROGRAM R.
# from here on, you can use R syntax
myDf <- spssdata.GetDataFromSPSS(missingValueToNA=TRUE,
                                 factorMode="labels",
                                 rDate="POSIXct")
save(myDf, file="d:/path/to/your/myDf.Rdata")
END PROGRAM.
```

### Exchange data with Excel

One option is to use text files (tab-separated or comma-separated) to exchange data with spreadsheet applications.

To read and write Excel files directly, use package [`XLConnect`](http://cran.r-project.org/package=XLConnect).

Read and write data from a database
-------------------------

Excel files can also be treated as a database with the `RODBC` package. One can then use standard SQL commands like `query` and `fetch` to select data.


```r
library(RODBC)
xlsCon <- odbcConnectExcel2007("data.xls", readOnly=FALSE)
odbcGetInfo(xlsCon)
sqlTables(xlsCon)
(myDfXls <- sqlFetch(xlsCon, "sheet1"))
sqlQuery(xlsCon, "select IV, DV from [sheet1$] order by IV")
sqlQuery(xlsCon, "select * from [sheet1$] where IV = 'A' AND DV < 10")
myDfXls$newDV <- rnorm(nrow(myDfXls))
sqlSave(xlsCon, myDfXls, tablename="newSheet")
odbcClose(xlsCon)
# not shown
```


There are R packages that provide an interface to all common database types, e.g. to [MySQL](http://cran.r-project.org/package=RMySQL), [Oracle](http://cran.r-project.org/package=ROracle) or [SQLite](http://cran.r-project.org/package=RSQLite).

Useful documents
-------------------------

 * [R Data Import/Export](http://cran.at.r-project.org/doc/manuals/R-data.html)
 * Muenchen, R. A. (2011). R for SAS and SPSS Users (2nd ed.). New York, NY: Springer. [URL](http://r4stats.com/)
 * Muenchen, R. A. & Hilbe, J. M. (2010). R for Stata Users. New York, NY: Springer. [URL](http://r4stats.com/)

Useful packages
-------------------------

Scrape HTML pages directly with [`XML`](http://cran.r-project.org/package=XML) (e.g., `readHTMLTable()`).

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:foreign))
try(detach(package:RODBC))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dfImportExport.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dfImportExport.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dfImportExport.R) - [all posts](https://github.com/dwoll/RExRepos/)
