
## ------------------------------------------------------------------------
wants <- c("car", "mvtnorm")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
P     <- 3
Nj    <- c(15, 25, 20)
Sigma <- matrix(c(16,-2, -2,9), byrow=TRUE, ncol=2)
mu11  <- c(-4,  4)
mu21  <- c( 3,  3)
mu31  <- c( 1, -1)

library(mvtnorm)
Y11 <- round(rmvnorm(Nj[1], mean=mu11, sigma=Sigma))
Y21 <- round(rmvnorm(Nj[2], mean=mu21, sigma=Sigma))
Y31 <- round(rmvnorm(Nj[3], mean=mu31, sigma=Sigma))

dfMan1 <- data.frame(Y =rbind(Y11, Y21, Y31),
                     IV=factor(rep(1:P, Nj)))


## ------------------------------------------------------------------------
manRes1 <- manova(cbind(Y.1, Y.2) ~ IV, data=dfMan1)
summary(manRes1, test="Wilks")


## ----results='hide'------------------------------------------------------
summary(manRes1, test="Roy")
summary(manRes1, test="Pillai")
summary(manRes1, test="Hotelling-Lawley")


## ------------------------------------------------------------------------
Q    <- 2
mu12 <- c(-1,  4)
mu22 <- c( 4,  8)
mu32 <- c( 4,  0)

library(mvtnorm)
Y12  <- round(rmvnorm(Nj[1], mean=mu12, sigma=Sigma))
Y22  <- round(rmvnorm(Nj[2], mean=mu22, sigma=Sigma))
Y32  <- round(rmvnorm(Nj[3], mean=mu32, sigma=Sigma))

dfMan2 <- data.frame(Y  =rbind(Y11, Y21, Y31, Y12, Y22, Y32),
                     IV1=factor(rep(rep(1:P, Nj), Q)),
                     IV2=factor(rep(1:Q, each=sum(Nj))))


## ------------------------------------------------------------------------
manRes2 <- manova(cbind(Y.1, Y.2) ~ IV1*IV2, data=dfMan2)
summary(manRes2, test="Pillai")


## ----results='hide'------------------------------------------------------
summary(manRes2, test="Wilks")
summary(manRes2, test="Roy")
summary(manRes2, test="Hotelling-Lawley")


## ------------------------------------------------------------------------
library(car)
fitIII <- lm(cbind(Y.1, Y.2) ~ IV1*IV2, data=dfMan2,
             contrasts=list(IV1=contr.sum, IV2=contr.sum))
ManRes <- Manova(fitIII, type="III")
summary(ManRes, multivariate=TRUE)


## ------------------------------------------------------------------------
try(detach(package:mvtnorm))
try(detach(package:car))

