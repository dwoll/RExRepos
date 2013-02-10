
## @knitr 
wants <- c("car", "multcomp")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(123)
P     <- 4
Nj    <- c(41, 37, 42, 40)
muJ   <- rep(c(-1, 0, 1, 2), Nj)
dfCRp <- data.frame(IV=factor(rep(LETTERS[1:P], Nj)),
                    DV=rnorm(sum(Nj), muJ, 5))


## @knitr rerAnovaCRp01
plot.design(DV ~ IV, fun=mean, data=dfCRp, main="Group means")


## @knitr 
oneway.test(DV ~ IV, data=dfCRp, var.equal=TRUE)


## @knitr 
oneway.test(DV ~ IV, data=dfCRp, var.equal=FALSE)


## @knitr 
aovCRp <- aov(DV ~ IV, data=dfCRp)
summary(aovCRp)
model.tables(aovCRp, type="means")


## @knitr 
(anovaCRp <- anova(lm(DV ~ IV, data=dfCRp)))


## @knitr 
anova(lm(DV ~ 1, data=dfCRp), lm(DV ~ IV, data=dfCRp))


## @knitr 
anovaCRp["Residuals", "Sum Sq"]


## @knitr 
dfSSb <- anovaCRp["IV",        "Df"]
SSb   <- anovaCRp["IV",        "Sum Sq"]
MSb   <- anovaCRp["IV",        "Mean Sq"]
SSw   <- anovaCRp["Residuals", "Sum Sq"]
MSw   <- anovaCRp["Residuals", "Mean Sq"]


## @knitr 
(etaSq <- SSb / (SSb + SSw))
(omegaSq <- dfSSb * (MSb-MSw) / (SSb + SSw + MSw))
(f <- sqrt(etaSq / (1-etaSq)))


## @knitr 
cntrMat <- rbind("A-D"          =c(  1,   0,   0,  -1),
                 "1/3*(A+B+C)-D"=c(1/3, 1/3, 1/3,  -1),
                 "B-C"          =c(  0,   1,  -1,   0))
library(multcomp)
summary(glht(aovCRp, linfct=mcp(IV=cntrMat), alternative="less"),
        test=adjusted("none"))


## @knitr 
pairwise.t.test(dfCRp$DV, dfCRp$IV, p.adjust.method="bonferroni")


## @knitr 
(tHSD <- TukeyHSD(aovCRp))


## @knitr rerAnovaCRp02
plot(tHSD)


## @knitr rerAnovaCRp03
Estud <- rstudent(aovCRp)
qqnorm(Estud, pch=20, cex=2)
qqline(Estud, col="gray60", lwd=2)


## @knitr 
shapiro.test(Estud)


## @knitr rerAnovaCRp04
plot(Estud ~ dfCRp$IV, main="Residuals per group")


## @knitr 
library(car)
leveneTest(aovCRp)


## @knitr 
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:multcomp))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))


