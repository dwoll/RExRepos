
## @knitr 
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
categ <- factor(1:3, labels=c("lo", "med", "hi"))
drug  <- rep(categ, c(30, 50, 20))
plac  <- rep(rep(categ, length(categ)), c(14,7,9, 5,26,19, 1,7,12))
cTab  <- table(drug, plac)
addmargins(cTab)


## @knitr 
mcnemar.test(cTab)


## @knitr 
library(coin)
symmetry_test(cTab, teststat="quad", distribution=approximate(B=9999))


## @knitr 
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))


