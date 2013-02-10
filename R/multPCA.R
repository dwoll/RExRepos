
## @knitr 
wants <- c("mvtnorm", "psych", "robustbase", "pcaPP")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(123)
library(mvtnorm)
Sigma <- matrix(c(4, 2, 2, 3), ncol=2)
mu    <- c(1, 2)
N     <- 50
X     <- rmvnorm(N, mean=mu, sigma=Sigma)


## @knitr 
(pca <- prcomp(X))


## @knitr 
summary(pca)
pca$sdev^2 / sum(diag(cov(X)))


## @knitr rerMultPCA01
plot(pca)


## @knitr 
(pcaPrin <- princomp(X))
(G <- pcaPrin$loadings)
pc <- pcaPrin$scores
head(pc)


## @knitr 
Gscl <- G %*% diag(pca$sdev)
ctr  <- colMeans(X)
xMat <- rbind(ctr[1] - Gscl[1, ], ctr[1])
yMat <- rbind(ctr[2] - Gscl[2, ], ctr[2])
ab1  <- solve(cbind(1, xMat[ , 1]), yMat[ , 1])
ab2  <- solve(cbind(1, xMat[ , 2]), yMat[ , 2])


## @knitr rerMultPCA02
plot(X, xlab="x", ylab="y", pch=20, asp=1,
     main="Data und principal components")
abline(coef=ab1, lwd=2, col="gray")
abline(coef=ab2, lwd=2, col="gray")
matlines(xMat, yMat, lty=1, lwd=6, col="blue")
points(ctr[1], ctr[2], pch=16, col="red", cex=3)
legend(x="topleft", legend=c("data", "PC axes", "SDs of PC", "centroid"),
       pch=c(20, NA, NA, 16), lty=c(NA, 1, 1, NA), lwd=c(NA, 2, 2, NA),
       col=c("black", "gray", "blue", "red"), bg="white")


## @knitr 
Hs   <- scale(pc)
BHs  <- t(Gscl %*% t(Hs))
repr <- sweep(BHs, 2, ctr, "+")
all.equal(X, repr)
sum((X-repr)^2)


## @knitr 
BHs1  <- t(Gscl[ , 1] %*% t(Hs[ , 1]))
repr1 <- sweep(BHs1, 2, ctr, "+")
sum((X-repr1)^2)
qr(scale(repr1, center=TRUE, scale=FALSE))$rank


## @knitr rerMultPCA03
plot(X, xlab="x", ylab="y", pch=20, asp=1, main="Data und approximation")
abline(coef=ab1, lwd=2, col="gray")
abline(coef=ab2, lwd=2, col="gray")
segments(X[ , 1], X[ , 2], repr1[ , 1], repr1[ , 2])
points(repr1, pch=1, lwd=2, col="blue", cex=2)
points(ctr[1], ctr[2], pch=16, col="red", cex=3)
legend(x="topleft", legend=c("data", "PC axes", "centroid", "approximation"),
       pch=c(20, NA, 16, 1), lty=c(NA, 1, NA, NA), lwd=c(NA, 2, NA, 2),
       col=c("black", "gray", "red", "blue"), bg="white")


## @knitr 
Gscl %*% t(Gscl)
cov(X)
Gscl[ , 1] %*% t(Gscl[ , 1])


## @knitr 
library(robustbase)
princomp(X, cov=covMcd(X))


## @knitr 
library(pcaPP)
PCAproj(X, k=ncol(X), method="qn")


## @knitr 
try(detach(package:pcaPP))
try(detach(package:mvtnorm))
try(detach(package:psych))
try(detach(package:robustbase))


