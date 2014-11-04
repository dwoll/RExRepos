
## ------------------------------------------------------------------------
wants <- c("car", "DescTools", "multcomp", "phia")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
Njk  <- 8
P    <- 2
Q    <- 3
muJK <- c(rep(c(1, -1), Njk), rep(c(2, 1), Njk), rep(c(3, 3), Njk))
dfCRFpq <- data.frame(IV1=factor(rep(1:P, times=Njk*Q)),
                      IV2=factor(rep(1:Q,  each=Njk*P)),
                      DV =rnorm(Njk*P*Q, muJK, 2))


## ------------------------------------------------------------------------
dfCRFpq$IVcomb <- interaction(dfCRFpq$IV1, dfCRFpq$IV2)


## ------------------------------------------------------------------------
aovCRFpq <- aov(DV ~ IV1*IV2, data=dfCRFpq)
summary(aovCRFpq)


## ------------------------------------------------------------------------
# change contrasts for SS type III
fitIII <- lm(DV ~ IV1 + IV2 + IV1:IV2, data=dfCRFpq,
             contrasts=list(IV1=contr.sum, IV2=contr.sum))
library(car)                           # for Anova()
Anova(fitIII, type="III")


## ----rerAnovaCRFpq01-----------------------------------------------------
plot.design(DV ~ IV1*IV2, data=dfCRFpq, main="Marginal means")
interaction.plot(dfCRFpq$IV1, dfCRFpq$IV2, dfCRFpq$DV,
                 main="Cell means", col=c("red", "blue", "green"), lwd=2)


## ------------------------------------------------------------------------
library(DescTools)
EtaSq(aovCRFpq, type=1)


## ------------------------------------------------------------------------
library(phia)
testInteractions(aovCRFpq, fixed="IV2", across="IV1", adjustment="none")
testInteractions(aovCRFpq, fixed="IV1", across="IV2", adjustment="none")


## ------------------------------------------------------------------------
cMat <- rbind("c1"=c( 1/2, 1/2, -1),
              "c2"=c(  -1,   0,  1))

library(multcomp)
summary(glht(aovCRFpq, linfct=mcp(IV2=cMat), alternative="two.sided"),
        test=adjusted("bonferroni"))


## ------------------------------------------------------------------------
aovCRF <- aov(DV ~ IV1 + IV2, data=dfCRFpq)
TukeyHSD(aovCRF, which="IV2")


## ------------------------------------------------------------------------
library(multcomp)
tukey <- glht(aovCRF, linfct=mcp(IV2="Tukey"))
summary(tukey)
confint(tukey)


## ------------------------------------------------------------------------
(aovCRFpqA <- aov(DV ~ IVcomb, data=dfCRFpq))
cntrMat <- rbind("c1"=c(-1/2,  1/4, -1/2, 1/4, 1/4, 1/4),
                 "c2"=c(   0,    0,   -1,   0,   1,   0),
                 "c3"=c(-1/2, -1/2,  1/4, 1/4, 1/4, 1/4))


## ------------------------------------------------------------------------
library(multcomp)
summary(glht(aovCRFpqA, linfct=mcp(IVcomb=cntrMat), alternative="greater"),
        test=adjusted("none"))


## ------------------------------------------------------------------------
library(DescTools)
ScheffeTest(aovCRFpqA, which="IVcomb", contrasts=t(cntrMat))


## ------------------------------------------------------------------------
library(DescTools)
ScheffeTest(aovCRFpq, which="IV2", contrasts=c(-1, 1/2, 1/2))


## ----rerAnovaCRFpq02-----------------------------------------------------
Estud <- rstudent(aovCRFpq)
qqnorm(Estud, pch=20, cex=2)
qqline(Estud, col="gray60", lwd=2)


## ------------------------------------------------------------------------
shapiro.test(Estud)


## ----rerAnovaCRFpq03-----------------------------------------------------
plot(Estud ~ dfCRFpq$IVcomb, main="Residuals per group")


## ------------------------------------------------------------------------
library(car)
leveneTest(aovCRFpq)


## ------------------------------------------------------------------------
try(detach(package:phia))
try(detach(package:car))
try(detach(package:multcomp))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:TH.data))
try(detach(package:DescTools))

