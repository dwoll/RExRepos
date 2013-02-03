
## @knitr 
wants <- c("car", "hexbin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr rerDiagDistributions01
set.seed(1.234)
x <- rnorm(200, 175, 10)
hist(x, xlab="x", ylab="N", breaks="FD")


## @knitr rerDiagDistributions02
hist(x, freq=FALSE, xlab="x", ylab="relative frequency",
     breaks="FD", main="Histogram und normal PDF")
rug(jitter(x))
curve(dnorm(x, mean(x), sd(x)), lwd=2, col="blue", add=TRUE)


## @knitr rerDiagDistributions03
hist(x, freq=FALSE, xlab="x", breaks="FD",
     main="Histogram and density estimate")
lines(density(x), lwd=2, col="blue")
rug(jitter(x))


## @knitr 
y <- rnorm(100, mean=175, sd=7)
stem(y)


## @knitr 
Nj <- 40
P  <- 3
DV <- rnorm(P*Nj, mean=100, sd=15)
IV <- gl(P, Nj, labels=c("Control", "Group A", "Group B"))


## @knitr rerDiagDistributions04
boxplot(DV ~ IV, ylab="Score", col=c("red", "blue", "green"),
        main="Boxplot of scores in 3 groups")
stripchart(DV ~ IV, pch=16, col="darkgray", vert=TRUE, add=TRUE)


## @knitr rerDiagDistributions05
xC <- DV[IV == "Control"]
xA <- DV[IV == "Group A"]
boxplot(xC, xA)


## @knitr 
Nj  <- 5
DV1 <- rnorm(Nj, 20, 2)
DV2 <- rnorm(Nj, 25, 2)
DV  <- c(DV1, DV2)
IV  <- gl(2, Nj)
Mj  <- tapply(DV, IV, FUN=mean)


## @knitr rerDiagDistributions06
dotchart(DV, gdata=Mj, pch=16, color=rep(c("red", "blue"), each=Nj),
         gcolor="black", labels=rep(LETTERS[1:Nj], 2), groups=IV,
		 xlab="AV", ylab="group",
         main="individual results and means from 2 groups")


## @knitr 
Nj   <- 25
P    <- 4
dice <- sample(1:6, P*Nj, replace=TRUE)
IV   <- gl(P, Nj)


## @knitr rerDiagDistributions07
stripchart(dice ~ IV, xlab="Result", ylab="group", pch=1, col="blue",
           main="Dice results: 4 groups", sub="jitter-method", method="jitter")
stripchart(dice ~ IV, xlab="Result", ylab="group", pch=16, col="red",
           main="Dice results: 4 groups", sub="stack-method", method="stack")


## @knitr rerDiagDistributions08
DV1 <- rnorm(200)
DV2 <- rf(200, df1=3, df2=15)
qqplot(DV1, DV2, xlab="quantile N(0, 1)", ylab="quantile F(3, 15)",
       main="Comparison of quantiles from N(0, 1) and F(3, 15)")


## @knitr rerDiagDistributions09
height <- rnorm(100, mean=175, sd=7)
qqnorm(height)
qqline(height, col="red", lwd=2)


## @knitr rerDiagDistributions10
vec <- round(rnorm(10), 1)
Fn  <- ecdf(vec)
plot(Fn, main="Empirical cumulative distribution function")
curve(pnorm, add=TRUE, col="gray", lwd=2)


## @knitr 
N  <- 200
P  <- 2
x  <- rnorm(N, 100, 15)
y  <- 0.5*x + rnorm(N, 0, 10)
IV <- gl(P, N/P, labels=LETTERS[1:P])


## @knitr rerDiagDistributions11
plot(x, y, pch=c(4, 16)[unclass(IV)], lwd=2,
     col=c("black", "blue")[unclass(IV)],
     main="Joint distribution per group")
legend(x="topleft", legend=c("group A", "group B"),
       pch=c(4, 16), col=c("black", "blue"))


## @knitr rerDiagDistributions12
library(car)
dataEllipse(x, y, xlab="x", ylab="y", asp=1, levels=0.5, lwd=2, center.pch=16,
            col="blue", main="Joint distribution of two variables")
legend(x="bottomright", legend=c("Data", "centroid", "distribution ellipse"),
       pch=c(1, 16, NA), lty=c(NA, NA, 1), col=c("black", "blue", "blue"))


## @knitr rerDiagDistributions13
N  <- 5000
xx <- rnorm(N, 100, 15)
yy <- 0.4*xx + rnorm(N, 0, 10)
plot(xx, yy, pch=16, col=rgb(0, 0, 1, 0.3))


## @knitr rerDiagDistributions14
smoothScatter(xx, yy, bandwidth=4)


## @knitr rerDiagDistributions15
library(hexbin)
res <- hexbin(xx, yy, xbins=20)
plot(res)
summary(res)


## @knitr 
try(detach(package:car))
try(detach(package:nnet))
try(detach(package:MASS))
try(detach(package:hexbin))
try(detach(package:grid))
try(detach(package:lattice))


