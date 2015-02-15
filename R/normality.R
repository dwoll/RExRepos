## ------------------------------------------------------------------------
wants <- c("energy", "ICS", "mvtnorm")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ----rerNormality01------------------------------------------------------
set.seed(123)
DV <- rnorm(20, mean=1.5, sd=3)
qqnorm(DV, pch=20, cex=2)
qqline(DV, col="gray60", lwd=2)

## ------------------------------------------------------------------------
shapiro.test(DV)

## ------------------------------------------------------------------------
library(DescTools)
AndersonDarlingTest(DV)

## ------------------------------------------------------------------------
library(DescTools)
CramerVonMisesTest(DV)

## ------------------------------------------------------------------------
library(DescTools)
ShapiroFranciaTest(DV)

## ------------------------------------------------------------------------
library(DescTools)
JarqueBeraTest(DV)

## ------------------------------------------------------------------------
ks.test(DV, "pnorm", mean=1, sd=2, alternative="two.sided")

## ------------------------------------------------------------------------
library(DescTools)
LillieTest(DV)

## ------------------------------------------------------------------------
library(DescTools)
PearsonTest(DV, n.classes=6, adjust=TRUE)

## ------------------------------------------------------------------------
mu    <- c(2, 4, 5)
Sigma <- matrix(c(4,2,-3, 2,16,-1, -3,-1,9), byrow=TRUE, ncol=3)
library(mvtnorm)
X <- rmvnorm(100, mu, Sigma)

## ------------------------------------------------------------------------
library(energy)                    # for mvnorm.etest()
mvnorm.etest(X)

## ------------------------------------------------------------------------
library(ICS)
mvnorm.kur.test(X)

## ------------------------------------------------------------------------
library(ICS)
X <- rmvnorm(100, c(2, 4, 5))
mvnorm.skew.test(X)

## ------------------------------------------------------------------------
try(detach(package:DescTools))
try(detach(package:energy))
try(detach(package:ICS))
try(detach(package:mvtnorm))
try(detach(package:survey))
try(detach(package:CompQuadForm))

