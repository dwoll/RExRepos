## ------------------------------------------------------------------------
wants <- c("car", "DescTools", "multcomp")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
P     <- 4
Nj    <- c(41, 37, 42, 40)
muJ   <- rep(c(-1, 0, 1, 2), Nj)
dfCRp <- data.frame(IV=factor(rep(LETTERS[1:P], Nj)),
                    DV=rnorm(sum(Nj), muJ, 5))

## ----rerAnovaCRp01-------------------------------------------------------
plot.design(DV ~ IV, fun=mean, data=dfCRp, main="Group means")

## ------------------------------------------------------------------------
oneway.test(DV ~ IV, data=dfCRp, var.equal=TRUE)

## ------------------------------------------------------------------------
oneway.test(DV ~ IV, data=dfCRp, var.equal=FALSE)

## ------------------------------------------------------------------------
aovCRp <- aov(DV ~ IV, data=dfCRp)
summary(aovCRp)
model.tables(aovCRp, type="means")

## ------------------------------------------------------------------------
(anovaCRp <- anova(lm(DV ~ IV, data=dfCRp)))

## ------------------------------------------------------------------------
anova(lm(DV ~ 1, data=dfCRp), lm(DV ~ IV, data=dfCRp))

## ------------------------------------------------------------------------
anovaCRp["Residuals", "Sum Sq"]

## ------------------------------------------------------------------------
dfSSb <- anovaCRp["IV",        "Df"]
SSb   <- anovaCRp["IV",        "Sum Sq"]
MSb   <- anovaCRp["IV",        "Mean Sq"]
SSw   <- anovaCRp["Residuals", "Sum Sq"]
MSw   <- anovaCRp["Residuals", "Mean Sq"]

## ------------------------------------------------------------------------
(etaSq <- SSb / (SSb + SSw))
library(DescTools)                     # for EtaSq()
EtaSq(aovCRp, type=1)

## ------------------------------------------------------------------------
(omegaSq <- dfSSb * (MSb-MSw) / (SSb + SSw + MSw))
(f <- sqrt(etaSq / (1-etaSq)))

## ------------------------------------------------------------------------
cntrMat <- rbind("A-D"          =c(  1,   0,   0,  -1),
                 "1/3*(A+B+C)-D"=c(1/3, 1/3, 1/3,  -1),
                 "B-C"          =c(  0,   1,  -1,   0))
library(multcomp)                      # for glht()
summary(glht(aovCRp, linfct=mcp(IV=cntrMat), alternative="less"),
        test=adjusted("none"))

## ------------------------------------------------------------------------
pairwise.t.test(dfCRp$DV, dfCRp$IV, p.adjust.method="bonferroni")

## ------------------------------------------------------------------------
library(DescTools)                  # for ScheffeTest()
ScheffeTest(aovCRp, which="IV", contrasts=t(cntrMat))

## ------------------------------------------------------------------------
(tHSD <- TukeyHSD(aovCRp))

## ----rerAnovaCRp02-------------------------------------------------------
plot(tHSD)

## ------------------------------------------------------------------------
library(multcomp)                      # for glht()
tukey <- glht(aovCRp, linfct=mcp(IV="Tukey"))
summary(tukey)
confint(tukey)

## ----rerAnovaCRp03-------------------------------------------------------
Estud <- rstudent(aovCRp)
qqnorm(Estud, pch=20, cex=2)
qqline(Estud, col="gray60", lwd=2)

## ------------------------------------------------------------------------
shapiro.test(Estud)

## ----rerAnovaCRp04-------------------------------------------------------
plot(Estud ~ dfCRp$IV, main="Residuals per group")

## ------------------------------------------------------------------------
library(car)
leveneTest(aovCRp)

## ------------------------------------------------------------------------
try(detach(package:car))
try(detach(package:multcomp))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:TH.data))
try(detach(package:DescTools))

