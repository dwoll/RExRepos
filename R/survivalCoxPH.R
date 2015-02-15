## ------------------------------------------------------------------------
wants <- c("survival")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
N      <- 180
P      <- 3
sex    <- factor(sample(c("f", "m"), N, replace=TRUE))
X      <- rnorm(N, 0, 1)
IV     <- factor(rep(LETTERS[1:P], each=N/P))
IVeff  <- c(0, -1, 1.5)
Xbeta  <- 0.7*X + IVeff[unclass(IV)] + rnorm(N, 0, 2)
weibA  <- 1.5
weibB  <- 100
U      <- runif(N, 0, 1)
eventT <- ceiling((-log(U)*weibB*exp(-Xbeta))^(1/weibA))
obsLen <- 120
censT  <- rep(obsLen, N)
obsT   <- pmin(eventT, censT)
status <- eventT <= censT
dfSurv <- data.frame(obsT, status, sex, X, IV)

## ------------------------------------------------------------------------
library(survival)
dfSurvCP <- survSplit(dfSurv, cut=seq(30, 90, by=30), end="obsT",
                      event="status", start="start", id="ID", zero=0)

## ------------------------------------------------------------------------
library(survival)
(fitCPH <- coxph(Surv(obsT, status) ~ X + IV, data=dfSurv))

## ----results='hide'------------------------------------------------------
coxph(Surv(start, obsT, status) ~ X + IV, data=dfSurvCP)
summary(fitCPH)
# not shown

## ------------------------------------------------------------------------
library(survival)
extractAIC(fitCPH)

## ------------------------------------------------------------------------
LLf <- fitCPH$loglik[2]
LL0 <- fitCPH$loglik[1]

## ------------------------------------------------------------------------
as.vector(1 - (LLf / LL0))

## ------------------------------------------------------------------------
as.vector(1 - exp((2/N) * (LL0 - LLf)))

## ------------------------------------------------------------------------
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))

## ------------------------------------------------------------------------
library(survival)
fitCPH1 <- coxph(Surv(obsT, status) ~ X, data=dfSurv)
anova(fitCPH1, fitCPH)          # model comparison

## ------------------------------------------------------------------------
library(survival)                # for survfit()
(CPH <- survfit(fitCPH))

quantile(CPH, probs=c(0.25, 0.5, 0.75), conf.int=FALSE)

## ----rerSurvivalCoxPH01--------------------------------------------------
dfNew  <- data.frame(sex=factor(c("f", "f"), levels=levels(dfSurv$sex)),
                       X=c(-2, -2),
                      IV=factor(c("A", "C"), levels=levels(dfSurv$IV)))

library(survival)
CPHnew <- survfit(fitCPH, newdata=dfNew)

par(mar=c(5, 4.5, 4, 2)+0.1, cex.lab=1.4, cex.main=1.4)
plot(CPH, main=expression(paste("Cox PH-estimate ", hat(S)(t), " with CI")),
     xlab="t", ylab="Survival", lwd=2)
lines(CPHnew$time, CPHnew$surv[ , 1], lwd=2, col="blue")
lines(CPHnew$time, CPHnew$surv[ , 2], lwd=2, col="red")
legend(x="topright", lwd=2, col=c("black", "blue", "red"),
       legend=c("pseudo-observation", "sex=f, X=-2, IV=A", "sex=f, X=-2, IV=C"))

## ----rerSurvivalCoxPH02--------------------------------------------------
library(survival)                # for basehaz()
expCoef  <- exp(coef(fitCPH))
Lambda0A <- basehaz(fitCPH, centered=FALSE)
Lambda0B <- expCoef[2]*Lambda0A$hazard
Lambda0C <- expCoef[3]*Lambda0A$hazard
plot(hazard ~ time, main=expression(paste("Cox PH-estimate ", hat(Lambda)[g](t), " per group")),
     type="s", ylim=c(0, 5), xlab="t", ylab="cumulative hazard", lwd=2, data=Lambda0A)
lines(Lambda0A$time, Lambda0B, lwd=2, col="red")
lines(Lambda0A$time, Lambda0C, lwd=2, col="green")
legend(x="bottomright", lwd=2, col=1:3, legend=LETTERS[1:3])

## ----rerSurvivalCoxPH03--------------------------------------------------
library(survival)                # for survfit()
dfSurv <- transform(dfSurv, Xcut=cut(X, breaks=c(-Inf, median(X), Inf),
                                        labels=c("lo", "hi")))
KMiv   <- survfit(Surv(obsT, status) ~ IV,   type="kaplan-meier", data=dfSurv)
KMxcut <- survfit(Surv(obsT, status) ~ Xcut, type="kaplan-meier", data=dfSurv)

plot(KMiv, fun="cloglog", main="cloglog-Plot for IV1", xlab="ln t",
     ylab=expression(ln(-ln(hat(S)[g](t)))), col=c("black", "blue", "red"), lty=1:3)

legend(x="topleft", col=c("black", "blue", "red"), lwd=2, lty=1:3, legend=LETTERS[1:3])

plot(KMxcut, fun="cloglog", main="cloglog-Plot for Xcut", xlab="ln t",
     ylab=expression(ln(-ln(hat(S)[g](t)))), col=c("black", "blue"), lty=1:2)

legend(x="topleft", col=c("black", "blue"), lwd=2, lty=1:2, legend=c("lo", "hi"))

## ------------------------------------------------------------------------
library(survival)                      # for cox.zph()
(czph <- cox.zph(fitCPH))

## ----rerSurvivalCoxPH04--------------------------------------------------
par(mfrow=c(2, 2), cex.main=1.4, cex.lab=1.4)
plot(czph)

## ----rerSurvivalCoxPH05--------------------------------------------------
dfbetas <- residuals(fitCPH, type="dfbetas")

par(mfrow=c(2, 2), cex.main=1.4, cex.lab=1.4)
plot(dfbetas[ , 1], type="h", main="DfBETAS for X",    ylab="DfBETAS", lwd=2)
plot(dfbetas[ , 2], type="h", main="DfBETAS for IV-B", ylab="DfBETAS", lwd=2)
plot(dfbetas[ , 3], type="h", main="DfBETAS for IV-C", ylab="DfBETAS", lwd=2)

## ----rerSurvivalCoxPH06--------------------------------------------------
resMart <- residuals(fitCPH, type="martingale")
plot(dfSurv$X, resMart, main="Martingale-residuals for X",
     xlab="X", ylab="Residuen", pch=20)
lines(loess.smooth(dfSurv$X, resMart), lwd=2, col="blue")
legend(x="bottomleft", col="blue", lwd=2, legend="LOESS fit", cex=1.4)

## ------------------------------------------------------------------------
library(survival)
predRes <- predict(fitCPH, type="risk")
head(predRes, n=10)

## ------------------------------------------------------------------------
library(survival)
Shat1 <- survexp(~ 1, ratetable=fitCPH, data=dfSurv)
with(Shat1, head(data.frame(time, surv), n=4))

## ------------------------------------------------------------------------
library(survival)
Shat2 <- survexp(~ IV, ratetable=fitCPH, data=dfSurv)
with(Shat2, head(data.frame(time, surv), n=4))

## ------------------------------------------------------------------------
try(detach(package:survival))
try(detach(package:splines))

