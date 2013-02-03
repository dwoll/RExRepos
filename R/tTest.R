
## @knitr 
set.seed(1.234)
N    <- 100
DV   <- rnorm(N, 5, 20)
muH0 <- 0
t.test(DV, alternative="two.sided", mu=muH0)


## @knitr 
(d <- (mean(DV) - muH0) / sd(DV))


## @knitr 
Nj     <- c(18, 21)
DVm    <- rnorm(Nj[1], 180, 10)
DVf    <- rnorm(Nj[2], 175, 6)
tIndDf <- data.frame(DV=c(DVm, DVf),
                     IV=factor(rep(c("f", "m"), Nj)))


## @knitr results='hide'
t.test(DVf, DVm, alternative="less", var.equal=TRUE)


## @knitr 
t.test(DV ~ IV, alternative="greater", var.equal=TRUE, data=tIndDf)


## @knitr 
t.test(DV ~ IV, alternative="greater", var.equal=FALSE, data=tIndDf)


## @knitr 
n1 <- Nj[1]
n2 <- Nj[2]
sdPool <- sqrt(((n1-1)*var(DVm) + (n2-1)*var(DVf)) / (n1+n2-2))
(d     <- (mean(DVm) - mean(DVf)) / sdPool)


## @knitr 
N      <- 20
DVpre  <- rnorm(N, mean=90,  sd=15)
DVpost <- rnorm(N, mean=100, sd=15)
tDepDf <- data.frame(DV=c(DVpre, DVpost),
                     IV=factor(rep(0:1, each=N), labels=c("pre", "post")))


## @knitr 
t.test(DV ~ IV, alternative="less", paired=TRUE, data=tDepDf)


## @knitr results='hide'
DVdiff <- DVpre - DVpost
t.test(DVdiff, alternative="less")


## @knitr 
(d <- mean(DVdiff) / sd(DVdiff))


