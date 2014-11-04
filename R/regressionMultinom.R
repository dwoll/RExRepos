
## ------------------------------------------------------------------------
wants <- c("mlogit", "nnet", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
N      <- 100
X1     <- rnorm(N, 175, 7)
X2     <- rnorm(N,  30, 8)
Ycont  <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Ycateg <- cut(Ycont, breaks=quantile(Ycont), include.lowest=TRUE,
              labels=c("--", "-", "+", "++"), ordered=FALSE)
dfMN   <- data.frame(X1, X2, Ycateg)


## ------------------------------------------------------------------------
library(VGAM)
vglmFitMN <- vglm(Ycateg ~ X1 + X2, family=multinomial(refLevel=1), data=dfMN)


## ------------------------------------------------------------------------
exp(VGAM::coef(vglmFitMN))


## ----results='hide'------------------------------------------------------
library(nnet)
(mnFit <- multinom(Ycateg ~ X1 + X2, data=dfMN))
# not shown


## ----results='hide'------------------------------------------------------
library(mlogit)
dfMNL <- mlogit.data(dfMN, choice="Ycateg", shape="wide", varying=NULL)
(mlogitFit <- mlogit(Ycateg ~ 0 | X1 + X2, reflevel="--", data=dfMNL))
# not shown


## ------------------------------------------------------------------------
PhatCateg <- VGAM::predict(vglmFitMN, type="response")
head(PhatCateg)


## ----results='hide'------------------------------------------------------
predict(mnFit, type="probs")
fitted(mlogitFit, outcome=FALSE)
# not shown


## ------------------------------------------------------------------------
categHat <- levels(dfMN$Ycateg)[max.col(PhatCateg)]
head(categHat)


## ----results='hide'------------------------------------------------------
predCls <- predict(mnFit, type="class")
head(predCls)
# not shown


## ------------------------------------------------------------------------
facHat <- factor(categHat, levels=levels(dfMN$Ycateg))
cTab   <- xtabs(~ Ycateg + facHat, data=dfMN)
addmargins(cTab)


## ------------------------------------------------------------------------
(CCR <- sum(diag(cTab)) / sum(cTab))


## ------------------------------------------------------------------------
VGAM::deviance(vglmFitMN)
VGAM::logLik(vglmFitMN)
VGAM::AIC(vglmFitMN)


## ------------------------------------------------------------------------
vglm0 <- vglm(Ycateg ~ 1, family=multinomial(refLevel=1), data=dfMN)
LLf   <- VGAM::logLik(vglmFitMN)
LL0   <- VGAM::logLik(vglm0)


## ------------------------------------------------------------------------
as.vector(1 - (LLf / LL0))


## ------------------------------------------------------------------------
as.vector(1 - exp((2/N) * (LL0 - LLf)))


## ------------------------------------------------------------------------
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))


## ------------------------------------------------------------------------
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7),
                    X2=rnorm(Nnew,  30, 8),
                    Ycateg=factor(sample(c("--", "-", "+", "++"), Nnew, TRUE),
                                  levels=c("--", "-", "+", "++")))


## ------------------------------------------------------------------------
VGAM::predict(vglmFitMN, dfNew, type="response")


## ----results='hide'------------------------------------------------------
predict(mnFit, dfNew, type="probs")

dfNewL <- mlogit.data(dfNew, choice="Ycateg", shape="wide", varying=NULL)
predict(mlogitFit, dfNewL)
# not shown


## ------------------------------------------------------------------------
sumMN   <- VGAM::summary(vglmFitMN)
(coefMN <- VGAM::coef(sumMN))


## ------------------------------------------------------------------------
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefMN, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))


## ------------------------------------------------------------------------
2*(1 - pnorm(abs(coefMN[ , "z value"])))


## ----results='hide'------------------------------------------------------
summary(mnFit)
summary(mlogitFit)
# not shown


## ------------------------------------------------------------------------
vglmFitR <- vglm(Ycateg ~ X1, family=multinomial(refLevel=1), data=dfMN)
VGAM::lrtest(vglmFitMN, vglmFitR)


## ------------------------------------------------------------------------
VGAM::lrtest(vglmFitMN, vglm0)


## ------------------------------------------------------------------------
try(detach(package:mlogit))
try(detach(package:Formula))
try(detach(package:maxLik))
try(detach(package:miscTools))
try(detach(package:nnet))
try(detach(package:VGAM))
try(detach(package:splines))
try(detach(package:stats4))

