## ------------------------------------------------------------------------
wants <- c("coin", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
disease <- factor(rep(c("no", "yes"),   c(10, 5)))
diagN   <- rep(c("isHealthy", "isIll"), c( 8, 2))
diagY   <- rep(c("isHealthy", "isIll"), c( 1, 4))
diagT   <- factor(c(diagN, diagY))
contT1  <- table(disease, diagT)
addmargins(contT1)

## ------------------------------------------------------------------------
fisher.test(contT1, alternative="greater")

## ------------------------------------------------------------------------
TN <- c11 <- contT1[1, 1]       ## true negative
TP <- c22 <- contT1[2, 2]       ## true positive / hit
FP <- c12 <- contT1[1, 2]       ## false positive
FN <- c21 <- contT1[2, 1]       ## false negative / miss

## ------------------------------------------------------------------------
(prevalence <- sum(contT1[2, ]) / sum(contT1))

## ------------------------------------------------------------------------
(sensitivity <- recall <- TP / (TP+FN))

## ------------------------------------------------------------------------
(specificity <- TN / (TN+FP))

## ------------------------------------------------------------------------
(relevance <- precision <- TP / (TP+FP))

## ------------------------------------------------------------------------
(CCR <- sum(diag(contT1)) / sum(contT1))

## ------------------------------------------------------------------------
(Fval <- 1 / mean(1 / c(precision, recall)))

## ------------------------------------------------------------------------
library(DescTools)                    # for OddsRatio()
(OR <- OddsRatio(contT1, conf.level=0.95))  # odds ratio

## ------------------------------------------------------------------------
library(DescTools)                    # for YuleQ()
YuleQ(contT1)  ## Yule's Q

## ------------------------------------------------------------------------
library(DescTools)                    # for RelRisk()
RelRisk(contT1)                       # relative risk

## ------------------------------------------------------------------------
(risk    <- prop.table(contT1, margin=1))
(relRisk <- risk[1, 1] / risk[2, 1])

## ------------------------------------------------------------------------
set.seed(123)
N        <- 50
smokes   <- factor(sample(c("no", "yes"), N, replace=TRUE))
siblings <- factor(round(abs(rnorm(N, 1, 0.5))))
cTab     <- table(smokes, siblings)
addmargins(cTab)

## ------------------------------------------------------------------------
chisq.test(cTab)

## ------------------------------------------------------------------------
DV1  <- cut(c(100, 76, 56, 99, 50, 62, 36, 69, 55,  17), breaks=3,
            labels=LETTERS[1:3])
DV2  <- cut(c(42,  74, 22, 99, 73, 44, 10, 68, 19, -34), breaks=3,
            labels=LETTERS[1:3])
cTab <- table(DV1, DV2)
addmargins(cTab)

## ------------------------------------------------------------------------
library(DescTools)
Assocs(cTab)

## ------------------------------------------------------------------------
N    <- 10
myDf <- data.frame(work =factor(sample(c("home", "office"), N, replace=TRUE)),
                   sex  =factor(sample(c("f", "m"),         N, replace=TRUE)),
                   group=factor(sample(c("A", "B"), 10, replace=TRUE)))
tab3 <- xtabs(~ work + sex + group, data=myDf)

## ------------------------------------------------------------------------
library(coin)
cmh_test(tab3, distribution=approximate(B=9999))

## ------------------------------------------------------------------------
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))
try(detach(package:DescTools))

