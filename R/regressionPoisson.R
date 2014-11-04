
## ----echo=FALSE----------------------------------------------------------
library(knitr)
opts_knit$set(self.contained=FALSE)
opts_chunk$set(tidy=FALSE, message=FALSE, warning=FALSE, comment=NA)
# render_jekyll()


## ------------------------------------------------------------------------
wants <- c("lmtest", "MASS", "mvtnorm", "pscl", "sandwich", "VGAM")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
library(mvtnorm)
set.seed(123)
N     <- 200
sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,8), byrow=TRUE, ncol=3)
mu    <- c(-3, 2, 4)
XY    <- rmvnorm(N, mean=mu, sigma=sigma)
Y     <- round(XY[ , 3] - 1.5)
Y[Y < 0] <- 0
dfCount <- data.frame(X1=XY[ , 1], X2=XY[ , 2], Y)


## ------------------------------------------------------------------------
glmFitP <- glm(Y ~ X1 + X2, family=poisson(link="log"), data=dfCount)
summary(glmFitP)


## ------------------------------------------------------------------------
exp(coef(glmFitP))


## ------------------------------------------------------------------------
exp(confint(glmFitP))


## ----results='hide'------------------------------------------------------
library(VGAM)
summary(vglmFit <- vglm(Y ~ X1 + X2, family=poissonff, data=dfCount))
# not shown


## ------------------------------------------------------------------------
Nt   <- 100
Ti   <- sample(20:40, Nt, replace=TRUE)
Xt   <- rnorm(Nt, 100, 15)
Yt   <- rbinom(Nt, size=Ti, prob=0.5)
glm(Yt ~ Xt, family=poisson(link="log"), offset=log(Ti))


## ------------------------------------------------------------------------
glmFitQP <- glm(Y ~ X1 + X2, family=quasipoisson(link="log"), data=dfCount)
summary(glmFitQP)


## ----results='hide'------------------------------------------------------
library(VGAM)
vglm(Y ~ X1 + X2, family=quasipoissonff, data=dfCount)
# not shown


## ------------------------------------------------------------------------
library(sandwich)
hcSE <- vcovHC(glmFitP, type="HC0")

library(lmtest)
coeftest(glmFitP, vcov=hcSE)


## ------------------------------------------------------------------------
library(MASS)
glmFitNB <- glm.nb(Y ~ X1 + X2, data=dfCount)
summary(glmFitNB)


## ----results='hide'------------------------------------------------------
library(VGAM)
vglm(Y ~ X1 + X2, family=negbinomial, data=dfCount)
# not shown


## ------------------------------------------------------------------------
library(pscl)
odTest(glmFitNB)


## ------------------------------------------------------------------------
library(pscl)
ziFitP <- zeroinfl(Y ~ X1 + X2 | 1, dist="poisson", data=dfCount)
summary(ziFitP)


## ----results='hide'------------------------------------------------------
library(VGAM)
vglm(Y ~ X1 + X2, family=zipoissonff, data=dfCount)
# not shown


## ------------------------------------------------------------------------
library(pscl)
vuong(ziFitP, glmFitP)


## ------------------------------------------------------------------------
ziFitNB <- zeroinfl(Y ~ X1 + X2 | 1, dist="negbin", data=dfCount)
summary(ziFitNB)


## ----results='hide'------------------------------------------------------
library(VGAM)
vglm(Y ~ X1 + X2, family=zinegbinomial, data=dfCount)
# not shown


## ------------------------------------------------------------------------
library(pscl)
vuong(ziFitNB, glmFitNB)


## ------------------------------------------------------------------------
try(detach(package:VGAM))
try(detach(package:sandwich))
try(detach(package:lmtest))
try(detach(package:zoo))
try(detach(package:pscl))
try(detach(package:mvtnorm))
try(detach(package:lattice))
try(detach(package:splines))
try(detach(package:stats4))
try(detach(package:MASS))

