## ------------------------------------------------------------------------
wants <- c("glmnet", "lmtest", "MASS", "robustbase", "sandwich")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N,  30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y  <- 0.5*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 7)
dfRegr <- data.frame(X1, X2, X3, Y)

## ------------------------------------------------------------------------
library(robustbase)
ltsFit <- ltsReg(Y ~ X1 + X2 + X3, data=dfRegr)
summary(ltsFit)

## ------------------------------------------------------------------------
library(MASS)
fitRLM <- rlm(Y ~ X1 + X2 + X3, data=dfRegr)
summary(fitRLM)

## ------------------------------------------------------------------------
fit <- lm(Y ~ X1 + X2 + X3, data=dfRegr)
library(sandwich)
hcSE <- vcovHC(fit, type="HC3")
library(lmtest)
coeftest(fit, vcov=hcSE)

## ------------------------------------------------------------------------
library(MASS)
lambdas  <- 10^(seq(-2, 4, length=100))
ridgeGCV <- lm.ridge(scale(Y) ~ scale(X1) + scale(X2) + scale(X3),
                     data=dfRegr, lambda=lambdas)

## ------------------------------------------------------------------------
select(ridgeGCV)
ridgeSel <- lm.ridge(scale(Y) ~ scale(X1) + scale(X2) + scale(X3),
                     lambda=1.50)
coef(ridgeSel)

## ----regressionRobPen01--------------------------------------------------
plot(x=log(ridgeGCV$lambda), y=ridgeGCV$GCV, main="Ridge",
     xlab="log(lambda)", ylab="GCV")

## ------------------------------------------------------------------------
library(glmnet)
matScl  <- scale(cbind(Y, X1, X2, X3))
ridgeCV <- cv.glmnet(x=matScl[ , c("X1", "X2", "X3")], y=matScl[ , "Y"],
                     nfolds=10, alpha=0)

## ------------------------------------------------------------------------
ridge <- glmnet(x=matScl[ , c("X1", "X2", "X3")], y=matScl[ , "Y"],
                lambda=ridgeCV$lambda.min, alpha=0)
coef(ridge)

## ----regressionRobPen02--------------------------------------------------
plot(ridgeCV$glmnet.fit, xvar="lambda", label=TRUE, lwd=2)
title("Ridge", line=3, col="blue")
legend(x="bottomright", legend=c("X1", "X2", "X3"), lwd=2,
       col=c("black", "red", "green"), bg="white")

## ------------------------------------------------------------------------
lassoCV <- cv.glmnet(x=matScl[ , c("X1", "X2", "X3")], y=matScl[ , "Y"],
                     nfolds=10, alpha=1)
lasso <- glmnet(x=matScl[ , c("X1", "X2", "X3")], y=matScl[ , "Y"],
                lambda=lassoCV$lambda.min, alpha=1)
coef(lasso)

## ----regressionRobPen03--------------------------------------------------
plot(lassoCV$glmnet.fit, xvar="norm", label=FALSE, lwd=2)
title("LASSO", line=3, col="blue")
legend(x="bottomleft", legend=c("X1", "X2", "X3"), lwd=2,
       col=c("black", "red", "green"), bg="white")

## ------------------------------------------------------------------------
elNetCV <- cv.glmnet(x=matScl[ , c("X1", "X2", "X3")], y=matScl[ , "Y"],
                     nfolds=10, alpha=0.5)
elNet <- glmnet(x=matScl[ , c("X1", "X2", "X3")], y=matScl[ , "Y"],
                lambda=lassoCV$lambda.min, alpha=0.5)
coef(elNet)

## ----regressionRobPen04--------------------------------------------------
plot(elNetCV$glmnet.fit, xvar="dev", label=FALSE, lwd=2)
title("Elastic Net", line=3, col="blue")
legend(x="bottomleft", legend=c("X1", "X2", "X3"), lwd=2,
       col=c("black", "red", "green"), bg="white")

## ------------------------------------------------------------------------
try(detach(package:lmtest))
try(detach(package:sandwich))
try(detach(package:zoo))
try(detach(package:glmnet))
try(detach(package:Matrix))
try(detach(package:robustbase))
try(detach(package:MASS))

