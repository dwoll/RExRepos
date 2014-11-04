
## ------------------------------------------------------------------------
wants <- c("car", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
N    <- 10
P    <- 2
Q    <- 3
muJK <- c(rep(c(1, -2), N), rep(c(2, 0), N), rep(c(3, 3), N))
dfRBFpqL <- data.frame(id =factor(rep(1:N, times=P*Q)),
                       IV1=factor(rep(rep(1:P, each=N), times=Q)),
                       IV2=factor(rep(rep(1:Q, each=N*P))),
                       DV =rnorm(N*P*Q, muJK, 2))


## ------------------------------------------------------------------------
aovRBFpq <- aov(DV ~ IV1*IV2 + Error(id/(IV1*IV2)), data=dfRBFpqL)
summary(aovRBFpq)


## ------------------------------------------------------------------------
dfTemp   <- reshape(dfRBFpqL, v.names="DV", timevar="IV1",
                    idvar=c("id", "IV2"), direction="wide")
dfRBFpqW <- reshape(dfTemp, v.names=c("DV.1", "DV.2"),
                    timevar="IV2", idvar="id", direction="wide")


## ------------------------------------------------------------------------
library(car)
fitRBFpq   <- lm(cbind(DV.1.1, DV.2.1, DV.1.2, DV.2.2, DV.1.3, DV.2.3) ~ 1,
                 data=dfRBFpqW)
inRBFpq    <- expand.grid(IV1=gl(P, 1), IV2=gl(Q, 1))
AnovaRBFpq <- Anova(fitRBFpq, idata=inRBFpq, idesign=~IV1*IV2)
summary(AnovaRBFpq, multivariate=FALSE, univariate=TRUE)


## ------------------------------------------------------------------------
anova(fitRBFpq, M=~IV1, X=~1, idata=inRBFpq, test="Spherical")
anova(fitRBFpq, M=~IV1 + IV2, X=~IV1, idata=inRBFpq, test="Spherical")
anova(fitRBFpq, M=~IV1 + IV2 + IV1:IV2, X=~IV1 + IV2,
      idata=inRBFpq, test="Spherical")


## ------------------------------------------------------------------------
mauchly.test(fitRBFpq, M=~IV1, X=~1, idata=inRBFpq)
mauchly.test(fitRBFpq, M=~IV1 + IV2, X=~IV1, idata=inRBFpq)
mauchly.test(fitRBFpq, M=~IV1 + IV2 + IV1:IV2, X=~IV1 + IV2, idata=inRBFpq)


## ------------------------------------------------------------------------
library(DescTools)
EtaSq(aovRBFpq, type=1)


## ------------------------------------------------------------------------
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==1)))
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==2)))
summary(aov(DV ~ IV1 + Error(id/IV1), data=dfRBFpqL, subset=(IV2==3)))


## ------------------------------------------------------------------------
library(car)
summary(AnovaRBFpq, multivariate=TRUE, univariate=FALSE)


## ------------------------------------------------------------------------
try(detach(package:car))
try(detach(package:DescTools))

