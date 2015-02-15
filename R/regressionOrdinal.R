## ----echo=FALSE----------------------------------------------------------
library(knitr)
opts_knit$set(self.contained=FALSE)
opts_chunk$set(tidy=FALSE, message=FALSE, warning=FALSE, comment=NA)

## ------------------------------------------------------------------------
wants <- c("MASS", "ordinal", "rms", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
N     <- 100
X1    <- rnorm(N, 175, 7)
X2    <- rnorm(N,  30, 8)
Ycont <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Yord  <- cut(Ycont, breaks=quantile(Ycont), include.lowest=TRUE,
             labels=c("--", "-", "+", "++"), ordered=TRUE)
dfOrd <- data.frame(X1, X2, Yord)

## ------------------------------------------------------------------------
library(VGAM)
(vglmFit <- vglm(Yord ~ X1 + X2, family=propodds, data=dfOrd))

## ----results='hide'------------------------------------------------------
vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE, reverse=TRUE), data=dfOrd)
# not shown

## ----results='hide'------------------------------------------------------
vglm(Yord ~ X1 + X2, family=acat(parallel=TRUE), data=dfOrd)
# not shown

## ----results='hide'------------------------------------------------------
vglm(Yord ~ X1 + X2, family=sratio(parallel=TRUE), data=dfOrd)
# not shown

## ------------------------------------------------------------------------
library(rms)
(ormFit <- orm(Yord ~ X1 + X2, data=dfOrd))

## ----results='hide'------------------------------------------------------
library(MASS)
(polrFit <- polr(Yord ~ X1 + X2, method="logistic", data=dfOrd))
# not shown

## ------------------------------------------------------------------------
exp(MASS:::confint.polr(polrFit))

## ----results='hide'------------------------------------------------------
library(ordinal)
(clmFit <- clm(Yord ~ X1 + X2, link="logit", data=dfOrd))
# not shown

## ------------------------------------------------------------------------
PhatCateg <- VGAM::predict(vglmFit, type="response")
head(PhatCateg)

## ----results='hide'------------------------------------------------------
predict(ormFit, type="fitted.ind")
predict(clmFit, subset(dfOrd, select=c("X1", "X2"), type="prob"))$fit
predict(polrFit, type="probs")
# not shown

## ------------------------------------------------------------------------
categHat <- levels(dfOrd$Yord)[max.col(PhatCateg)]
head(categHat)

## ----results='hide'------------------------------------------------------
predict(clmFit, type="class")
predict(polrFit, type="class")
# not shown

## ------------------------------------------------------------------------
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7),
                    X2=rnorm(Nnew,  30, 8))

## ------------------------------------------------------------------------
VGAM::predict(vglmFit, dfNew, type="response")

## ----results='hide'------------------------------------------------------
predict(ormFit,  dfNew, type="fitted.ind")
predict(polrFit, dfNew, type="probs")
predict(clmFit,  subset(dfNew, select=c("X1", "X2"), type="prob"))$fit
# not shown

## ------------------------------------------------------------------------
facHat <- factor(categHat, levels=levels(dfOrd$Yord))
cTab   <- xtabs(~ Yord + facHat, data=dfOrd)
addmargins(cTab)

## ------------------------------------------------------------------------
(CCR <- sum(diag(cTab)) / sum(cTab))

## ------------------------------------------------------------------------
VGAM::deviance(vglmFit)
VGAM::logLik(vglmFit)
VGAM::AIC(vglmFit)

## ------------------------------------------------------------------------
vglm0 <- vglm(Yord ~ 1, family=propodds, data=dfOrd)
LLf   <- VGAM::logLik(vglmFit)
LL0   <- VGAM::logLik(vglm0)

## ------------------------------------------------------------------------
as.vector(1 - (LLf / LL0))

## ------------------------------------------------------------------------
as.vector(1 - exp((2/N) * (LL0 - LLf)))

## ------------------------------------------------------------------------
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))

## ------------------------------------------------------------------------
sumOrd   <- summary(vglmFit)
(coefOrd <- coef(sumOrd))

## ------------------------------------------------------------------------
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefOrd, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))

## ----results='hide'------------------------------------------------------
summary(polrFit)
summary(clmFit)
# not shown

## ------------------------------------------------------------------------
vglmR <- vglm(Yord ~ X1, family=propodds, data=dfOrd)
VGAM::lrtest(vglmFit, vglmR)

## ------------------------------------------------------------------------
VGAM::lrtest(vglmFit, vglm0)

## ------------------------------------------------------------------------
vglmP  <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE,  reverse=TRUE),
              data=dfOrd)

# vglmNP <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=FALSE, reverse=TRUE),
#                data=dfOrd)
# VGAM::lrtest(vglmP, vglmNP)

## ------------------------------------------------------------------------
clmP  <- clm(Yord ~ X1 + X2, link="logit", data=dfOrd)

## model with non-proportional odds for X2:
clmNP <- clm(Yord ~ X1, nominal=~X2, data=dfOrd)
anova(clmP, clmNP)

## ------------------------------------------------------------------------
try(detach(package:ordinal))
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:lattice))
try(detach(package:survival))
try(detach(package:VGAM))
try(detach(package:splines))
try(detach(package:stats4))
try(detach(package:MASS))
try(detach(package:Formula))
try(detach(package:grid))
try(detach(package:SparseM))

