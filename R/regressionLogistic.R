
## @knitr 
wants <- c("rms")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
N     <- 100
X1    <- rnorm(N, 175, 7)
X2    <- rnorm(N,  30, 8)
Y     <- 0.5*X1 - 0.3*X2 + 10 + rnorm(N, 0, 6)
Yfac  <- cut(Y, breaks=c(-Inf, median(Y), Inf), labels=c("lo", "hi"))
dfLog <- data.frame(X1, X2, Yfac)


## @knitr rerRegressionLogistic01
cdplot(Yfac ~ X1, data=dfLog)
cdplot(Yfac ~ X2, data=dfLog)


## @knitr 
(glmFit <- glm(Yfac ~ X1 + X2,
               family=binomial(link="logit"), data=dfLog))


## @knitr 
exp(coef(glmFit))


## @knitr 
exp(confint(glmFit))


## @knitr 
N      <- 100
x1     <- rnorm(N, 100, 15)
x2     <- rnorm(N, 10, 3)
total  <- sample(40:60, N, replace=TRUE)
hits   <- rbinom(N, total, prob=0.4)
hitMat <- cbind(hits, total-hits)
glm(hitMat ~ X1 + X2, family=binomial(link="logit"))


## @knitr 
relHits <- hits/total
glm(relHits ~ X1 + X2, weights=total, family=binomial(link="logit"))


## @knitr rerRegressionLogistic02
logitHat <- predict(glmFit, type="link")
plot(logitHat, pch=16, col=c("red", "blue")[unclass(dfLog$Yfac)])
abline(h=0)


## @knitr 
Phat <- fitted(glmFit)
Phat <- predict(glmFit, type="response")
head(Phat)
mean(Phat)
prop.table(table(dfLog$Yfac))


## @knitr 
thresh <- 0.5
Yhat   <- cut(Phat, breaks=c(-Inf, thresh, Inf), labels=c("lo", "hi"))
cTab   <- table(Yfac, Yhat)
addmargins(cTab)


## @knitr 
sum(diag(cTab)) / sum(cTab)


## @knitr 
deviance(glmFit)
logLik(glmFit)
AIC(glmFit)


## @knitr 
library(rms)
lrm(Yfac ~ X1 + X2, data=dfLog)


## @knitr 
glm0 <- update(glmFit, . ~ 1)
LLf  <- logLik(glmFit)
LL0  <- logLik(glm0)


## @knitr 
as.vector(1 - (LLf / LL0))


## @knitr 
as.vector(1 - exp((2/N) * (LL0 - LLf)))


## @knitr 
as.vector((1 - exp((2/N) * (LL0 - LLf))) / (1 - exp(LL0)^(2/N)))


## @knitr 
Nnew  <- 3
dfNew <- data.frame(X1=rnorm(Nnew, 175, 7), X2=rnorm(Nnew, 100, 15))
predict(glmFit, newdata=dfNew, type="response")


## @knitr 
summary(glmFit)


## @knitr 
anova(glm0, glmFit, test="Chisq")


## @knitr 
drop1(glmFit, test="Chi")


## @knitr 
try(detach(package:rms))
try(detach(package:Hmisc))
try(detach(package:survival))
try(detach(package:splines))


