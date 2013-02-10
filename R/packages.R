
## @knitr 
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
.libPaths()


## @knitr eval=FALSE
installed.packages()
# not shown (very long output)


## @knitr 
rownames(installed.packages())


## @knitr eval=FALSE
library()
# not shown (opens separate window)


## @knitr eval=FALSE
setRepositories("http://cran.ma.imperial.ac.uk/")
install.packages(c("coin", "car"))
install.packages("coin", repos="http://cran.at.r-project.org/")
update.packages()
# remove.packages("coin")
# not shown


## @knitr eval=FALSE
help(package=coin)
vignette()
vignette("coin_implementation")
# not shown (opens separate window)


## @knitr 
library(coin)


## @knitr 
library(coin, logical.return=TRUE)


## @knitr warning=TRUE
require(doesNotExist)


## @knitr 
sessionInfo()
search()


## @knitr eval=FALSE
detach(package:coin)


## @knitr eval=FALSE
data(package="coin")
data(jobsatisfaction, package="coin")
# not shown (opens separate window)


## @knitr 
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))


