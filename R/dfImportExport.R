
## ------------------------------------------------------------------------
wants <- c("foreign", "RODBC", "RSQLite")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
myVar <- c(4, 19, 22)


## ----eval=FALSE----------------------------------------------------------
vec     <- scan()
charVec <- scan(what="character")
# not shown


## ----eval=FALSE----------------------------------------------------------
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
myDf <- edit(myDf)
fix(myDf)
# not shown


## ----eval=FALSE----------------------------------------------------------
newDf <- edit(data.frame())
# not shown


## ----eval=FALSE----------------------------------------------------------
sink("d:/daniel/logfile.txt", split=TRUE)
# not shown


## ----eval=FALSE----------------------------------------------------------
dump("myDf", file="dumpMyDf.txt")
source("dumpMyDf.txt")
# not shown


## ----eval=FALSE----------------------------------------------------------
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
write.table(myDf, file="data.txt", row.names=FALSE)
# not shown


## ----eval=FALSE----------------------------------------------------------
readLines(file="data.txt")
# not shown


## ----eval=FALSE----------------------------------------------------------
read.table(file="data.txt", header=TRUE)
read.table(file="data.txt", header=FALSE)
read.table(file="data.txt", sep="\t")
read.table(file="data.txt", stringsAsFactors=FALSE)
# not shown


## ----eval=FALSE----------------------------------------------------------
read.table(file=stdin(), header=TRUE)
read.table(file="clipboard", header=TRUE))
read.table(file="http://www.uni-kiel.de/psychologie/dwoll/data.txt", header=TRUE)
# not shown


## ----eval=FALSE----------------------------------------------------------
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
save(myDf, file="data.RData")
load("data.RData")
# not shown


## ----eval=FALSE----------------------------------------------------------
library(foreign)
read.spss(file="data.sav", use.value.labels=TRUE, to.data.frame=FALSE,
          trim.factor.names=FALSE)
# not shown


## ----eval=FALSE----------------------------------------------------------
write.foreign(df=myDf, datafile="d:/daniel/dataGoesHere.dat",
              codefile="d:/daniel/syntaxGoesHere.sps", package="SPSS")
# not shown


## ----eval=FALSE----------------------------------------------------------
# data.xls is the registered DSN
library(RODBC)
xlsCon <- odbcConnectExcel2007("data.xls", readOnly=FALSE)
odbcGetInfo(xlsCon)
sqlTables(xlsCon)
(myDfXls <- sqlFetch(xlsCon, "sheet1"))
sqlQuery(xlsCon, "SELECT IV, DV FROM [sheet1$] ORDER BY IV")
sqlQuery(xlsCon, "SELECT * FROM [sheet1$] where (IV = 'A') AND (DV < 10)")
myDfXls$newDV <- rnorm(nrow(myDfXls))
sqlSave(xlsCon, myDfXls, tablename="newSheet")
odbcClose(xlsCon)
# not shown


## ------------------------------------------------------------------------
IQ     <- rnorm(2*10, mean=100, sd=15)
rating <- sample(LETTERS[1:3], 2*50, replace=TRUE)
sex    <- factor(rep(c("f", "m"), times=50))
myDf   <- data.frame(sex, IQ, rating, stringsAsFactors=FALSE)


## ------------------------------------------------------------------------
library("RSQLite")
drv <- dbDriver("SQLite")
con <- dbConnect(drv, dbname=":memory:")
dbWriteTable(con, name="MyDataFrame", value=myDf, row.names=FALSE)


## ------------------------------------------------------------------------
dbListTables(con)
dbListFields(con, "MyDataFrame")


## ------------------------------------------------------------------------
out <- dbReadTable(con, "MyDataFrame")
head(out, n=4)
dbGetQuery(con, "SELECT sex, AVG(IQ) AS mIQ, SUM(IQ) AS sIQ FROM MyDataFrame GROUP BY sex")


## ------------------------------------------------------------------------
res <- dbSendQuery(con, "SELECT IQ, rating FROM MyDataFrame WHERE rating = 'A'")

while(!dbHasCompleted(res)) {
  partial <- dbFetch(res, n=4)
  print(partial)
}


## ------------------------------------------------------------------------
dbClearResult(res)
dbRemoveTable(con, "MyDataFrame")
dbDisconnect(con)


## ----eval=FALSE----------------------------------------------------------
try(detach(package:foreign))
try(detach(package:RODBC))
try(detach(package:RSQLite))
try(detach(package:DBI))

