
## ------------------------------------------------------------------------
wants <- c("sos")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ----eval=FALSE----------------------------------------------------------
help.start()
help(round)
?round
?"/"
# not shown (opens browser window)


## ------------------------------------------------------------------------
args(round)
example(round)


## ----eval=FALSE----------------------------------------------------------
help.search("mean")
# not shown (opens browser window)


## ------------------------------------------------------------------------
apropos("mean")


## ----eval=FALSE----------------------------------------------------------
library(sos)                  # for findFn()
findFn("Petal.Length")
# not shown (opens browser window)


## ------------------------------------------------------------------------
try(detach(package:sos))
try(detach(package:brew))

