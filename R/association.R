
## @knitr 
wants <- c("coin", "epitools", "vcd")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
disease <- factor(rep(c("no", "yes"),   c(10, 5)))
diagN   <- rep(c("isHealthy", "isIll"), c( 8, 2))
diagY   <- rep(c("isHealthy", "isIll"), c( 1, 4))
diagT   <- factor(c(diagN, diagY))
contT1  <- table(disease, diagT)
addmargins(contT1)


## @knitr 
fisher.test(contT1, alternative="greater")


## @knitr 
TN <- c11 <- contT1[1, 1]       ## true negative
TP <- c22 <- contT1[2, 2]       ## true positive / hit
FP <- c12 <- contT1[1, 2]       ## false positive
FN <- c21 <- contT1[2, 1]       ## false negative / miss


## @knitr 
(prevalence <- sum(contT1[2, ]) / sum(contT1))


## @knitr 
(sensitivity <- recall <- TP / (TP+FN))


## @knitr 
(specificity <- TN / (TN+FP))


## @knitr 
(relevance <- precision <- TP / (TP+FP))


## @knitr 
(CCR <- sum(diag(contT1)) / sum(contT1))


## @knitr 
(Fval <- 1 / mean(1 / c(precision, recall)))


## @knitr 
library(vcd)                          ## for oddsratio()
(OR <- oddsratio(contT1, log=FALSE))  ## odds ratio
(ORln <- oddsratio(contT1))           ## log odds ratio


## @knitr 
summary(ORln)            ## significance test log OR


## @knitr 
(CIln <- confint(ORln))  ## confidence interval log OR
exp(CIln)                ## confidence interval OR (not log)


## @knitr 
(Q <- (c11*c22 - c12*c21) / (c11*c22 + c12*c21))  ## Yule's Q
(OR-1) / (OR+1)          ## alternative calculation given OR


## @knitr 
library(epitools)
riskratio(contT1, method="small")


## @knitr 
set.seed(1.234)
N        <- 50
smokes   <- factor(sample(c("no", "yes"), N, replace=TRUE))
siblings <- factor(round(abs(rnorm(N, 1, 0.5))))
cTab     <- table(smokes, siblings)
addmargins(cTab)


## @knitr 
chisq.test(cTab)


## @knitr 
DV1  <- cut(c(100, 76, 56, 99, 50, 62, 36, 69, 55,  17), breaks=3,
            labels=LETTERS[1:3])
DV2  <- cut(c(42,  74, 22, 99, 73, 44, 10, 68, 19, -34), breaks=3,
            labels=LETTERS[1:3])
cTab <- table(DV1, DV2)
addmargins(cTab)


## @knitr 
library(vcd)
assocstats(cTab)


## @knitr 
N    <- 10
myDf <- data.frame(work =factor(sample(c("home", "office"), N, replace=TRUE)),
                   sex  =factor(sample(c("f", "m"),         N, replace=TRUE)),
                   group=factor(sample(c("A", "B"), 10, replace=TRUE)))
tab3 <- xtabs(~ work + sex + group, data=myDf)


## @knitr 
library(coin)
cmh_test(tab3, distribution=approximate(B=9999))


## @knitr 
try(detach(package:vcd))
try(detach(package:colorspace))
try(detach(package:MASS))
try(detach(package:grid))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))


