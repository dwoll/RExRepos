
## @knitr 
wants <- c("GPArotation", "mvtnorm", "psych")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
N <- 200
P <- 6
Q <- 2
(Lambda <- matrix(c(0.7,-0.4, 0.8,0, -0.2,0.9, -0.3,0.4, 0.3,0.7, -0.8,0.1),
                  nrow=P, ncol=Q, byrow=TRUE))


## @knitr 
set.seed(123)
library(mvtnorm)
Kf <- diag(Q)
mu <- c(5, 15)
FF <- rmvnorm(N, mean=mu,        sigma=Kf)
E  <- rmvnorm(N, mean=rep(0, P), sigma=diag(P))
X  <- FF %*% t(Lambda) + E


## @knitr 
(fa <- factanal(X, factors=2, scores="regression"))


## @knitr 
library(psych)
corMat <- cor(X)
(faPC  <- fa(r=corMat, nfactors=2, n.obs=N, rotate="varimax"))


## @knitr 
bartlett <- fa$scores
head(bartlett)


## @knitr 
anderson <- factor.scores(x=X, f=faPC, method="Anderson")
head(anderson$scores)


## @knitr rerMultFA01
factor.plot(faPC, cut=0.5)
fa.diagram(faPC)


## @knitr rerMultFA02
fa.parallel(X)                     # parallel analysis
vss(X, n.obs=N, rotate="varimax")  # very simple structure


## @knitr 
try(detach(package:psych))
try(detach(package:GPArotation))
try(detach(package:mvtnorm))


