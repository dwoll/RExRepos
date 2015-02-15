## ------------------------------------------------------------------------
wants <- c("rms")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
SSRIpre  <- c(18, 16, 16, 15, 14, 20, 14, 21, 25, 11)
SSRIpost <- c(12,  0, 10,  9,  0, 11,  2,  4, 15, 10)
PlacPre  <- c(18, 16, 15, 14, 20, 25, 11, 25, 11, 22)
PlacPost <- c(11,  4, 19, 15,  3, 14, 10, 16, 10, 20)
WLpre    <- c(15, 19, 10, 29, 24, 15,  9, 18, 22, 13)
WLpost   <- c(17, 25, 10, 22, 23, 10,  2, 10, 14,  7)

P        <- 3
Nj       <- rep(length(SSRIpre), times=P)
IV       <- factor(rep(1:P, Nj), labels=c("SSRI", "Placebo", "WL"))
DVpre    <- c(SSRIpre,  PlacPre,  WLpre)
DVpost   <- c(SSRIpost, PlacPost, WLpost)
postFac  <- cut(DVpost, breaks=c(-Inf, median(DVpost), Inf),
                        labels=c("lo", "hi"))
dfAncova <- data.frame(IV, DVpre, DVpost, postFac)

## ----rerRegressionLogistic01---------------------------------------------
cdplot(postFac ~ DVpre, data=dfAncova, subset=IV == "SSRI",
       main="Estimated categ probs SSRI")
cdplot(postFac ~ DVpre, data=dfAncova, subset=IV == "Placebo",
       main="Estimated categ probs placebo")
cdplot(postFac ~ DVpre, data=dfAncova, subset=IV == "WL",
       main="Estimated categ probs WL")

## ------------------------------------------------------------------------
(glmFit <- glm(postFac ~ DVpre + IV, family=binomial(link="logit"), data=dfAncova))

## ------------------------------------------------------------------------
exp(coef(glmFit))

## ------------------------------------------------------------------------
exp(confint(glmFit))

## ------------------------------------------------------------------------
N      <- 100
x1     <- rnorm(N, 100, 15)
x2     <- rnorm(N, 10, 3)
total  <- sample(40:60, N, replace=TRUE)
hits   <- rbinom(N, total, prob=0.4)
hitMat <- cbind(hits, total-hits)
glm(hitMat ~ x1 + x2, family=binomial(link="logit"))

## ------------------------------------------------------------------------
relHits <- hits/total
glm(relHits ~ x1 + x2, weights=total, family=binomial(link="logit"))

## ----rerRegressionLogistic02---------------------------------------------
logitHat <- predict(glmFit, type="link")
plot(logitHat, pch=16, col=c("red", "blue")[unclass(dfAncova$postFac)])
abline(h=0)

## ------------------------------------------------------------------------
Phat <- fitted(glmFit)
Phat <- predict(glmFit, type="response")
head(Phat)
mean(Phat)
prop.table(xtabs(~ postFac, data=dfAncova))

## ------------------------------------------------------------------------
thresh <- 0.5
facHat <- cut(Phat, breaks=c(-Inf, thresh, Inf), labels=c("lo", "hi"))
cTab   <- xtabs(~ postFac + facHat, data=dfAncova)
addmargins(cTab)

## ------------------------------------------------------------------------
(CCR <- sum(diag(cTab)) / sum(cTab))

## ------------------------------------------------------------------------
deviance(glmFit)
logLik(glmFit)
AIC(glmFit)

## ------------------------------------------------------------------------
library(rms)
lrm(postFac ~ DVpre + IV, data=dfAncova)

## ------------------------------------------------------------------------
N    <- nobs(glmFit)
glm0 <- update(glmFit, . ~ 1)
LLf  <- logLik(glmFit)
LL0  <- logLik(glm0)

## ------------------------------------------------------------------------
as.vector(1 - (LLf / LL0))

## ------------------------------------------------------------------------
as.vector(1 - exp((2/N) * (LL0 - LLf)))

## ------------------------------------------------------------------------
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))

## ------------------------------------------------------------------------
Nnew  <- 3
dfNew <- data.frame(DVpre=rnorm(Nnew, 20, sd=7),
                    IV=factor(rep("SSRI", Nnew), levels=levels(dfAncova$IV)))
predict(glmFit, newdata=dfNew, type="response")

## ------------------------------------------------------------------------
summary(glmFit)

## ------------------------------------------------------------------------
anova(glm0, glmFit, test="Chisq")

## ------------------------------------------------------------------------
drop1(glmFit, test="Chi")

## ------------------------------------------------------------------------
glmPre <- update(glmFit, . ~ . - IV) # no IV factor
anova(glmPre, glmFit, test="Chisq")

## ------------------------------------------------------------------------
anova(glm0, glmPre, test="Chisq")

## ------------------------------------------------------------------------
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:grid))
try(detach(package:lattice))
try(detach(package:survival))
try(detach(package:splines))
try(detach(package:Formula))

