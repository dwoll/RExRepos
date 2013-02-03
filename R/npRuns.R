
## @knitr 
wants <- c("tseries")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
queue <- factor(c("f", "m", "m", "f", "m", "f", "f", "f"))
library(tseries)
runs.test(queue, alternative="greater")


## @knitr 
Nj    <- table(queue)
(runs <- rle(levels(queue)[as.numeric(queue)]))
(rr <- length(runs$lengths))
(rr1 <- table(runs$values)[1])
(rr2 <- table(runs$values)[2])


## @knitr 
getP <- function(r1, r2, n1, n2) {
    # iterations of a symbol <= total number of this symbol?
    stopifnot(r1 <= n1, r2 <= n2)

    # probability in case r1+r2 is uneven
    p <- (choose(n1-1, r1-1) * choose(n2-1, r2-1)) / choose(n1+n2, n1)

    # probability in case r1+r2 is even: twice the uneven case
    ifelse(((r1+r2) %% 2) == 0, 2*p, p)
}


## @knitr 
n1    <- Nj[1]
n2    <- Nj[2]
N     <- sum(Nj)
rMin  <- 2
(rMax <- ifelse(n1 == n2, N, 2*min(n1, n2) + 1))


## @knitr 
p3.2 <- getP(3, 2, n1, n2)
p2.3 <- getP(2, 3, n1, n2)
p3.3 <- getP(3, 3, n1, n2)
p4.3 <- getP(4, 3, n1, n2)


## @knitr 
(pGrEq <- p3.2 + p2.3 + p3.3 + p4.3)


## @knitr 
p2.2 <- getP(2, 2, n1, n2)
p1.2 <- getP(1, 2, n1, n2)
p2.1 <- getP(2, 1, n1, n2)
p1.1 <- getP(1, 1, n1, n2)


## @knitr 
(pLess <- p2.2 + p1.2 + p2.1 + p1.1)
pGrEq + pLess


## @knitr 
muR   <- 1 + ((2*n1*n2) / N)
varR  <- (2*n1*n2*(2*n1*n2 - N)) / (N^2 * (N-1))
rZ    <- (rr-muR) / sqrt(varR)
(pVal <- 1-pnorm(rZ))


## @knitr 
try(detach(package:tseries))


