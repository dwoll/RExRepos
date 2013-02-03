
## @knitr 
wants <- c("energy", "ICS", "mvtnorm", "nortest", "QuantPsyc", "tseries")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr rerNormality01
set.seed(1.234)
DV <- rnorm(20, mean=1.5, sd=3)
qqnorm(DV, pch=20, cex=2)
qqline(DV, col="gray60", lwd=2)


## @knitr 
shapiro.test(DV)


## @knitr 
library(nortest)
ad.test(DV)


## @knitr 
library(nortest)
cvm.test(DV)


## @knitr 
library(nortest)
sf.test(DV)


## @knitr 
library(tseries)
jarque.bera.test(DV)


## @knitr 
ks.test(DV, "pnorm", mean=1, sd=2, alternative="two.sided")


## @knitr 
library(nortest)
lillie.test(DV)


## @knitr 
library(nortest)
pearson.test(DV, n.classes=6, adjust=TRUE)


## @knitr 
mu    <- c(2, 4, 5)
Sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,9), byrow=TRUE, ncol=3)
library(mvtnorm)
X <- rmvnorm(100, mu, Sigma)


## @knitr 
library(energy)                    # for mvnorm.etest()
mvnorm.etest(X)


## @knitr 
library(QuantPsyc)                 # for mult.norm()
mn <- mult.norm(X, chicrit=0.001)
mn$mult.test


## @knitr 
library(ICS)
mvnorm.kur.test(X)


## @knitr 
library(ICS)
X <- rmvnorm(100, c(2, 4, 5))
mvnorm.skew.test(X)


## @knitr 
try(detach(package:nortest))
try(detach(package:QuantPsyc))
try(detach(package:tseries))
try(detach(package:energy))
try(detach(package:boot))
try(detach(package:MASS))
try(detach(package:ICS))
try(detach(package:mvtnorm))
try(detach(package:survey))


