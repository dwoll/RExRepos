## ------------------------------------------------------------------------
wants <- c("coin", "e1071")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
Nj     <- c(7, 8)
sigma  <- 20
DVa    <- round(rnorm(Nj[1], 100, sigma))
DVb    <- round(rnorm(Nj[2], 110, sigma))
tIndDf <- data.frame(DV=c(DVa, DVb),
                     IV=factor(rep(c("A", "B"), Nj)))

## ------------------------------------------------------------------------
library(coin)
(ot <- oneway_test(DV ~ IV, alternative="less", data=tIndDf, distribution="exact"))

## ------------------------------------------------------------------------
tRes <- t.test(DV ~ IV, alternative="less", var.equal=TRUE, data=tIndDf)
tRes$p.value

## ------------------------------------------------------------------------
idx   <- seq(along=tIndDf$DV)
idxA  <- combn(idx, Nj[1])
getDM <- function(x) { mean(tIndDf$DV[!(idx %in% x)]) - mean(tIndDf$DV[x]) }
resDM <- apply(idxA, 2, getDM)
diffM <- diff(tapply(tIndDf$DV, tIndDf$IV, mean))

# don't use <= because of floating point arithmetic problems
DMstar   <- apply(idxA, 2, getDM)
DMbase   <- mean(DVa) - mean(DVb)
tol      <- .Machine$double.eps^0.5
DMsIsLEQ <- (DMstar < DMbase) | (abs(DMstar-DMbase) < tol)
(pVal    <- sum(DMsIsLEQ) / length(DMstar))

## ----rerResamplingPerm01-------------------------------------------------
supp <- support(ot)
dens <- sapply(supp, dperm, object=ot)
plot(supp, dens, xlab="Support", ylab=NA, pch=20, main="Density permutation distribution")

## ----rerResamplingPerm02-------------------------------------------------
qEmp <- sapply(ppoints(supp), qperm, object=ot)
qqnorm(qEmp, xlab="Normal quantiles", ylab="Permutation quantiles",
       pch=20, main="Permutation quantiles vs. normal quantiles")
abline(a=0, b=1, lwd=2, col="blue")

## ----rerResamplingPerm03-------------------------------------------------
plot(qEmp, ecdf(qEmp)(qEmp), col="gray60", pch=16,
     xlab="Difference in means", ylab="Cumulative relative frequency",
     main="Cumulative relative frequency and normal CDF")

## ------------------------------------------------------------------------
N      <- 12
id     <- factor(rep(1:N, times=2))
DVpre  <- rnorm(N, 100, 20)
DVpost <- rnorm(N, 110, 20)
tDepDf <- data.frame(DV=c(DVpre, DVpost),
                     IV=factor(rep(0:1, each=N), labels=c("pre", "post")))

## ------------------------------------------------------------------------
library(coin)
oneway_test(DV ~ IV | id, alternative="less", distribution=approximate(B=9999), data=tDepDf)

## ------------------------------------------------------------------------
t.test(DV ~ IV, alternative="less", paired=TRUE, data=tDepDf)$p.value

## ------------------------------------------------------------------------
DVd    <- DVpre - DVpost
sgnLst <- lapply(numeric(N), function(x) { c(-1, 1) } )
sgnMat <- data.matrix(expand.grid(sgnLst))
getMD  <- function(x) { mean(abs(DVd) * x) }
MDstar <- apply(sgnMat, 1, getMD)
MDbase <- mean(DVd)

# don't use <= because of floating point arithmetic problems
tol      <- .Machine$double.eps^0.5
MDsIsLEQ <- (MDstar < MDbase) | (abs(MDstar-MDbase) < tol)
(pVal    <- sum(MDsIsLEQ) / length(MDstar))

## ------------------------------------------------------------------------
Nf  <- 8
DV1 <- rbinom(Nf, size=1, prob=0.5)
DV2 <- rbinom(Nf, size=1, prob=0.5)
fisher.test(DV1, DV2, alternative="greater")$p.value

## ------------------------------------------------------------------------
library(e1071)
permIdx  <- permutations(Nf)
getAgree <- function(idx) { sum(diag(table(DV1, DV2[idx]))) }
resAgree <- apply(permIdx, 1, getAgree)
agree12  <- sum(diag(table(DV1, DV2)))
(pVal    <- sum(resAgree >= agree12) / length(resAgree))

## ------------------------------------------------------------------------
try(detach(package:e1071))
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))

