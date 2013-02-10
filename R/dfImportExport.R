
## @knitr 
wants <- c("foreign", "RODBC")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
myVar <- c(4, 19, 22)


## @knitr eval=FALSE
vec     <- scan()
charVec <- scan(what="character")
# not shown


## @knitr eval=FALSE
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
myDf <- edit(myDf)
fix(myDf)
# not shown


## @knitr eval=FALSE
newDf <- edit(data.frame())
# not shown


## @knitr eval=FALSE
sink("d:/daniel/logfile.txt", split=TRUE)
# not shown


## @knitr eval=FALSE
dump("myDf", file="dumpMyDf.txt")
source("dumpMyDf.txt")
# not shown


## @knitr eval=FALSE
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
write.table(myDf, file="data.txt", row.names=FALSE)
# not shown


## @knitr eval=FALSE
readLines(file="data.txt")
# not shown


## @knitr eval=FALSE
read.table(file="data.txt", header=TRUE)
read.table(file="data.txt", header=FALSE)
read.table(file="data.txt", sep="\t")
read.table(file="data.txt", stringsAsFactors=FALSE)
# not shown


## @knitr eval=FALSE
read.table(file=stdin(), header=TRUE)
read.table(file="clipboard", header=TRUE))
read.table(file="http://www.uni-kiel.de/psychologie/dwoll/data.txt", header=TRUE)
# not shown


## @knitr eval=FALSE
myDf <- data.frame(IV=factor(rep(c("A", "B"), 5)), DV=rnorm(10))
save(myDf, file="data.RData")
load("data.RData")
# not shown


## @knitr eval=FALSE
library(foreign)
read.spss(file="data.sav", use.value.labels=TRUE, to.data.frame=FALSE,
          trim.factor.names=FALSE)
# not shown


## @knitr eval=FALSE
write.foreign(df=myDf, datafile="d:/daniel/dataGoesHere.dat",
              codefile="d:/daniel/syntaxGoesHere.sps", package="SPSS")
# not shown


## @knitr eval=FALSE
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


## @knitr 
try(detach(package:foreign))
try(detach(package:RODBC))


