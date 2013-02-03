
## @knitr 
wants <- c("e1071", "psych", "robustbase", "vegan")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
age <- c(17, 30, 30, 25, 23, 21)
N   <- length(age)
M   <- mean(age)
var(age)
sd(age)


## @knitr 
(cML <- cov.wt(as.matrix(age), method="ML"))
(vML <- diag(cML$cov))
sqrt(vML)


## @knitr 
library(psych)
ageWins <- winsor(age, trim=0.2)
var(ageWins)
sd(ageWins)


## @knitr 
quantile(age)
IQR(age)


## @knitr 
mean(abs(age-median(age)))


## @knitr 
mad(age)


## @knitr 
library(robustbase)
Qn(age)


## @knitr 
scaleTau2(age)


## @knitr 
fac <- factor(c("C", "D", "A", "D", "E", "D", "C", "E", "E", "B", "E"),
              levels=c(LETTERS[1:5], "Q"))
P   <- nlevels(fac)
(Fj <- prop.table(table(fac)))


## @knitr 
library(vegan)
shannonIdx <- diversity(Fj, index="shannon")
(H <- (1/log(P)) * shannonIdx)


## @knitr 
library(e1071)
skewness(age)
kurtosis(age)


## @knitr 
try(detach(package:psych))
try(detach(package:robustbase))
try(detach(package:vegan))
try(detach(package:permute))
try(detach(package:e1071))
try(detach(package:class))


