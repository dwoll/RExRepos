## ------------------------------------------------------------------------
wants <- c("AICcmodavg", "lme4", "multcomp", "nlme", "pbkrtest")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
P     <- 2               # Xb1
Q     <- 2               # Xb2
R     <- 3               # Xw1
S     <- 3               # Xw2
Njklm <- 20              # obs per cell
Njk   <- Njklm*P*Q       # number of subjects
N     <- Njklm*P*Q*R*S   # number of observations
id    <- gl(Njk,         R*S, N, labels=c(paste("s", 1:Njk, sep="")))
Xb1   <- gl(P,   Njklm*Q*R*S, N, labels=c("CG", "T"))
Xb2   <- gl(Q,   Njklm  *R*S, N, labels=c("f", "m"))
Xw1   <- gl(R,             S, N, labels=c("A", "B", "C"))
Xw2   <- gl(S,   1,           N, labels=c("-", "o", "+"))

## ------------------------------------------------------------------------
mu      <- 100
eB1     <- c(-5, 5)
eB2     <- c(-5, 5)
eW1     <- c(-5, 0, 5)
eW2     <- c(-5, 0, 5)
eB1B2   <- c(-5, 5, 5, -5)
eB1W1   <- c(-5, 5, 2, -2, 3, -3)
eB1W2   <- c(-5, 5, 2, -2, 3, -3)
eB2W1   <- c(-5, 5, 2, -2, 3, -3)
eB2W2   <- c(-5, 5, 2, -2, 3, -3)
eW1W2   <- c(-5, 2, 3, 2, 3, -5, 2, -5, 3)
eB1B2W1 <- c(-5, 5, 5, -5, 2, -2, -2, 2, 3, -3, -3, 3)
eB1B2W2 <- c(-5, 5, 5, -5, 2, -2, -2, 2, 3, -3, -3, 3)
eB1W1W2 <- c(-5, 5, 2, -2, 3, -3, 3, -3, -5, 5, 2, -2, 2, -2, 3, -3, -5, 5)
eB2W1W2 <- c(-5, 5, 2, -2, 3, -3, 3, -3, -5, 5, 2, -2, 2, -2, 3, -3, -5, 5)
# no 3rd-order interaction B1xB2xW1xW2

## ------------------------------------------------------------------------
names(eB1)     <- levels(Xb1)
names(eB2)     <- levels(Xb2)
names(eW1)     <- levels(Xw1)
names(eW2)     <- levels(Xw2)
names(eB1B2)   <- levels(interaction(Xb1, Xb2))
names(eB1W1)   <- levels(interaction(Xb1, Xw1))
names(eB1W2)   <- levels(interaction(Xb1, Xw2))
names(eB2W1)   <- levels(interaction(Xb2, Xw1))
names(eB2W2)   <- levels(interaction(Xb2, Xw2))
names(eW1W2)   <- levels(interaction(Xw1, Xw2))
names(eB1B2W1) <- levels(interaction(Xb1, Xb2, Xw1))
names(eB1B2W2) <- levels(interaction(Xb1, Xb2, Xw2))
names(eB1W1W2) <- levels(interaction(Xb1, Xw1, Xw2))
names(eB2W1W2) <- levels(interaction(Xb2, Xw1, Xw2))

## ------------------------------------------------------------------------
muJKLM <- mu +
          eB1[Xb1] + eB2[Xb2] + eW1[Xw1] + eW2[Xw2] +
          eB1B2[interaction(Xb1, Xb2)] +
          eB1W1[interaction(Xb1, Xw1)] +
          eB1W2[interaction(Xb1, Xw2)] +
          eB2W1[interaction(Xb2, Xw1)] +
          eB2W2[interaction(Xb2, Xw2)] +
          eW1W2[interaction(Xw1, Xw2)] +
          eB1B2W1[interaction(Xb1, Xb2, Xw1)] +
          eB1B2W2[interaction(Xb1, Xb2, Xw2)] +
          eB1W1W2[interaction(Xb1, Xw1, Xw2)] +
          eB2W1W2[interaction(Xb2, Xw1, Xw2)]
muId  <- rep(rnorm(Njk, 0, 3), each=R*S)
mus   <- muJKLM + muId
sigma <- 50

Y  <- round(rnorm(N, mus, sigma), 1)
d2 <- data.frame(id, Xb1, Xb2, Xw1, Xw2, Y)

## ------------------------------------------------------------------------
d1 <- aggregate(Y ~ id + Xw1 + Xb1 + Xb2, data=d2, FUN=mean)

## ------------------------------------------------------------------------
summary(aov(Y ~ Xw1 + Error(id/Xw1), data=d1))

## ------------------------------------------------------------------------
library(nlme)
anova(lme(Y ~ Xw1, random=~1 | id, method="ML", data=d1))

## ------------------------------------------------------------------------
lmeFit <- lme(Y ~ Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
              method="ML", data=d1)
anova(lmeFit)

## ------------------------------------------------------------------------
anova(lme(Y ~ Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))

## ------------------------------------------------------------------------
library(lme4)
fitF <- lmer(Y ~ Xw1 + (1|id), data=d1)
anova(fitF)

## ------------------------------------------------------------------------
# restricted model
fitR <- lmer(Y ~ 1 + (1|id), data=d1)
library(pbkrtest)
KRmodcomp(fitF, fitR)

## ------------------------------------------------------------------------
library(AICcmodavg)
AICc(fitF)
aictab(cand.set=list(fitR, fitF),
       modnames=c("restricted", "full"),
       sort=FALSE, second.ord=FALSE)

## ------------------------------------------------------------------------
library(multcomp)
contr <- glht(lmeFit, linfct=mcp(Xw1="Tukey"))
summary(contr)
confint(contr)

## ------------------------------------------------------------------------
summary(aov(Y ~ Xw1*Xw2 + Error(id/(Xw1*Xw2)), data=d2))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xw1*Xw2, random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))

## ------------------------------------------------------------------------
anova(lmer(Y ~ Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))

## ------------------------------------------------------------------------
summary(aov(Y ~ Xb1*Xw1 + Error(id/Xw1), data=d1))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xw1, random=~1 | id, method="ML", data=d1))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xw1, random=~1 | id, correlation=corCompSymm(form=~1|id),
          method="ML", data=d1))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xw1, random=list(id=pdCompSymm(~Xw1-1)), method="REML", data=d1))

## ------------------------------------------------------------------------
anova(lmer(Y ~ Xb1*Xw1 + (1|id), data=d1))

## ------------------------------------------------------------------------
summary(aov(Y ~ Xb1*Xb2*Xw1 + Error(id/Xw1), data=d1))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xb2*Xw1, random=~1 | id, method="ML", data=d1))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xb2*Xw1, random=~1 | id,
          correlation=corCompSymm(form=~1 | id), method="ML", data=d1))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xb2*Xw1,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1)))),
          method="ML", data=d1))

## ------------------------------------------------------------------------
anova(lmer(Y ~ Xb1*Xb2*Xw1 + (1|id), data=d1))

## ------------------------------------------------------------------------
summary(aov(Y ~ Xb1*Xw1*Xw2 + Error(id/(Xw1*Xw2)), data=d2))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))

## ------------------------------------------------------------------------
anova(lmer(Y ~ Xb1*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))

## ------------------------------------------------------------------------
summary(aov(Y ~ Xb1*Xb2*Xw1*Xw2 + Error(id/(Xw1*Xw2)), data=d2))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xb2*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdIdent(~Xw1-1), pdIdent(~Xw2-1)))),
          method="ML", data=d2))

## ------------------------------------------------------------------------
anova(lme(Y ~ Xb1*Xb2*Xw1*Xw2,
          random=list(id=pdBlocked(list(~1, pdCompSymm(~Xw1-1), pdCompSymm(~Xw2-1)))),
          method="ML", data=d2))

## ------------------------------------------------------------------------
anova(lmer(Y ~ Xb1*Xb2*Xw1*Xw2 + (1|id) + (1|Xw1:id) + (1|Xw2:id), data=d2))

## ------------------------------------------------------------------------
try(detach(package:multcomp))
try(detach(package:mvtnorm))
try(detach(package:survival))
try(detach(package:splines))
try(detach(package:TH.data))
try(detach(package:lme4))
try(detach(package:nlme))
try(detach(package:Matrix))
try(detach(package:Rcpp))
try(detach(package:AICcmodavg))
try(detach(package:pbkrtest))
try(detach(package:MASS))

