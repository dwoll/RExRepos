
## ------------------------------------------------------------------------
wants <- c("coin", "DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
IQ1  <- c( 99, 131, 118, 112, 128, 136, 120, 107, 134, 122)
IQ2  <- c(134, 103, 127, 121, 139, 114, 121, 132)
IQ3  <- c(110, 123, 100, 131, 108, 114, 101, 128, 110)
IQ4  <- c(117, 125, 140, 109, 128, 137, 110, 138, 127, 141, 119, 148)
Nj   <- c(length(IQ1), length(IQ2), length(IQ3), length(IQ4))
KWdf <- data.frame(DV=c(IQ1, IQ2, IQ3, IQ4),
                   IV=factor(rep(1:4, Nj), labels=c("I", "II", "III", "IV")))


## ------------------------------------------------------------------------
kruskal.test(DV ~ IV, data=KWdf)


## ------------------------------------------------------------------------
library(coin)
kruskal_test(DV ~ IV, distribution=approximate(B=9999), data=KWdf)


## ------------------------------------------------------------------------
pairwise.wilcox.test(KWdf$DV, KWdf$IV, p.adjust.method="holm")


## ------------------------------------------------------------------------
oneway_test(DV ~ IV, distribution=approximate(B=9999), data=KWdf)


## ------------------------------------------------------------------------
set.seed(123)
P    <- 4
Nj   <- c(41, 37, 42, 40)
muJ  <- rep(c(-1, 0, 1, 2), Nj)
JTdf <- data.frame(IV=ordered(rep(LETTERS[1:P], Nj)),
                   DV=rnorm(sum(Nj), muJ, 7))


## ------------------------------------------------------------------------
library(DescTools)
JonckheereTerpstraTest(DV ~ IV, data=JTdf)


## ------------------------------------------------------------------------
library(coin)
kruskal_test(DV ~ IV, distribution=approximate(B=9999), data=JTdf)


## ------------------------------------------------------------------------
N   <- 5
P   <- 4
DV1 <- c(14, 13, 12, 11, 10)
DV2 <- c(11, 12, 13, 14, 15)
DV3 <- c(16, 15, 14, 13, 12)
DV4 <- c(13, 12, 11, 10,  9)
Fdf <- data.frame(id=factor(rep(1:N, times=P)),
                  DV=c(DV1, DV2, DV3, DV4),
                  IV=factor(rep(1:P, each=N),
                            labels=LETTERS[1:P]))


## ------------------------------------------------------------------------
friedman.test(DV ~ IV | id, data=Fdf)


## ------------------------------------------------------------------------
friedman_test(DV ~ IV | id, distribution=approximate(B=9999), data=Fdf)


## ------------------------------------------------------------------------
oneway_test(DV ~ IV | id, distribution=approximate(B=9999), data=Fdf)


## ------------------------------------------------------------------------
N   <- 10
P   <- 4
muJ <- rep(c(-1, 0, 1, 2), each=N)
Pdf <- data.frame(id=factor(rep(1:N, times=P)),
                  DV=rnorm(N*P, muJ, 3),
                  IV=ordered(rep(LETTERS[1:P], each=N)))


## ------------------------------------------------------------------------
library(DescTools)
PageTest(DV ~ IV | id, data=Pdf)


## ------------------------------------------------------------------------
library(coin)
friedman_test(DV ~ IV | id, distribution=approximate(B=9999), data=Pdf)


## ------------------------------------------------------------------------
try(detach(package:DescTools))
try(detach(package:coin))
try(detach(package:survival))
try(detach(package:splines))

