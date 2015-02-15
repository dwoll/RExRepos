## ------------------------------------------------------------------------
wants <- c("DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
sex     <- c("m", "f", "f", "m", "m", "m", "f", "f")
(sexFac <- factor(sex))

## ------------------------------------------------------------------------
factor(c(1, 1, 3, 3, 4, 4), levels=1:5)
(sexNum <- rbinom(10, size=1, prob=0.5))
factor(sexNum, labels=c("man", "woman"))
levels(sexFac) <- c("female", "male")
sexFac

## ------------------------------------------------------------------------
(fac1 <- factor(rep(c("A", "B"), c(5, 5))))
(fac2 <- gl(2, 5, labels=c("less", "more"), ordered=TRUE))
sample(fac2, length(fac2), replace=FALSE)

## ------------------------------------------------------------------------
expand.grid(IV1=gl(2, 2, labels=c("a", "b")), IV2=gl(3, 1))

## ------------------------------------------------------------------------
nlevels(sexFac)
summary(sexFac)
levels(sexFac)
str(sexFac)

## ------------------------------------------------------------------------
unclass(sexFac)
unclass(factor(10:15))
as.character(sexFac)

## ------------------------------------------------------------------------
(fac1 <- factor(sample(LETTERS, 5)))
(fac2 <- factor(sample(letters, 3)))
(charVec1 <- levels(fac1)[fac1])
(charVec2 <- levels(fac2)[fac2])
factor(c(charVec1, charVec2))

## ------------------------------------------------------------------------
rep(fac1, times=2)

## ------------------------------------------------------------------------
Njk  <- 2
P    <- 2
Q    <- 3
(IV1 <- factor(rep(c("lo", "hi"), each=Njk*Q)))
(IV2 <- factor(rep(1:Q, times=Njk*P)))
interaction(IV1, IV2)

## ------------------------------------------------------------------------
(status <- factor(c("hi", "lo", "hi", "mid")))
(ordStat <- ordered(status, levels=c("lo", "mid", "hi")))
ordStat[1] > ordStat[2]

## ------------------------------------------------------------------------
(chars <- rep(LETTERS[1:3], each=5))
(fac1  <- factor(chars))
factor(chars, levels=c("C", "A", "B"))

## ------------------------------------------------------------------------
library(DescTools)
(facRe <- reorder.factor(fac1, new.order=c("C", "B", "A")))

## ------------------------------------------------------------------------
vec <- rnorm(15, rep(c(10, 5, 15), each=5), 3)
tapply(vec, fac1, FUN=mean)
reorder(fac1, vec, FUN=mean)

## ------------------------------------------------------------------------
(fac2 <- factor(sample(1:2, 10, replace=TRUE), labels=c("B", "A")))
sort(fac2)
sort(as.character(fac2))

## ------------------------------------------------------------------------
try(detach(package:DescTools))

