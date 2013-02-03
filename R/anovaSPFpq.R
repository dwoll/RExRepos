
## @knitr 
wants <- c("car", "multcomp")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
Nj   <- 10
P    <- 3
Q    <- 3
muJK <- c(rep(c(1,-1,-2), Nj), rep(c(2,1,-1), Nj), rep(c(3,3,0), Nj))
dfSPFpqL <- data.frame(id=factor(rep(1:(P*Nj), times=Q)),
                       IVbtw=factor(rep(LETTERS[1:P], times=Q*Nj)),
                       IVwth=factor(rep(1:Q, each=P*Nj)),
                       DV=rnorm(Nj*P*Q, muJK, 3))


## @knitr 
summary(aov(DV ~ IVbtw*IVwth + Error(id/IVwth), data=dfSPFpqL))


## @knitr 
dfSPFpqW <- reshape(dfSPFpqL, v.names="DV", timevar="IVwth",
                    idvar=c("id", "IVbtw"), direction="wide")


## @knitr 
library(car)
fitSPFpq   <- lm(cbind(DV.1, DV.2, DV.3) ~ IVbtw, data=dfSPFpqW)
inSPFpq    <- data.frame(IVwth=gl(Q, 1))
AnovaSPFpq <- Anova(fitSPFpq, idata=inSPFpq, idesign=~IVwth)
summary(AnovaSPFpq, multivariate=FALSE, univariate=TRUE)


## @knitr 
anova(fitSPFpq, M=~1, X=~0, idata=inSPFpq, test="Spherical")
anova(fitSPFpq, M=~IVwth, X=~1, idata=inSPFpq, test="Spherical")


## @knitr 
mauchly.test(fitSPFpq, M=~IVwth, X=~1, idata=inSPFpq)


## @knitr 
(anRes <- anova(lm(DV ~ IVbtw*IVwth*id, data=dfSPFpqL)))


## @knitr 
SSEtot <- anRes["id", "Sum Sq"] + anRes["IVwth:id", "Sum Sq"]
SSbtw  <- anRes["IVbtw", "Sum Sq"]
SSwth  <- anRes["IVwth", "Sum Sq"]
SSI    <- anRes["IVbtw:IVwth", "Sum Sq"]


## @knitr 
(gEtaSqB <- SSbtw / (SSbtw + SSEtot))
(gEtaSqW <- SSwth / (SSwth + SSEtot))
(gEtaSqI <- SSI   / (SSI   + SSEtot))


## @knitr 
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==1)))
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==2)))
summary(aov(DV ~ IVbtw, data=dfSPFpqL, subset=(IVwth==3)))


## @knitr 
summary(aov(DV ~ IVwth + Error(id/IVwth), data=dfSPFpqL,
        subset=(IVbtw=="A")))
summary(aov(DV ~ IVwth + Error(id/IVwth), data=dfSPFpqL,
        subset=(IVbtw=="B")))
summary(aov(DV ~ IVwth + Error(id/IVwth), data=dfSPFpqL,
        subset=(IVbtw=="C")))


## @knitr 
mDf    <- aggregate(DV ~ id + IVbtw, data=dfSPFpqL, FUN=mean)
aovRes <- aov(DV ~ IVbtw, data=mDf)


## @knitr 
cMat <- rbind("-0.5*(A+B)+C"=c(-1/2, -1/2, 1),
                       "A-C"=c(-1,    0,   1))


## @knitr 
library(multcomp)
summary(glht(aovRes, linfct=mcp(IVbtw=cMat), alternative="greater"),
        test=adjusted("none"))


## @knitr 
try(detach(package:multcomp))
try(detach(package:mvtnorm))
try(detach(package:car))
try(detach(package:survival))
try(detach(package:splines))
try(detach(package:nnet))
try(detach(package:MASS))


