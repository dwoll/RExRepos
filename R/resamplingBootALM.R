
## @knitr 
wants <- c("boot")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 3)
dfRegr <- data.frame(X1, X2, X3, Y)


## @knitr 
(fit <- lm(Y ~ X1 + X2 + X3, data=dfRegr))
sqrt(diag(vcov(fit)))
confint(fit)


## @knitr 
getRegr <- function(dat, idx) {
    bsFit <- lm(Y ~ X1 + X2 + X3, subset=idx, data=dat)
    coef(bsFit)
}


## @knitr 
library(boot)
nR <- 999
(bsRegr <- boot(dfRegr, statistic=getRegr, R=nR))


## @knitr 
boot.ci(bsRegr, conf=0.95, type="bca", index=1)$bca
boot.ci(bsRegr, conf=0.95, type="bca", index=2)$bca
boot.ci(bsRegr, conf=0.95, type="bca", index=3)$bca
boot.ci(bsRegr, conf=0.95, type="bca", index=4)$bca


## @knitr 
P     <- 4
Nj    <- c(41, 37, 42, 40)
muJ   <- rep(c(-1, 0, 1, 2), Nj)
dfCRp <- data.frame(IV=factor(rep(LETTERS[1:P], Nj)),
                    DV=rnorm(sum(Nj), muJ, 6))


## @knitr 
anBase <- anova(lm(DV ~ IV, data=dfCRp))
Fbase  <- anBase["IV", "F value"]
(pBase <- anBase["IV", "Pr(>F)"])


## @knitr 
fit0 <- lm(DV ~ 1, data=dfCRp)        ## fit 0-model
E    <- residuals(fit0)               ## residuals
Er   <- E / sqrt(1-hatvalues(fit0))   ## rescaled residuals
Yhat <- fitted(fit0)                  ## prediction

getAnova <- function(dat, idx) {
    Ystar <- Yhat + Er[idx]
    anBS  <- anova(lm(Ystar ~ IV, data=dat))
    anBS["IV", "F value"]
}

library(boot)
nR       <- 999
(bsAnova <- boot(dfCRp, statistic=getAnova, R=nR))
Fstar    <- bsAnova$t
(pValBS  <- (sum(Fstar >= Fbase) + 1) / (length(Fstar) + 1))


## @knitr rerResamplingBootALM01
plot(Fstar, ecdf(Fstar)(Fstar), col="gray60", pch=1, xlab="f* bzw. f",
     ylab="P(F <= f)", main="F*: cumulative rel. freqs and F CDF")
curve(pf(x, P-1, sum(Nj) - P), lwd=2, add=TRUE)
legend(x="topleft", lty=c(NA, 1), pch=c(1, NA), lwd=c(2, 2),
       col=c("gray60", "black"), legend=c("F*", "F"))


## @knitr 
getAnovaWild <- function(dat, idx) {
    n  <- length(idx)                     ## size of replication
    ## 1st choice for random variate U: Rademacher-variables
    Ur <- sample(c(-1, 1), size=n, replace=TRUE, prob=c(0.5, 0.5))

    ## 2nd option for choosing random variate U
    Uf <- sample(c(-(sqrt(5) - 1)/2, (sqrt(5) + 1)/2), size=n, replace=TRUE,
                 prob=c((sqrt(5) + 1)/(2*sqrt(5)), (sqrt(5) - 1)/(2*sqrt(5))))

    Ystar <- Yhat + (Er*Ur)[idx]          ## for E* with Rademacher-variables
    # Ystar <- Yhat + (Er*Uf)[idx]        ## for E* with 2nd option
    anBS  <- anova(lm(Ystar ~ IV, data=dat))
    anBS["IV", "F value"]
}


## @knitr 
library(boot)
nR       <- 999
bsAnovaW <- boot(dfCRp, statistic=getAnovaWild, R=nR)
FstarW   <- bsAnovaW$t
(pValBSw <- (sum(FstarW >= Fbase) + 1) / (length(FstarW) + 1))


## @knitr 
try(detach(package:boot))


