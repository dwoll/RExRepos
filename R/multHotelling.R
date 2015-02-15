## ------------------------------------------------------------------------
wants <- c("DescTools", "mvtnorm")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
library(mvtnorm)
Nj    <- c(15, 25)
Sigma <- matrix(c(16,-2, -2,9), byrow=TRUE, ncol=2)
mu1   <- c(-4, 4)
Y1    <- round(rmvnorm(Nj[1], mean=mu1, sigma=Sigma))

## ------------------------------------------------------------------------
muH0 <- c(-1, 2)
library(DescTools)
HotellingsT2Test(Y1, mu=muH0)

## ------------------------------------------------------------------------
Y1ctr  <- sweep(Y1, 2, muH0, "-")
(anRes <- anova(lm(Y1ctr ~ 1), test="Hotelling-Lawley"))

## ------------------------------------------------------------------------
mu2 <- c(3, 3)
Y2  <- round(rmvnorm(Nj[2], mean=mu2, sigma=Sigma))
Y12 <- rbind(Y1, Y2)
IV  <- factor(rep(1:2, Nj))

## ------------------------------------------------------------------------
library(DescTools)
HotellingsT2Test(Y12 ~ IV)

## ------------------------------------------------------------------------
anova(lm(Y12 ~ IV), test="Hotelling-Lawley")
summary(manova(Y12 ~ IV), test="Hotelling-Lawley")

## ------------------------------------------------------------------------
N    <- 20
P    <- 2
muJK <- c(90, 100, 85, 105)
Sig  <- 15
Y1t0 <- rnorm(N, mean=muJK[1], sd=Sig)
Y1t1 <- rnorm(N, mean=muJK[2], sd=Sig)
Y2t0 <- rnorm(N, mean=muJK[3], sd=Sig)
Y2t1 <- rnorm(N, mean=muJK[4], sd=Sig)
Ydf  <- data.frame(id=factor(rep(1:N, times=P)),
                   Y1=c(Y1t0, Y1t1),
                   Y2=c(Y2t0, Y2t1),
                   IV=factor(rep(1:P, each=N), labels=c("t0", "t1")))

## ------------------------------------------------------------------------
dfDiff <- aggregate(cbind(Y1, Y2) ~ id, data=Ydf, FUN=diff)
DVdiff <- data.matrix(dfDiff[ , -1])
muH0   <- c(0, 0)

## ------------------------------------------------------------------------
library(DescTools)
HotellingsT2Test(DVdiff, mu=muH0)

## ------------------------------------------------------------------------
anova(lm(DVdiff ~ 1), test="Hotelling-Lawley")

## ------------------------------------------------------------------------
try(detach(package:DescTools))
try(detach(package:mvtnorm))

