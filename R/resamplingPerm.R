
## @knitr 
wants <- c("coin", "e1071")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
Nj     <- c(7, 8)
sigma  <- 20
DVa    <- rnorm(Nj[1], 100, sigma)
DVb    <- rnorm(Nj[2], 110, sigma)
tIndDf <- data.frame(DV=c(DVa, DVb),
                     IV=factor(rep(c("A", "B"), Nj)))


## @knitr 
library(coin)
oneway_test(DV ~ IV, alternative="less", distribution="exact", data=tIndDf)


## @knitr 
tRes <- t.test(DV ~ IV, alternative="less", var.equal=TRUE, data=tIndDf)
tRes$p.value


## @knitr 
idx   <- seq(along=tIndDf$DV)
idxA  <- combn(idx, Nj[1])
getDM <- function(x) { mean(tIndDf$DV[!(idx %in% x)]) - mean(tIndDf$DV[x]) }
resDM <- apply(idxA, 2, getDM)
diffM <- diff(tapply(tIndDf$DV, tIndDf$IV, mean))
(pVal <- sum(resDM >= diffM) / length(resDM))


## @knitr rerResamplingPerm01
hist(resDM, freq=FALSE, breaks="FD", xlab="Difference in means",
     main="Permutation test: Histogram difference in means")
curve(dnorm(x, 0, sigma/sqrt(Nj[1]) + sigma/sqrt(Nj[2])), lwd=2, add=TRUE)
legend(x="topright", lty=1, lwd=2, legend=expression(paste("N(0, ", sigma[1]^2 / n[1] + sigma[2]^2 / n[2], ")")))


## @knitr rerResamplingPerm02
plot(resDM, ecdf(resDM)(resDM), col="gray60", pch=16,
     xlab="Difference in means", ylab="cumulative relative frequency",
     main="Cumulative relative frequency and normal CDF")
curve(pnorm(x, 0, sigma/sqrt(Nj[1]) + sigma/sqrt(Nj[2])), lwd=2, add=TRUE)
legend(x="bottomright", lty=c(NA, 1), pch=c(16, NA), lwd=c(1, 2),
       col=c("gray60", "black"),
       legend=c("Permutations",
       expression(paste("N(0, ", sigma[1]^2 / n[1] + sigma[2]^2 / n[2], ")"))))


## @knitr 
N      <- 12
id     <- factor(rep(1:N, times=2))
DVpre  <- rnorm(N, 100, 20)
DVpost <- rnorm(N, 110, 20)
tDepDf <- data.frame(DV=c(DVpre, DVpost),
                     IV=factor(rep(0:1, each=N), labels=c("pre", "post")))


## @knitr 
library(coin)
oneway_test(DV ~ IV | id, alternative="less", distribution=approximate(B=9999), data=tDepDf)


## @knitr 
t.test(DV ~ IV, alternative="less", paired=TRUE, data=tDepDf)$p.value


## @knitr 
DVd    <- DVpre - DVpost
sgnLst <- lapply(numeric(N), function(x) { c(-1, 1) } )
sgnMat <- data.matrix(expand.grid(sgnLst))
getMD  <- function(x) { mean(abs(DVd) * x) }
resMD  <- apply(sgnMat, 1, getMD)
(pVal  <- sum(resMD <= mean(DVd)) / length(resMD))


## @knitr 
Nf  <- 7
DV1 <- rbinom(Nf, size=1, prob=0.5)
DV2 <- rbinom(Nf, size=1, prob=0.5)
fisher.test(DV1, DV2, alternative="greater")$p.value


## @knitr 
library(e1071)
permIdx  <- permutations(Nf)
getAgree <- function(idx) {
    sum(diag(table(DV1, DV2[idx])))
}

resAgree <- apply(permIdx, 1, getAgree)
agree12  <- sum(diag(table(DV1, DV2)))
(pVal    <- sum(resAgree >= agree12) / length(resAgree))


## @knitr 
try(detach(package:e1071))
try(detach(package:class))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))


