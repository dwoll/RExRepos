
## ------------------------------------------------------------------------
wants <- c("boot")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 3)
dfRegr <- data.frame(X1, X2, X3, Y)


## ------------------------------------------------------------------------
glmFit <- glm(Y ~ X1 + X2 + X3, data=dfRegr,
              family=gaussian(link="identity"))


## ------------------------------------------------------------------------
library(boot)                          # for cv.glm()
k    <- 3
kfCV <- cv.glm(data=dfRegr, glmfit=glmFit, K=k)
kfCV$delta


## ------------------------------------------------------------------------
LOOCV <- cv.glm(data=dfRegr, glmfit=glmFit, K=N)


## ------------------------------------------------------------------------
LOOCV$delta


## ------------------------------------------------------------------------
SSRIpre  <- c(18, 16, 16, 15, 14, 20, 14, 21, 25, 11)
SSRIpost <- c(12,  0, 10,  9,  0, 11,  2,  4, 15, 10)
PlacPre  <- c(18, 16, 15, 14, 20, 25, 11, 25, 11, 22)
PlacPost <- c(11,  4, 19, 15,  3, 14, 10, 16, 10, 20)
WLpre    <- c(15, 19, 10, 29, 24, 15,  9, 18, 22, 13)
WLpost   <- c(17, 25, 10, 22, 23, 10,  2, 10, 14,  7)
DVpre    <- c(SSRIpre,  PlacPre,  WLpre)
DVpost   <- c(SSRIpost, PlacPost, WLpost)
postFac  <- cut(DVpost, breaks=c(-Inf, median(DVpost), Inf),
                        labels=c("lo", "hi"))
dfAncova <- data.frame(DVpre, DVpost, postFac)

glmLR <- glm(postFac ~ DVpre, family=binomial(link="logit"), data=dfAncova)


## ------------------------------------------------------------------------
# Brier score loss function - general version for several GLMs
brierA <- function(y, pHat) {
    mean(((y == 1) * pHat)^2 + ((y == 0) * (1-pHat))^2)
}

library(boot)                          # for cv.glm()
B1 <- cv.glm(data=dfAncova, glmfit=glmLR, cost=brierA, K=10)
B1$delta

# Brier score loss function - simplified version for logistic regression only
brierB <- function(y, pHat) {
    mean((y-pHat)^2)
}

B2 <- cv.glm(data=dfAncova, glmfit=glmLR, cost=brierB, K=10)
B2$delta


## ------------------------------------------------------------------------
getBSB <- function(dat, idx) {
    op <- options(warn=2)
    on.exit(options(op))

    bsFit <- try(glm(postFac ~ DVpre, family=binomial(link="logit"), subset=idx, data=dat))
    fail  <- inherits(bsFit, "try-error")
    if(fail || !bsFit$converged) {
        return(NA)
    } else {
        BbsTrn <- brierB(bsFit$y, predict(bsFit, type="response"))
        BbsTst <- brierB(as.numeric(dat$postFac)-1, predict(bsFit, newdata=dat, type="response"))
        return(BbsTrn - BbsTst)
    }
}


## ------------------------------------------------------------------------
library(boot)                          # for boot()
nR    <- 999
bsRes <- boot(dfAncova, statistic=getBSB, R=nR)

(Btrain   <- brierB(glmLR$y, predict(glmLR, type="response")))
(optimism <- mean(bsRes$t, na.rm=TRUE))


## ------------------------------------------------------------------------
(predErr <- Btrain - optimism)


## ------------------------------------------------------------------------
try(detach(package:boot))

