
## @knitr 
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
N   <- 10
P   <- 5
cDf <- data.frame(id=factor(rep(1:N, each=P)),
                  year=factor(rep(1981:1985, times=N)),
                  pref=c(1,1,0,1,0, 0,1,0,0,1, 1,0,1,0,0, 1,1,1,1,1, 0,1,0,0,0,
                         1,0,1,1,1, 0,0,0,0,0, 1,1,1,1,0, 0,1,0,1,1, 1,0,1,0,0))


## @knitr 
library(coin)
symmetry_test(pref ~ year | id, teststat="quad", data=cDf)


## @knitr 
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))


