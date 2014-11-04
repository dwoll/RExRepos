
## ------------------------------------------------------------------------
wants <- c("survival")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
N      <- 180                  # number of observations
P      <- 3                    # number of groups
sex    <- factor(sample(c("f", "m"), N, replace=TRUE))  # stratification factor
X      <- rnorm(N, 0, 1)       # continuous covariate
IV     <- factor(rep(LETTERS[1:P], each=N/P))  # factor covariate
IVeff  <- c(0, -1, 1.5)        # effects of factor levels (1 -> reference level)
Xbeta  <- 0.7*X + IVeff[unclass(IV)] + rnorm(N, 0, 2)
weibA  <- 1.5                  # Weibull shape parameter
weibB  <- 100                  # Weibull scale parameter
U      <- runif(N, 0, 1)       # uniformly distributed RV
eventT <- ceiling((-log(U)*weibB*exp(-Xbeta))^(1/weibA))   # simulated event time

# censoring due to study end after 120 days
obsLen <- 120                  # length of observation time
censT  <- rep(obsLen, N)       # censoring time = end of study
obsT   <- pmin(eventT, censT)  # observed censored event times
status <- eventT <= censT      # has event occured?
dfSurv <- data.frame(obsT, status, sex, X, IV)          # data frame


## ------------------------------------------------------------------------
library(survival)
dfSurvCP <- survSplit(dfSurv, cut=seq(30, 90, by=30), end="obsT",
                      event="status", start="start", id="ID", zero=0)


## ----rerSurvivalKM01-----------------------------------------------------
plot(ecdf(eventT), xlim=c(0, 200), main="Cumulative survival distribution",
     xlab="t", ylab="F(t)", cex.lab=1.4)
abline(v=obsLen, col="blue", lwd=2)
text(obsLen-5, 0.2, adj=1, labels="end of study", cex=1.4)


## ------------------------------------------------------------------------
library(survival)                # for Surv(), survfit()
## global estimate
KM0 <- survfit(Surv(obsT, status) ~ 1,  type="kaplan-meier", conf.type="log", data=dfSurv)

## separate estimate for all strata
(KM <- survfit(Surv(obsT, status) ~ IV, type="kaplan-meier", conf.type="log", data=dfSurv))


## ------------------------------------------------------------------------
quantile(KM0, probs=c(0.25, 0.5, 0.75), conf.int=FALSE)


## ------------------------------------------------------------------------
summary(KM0)


## ----rerSurvivalKM02-----------------------------------------------------
plot(KM0, main=expression(paste("Kaplan-Meier-estimate ", hat(S)(t), " with CI")),
     xlab="t", ylab="Survival", lwd=2)


## ----rerSurvivalKM03-----------------------------------------------------
plot(KM, main=expression(paste("Kaplan-Meier-estimate ", hat(S)[g](t), " for groups g")),
     xlab="t", ylab="Survival", lwd=2, col=1:3)
legend(x="topright", col=1:3, lwd=2, legend=LETTERS[1:3])


## ----rerSurvivalKM04-----------------------------------------------------
plot(KM0, main=expression(paste("Kaplan-Meier-estimate ", hat(Lambda)(t))),
     xlab="t", ylab="cumulative hazard", fun="cumhaz", lwd=2)


## ------------------------------------------------------------------------
library(survival)
survdiff(Surv(obsT, status) ~ IV, data=dfSurv)


## ------------------------------------------------------------------------
library(survival)
survdiff(Surv(obsT, status) ~ IV + strata(sex), data=dfSurv)


## ------------------------------------------------------------------------
try(detach(package:survival))
try(detach(package:splines))

