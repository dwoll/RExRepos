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
isSingle <- sample(c(TRUE, FALSE), nrow(myDf1), replace=TRUE)
myDf2    <- myDf1
myDf2$isSingle1    <- isSingle
myDf2["isSingle2"] <- isSingle
myDf3 <- cbind(myDf1, isSingle)
head(myDf3)
myDf4 <- transform(myDf3, rSq=rating^2)
head(myDf4)

## ------------------------------------------------------------------------
dfTemp <- myDf1
dfTemp$group <- NULL
head(dfTemp)

## ------------------------------------------------------------------------
delVars <- c("sex", "IQ")
dfTemp[delVars] <- list(NULL)
head(dfTemp)

## ------------------------------------------------------------------------
(idx1 <- order(myDf1$rating))
myDf1[idx1, ]
(idx2 <- order(myDf1$group, myDf1$IQ))
myDf1[idx2, ]
(idx3 <- order(myDf1$group, -myDf1$rating))
myDf1[idx3, ]

## ------------------------------------------------------------------------
(idxLog <- myDf1$sex == "f")
(idxNum <- which(idxLog))
myDf1[idxNum, ]

## ------------------------------------------------------------------------
(idx2 <- (myDf1$sex == "m") & (myDf1$rating > 2))
myDf1[which(idx2), ]

## ------------------------------------------------------------------------
(idx3 <- (myDf1$IQ < 90) | (myDf1$IQ > 110))
myDf1[which(idx3), ]

## ------------------------------------------------------------------------
myDf1[1:3, c("group", "IQ")]
myDf1[1:3, 2:4]

## ------------------------------------------------------------------------
dfTemp <- myDf1
(names(dfTemp) <- paste(rep(c("A", "B"), each=3), 100:102, sep=""))
(colIdx <- grep("^B.*$", names(dfTemp)))
dfTemp[1:3, colIdx]

## ------------------------------------------------------------------------
subset(myDf1, sex == "f")
subset(myDf1, sex == "f", select=-2)
subset(myDf1, (sex == "m") & (rating > 2))
subset(myDf1, (IQ < 90) | (IQ > 110))
subset(myDf1, group %in% c("CG", "WL"))

## ------------------------------------------------------------------------
myDfNum <- Filter(is.numeric, myDf1)
head(myDfNum)

## ------------------------------------------------------------------------
myDfDouble <- rbind(myDf1, myDf1[sample(1:nrow(myDf1), 4), ])
duplicated(myDfDouble)
myDfUnique <- unique(myDfDouble)

## ------------------------------------------------------------------------
myDfNA           <- myDf1
myDfNA$IQ[4]     <- NA
myDfNA$rating[5] <- NA

## ------------------------------------------------------------------------
is.na(myDfNA)[1:5, c("age", "IQ", "rating")]
apply(is.na(myDfNA), 2, any)
complete.cases(myDfNA)
subset(myDfNA, !complete.cases(myDfNA))
head(na.omit(myDfNA))

