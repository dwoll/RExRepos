
## @knitr 
wants <- c("coin", "psych")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
x <- c(17, 30, 30, 25, 23, 21)
y <- c(1, 12, 8, 10, 5, 3)
cov(x, y)


## @knitr 
(cmML <- cov.wt(cbind(x, y), method="ML")$cov)


## @knitr 
cmML[upper.tri(cmML)]


## @knitr 
(r <- cor(x, y))


## @knitr 
library(psych)
(rZ <- fisherz(r))
fisherz2r(rZ)


## @knitr 
set.seed(123)
N  <- 100
z1 <- runif(N)
z2 <- runif(N)
x  <- -0.3*z1 + 0.2*z2 + rnorm(N, 0, 0.3)
y  <-  0.3*z1 - 0.4*z2 + rnorm(N, 0, 0.3)
cor(x, y)


## @knitr 
x.z1 <- residuals(lm(x ~ z1))
y.z1 <- residuals(lm(y ~ z1))
cor(x.z1, y.z1)


## @knitr 
x.z12 <- residuals(lm(x ~ z1 + z2))
y.z12 <- residuals(lm(y ~ z1 + z2))
cor(x.z12, y.z12)


## @knitr 
cor(x.z1, y)


## @knitr 
X1 <- c(19, 19, 31, 19, 24)
X2 <- c(95, 76, 94, 76, 76)
X3 <- c(197, 178, 189, 184, 173)
(X <- cbind(X1, X2, X3))


## @knitr 
(covX <- cov(X))
(cML <- cov.wt(X, method="ML"))
cML$cov


## @knitr 
cor(X)


## @knitr results='hide'
cov2cor(covX)


## @knitr 
vec <- rnorm(nrow(X))
cor(vec, X)


## @knitr 
DV1   <- c(97, 76, 56, 99, 50, 62, 36, 69, 55,  17)
DV2   <- c(42, 74, 22, 99, 73, 44, 10, 68, 19, -34)
DV3   <- c(61, 88, 21, 29, 56, 37, 21, 70, 46,  88)
DV4   <- c(58, 65, 38, 19, 55, 23, 26, 60, 50,  91)
DVmat <- cbind(DV1, DV2, DV3, DV4)


## @knitr 
cor(DV1, DV2, method="spearman")
cor(DVmat, method="spearman")


## @knitr 
cor(DV1, DV2, method="kendall")
cor(DVmat, method="kendall")


## @knitr 
cor.test(DV1, DV2)


## @knitr 
library(psych)
corr.test(DVmat, adjust="bonferroni")


## @knitr 
cor.test(DV1, DV2, method="spearman")
library(coin)
spearman_test(DV1 ~ DV2, distribution=approximate(B=9999))


## @knitr 
library(psych)
corr.test(DVmat, method="spearman", adjust="bonferroni")


## @knitr 
cor.test(DV1, DV2, method="kendall")


## @knitr 
library(psych)
corr.test(DVmat, method="kendall", adjust="bonferroni")


## @knitr 
N <- length(DV1)
library(psych)
r.test(n=N, n2=N, r12=cor(DV1, DV2), r34=cor(DV3, DV4))


## @knitr 
try(detach(package:psych))
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:stats4))
try(detach(package:mvtnorm))
try(detach(package:survival))
try(detach(package:splines))


