
## @knitr 
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(123)
N  <- 100
X1 <- rnorm(N, 175, 7)
X2 <- rnorm(N, 30, 8)
X3 <- abs(rnorm(N, 60, 30))
Y1 <- 0.2*X1 - 0.3*X2 - 0.4*X3 + 10 + rnorm(N, 0, 10)
Y2 <- -0.3*X2 + 0.2*X3 + rnorm(N, 10)
Y  <- cbind(Y1, Y2)
dfRegr <- data.frame(X1, X2, X3, Y1, Y2)


## @knitr 
(fit <- lm(cbind(Y1, Y2) ~ X1 + X2 + X3, data=dfRegr))


## @knitr 
coef(lm(Y1 ~ X1 + X2 + X3, data=dfRegr))
coef(lm(Y2 ~ X1 + X2 + X3, data=dfRegr))


## @knitr 
summary(manova(fit), test="Hotelling-Lawley")


## @knitr results='hide'
summary(manova(fit), test="Wilks")
summary(manova(fit), test="Roy")
summary(manova(fit), test="Pillai")


## @knitr 
library(car)                           # for Manova()
Manova(fit, type="II")


## @knitr 
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))


