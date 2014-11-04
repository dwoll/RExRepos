
## ------------------------------------------------------------------------
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
N       <- 20
pre     <- rbinom(N, size=1, prob=0.6)
post    <- rbinom(N, size=1, prob=0.4)
preFac  <- factor(pre,  labels=c("no", "yes"))
postFac <- factor(post, labels=c("no", "yes"))
cTab    <- table(preFac, postFac)
addmargins(cTab)


## ------------------------------------------------------------------------
mcnemar.test(cTab, correct=FALSE)


## ------------------------------------------------------------------------
library(coin)
symmetry_test(cTab, teststat="quad", distribution=approximate(B=9999))


## ------------------------------------------------------------------------
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))

