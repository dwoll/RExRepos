---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Data import and export"
categories: [DataFrames]
rerCat: Data_Frames
tags: [DataFrames]
---

Data import and export
=========================

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

### Create a logfile for commands and output


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

One option is to use text files (tab-separated or comma-separated) as described above to exchange data with other statistics software packages.

Another option to exchange data with SPSS, SAS and Stata (among others) is the `foreign` package. Example for SPSS:


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

Exchanging data with SAS and Stata works the same way: Package `foreign` provides functions `read.xport()` for reading files in SAS XPORT format, `read.dta()` and `write.dta()` read and write Stata files, respectively.

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

One option is to use text files (tab-separated or comma-separated) as described above to exchange data with spreadsheet applications.

To read and write Excel files directly, use package [`XLConnect`](http://cran.r-project.org/package=XLConnect).

Read and write data from a database
-------------------------

There are R packages that provide an interface to all common database types. Using databases is described in more detail in:

 * Adler, J. (2012). R in a Nutshell (2nd ed.). Sebastopol, CA: O'Reilly.
 * Spector, P. (2008). Data Manipulation with R. New York, NY: Springer.

### Using the ODBC interface with `RODBC`

Excel files can also be treated as a database with the `RODBC` package. First, you have to [register a data source name (DSN)](http://www.stata.com/support/faqs/data-management/configuring-odbc-win/) for the file under your operating system. One can then use standard SQL commands like `SELECT` to select data.


```r
# data.xls is the registered DSN
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

### Using the DBI interface with `RSQLite`

Simulate data first.


```r
IQ     <- rnorm(2*50, mean=100, sd=15)
rating <- sample(LETTERS[1:3], 2*50, replace=TRUE)
sex    <- factor(rep(c("f", "m"), times=50))
myDf   <- data.frame(sex, IQ, rating, stringsAsFactors=FALSE)
```

Save data frame in SQLite database (= a file).


```r
library("RSQLite")
drv <- dbDriver("SQLite")
con <- dbConnect(drv, "myDf.db")
dbWriteTable(con, name="MyDataFrame", value=myDf, row.names=FALSE)
dbListTables(con)
dbListFields(con, "MyDataFrame")
out <- dbReadTable(con, "MyDataFrame")
head(out, n=4)
dbGetQuery(con, "SELECT sex, AVG(IQ) AS mIQ, SUM(IQ) as sIQ FROM MyDataFrame GROUP BY sex")
res <- dbSendQuery(con, "SELECT IQ, rating FROM MyDataFrame WHERE rating = 'A'")

while(!dbHasCompleted(res)) {
  partial <- dbFetch(res, n=3)
  print(partial)
}

dbClearResult(res)
dbRemoveTable(con, "MyDataFrame")
dbDisconnect(con)
# not shown
```

Useful documents
-------------------------

 * [R Data Import/Export](http://cran.at.r-project.org/doc/manuals/R-data.html)
 * Muenchen, R. A. (2011). R for SAS and SPSS Users (2nd ed.). New York, NY: Springer. [URL](http://r4stats.com/)
 * Muenchen, R. A. & Hilbe, J. M. (2010). R for Stata Users. New York, NY: Springer. [URL](http://r4stats.com/)

Useful packages
-------------------------

The [CRAN Web Technologies Task View](http://CRAN.R-project.org/view=WebTechnologies) presents packages to directly scrape data from online sources. [`data.table`](http://cran.r-project.org/package=data.table) provides function `fread()` for high performance reading of large plain text data files.

Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:foreign))
try(detach(package:RODBC))
try(detach(package:RSQLite))
try(detach(package:DBI))
```

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/dfImportExport.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/dfImportExport.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/dfImportExport.R) - [all posts](https://github.com/dwoll/RExRepos/)
