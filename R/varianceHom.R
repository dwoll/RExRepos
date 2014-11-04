
## ------------------------------------------------------------------------
wants <- c("car", "coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
P     <- 2
Nj    <- c(50, 40)
DV1   <- rnorm(Nj[1], mean=100, sd=15)
DV2   <- rnorm(Nj[2], mean=100, sd=13)
varDf <- data.frame(DV=c(DV1, DV2),
                    IV=factor(rep(1:P, Nj)))


## ----rerVarHom01---------------------------------------------------------
boxplot(DV ~ IV, data=varDf)
stripchart(DV ~ IV, data=varDf, pch=16, vert=TRUE, add=TRUE)


## ----results='hide'------------------------------------------------------
var.test(DV1, DV2)


## ------------------------------------------------------------------------
var.test(DV ~ IV, data=varDf)


## ------------------------------------------------------------------------
mood.test(DV ~ IV, alternative="greater", data=varDf)


## ------------------------------------------------------------------------
ansari.test(DV ~ IV, alternative="greater", exact=FALSE, data=varDf)


## ------------------------------------------------------------------------
library(coin)
ansari_test(DV ~ IV, alternative="greater", distribution="exact", data=varDf)


## ------------------------------------------------------------------------
Nj    <- c(22, 18, 20)
N     <- sum(Nj)
P     <- length(Nj)
levDf <- data.frame(DV=sample(0:100, N, replace=TRUE),
                    IV=factor(rep(1:P, Nj)))


## ----rerVarHom02---------------------------------------------------------
boxplot(DV ~ IV, data=levDf)
stripchart(DV ~ IV, data=levDf, pch=20, vert=TRUE, add=TRUE)


## ------------------------------------------------------------------------
library(car)
leveneTest(DV ~ IV, center=median, data=levDf)
leveneTest(DV ~ IV, center=mean, data=levDf)


## ------------------------------------------------------------------------
fligner.test(DV ~ IV, data=levDf)


## ------------------------------------------------------------------------
library(coin)
fligner_test(DV ~ IV, distribution=approximate(B=9999), data=levDf)


## ------------------------------------------------------------------------
try(detach(package:car))
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))

