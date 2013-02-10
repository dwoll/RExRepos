
## @knitr 
wants <- c("car", "ICSNP")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(123)
N      <- 10
P      <- 4
muJ    <- rep(c(-1, 0, 1, 2), each=N)
dfRBpL <- data.frame(id=factor(rep(1:N, times=P)),
                     IV=factor(rep(1:P,  each=N)),
                     DV=rnorm(N*P, muJ, 3))


## @knitr 
summary(aov(DV ~ IV + Error(id/IV), data=dfRBpL))


## @knitr 
(anRes <- anova(lm(DV ~ IV*id, data=dfRBpL)))


## @knitr 
SSEtot <- anRes["id", "Sum Sq"] + anRes["IV:id", "Sum Sq"]
SSb    <- anRes["IV", "Sum Sq"]


## @knitr 
(gEtaSq <- SSb / (SSb + SSEtot))


## @knitr 
dfRBpW <- reshape(dfRBpL, v.names="DV", timevar="IV", idvar="id",
                  direction="wide")


## @knitr 
library(car)
fitRBp   <- lm(cbind(DV.1, DV.2, DV.3, DV.4) ~ 1, data=dfRBpW)
inRBp    <- data.frame(IV=gl(P, 1))
AnovaRBp <- Anova(fitRBp, idata=inRBp, idesign=~IV)
summary(AnovaRBp, multivariate=FALSE, univariate=TRUE)


## @knitr 
anova(fitRBp, M=~IV, X=~1, idata=inRBp, test="Spherical")


## @knitr 
mauchly.test(fitRBp, M=~IV, X=~1, idata=inRBp)


## @knitr 
DVw     <- data.matrix(subset(dfRBpW,
                       select=c("DV.1", "DV.2", "DV.3", "DV.4")))
diffMat <- combn(1:P, 2, function(x) { DVw[ , x[1]] - DVw[ , x[2]] } )
DVdiff  <- diffMat[ , 1:(P-1), drop=FALSE]
muH0    <- rep(0, ncol(DVdiff))


## @knitr 
library(ICSNP)
HotellingsT2(DVdiff, mu=muH0)


## @knitr 
library(car)
summary(AnovaRBp, multivariate=TRUE, univariate=FALSE)


## @knitr 
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:ICSNP))
try(detach(package:ICS))
try(detach(package:survey))
try(detach(package:mvtnorm))


