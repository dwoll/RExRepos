## ------------------------------------------------------------------------
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
P    <- 3
Q    <- 3
g11  <- c(41, 43, 50)
g12  <- c(51, 43, 53, 54, 46)
g13  <- c(45, 55, 56, 60, 58, 62, 62)
g21  <- c(56, 47, 45, 46, 49)
g22  <- c(58, 54, 49, 61, 52, 62)
g23  <- c(59, 55, 68, 63)
g31  <- c(43, 56, 48, 46, 47)
g32  <- c(59, 46, 58, 54)
g33  <- c(55, 69, 63, 56, 62, 67)
dfMD <- data.frame(IV1=factor(rep(1:P, c(3+5+7, 5+6+4, 5+4+6))),
                   IV2=factor(rep(rep(1:Q, P), c(3,5,7, 5,6,4, 5,4,6))),
                   DV =c(g11, g12, g13, g21, g22, g23, g31, g32, g33))

## ------------------------------------------------------------------------
xtabs(~ IV1 + IV2, data=dfMD)

## ------------------------------------------------------------------------
anova(lm(DV ~ IV1 + IV2 + IV1:IV2, data=dfMD))
anova(lm(DV ~ IV2 + IV1 + IV1:IV2, data=dfMD))

## ------------------------------------------------------------------------
SS.I1 <- anova(lm(DV ~ 1,                 data=dfMD),
               lm(DV ~ IV1,               data=dfMD))
SS.I2 <- anova(lm(DV ~ IV1,               data=dfMD),
               lm(DV ~ IV1+IV2,           data=dfMD))
SS.Ii <- anova(lm(DV ~ IV1+IV2,           data=dfMD),
               lm(DV ~ IV1+IV2 + IV1:IV2, data=dfMD))

## ------------------------------------------------------------------------
SS.I1[2, "Sum of Sq"]
SS.I2[2, "Sum of Sq"]
SS.Ii[2, "Sum of Sq"]

## ------------------------------------------------------------------------
SST <- anova(lm(DV ~ 1,       data=dfMD),
             lm(DV ~ IV1*IV2, data=dfMD))
SST[2, "Sum of Sq"]
SS.I1[2, "Sum of Sq"] + SS.I2[2, "Sum of Sq"] + SS.Ii[2, "Sum of Sq"]

## ------------------------------------------------------------------------
library(car)
Anova(lm(DV ~ IV1*IV2, data=dfMD), type="II")

## ------------------------------------------------------------------------
SS.II1 <- anova(lm(DV ~     IV2,         data=dfMD),
                lm(DV ~ IV1+IV2,         data=dfMD))
SS.II2 <- anova(lm(DV ~ IV1,             data=dfMD),
                lm(DV ~ IV1+IV2,         data=dfMD))
SS.IIi <- anova(lm(DV ~ IV1+IV2,         data=dfMD),
                lm(DV ~ IV1+IV2+IV1:IV2, data=dfMD))

## ------------------------------------------------------------------------
SS.II1[2, "Sum of Sq"]
SS.II2[2, "Sum of Sq"]
SS.IIi[2, "Sum of Sq"]

## ------------------------------------------------------------------------
SST <- anova(lm(DV ~ 1,       data=dfMD),
             lm(DV ~ IV1*IV2, data=dfMD))
SST[2, "Sum of Sq"]
SS.II1[2, "Sum of Sq"] + SS.II2[2, "Sum of Sq"] + SS.IIi[2, "Sum of Sq"]

## ------------------------------------------------------------------------
# options(contrasts=c(unordered="contr.sum",       ordered="contr.poly"))

## ------------------------------------------------------------------------
# options(contrasts=c(unordered="contr.treatment", ordered="contr.poly"))

## ------------------------------------------------------------------------
fitIII <- lm(DV ~ IV1 + IV2 + IV1:IV2, data=dfMD,
             contrasts=list(IV1=contr.sum, IV2=contr.sum))

## ------------------------------------------------------------------------
library(car)
Anova(fitIII, type="III")

## ------------------------------------------------------------------------
# A: lm(DV ~     IV2 + IV1:IV2) vs. lm(DV ~ IV1 + IV2 + IV1:IV2)

## ------------------------------------------------------------------------
# B: lm(DV ~ IV1     + IV1:IV2) vs. lm(DV ~ IV1 + IV2 + IV1:IV2)

## ------------------------------------------------------------------------
drop1(fitIII, ~ ., test="F")

## ------------------------------------------------------------------------
drop1(fitIII, ~ ., test="F")

## ------------------------------------------------------------------------
try(detach(package:car))

