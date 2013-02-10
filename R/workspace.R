
## @knitr 
getwd()


## @knitr eval=FALSE
setwd("d:/daniel/work/r/")


## @knitr 
Aval <- 7
Bval <- 15
Cval <- 10
ls()


## @knitr 
ls(pattern="C")
exists("Bval")
exists("doesNotExist")


## @knitr 
Aval
rm(Aval)
Aval                             # this will give an error
## rm(list=ls(all.names=TRUE))   # remove all objects from the workspace


## @knitr 
Bval
print(Bval)
(Bval <- 4.5)
.Last.value


## @knitr 
get("Bval")
varName <- "Bval"
get(varName)


## @knitr 
ls()
newNameVar <- "varNew"
assign(newNameVar, Bval)
varNew


## @knitr 
search()


## @knitr eval=FALSE
history()
savehistory("d:/daniel/work/r/history.r")


## @knitr eval=FALSE
save.image("d:/daniel/work/r/objects.Rdata")


