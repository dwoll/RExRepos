
## ------------------------------------------------------------------------
wants <- c("car", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
N      <- 10
P      <- 4
muJ    <- rep(c(-1, 0, 1, 2), each=N)
dfRBpL <- data.frame(id=factor(rep(1:N, times=P)),
                     IV=factor(rep(1:P,  each=N)),
                     DV=rnorm(N*P, muJ, 3))


## ------------------------------------------------------------------------
aovRBp <- aov(DV ~ IV + Error(id/IV), data=dfRBpL)
summary(aovRBp)


## ------------------------------------------------------------------------
library(DescTools)
EtaSq(aovRBp, type=1)


## ------------------------------------------------------------------------
dfRBpW <- reshape(dfRBpL, v.names="DV", timevar="IV", idvar="id",
                  direction="wide")


## ------------------------------------------------------------------------
library(car)
fitRBp   <- lm(cbind(DV.1, DV.2, DV.3, DV.4) ~ 1, data=dfRBpW)
inRBp    <- data.frame(IV=gl(P, 1))
AnovaRBp <- Anova(fitRBp, idata=inRBp, idesign=~IV)
summary(AnovaRBp, multivariate=FALSE, univariate=TRUE)


## ------------------------------------------------------------------------
anova(fitRBp, M=~IV, X=~1, idata=inRBp, test="Spherical")


## ------------------------------------------------------------------------
mauchly.test(fitRBp, M=~IV, X=~1, idata=inRBp)


## ------------------------------------------------------------------------
DVw     <- data.matrix(subset(dfRBpW,
                       select=c("DV.1", "DV.2", "DV.3", "DV.4")))
diffMat <- combn(1:P, 2, function(x) { DVw[ , x[1]] - DVw[ , x[2]] } )
DVdiff  <- diffMat[ , 1:(P-1), drop=FALSE]
muH0    <- rep(0, ncol(DVdiff))


## ------------------------------------------------------------------------
library(DescTools)
HotellingsT2Test(DVdiff, mu=muH0)


## ------------------------------------------------------------------------
library(car)
summary(AnovaRBp, multivariate=TRUE, univariate=FALSE)


## ------------------------------------------------------------------------
try(detach(package:car))
try(detach(package:DescTools))

