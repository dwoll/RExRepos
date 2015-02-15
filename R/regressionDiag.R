## ----echo=FALSE----------------------------------------------------------
library(knitr)
opts_knit$set(self.contained=FALSE)
opts_chunk$set(tidy=FALSE, message=FALSE, warning=FALSE, comment=NA)

## ------------------------------------------------------------------------
wants <- c("car", "lmtest", "mvoutlier", "perturb", "robustbase", "tseries")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- 0.3*X1 - 0.2*X2 + rnorm(N, 0, 5)
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 5)
dfRegr <- data.frame(X1, X2, X3, Y)

## ------------------------------------------------------------------------
library(robustbase)
xyMat <- data.matrix(dfRegr)
robXY <- covMcd(xyMat)
XYz   <- scale(xyMat, center=robXY$center, scale=sqrt(diag(robXY$cov)))
summary(XYz)

## ------------------------------------------------------------------------
mahaSq <- mahalanobis(xyMat, center=robXY$center, cov=robXY$cov)
summary(sqrt(mahaSq))

## ----rerRegressionDiag01-------------------------------------------------
library(mvoutlier)
aqRes <- aq.plot(xyMat)

## ------------------------------------------------------------------------
which(aqRes$outliers)

## ------------------------------------------------------------------------
fit <- lm(Y ~ X1 + X2 + X3, data=dfRegr)
h   <- hatvalues(fit)
summary(h)

## ------------------------------------------------------------------------
cooksDst <- cooks.distance(fit)
summary(cooksDst)

## ------------------------------------------------------------------------
inflRes <- influence.measures(fit)
summary(inflRes)

## ----rerRegressionDiag02-------------------------------------------------
library(car)
influenceIndexPlot(fit)

## ------------------------------------------------------------------------
Estnd <- rstandard(fit)
Estud <- rstudent(fit)

## ----rerRegressionDiag03-------------------------------------------------
par(mar=c(5, 4.5, 4, 2)+0.1)
hist(Estud, main="Histogram studentized residals", breaks="FD", freq=FALSE)
curve(dnorm(x, mean=0, sd=1), col="red", lwd=2, add=TRUE)

## ----rerRegressionDiag04-------------------------------------------------
qqPlot(Estud, distribution="norm", pch=20, main="QQ-Plot studentized residuals")
qqline(Estud, col="red", lwd=2)

## ------------------------------------------------------------------------
shapiro.test(Estud)

## ----rerRegressionDiag05-------------------------------------------------
library(car)
spreadLevelPlot(fit, pch=20)

## ------------------------------------------------------------------------
library(car)
durbinWatsonTest(fit)

## ------------------------------------------------------------------------
library(lmtest)
bptest(fit)

## ------------------------------------------------------------------------
library(car)
ncvTest(fit)

## ------------------------------------------------------------------------
library(tseries)
white.test(dfRegr$X1, dfRegr$Y)

## ----results='hide'------------------------------------------------------
white.test(dfRegr$X2, dfRegr$Y)
white.test(dfRegr$X3, dfRegr$Y)
# not run

## ------------------------------------------------------------------------
lamObj  <- powerTransform(fit, family="bcPower")
(lambda <- coef(lamObj))

library(car)
yTrans <- bcPower(dfRegr$Y, lambda)

## ------------------------------------------------------------------------
X   <- data.matrix(subset(dfRegr, select=c("X1", "X2", "X3")))
(Rx <- cor(X))

## ------------------------------------------------------------------------
library(car)
vif(fit)

## ------------------------------------------------------------------------
fitScl <- lm(scale(Y) ~ scale(X1) + scale(X2) + scale(X3), data=dfRegr)
kappa(fitScl, exact=TRUE)

## ------------------------------------------------------------------------
library(perturb)
colldiag(fit, scale=TRUE, center=FALSE)

## ------------------------------------------------------------------------
pRes <- with(dfRegr, perturb(fit, pvars=c("X1", "X2", "X3"), prange=c(1, 1, 1)))
summary(pRes)

## ------------------------------------------------------------------------
try(detach(package:tseries))
try(detach(package:lmtest))
try(detach(package:zoo))
try(detach(package:perturb))
try(detach(package:mvoutlier))
try(detach(package:robustbase))
try(detach(package:sgeostat))
try(detach(package:car))

