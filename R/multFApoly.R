## ------------------------------------------------------------------------
wants <- c("GPArotation", "mvtnorm", "polycor", "psych")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
N <- 200                       # number of observations
P <- 6                         # number of variables
Q <- 2                         # number of factors

# true P x Q loading matrix -> variable-factor correlations
Lambda <- matrix(c(0.7,-0.4, 0.8,0, -0.2,0.9, -0.3,0.4, 0.3,0.7, -0.8,0.1),
                 nrow=P, ncol=Q, byrow=TRUE)

## ------------------------------------------------------------------------
# factor scores (uncorrelated factors)
library(mvtnorm)               # for rmvnorm()
FF <- rmvnorm(N, mean=c(5, 15), sigma=diag(Q))

# matrix with iid, mean 0, normal errors
E   <- rmvnorm(N, rep(0, P), diag(P))
X   <- FF %*% t(Lambda) + E    # matrix with variable values
dfX <- data.frame(X)           # data also as a data frame

## ------------------------------------------------------------------------
# categorize variables into a list of ordered factors
lOrd <- lapply(dfX, function(x) {
               cut(x, breaks=quantile(x), include.lowest=TRUE,
                   ordered=TRUE, labels=LETTERS[1:4]) })
dfOrd  <- data.frame(lOrd)     # combine list into a data frame
ordNum <- data.matrix(dfOrd)   # categorized data as a numeric matrix

## ------------------------------------------------------------------------
library(polycor)               # for hetcor()
pc <- hetcor(dfOrd, ML=TRUE)   # polychoric corr matrix

## ------------------------------------------------------------------------
library(psych)
faPC <- fa(r=pc$correlations, nfactors=2, n.obs=N, rotate="varimax")
faPC$loadings

## ----results='hide'------------------------------------------------------
# polychoric FA
faPCdirect <- fa.poly(ordNum, nfactors=2, rotate="varimax")

## ------------------------------------------------------------------------
faPCdirect$fa$loadings         # loadings are the same as above ...

## ----rerMultFApoly01-----------------------------------------------------
factor.plot(faPCdirect$fa, cut=0.5)
fa.diagram(faPCdirect)

## ----rerMultFApoly02, results='hide'-------------------------------------
fap <- fa.parallel.poly(ordNum)   # parallel analysis for dichotomous data

## ----rerMultFApoly03-----------------------------------------------------
fap
vss(pc$correlations, n.obs=N, rotate="varimax")  # very simple structure

## ------------------------------------------------------------------------
try(detach(package:GPArotation))
try(detach(package:psych))
try(detach(package:polycor))
try(detach(package:sfsmisc))
try(detach(package:mvtnorm))

