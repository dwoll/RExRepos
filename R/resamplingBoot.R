
## @knitr 
wants <- c("boot")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(123)
muH0 <- 100
sdH0 <- 40
N    <- 200
DV   <- rnorm(N, muH0, sdH0)


## @knitr 
getM <- function(orgDV, idx) {
    n     <- length(orgDV[idx])
    bsM   <- mean(orgDV[idx])
    bsS2M <- (((n-1) / n) * var(orgDV[idx])) / n
    c(bsM, bsS2M)
}

library(boot)
nR     <- 999
(bsRes <- boot(DV, statistic=getM, R=nR))


## @knitr 
alpha <- 0.05
boot.ci(bsRes, conf=1-alpha, type=c("basic", "perc", "norm", "stud", "bca"))


## @knitr 
res    <- replicate(nR, getM(DV, sample(seq(along=DV), replace=TRUE)))
Mstar  <- res[1, ]
SMstar <- sqrt(res[2, ])
tStar  <- (Mstar-mean(DV)) / SMstar


## @knitr rerResamplingBoot01
plot(tStar, ecdf(tStar)(tStar), col="gray60", pch=1, xlab="t* bzw. t",
     ylab="P(T <= t)", main="t*: cumulative rel. frequency and t CDF")
curve(pt(x, N-1), lwd=2, add=TRUE)
legend(x="topleft", lty=c(NA, 1), pch=c(1, NA), lwd=c(2, 2),
       col=c("gray60", "black"), legend=c("t*", "t"))


## @knitr 
try(detach(package:boot))


