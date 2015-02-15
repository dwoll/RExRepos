## ------------------------------------------------------------------------
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
.libPaths()

## ----eval=FALSE----------------------------------------------------------
installed.packages()
# not shown (very long output)

## ------------------------------------------------------------------------
rownames(installed.packages())

## ----eval=FALSE----------------------------------------------------------
library()
# not shown (opens separate window)

## ----eval=FALSE----------------------------------------------------------
setRepositories("http://cran.ma.imperial.ac.uk/")
install.packages(c("coin", "car"))
install.packages("coin", repos="http://cran.at.r-project.org/")
update.packages()
# remove.packages("coin")
# not shown

## ----eval=FALSE----------------------------------------------------------
help(package=coin)
vignette()
vignette("coin_implementation")
# not shown (opens separate window)

## ------------------------------------------------------------------------
library(coin)

## ------------------------------------------------------------------------
library(coin, logical.return=TRUE)

## ----warning=TRUE--------------------------------------------------------
require(doesNotExist)

## ------------------------------------------------------------------------
base::mean(c(1, 3, 4))

## ------------------------------------------------------------------------
sessionInfo()
search()

## ----eval=FALSE----------------------------------------------------------
detach(package:coin)

## ----eval=FALSE----------------------------------------------------------
data(package="coin")
data(jobsatisfaction, package="coin")
# not shown (opens separate window)

## ------------------------------------------------------------------------
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))

