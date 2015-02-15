## ------------------------------------------------------------------------
getwd()

## ----eval=FALSE----------------------------------------------------------
setwd("d:/daniel/work/r/")

## ------------------------------------------------------------------------
Aval <- 7
Bval <- 15
Cval <- 10
ls()

## ------------------------------------------------------------------------
# objects in .GlobalEnv workspace that have a capital C in their name
ls(".GlobalEnv", pattern="C")
exists("Bval")
exists("doesNotExist")

## ------------------------------------------------------------------------
Aval
rm(Aval)
Aval                             # this will give an error
## rm(list=ls(all.names=TRUE))   # remove all objects from the workspace

## ------------------------------------------------------------------------
Bval
print(Bval)
(Bval <- 4.5)
.Last.value

## ------------------------------------------------------------------------
get("Bval")
varName <- "Bval"
get(varName)

## ------------------------------------------------------------------------
ls()
newNameVar <- "varNew"
assign(newNameVar, Bval)
varNew

## ------------------------------------------------------------------------
search()

## ----eval=FALSE----------------------------------------------------------
history()
savehistory("d:/daniel/work/r/history.r")

## ----eval=FALSE----------------------------------------------------------
save.image("d:/daniel/work/r/objects.Rdata")

