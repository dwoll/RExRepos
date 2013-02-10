
## @knitr 
wants <- c("sos")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr eval=FALSE
help.start()
help(round)
?round
?"/"
# not shown (opens browser window)


## @knitr 
args(round)
example(round)


## @knitr eval=FALSE
help.search("mean")
# not shown (opens browser window)


## @knitr 
apropos("mean")


## @knitr eval=FALSE
library(sos)                  # for findFn()
findFn("Petal.Length")
# not shown (opens browser window)


## @knitr 
try(detach(package:sos))
try(detach(package:brew))


