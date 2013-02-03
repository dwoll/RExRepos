
## @knitr 
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
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


## @knitr 
summary(aov(DV ~ IVbtw1*IVbtw2*IVwth + Error(id/IVwth), data=dfSPFpq.rL))


## @knitr 
anRes     <- anova(lm(DV ~ IVbtw1*IVbtw2*IVwth*id, data=dfSPFpq.rL))
SSEtot    <- anRes["id", "Sum Sq"] + anRes["IVwth:id", "Sum Sq"]
SSbtw1    <- anRes["IVbtw1",       "Sum Sq"]
SSbtw2    <- anRes["IVbtw2",       "Sum Sq"]
SSwth     <- anRes["IVwth",        "Sum Sq"]
SSbtw1Wth <- anRes["IVbtw1:IVwth", "Sum Sq"]
SSbtw2Wth <- anRes["IVbtw2:IVwth", "Sum Sq"]


## @knitr 
(gEtaSqB1 <- SSbtw1 / (SSbtw1 + SSEtot))
(gEtaSqB2 <- SSbtw2 / (SSbtw2 + SSEtot))
(gEtaSqW <- SSwth / (SSwth + SSEtot))
(gEtaSqB1W <- SSbtw1Wth / (SSbtw1Wth + SSEtot))
(gEtaSqB2W <- SSbtw2Wth / (SSbtw2Wth + SSEtot))


## @knitr 
anRes2        <- anova(lm(DV ~ IVbtw1*IVbtw2*IVwth, data=dfSPFpq.rL))
SSbtw1Btw2    <- anRes2["IVbtw1:IVbtw2",       "Sum Sq"]
SSbtw1Btw2Wth <- anRes2["IVbtw1:IVbtw2:IVwth", "Sum Sq"]


## @knitr 
(gEtaSqB1B2 <- SSbtw1Btw2 / (SSbtw1Btw2 + SSEtot))
(gEtaSqB1B2W <- SSbtw1Btw2Wth / (SSbtw1Btw2Wth + SSEtot))


## @knitr 
dfSPFpq.rW <- reshape(dfSPFpq.rL, v.names="DV", timevar="IVwth",
                      idvar=c("id", "IVbtw1", "IVbtw2"), direction="wide")


## @knitr 
library(car)
fitSPFpq.r   <- lm(cbind(DV.1, DV.2, DV.3) ~ IVbtw1*IVbtw2, data=dfSPFpq.rW)
inSPFpq.r    <- data.frame(IVwth=gl(R, 1))
AnovaSPFpq.r <- Anova(fitSPFpq.r, idata=inSPFpq.r, idesign=~IVwth)
summary(AnovaSPFpq.r, multivariate=FALSE, univariate=TRUE)


## @knitr 
anova(fitSPFpq.r, M=~1, X=~0, idata=inSPFpq.r, test="Spherical")
anova(fitSPFpq.r, M=~IVwth, X=~1, idata=inSPFpq.r, test="Spherical")


## @knitr 
mauchly.test(fitSPFpq.r, M=~IVwth, X=~1, idata=inSPFpq.r)


## @knitr 
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


## @knitr 
summary(aov(DV ~ IVbtw*IVwth1*IVwth2 + Error(id/(IVwth1*IVwth2)),
            data=dfSPFp.qrL))


## @knitr 
anRes  <- anova(lm(DV ~ IVbtw*IVwth1*IVwth2*id, data=dfSPFp.qrL))
SSEtot <- anRes["id",               "Sum Sq"] +
          anRes["IVwth1:id",        "Sum Sq"] +
          anRes["IVwth2:id",        "Sum Sq"] +
          anRes["IVwth1:IVwth2:id", "Sum Sq"]


## @knitr 
SSbtw         <- anRes["IVbtw",               "Sum Sq"]
SSwth1        <- anRes["IVwth1",              "Sum Sq"]
SSwth2        <- anRes["IVwth2",              "Sum Sq"]
SSbtwWth1     <- anRes["IVbtw:IVwth1",        "Sum Sq"]
SSbtwWth2     <- anRes["IVbtw:IVwth2",        "Sum Sq"]
SSwth1Wth2    <- anRes["IVwth1:IVwth2",       "Sum Sq"]
SSbtwWth1Wth2 <- anRes["IVbtw:IVwth1:IVwth2", "Sum Sq"]


## @knitr 
(gEtaSqB  <- SSbtw / (SSbtw + SSEtot))
(gEtaSqW1 <- SSwth1 / (SSwth1 + SSEtot))
(gEtaSqBW1 <- SSbtwWth1 / (SSbtwWth1 + SSEtot))
(gEtaSqW2 <- SSwth2 / (SSwth2 + SSEtot))
(gEtaSqBW2 <- SSbtwWth2 / (SSbtwWth2 + SSEtot))
(gEtaSqW1W2 <- SSwth1Wth2 / (SSwth1Wth2 + SSEtot))
(gEtaSqBW1W2 <- SSbtwWth1Wth2 / (SSbtwWth1Wth2 + SSEtot))


## @knitr 
dfW1       <- reshape(dfSPFp.qrL, v.names="DV", timevar="IVwth1",
                      idvar=c("id", "IVbtw", "IVwth2"), direction="wide")
dfSPFp.qrW <- reshape(dfW1, v.names=c("DV.1", "DV.2", "DV.3"),
                      timevar="IVwth2", idvar=c("id", "IVbtw"), direction="wide")


## @knitr 
library(car)
fitSPFp.qr   <- lm(cbind(DV.1.1, DV.2.1, DV.3.1, DV.1.2, DV.2.2, DV.3.2) ~ IVbtw,
                   data=dfSPFp.qrW)
inSPFp.qr    <- expand.grid(IVwth1=gl(Q, 1), IVwth2=gl(R, 1))
AnovaSPFp.qr <- Anova(fitSPFp.qr, idata=inSPFp.qr, idesign=~IVwth1*IVwth2)
summary(AnovaSPFp.qr, multivariate=FALSE, univariate=TRUE)


## @knitr 
anova(fitSPFp.qr, M=~1, X=~0,
      idata=inSPFp.qr, test="Spherical")
anova(fitSPFp.qr, M=~IVwth1, X=~1,
      idata=inSPFp.qr, test="Spherical")
anova(fitSPFp.qr, M=~IVwth1 + IVwth2, X=~IVwth1,
      idata=inSPFp.qr, test="Spherical")
anova(fitSPFp.qr, M=~IVwth1 + IVwth2 + IVwth1:IVwth2, X=~IVwth1 + IVwth2,
      idata=inSPFp.qr, test="Spherical")


## @knitr 
mauchly.test(fitSPFp.qr, M=~IVwth1, X=~1,
             idata=inSPFp.qr)


## @knitr 
mauchly.test(fitSPFp.qr, M=~IVwth1 + IVwth2, X=~IVwth1,
             idata=inSPFp.qr)
mauchly.test(fitSPFp.qr, M=~IVwth1 + IVwth2 + IVwth1:IVwth2, X=~IVwth1 + IVwth2,
             idata=inSPFp.qr)


## @knitr 
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))


