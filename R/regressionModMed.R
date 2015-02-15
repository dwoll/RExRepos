## ------------------------------------------------------------------------
wants <- c("mediation", "multilevel", "rockchalk")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- abs(rnorm(N, 60, 30))
M  <- rnorm(N,  30, 8)
Y  <- 0.5*X1 - 0.3*M - 0.4*X2 + 10 + rnorm(N, 0, 3)

## ------------------------------------------------------------------------
X1c    <- c(scale(X1, center=TRUE, scale=FALSE))
Mc     <- c(scale(M,  center=TRUE, scale=FALSE))
fitMod <- lm(Y ~ X1c + Mc + X1c:Mc)
coef(summary(fitMod))

## ----moderation----------------------------------------------------------
library(rockchalk)
ps  <- plotSlopes(fitMod, plotx="X1c", modx="Mc", modxVals="std.dev")
(ts <- testSlopes(ps))
plot(ts)

## ------------------------------------------------------------------------
N <- 100
X <- rnorm(N, 175, 7)
M <- 0.7*X + rnorm(N, 0, 5)
Y <- 0.4*M + rnorm(N, 0, 5)
dfMed <- data.frame(X, M, Y)

## ------------------------------------------------------------------------
fit <- lm(Y ~ X + M, data=dfMed)
summary(fit)

## ------------------------------------------------------------------------
library(multilevel)
sobel(dfMed$X, dfMed$M, dfMed$Y)

## ------------------------------------------------------------------------
fitM <- lm(M ~ X,     data=dfMed)
fitY <- lm(Y ~ X + M, data=dfMed)

library(mediation)
fitMed <- mediate(fitM, fitY, sims=999, treat="X", mediator="M")
summary(fitMed)

## ----rerRegressionModMed01-----------------------------------------------
plot(fitMed)

## ------------------------------------------------------------------------
fitMedBoot <- mediate(fitM, fitY, boot=TRUE, sims=999, treat="X", mediator="M")
summary(fitMedBoot)

## ------------------------------------------------------------------------
try(detach(package:rockchalk))
try(detach(package:mediation))
try(detach(package:Matrix))
try(detach(package:lpSolve))
try(detach(package:multilevel))
try(detach(package:MASS))
try(detach(package:nlme))
try(detach(package:sandwich))
try(detach(package:mvtnorm))

