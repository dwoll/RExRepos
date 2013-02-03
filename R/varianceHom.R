
## @knitr 
wants <- c("car", "coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
P     <- 2
Nj    <- c(50, 40)
DV1   <- rnorm(Nj[1], mean=100, sd=15)
DV2   <- rnorm(Nj[2], mean=100, sd=13)
varDf <- data.frame(DV=c(DV1, DV2),
                    IV=factor(rep(1:P, Nj)))


## @knitr rerVarHom01
boxplot(DV ~ IV, data=varDf)
stripchart(DV ~ IV, data=varDf, pch=16, vert=TRUE, add=TRUE)


## @knitr results='hide'
var.test(DV1, DV2)


## @knitr 
var.test(DV ~ IV, data=varDf)


## @knitr 
mood.test(DV ~ IV, alternative="greater", data=varDf)


## @knitr 
ansari.test(DV ~ IV, alternative="greater", exact=FALSE, data=varDf)


## @knitr 
library(coin)
ansari_test(DV ~ IV, alternative="greater", distribution="exact", data=varDf)


## @knitr 
Nj    <- c(22, 18, 20)
N     <- sum(Nj)
P     <- length(Nj)
levDf <- data.frame(DV=sample(0:100, N, replace=TRUE),
                    IV=factor(rep(1:P, Nj)))


## @knitr rerVarHom02
boxplot(DV ~ IV, data=levDf)
stripchart(DV ~ IV, data=levDf, pch=20, vert=TRUE, add=TRUE)


## @knitr 
library(car)
leveneTest(DV ~ IV, center=median, data=levDf)
leveneTest(DV ~ IV, center=mean, data=levDf)


## @knitr 
fligner.test(DV ~ IV, data=levDf)


## @knitr 
library(coin)
fligner_test(DV ~ IV, distribution=approximate(B=9999), data=levDf)


## @knitr 
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))


