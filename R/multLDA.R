## ------------------------------------------------------------------------
wants <- c("mvtnorm", "MASS")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
library(mvtnorm)
Nj    <- c(15, 25, 20)
Sigma <- matrix(c(16,-2, -2,9), byrow=TRUE, ncol=2)
mu1   <- c(-4,  4)
mu2   <- c( 3,  3)
mu3   <- c( 1, -1)
Y1    <- rmvnorm(Nj[1], mean=mu1, sigma=Sigma)
Y2    <- rmvnorm(Nj[2], mean=mu2, sigma=Sigma)
Y3    <- rmvnorm(Nj[3], mean=mu3, sigma=Sigma)
Y     <- rbind(Y1, Y2, Y3)
IV    <- factor(rep(1:length(Nj), Nj))
Ydf   <- data.frame(IV, DV1=Y[ , 1], DV2=Y[ , 2])

## ------------------------------------------------------------------------
library(MASS)
(ldaRes <- lda(IV ~ DV1 + DV2, data=Ydf))

## ------------------------------------------------------------------------
ldaP <- lda(IV ~ DV1 + DV2, CV=TRUE, data=Ydf)
head(ldaP$posterior)

## ------------------------------------------------------------------------
ldaPred <- predict(ldaRes, Ydf)
ld      <- ldaPred$x
head(ld)

## ------------------------------------------------------------------------
cls <- ldaPred$class
head(cls)

## ------------------------------------------------------------------------
cTab <- table(IV, cls, dnn=c("IV", "ldaPred"))
addmargins(cTab)
sum(diag(cTab)) / sum(cTab)

## ------------------------------------------------------------------------
anova(lm(ld[ , 1] ~ IV))
anova(lm(ld[ , 2] ~ IV))

## ------------------------------------------------------------------------
priorP <- rep(1/nlevels(IV), nlevels(IV))
ldaEq  <- lda(IV ~ DV1 + DV2, prior=priorP, data=Ydf)

## ------------------------------------------------------------------------
library(MASS)
(ldaRob <- lda(IV ~ DV1 + DV2, method="mve", data=Ydf))
predict(ldaRob)$class

## ------------------------------------------------------------------------
library(MASS)
(qdaRes <- qda(IV ~ DV1 + DV2, data=Ydf))
predict(qdaRes)$class

## ------------------------------------------------------------------------
try(detach(package:MASS))
try(detach(package:mvtnorm))

