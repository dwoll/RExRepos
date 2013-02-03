
## @knitr 
wants <- c("binom")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
DV   <- factor(c("+", "+", "-", "+", "-", "+", "+"), levels=c("+", "-"))
N    <- length(DV)
(tab <- table(DV))
pH0 <- 0.25
binom.test(tab, p=pH0, alternative="greater", conf.level=0.95)


## @knitr 
N    <- 20
hits <- 10
binom.test(hits, N, p=pH0, alternative="two.sided")


## @knitr 
sum(dbinom(hits:N, N, p=pH0)) + sum(dbinom(0, N, p=pH0))


## @knitr 
library(binom)
binom.confint(tab[1], sum(tab))


## @knitr 
total <- c(4000, 5000, 3000)
hits  <- c( 585,  610,  539)
prop.test(hits, total)


## @knitr 
try(detach(package:binom))
try(detach(package:lattice))


