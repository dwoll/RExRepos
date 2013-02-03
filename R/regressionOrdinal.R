
## @knitr echo=FALSE
library(knitr)
opts_knit$set(self.contained=FALSE)
opts_chunk$set(tidy=FALSE, message=FALSE, warning=FALSE, comment=NA)
# render_jekyll()


## @knitr 
wants <- c("MASS", "ordinal", "rms", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr regressionOrdinalDf, cache=TRUE
set.seed(2.234)
N     <- 100
X1    <- rnorm(N, 175, 7)
X2    <- rnorm(N,  30, 8)
Ycont <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Yord  <- cut(Ycont, breaks=quantile(Ycont), include.lowest=TRUE,
             labels=c("--", "-", "+", "++"), ordered=TRUE)
dfOrd <- data.frame(X1, X2, Yord)


## @knitr 
library(VGAM)
(vglmFit <- vglm(Yord ~ X1 + X2, family=propodds, data=dfOrd))


## @knitr results='hide'
vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE, reverse=TRUE), data=dfOrd)
# not shown


## @knitr results='hide'
vglm(Yord ~ X1 + X2, family=acat(parallel=TRUE), data=dfOrd)
# not shown


## @knitr results='hide'
vglm(Yord ~ X1 + X2, family=sratio(parallel=TRUE), data=dfOrd)
# not shown


## @knitr 
library(rms)
(lrmFit <- lrm(Yord ~ X1 + X2, data=dfOrd))


## @knitr regressionOrdinalPolrFit, results='hide', cache=TRUE
library(MASS)
(polrFit <- polr(Yord ~ X1 + X2, method="logistic", data=dfOrd))
# not shown


## @knitr dependson=c("regressionOrdinalDf", "regressionOrdinalPolrFit")
exp(confint(polrFit))


## @knitr results='hide'
library(ordinal)
(clmFit <- clm(Yord ~ X1 + X2, link="logit", data=dfOrd))
# not shown


## @knitr 
PhatCateg <- predict(vglmFit, type="response")
head(PhatCateg)


## @knitr results='hide'
predict(lrmFit, type="fitted.ind")
predict(clmFit, subset(dfOrd, select=c("X1", "X2"), type="prob"))$fit
predict(polrFit, type="probs")
# not shown


## @knitr 
categHat <- levels(dfOrd$Yord)[max.col(PhatCateg)]
head(categHat)


## @knitr results='hide'
predict(clmFit, type="class")
predict(polrFit, type="class")
# not shown


## @knitr 
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7),
                    X2=rnorm(Nnew,  30, 8))


## @knitr 
predict(vglmFit, dfNew, type="response")


## @knitr results='hide'
predict(lrmFit,  dfNew, type="fitted.ind")
predict(polrFit, dfNew, type="probs")
predict(clmFit,  subset(dfNew, select=c("X1", "X2"), type="prob"))$fit
# not shown


## @knitr 
facHat <- factor(categHat, levels=levels(dfOrd$Yord))
cTab   <- table(dfOrd$Yord, facHat, dnn=c("Yord", "facHat"))
addmargins(cTab)


## @knitr 
(CCR <- sum(diag(cTab)) / sum(cTab))


## @knitr 
deviance(vglmFit)
logLik(vglmFit)
AIC(vglmFit)


## @knitr 
vglm0 <- vglm(Yord ~ 1, family=propodds, data=dfOrd)
LLf   <- logLik(vglmFit)
LL0   <- logLik(vglm0)


## @knitr 
as.vector(1 - (LLf / LL0))


## @knitr 
as.vector(1 - exp((2/N) * (LL0 - LLf)))


## @knitr 
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))


## @knitr 
sumOrd   <- summary(vglmFit)
(coefOrd <- coef(sumOrd))


## @knitr 
zCrit   <- qnorm(c(0.05/2, 1 - 0.05/2))
(ciCoef <- t(apply(coefOrd, 1, function(x) x["Estimate"] - zCrit*x["Std. Error"] )))


## @knitr 
2*(1 - pnorm(abs(coefOrd[ , "z value"])))


## @knitr results='hide', dependson=c("regressionOrdinalDf", "regressionOrdinalPolrFit")
summary(polrFit)
summary(clmFit)
# not shown


## @knitr 
vglmR <- vglm(Yord ~ X1, family=propodds, data=dfOrd)
VGAM::lrtest(vglmFit, vglmR)


## @knitr 
VGAM::lrtest(vglmFit, vglm0)


## @knitr 
vglmP <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=TRUE,  reverse=TRUE),
              data=dfOrd)

vglmNP <- vglm(Yord ~ X1 + X2, family=cumulative(parallel=FALSE, reverse=TRUE),
                data=dfOrd)
VGAM::lrtest(vglmP, vglmNP)


## @knitr 
try(detach(package:ordinal))
try(detach(package:ucminf))
try(detach(package:Matrix))
try(detach(package:lattice))
try(detach(package:MASS))
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:survival))
try(detach(package:VGAM))
try(detach(package:splines))
try(detach(package:stats4))


