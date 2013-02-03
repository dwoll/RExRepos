
## @knitr 
wants <- c("mlogit", "nnet", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
N      <- 100
X1     <- rnorm(N, 175, 7)
X2     <- rnorm(N,  30, 8)
Ycont  <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Ycateg <- cut(Ycont, breaks=quantile(Ycont), include.lowest=TRUE,
              labels=c("--", "-", "+", "++"), ordered=FALSE)
dfMN   <- data.frame(X1, X2, Ycateg)


## @knitr 
library(VGAM)
vglmFitMN <- vglm(Ycateg ~ X1 + X2, family=multinomial(refLevel=1), data=dfMN)


## @knitr 
exp(coef(vglmFitMN))


## @knitr results='hide'
library(nnet)
(mnFit <- multinom(Ycateg ~ X1 + X2, data=dfMN))
# not shown


## @knitr results='hide'
library(mlogit)
dfMNL <- mlogit.data(dfMN, choice="Ycateg", shape="wide", varying=NULL)
(mlogitFit <- mlogit(Ycateg ~ 0 | X1 + X2, reflevel="--", data=dfMNL))
# not shown


## @knitr 
PhatCateg <- predict(vglmFitMN, type="response")
head(PhatCateg)


## @knitr results='hide'
predict(mnFit, type="probs")
fitted(mlogitFit, outcome=FALSE)
# not shown


## @knitr 
categHat <- levels(dfMN$Ycateg)[max.col(PhatCateg)]
head(categHat)


## @knitr results='hide'
predCls <- predict(mnFit, type="class")
head(predCls)
# not shown


## @knitr 
facHat <- factor(categHat, levels=levels(dfMN$Ycateg))
cTab   <- table(dfMN$Ycateg, facHat, dnn=c("Ycateg", "facHat"))
addmargins(cTab)


## @knitr 
(CCR <- sum(diag(cTab)) / sum(cTab))


## @knitr 
deviance(vglmFitMN)
logLik(vglmFitMN)
AIC(vglmFitMN)


## @knitr 
vglm0 <- vglm(Ycateg ~ 1, family=multinomial(refLevel=1), data=dfMN)
LLf   <- logLik(vglmFitMN)
LL0   <- logLik(vglm0)


## @knitr 
as.vector(1 - (LLf / LL0))


## @knitr 
as.vector(1 - exp((2/N) * (LL0 - LLf)))


## @knitr 
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))


## @knitr 
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7),
                    X2=rnorm(Nnew,  30, 8),
                    Ycateg=factor(sample(c("--", "-", "+", "++"), Nnew, TRUE),
                                  levels=c("--", "-", "+", "++")))


## @knitr 
predict(vglmFitMN, dfNew, type="response")


## @knitr results='hide'
predict(mnFit, dfNew, type="probs")

dfNewL <- mlogit.data(dfNew, choice="Ycateg", shape="wide", varying=NULL)
predict(mlogitFit, dfNewL)
# not shown


## @knitr 
sumMN   <- summary(vglmFitMN)
(coefMN <- coef(sumMN))


## @knitr 
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefMN, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))


## @knitr 
2*(1 - pnorm(abs(coefMN[ , "z value"])))


## @knitr results='hide'
summary(mnFit)
summary(mlogitFit)
# not shown


## @knitr 
vglmFitR <- vglm(Ycateg ~ X1, family=multinomial(refLevel=1), data=dfMN)
VGAM::lrtest(vglmFitMN, vglmFitR)


## @knitr 
VGAM::lrtest(vglmFitMN, vglm0)


## @knitr 
try(detach(package:mlogit))
try(detach(package:MASS))
try(detach(package:Formula))
try(detach(package:statmod))
try(detach(package:maxLik))
try(detach(package:miscTools))
try(detach(package:nnet))
try(detach(package:VGAM))
try(detach(package:splines))
try(detach(package:stats4))


