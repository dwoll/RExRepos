
## ------------------------------------------------------------------------
wants <- c("DescTools", "robustbase")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
age <- c(17, 30, 30, 25, 23, 21)
N   <- length(age)
M   <- mean(age)
var(age)
sd(age)


## ------------------------------------------------------------------------
(cML <- cov.wt(as.matrix(age), method="ML"))
(vML <- diag(cML$cov))
sqrt(vML)


## ------------------------------------------------------------------------
library(DescTools)
ageWins <- Winsorize(age, probs=c(0.2, 0.8))
var(ageWins)
sd(ageWins)


## ------------------------------------------------------------------------
quantile(age)
IQR(age)


## ------------------------------------------------------------------------
library(DescTools)
MeanAD(age)


## ------------------------------------------------------------------------
mad(age)


## ------------------------------------------------------------------------
library(robustbase)
Qn(age)


## ------------------------------------------------------------------------
scaleTau2(age)


## ------------------------------------------------------------------------
fac <- factor(c("C", "D", "A", "D", "E", "D", "C", "E", "E", "B", "E"),
              levels=c(LETTERS[1:5], "Q"))
P   <- nlevels(fac)
(Fj <- prop.table(table(fac)))


## ------------------------------------------------------------------------
library(DescTools)
shannonIdx <- Entropy(Fj, base=exp(1))
(H <- (1/log(P)) * shannonIdx)


## ------------------------------------------------------------------------
library(DescTools)
Skew(age)
Kurt(age)


## ------------------------------------------------------------------------
try(detach(package:robustbase))
try(detach(package:DescTools))

