
## @knitr 
wants <- c("mvtnorm", "MASS")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
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


## @knitr 
library(MASS)
(ldaRes <- lda(IV ~ DV1 + DV2, data=Ydf))


## @knitr 
ldaP <- lda(IV ~ DV1 + DV2, CV=TRUE, data=Ydf)
head(ldaP$posterior)


## @knitr 
ldaPred <- predict(ldaRes, Ydf)
ld      <- ldaPred$x
head(ld)


## @knitr 
cls <- ldaPred$class
head(cls)


## @knitr 
cTab <- table(IV, cls, dnn=c("IV", "ldaPred"))
addmargins(cTab)
sum(diag(cTab)) / sum(cTab)


## @knitr 
anova(lm(ld[ , 1] ~ IV))
anova(lm(ld[ , 2] ~ IV))


## @knitr 
priorP <- rep(1/nlevels(IV), nlevels(IV))
ldaEq  <- lda(IV ~ DV1 + DV2, prior=priorP, data=Ydf)


## @knitr 
library(MASS)
(ldaRob <- lda(IV ~ DV1 + DV2, method="mve", data=Ydf))
predict(ldaRob)$class


## @knitr 
library(MASS)
(qdaRes <- qda(IV ~ DV1 + DV2, data=Ydf))
predict(qdaRes)$class


## @knitr 
try(detach(package:MASS))
try(detach(package:mvtnorm))


