
## @knitr 
wants <- c("modeest", "psych", "robustbase")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
age <- c(17, 30, 30, 25, 23, 21)
mean(age)


## @knitr 
weights <- c(0.6, 0.6, 0.3, 0.2, 0.4, 0.6)
weighted.mean(age, weights)


## @knitr 
library(psych)
geometric.mean(age)


## @knitr 
library(psych)
harmonic.mean(age)


## @knitr 
vec <- c(11, 22, 22, 33, 33, 33, 33)
library(modeest)
mfv(vec)
mlv(vec, method="mfv")


## @knitr 
median(age)


## @knitr 
mean(age, trim=0.2)


## @knitr 
library(psych)
(ageWins <- winsor(age, trim=0.2))
mean(ageWins)


## @knitr 
library(robustbase)
hM <- huberM(age)
hM$mu


## @knitr 
wilcox.test(age, conf.int=TRUE)$estimate


## @knitr 
N <- 8
X <- rnorm(N, 100, 15)
Y <- rnorm(N, 110, 15)
wilcox.test(X, Y, conf.int=TRUE)$estimate


## @knitr 
try(detach(package:modeest))
try(detach(package:psych))
try(detach(package:robustbase))


