
## ------------------------------------------------------------------------
age    <- c(19, 19, 31, 19, 24)
weight <- c(95, 76, 94, 76, 76)
height <- c(197, 178, 189, 184, 173)
(mat   <- cbind(age, weight, height))


## ------------------------------------------------------------------------
sum(mat)
rowSums(mat)
mean(mat)
colMeans(mat)


## ------------------------------------------------------------------------
apply(mat, 2, sum)
apply(mat, 1, max)
apply(mat, 1, range)
apply(mat, 2, mean, trim=0.1)


## ------------------------------------------------------------------------
Mj <- rowMeans(mat)
Mk <- colMeans(mat)
sweep(mat, 1, Mj, "-")
t(scale(t(mat), center=TRUE, scale=FALSE))
sweep(mat, 2, Mk, "-")
scale(mat, center=TRUE, scale=FALSE)


## ------------------------------------------------------------------------
cov(mat)
cor(mat)
cov.wt(mat, method="ML")
diag(cov(mat))


## ------------------------------------------------------------------------
vec <- rnorm(nrow(mat))
cor(mat, vec)
cor(vec, mat)

