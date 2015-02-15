## ----echo=FALSE----------------------------------------------------------
library(knitr)
opts_knit$set(self.contained=FALSE)
opts_chunk$set(tidy=FALSE, message=FALSE, warning=FALSE, comment=NA)
# render_jekyll()

## ------------------------------------------------------------------------
wants <- c("MASS")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
library(MASS)
str(UCBAdmissions)

## ------------------------------------------------------------------------
(llFit <- loglm(~ Admit + Dept + Gender, data=UCBAdmissions))

## ------------------------------------------------------------------------
UCBAdf <- as.data.frame(UCBAdmissions)
loglm(Freq ~ Admit + Dept + Gender, data=UCBAdf)

## ------------------------------------------------------------------------
loglm(~ Admit + Dept + Gender + Admit:Dept + Dept:Gender, data=UCBAdmissions)

## ----rerLogLinear01------------------------------------------------------
mosaicplot(~ Admit + Dept + Gender, shade=TRUE, data=UCBAdmissions)

## ------------------------------------------------------------------------
(llCoef <- coef(llFit))
exp(llCoef$Gender)

## ------------------------------------------------------------------------
glmFitT <- glm(Freq ~ Admit + Dept + Gender, family=poisson(link="log"), data=UCBAdf)
coef(summary(glmFitT))

# glm() fitted values are the same as loglm() ones
all.equal(c(fitted(llFit)), fitted(glmFitT), check.attributes=FALSE)

## ------------------------------------------------------------------------
(glmTcoef <- coef(glmFitT))

glmTcoef["(Intercept)"]
llCoef$`(Intercept)` + llCoef$Admit["Admitted"] + llCoef$Gender["Male"]  + llCoef$Dept["A"]

glmTcoef["(Intercept)"] + glmTcoef["DeptC"] + glmTcoef["GenderFemale"]
llCoef$`(Intercept)` + llCoef$Admit["Admitted"] + llCoef$Dept["C"] + llCoef$Gender["Female"]

## ------------------------------------------------------------------------
glmFitE <- glm(Freq ~ Admit + Dept + Gender, family=poisson(link="log"),
               contrasts=list(Admit=contr.sum,
                               Dept=contr.sum,
                             Gender=contr.sum), data=UCBAdf)
coef(summary(glmFitE))

## ------------------------------------------------------------------------
try(detach(package:MASS))

