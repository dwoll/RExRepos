
## ------------------------------------------------------------------------
wants <- c("car", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
Njk   <- 10
P     <- 2
Q     <- 2
R     <- 3
DV_t1 <- rnorm(P*Q*Njk, -3, 2)
DV_t2 <- rnorm(P*Q*Njk,  1, 2)
DV_t3 <- rnorm(P*Q*Njk,  2, 2)
dfSPFpq.rL <- data.frame(id=factor(rep(1:(P*Q*Njk), times=R)),
                         IVbtw1=factor(rep(1:P, times=Q*R*Njk)),
                         IVbtw2=factor(rep(rep(1:Q, each=P*Njk), times=R)),
                         IVwth=factor(rep(1:R, each=P*Q*Njk)),
                         DV=c(DV_t1, DV_t2, DV_t3))


## ------------------------------------------------------------------------
aovSPFpq.r <- aov(DV ~ IVbtw1*IVbtw2*IVwth + Error(id/IVwth), data=dfSPFpq.rL)
summary(aovSPFpq.r)


## ------------------------------------------------------------------------
library(DescTools)
EtaSq(aovSPFpq.r, type=1)


## ------------------------------------------------------------------------
dfSPFpq.rW <- reshape(dfSPFpq.rL, v.names="DV", timevar="IVwth",
                      idvar=c("id", "IVbtw1", "IVbtw2"), direction="wide")


## ------------------------------------------------------------------------
library(car)
fitSPFpq.r   <- lm(cbind(DV.1, DV.2, DV.3) ~ IVbtw1*IVbtw2, data=dfSPFpq.rW)
inSPFpq.r    <- data.frame(IVwth=gl(R, 1))
AnovaSPFpq.r <- Anova(fitSPFpq.r, idata=inSPFpq.r, idesign=~IVwth)
summary(AnovaSPFpq.r, multivariate=FALSE, univariate=TRUE)


## ------------------------------------------------------------------------
anova(fitSPFpq.r, M=~1, X=~0, idata=inSPFpq.r, test="Spherical")
anova(fitSPFpq.r, M=~IVwth, X=~1, idata=inSPFpq.r, test="Spherical")


## ------------------------------------------------------------------------
mauchly.test(fitSPFpq.r, M=~IVwth, X=~1, idata=inSPFpq.r)


## ------------------------------------------------------------------------
Nj     <- 10
P      <- 2
Q      <- 3
R      <- 2
DV_t11 <- rnorm(P*Nj,  8, 2)
DV_t21 <- rnorm(P*Nj, 13, 2)
DV_t31 <- rnorm(P*Nj, 13, 2)
DV_t12 <- rnorm(P*Nj, 10, 2)
DV_t22 <- rnorm(P*Nj, 15, 2)
DV_t32 <- rnorm(P*Nj, 15, 2)
dfSPFp.qrL <- data.frame(id=factor(rep(1:(P*Nj), times=Q*R)),
                         IVbtw=factor(rep(LETTERS[1:P], times=Q*R*Nj)),
                         IVwth1=factor(rep(1:Q, each=P*R*Nj)),
                         IVwth2=factor(rep(rep(1:R, each=P*Nj), times=Q)),
                         DV=c(DV_t11, DV_t12, DV_t21, DV_t22, DV_t31, DV_t32))


## ------------------------------------------------------------------------
aovSPFp.qr <- aov(DV ~ IVbtw*IVwth1*IVwth2 + Error(id/(IVwth1*IVwth2)),
                  data=dfSPFp.qrL)
summary(aovSPFp.qr)


## ------------------------------------------------------------------------
library(DescTools)
EtaSq(aovSPFp.qr, type=1)


## ------------------------------------------------------------------------
dfW1       <- reshape(dfSPFp.qrL, v.names="DV", timevar="IVwth1",
                      idvar=c("id", "IVbtw", "IVwth2"), direction="wide")
dfSPFp.qrW <- reshape(dfW1, v.names=c("DV.1", "DV.2", "DV.3"),
                      timevar="IVwth2", idvar=c("id", "IVbtw"), direction="wide")


## ------------------------------------------------------------------------
library(car)
fitSPFp.qr   <- lm(cbind(DV.1.1, DV.2.1, DV.3.1, DV.1.2, DV.2.2, DV.3.2) ~ IVbtw,
                   data=dfSPFp.qrW)
inSPFp.qr    <- expand.grid(IVwth1=gl(Q, 1), IVwth2=gl(R, 1))
AnovaSPFp.qr <- Anova(fitSPFp.qr, idata=inSPFp.qr, idesign=~IVwth1*IVwth2)
summary(AnovaSPFp.qr, multivariate=FALSE, univariate=TRUE)


## ------------------------------------------------------------------------
anova(fitSPFp.qr, M=~1, X=~0,
      idata=inSPFp.qr, test="Spherical")
anova(fitSPFp.qr, M=~IVwth1, X=~1,
      idata=inSPFp.qr, test="Spherical")
anova(fitSPFp.qr, M=~IVwth1 + IVwth2, X=~IVwth1,
      idata=inSPFp.qr, test="Spherical")
anova(fitSPFp.qr, M=~IVwth1 + IVwth2 + IVwth1:IVwth2, X=~IVwth1 + IVwth2,
      idata=inSPFp.qr, test="Spherical")


## ------------------------------------------------------------------------
mauchly.test(fitSPFp.qr, M=~IVwth1, X=~1,
             idata=inSPFp.qr)


## ------------------------------------------------------------------------
mauchly.test(fitSPFp.qr, M=~IVwth1 + IVwth2, X=~IVwth1,
             idata=inSPFp.qr)
mauchly.test(fitSPFp.qr, M=~IVwth1 + IVwth2 + IVwth1:IVwth2, X=~IVwth1 + IVwth2,
             idata=inSPFp.qr)


## ------------------------------------------------------------------------
try(detach(package:car))
try(detach(package:DescTools))

