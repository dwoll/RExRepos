## ------------------------------------------------------------------------
wants <- c("boot")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
n1  <- 18
n2  <- 21
DVm <- rnorm(n1, 180, 10)
DVf <- rnorm(n2, 175, 6)
tDf <- data.frame(DV=c(DVm, DVf),
                  IV=factor(rep(c("m", "f"), c(n1, n2))))

## ------------------------------------------------------------------------
getDM <- function(dat, idx) {
    Mfm <- aggregate(DV ~ IV, data=dat, subset=idx, FUN=mean)
    -diff(Mfm$DV)
}

## ------------------------------------------------------------------------
library(boot)
bsTind <- boot(tDf, statistic=getDM, strata=tDf$IV, R=999)
boot.ci(bsTind, conf=0.95, type=c("basic", "bca"))

## ------------------------------------------------------------------------
tt <- t.test(DV ~ IV, alternative="two.sided", var.equal=TRUE, data=tDf)
tt$conf.int

## ------------------------------------------------------------------------
try(detach(package:boot))

