
## ------------------------------------------------------------------------
wants <- c("car")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
set.seed(123)
N      <- 12
sex    <- sample(c("f", "m"), N, replace=TRUE)
group  <- sample(rep(c("CG", "WL", "T"), 4), N, replace=FALSE)
age    <- sample(18:35, N, replace=TRUE)
IQ     <- round(rnorm(N, mean=100, sd=15))
rating <- round(runif(N, min=0, max=6))
(myDf1 <- data.frame(id=1:N, sex, group, age, IQ, rating))


## ------------------------------------------------------------------------
dim(myDf1)
nrow(myDf1)
ncol(myDf1)
summary(myDf1)
str(myDf1)


## ------------------------------------------------------------------------
head(myDf1)
tail(myDf1)


## ------------------------------------------------------------------------
library(car)
some(myDf1, n=5)


## ----eval=FALSE----------------------------------------------------------
View(myDf1)
fix(myDf1)
# not shown


## ------------------------------------------------------------------------
fac   <- c("CG", "T1", "T2")
DV1   <- c(14, 22, 18)
DV2   <- c("red", "blue", "blue")
myDf2 <- data.frame(fac, DV1, DV2, stringsAsFactors=FALSE)
str(myDf2)


## ------------------------------------------------------------------------
fac   <- as.factor(fac)
myDf3 <- data.frame(fac, DV1, DV2, stringsAsFactors=FALSE)
str(myDf3)


## ------------------------------------------------------------------------
dimnames(myDf1)
names(myDf1)
names(myDf1)[3]
names(myDf1)[3] <- "fac"
names(myDf1)
names(myDf1)[names(myDf1) == "fac"] <- "group"
names(myDf1)


## ------------------------------------------------------------------------
(rows <- paste("Z", 1:12, sep=""))
rownames(myDf1) <- rows
head(myDf1)


## ------------------------------------------------------------------------
myDf1[[3]][2]
myDf1$rating
myDf1$age[4]
myDf1$IQ[10:12] <- c(99, 110, 89)
myDf1[3, 4]
myDf1[4, "group"]
myDf1[2, ]
myDf1[, "age"]
myDf1[1:5, 4, drop=FALSE]


## ------------------------------------------------------------------------
with(myDf1, tapply(IQ, group, FUN=mean))
xtabs(~ sex + group, data=myDf1)
IQ[3]
attach(myDf1)
IQ[3]
search()[1:4]


## ------------------------------------------------------------------------
IQ[3] <- 130; IQ[3]
myDf1$IQ[3]
detach(myDf1)
IQ


## ------------------------------------------------------------------------
try(detach(package:car))

