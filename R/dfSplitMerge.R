
## @knitr 
set.seed(1.234)
N      <- 12
sex    <- sample(c("f", "m"), N, replace=TRUE)
group  <- sample(rep(c("CG", "WL", "T"), 4), N, replace=FALSE)
age    <- sample(18:35, N, replace=TRUE)
IQ     <- round(rnorm(N, mean=100, sd=15))
rating <- round(runif(N, min=0, max=6))
(myDf  <- data.frame(id=1:N, sex, group, age, IQ, rating))


## @knitr 
(lDf <- split(myDf, myDf$group))
split(myDf, list(myDf$group, myDf$sex))
unsplit(lDf, myDf$group)


## @knitr 
(dfNew <- data.frame(id=13:15,
                     group=c("CG", "WL", "T"),
                     sex=c("f", "f", "m"),
                     age=c(18, 31, 21),
                     IQ=c(116, 101, 99),
                     rating=c(4, 4, 1)))
dfComb <- rbind(myDf, dfNew)
dfComb[11:15, ]


## @knitr 
(dfA <- data.frame(id=1:4,
                   initials=c("AB", "CD", "EF", "GH"),
                   IV1=c("-", "-", "+", "+"),
                   DV1=c(10, 10, 11, 14)))
(dfB <- data.frame(id=1:4,
                   initials=c("AB", "CD", "EF", "GH"),
                   IV2=c("A", "B", "A", "B"),
                   DV2=c(91, 89, 92, 79)))


## @knitr 
merge(dfA, dfB)
merge(dfA, dfB, by.x=c(TRUE, FALSE, FALSE, FALSE),
                by.y=c(TRUE, FALSE, FALSE, FALSE))


## @knitr 
(dfC <- data.frame(id=3:6,
                   initials=c("EF", "GH", "IJ", "KL"),
                   IV2=c("A", "B", "A", "B"),
                   DV2=c(92, 79, 101, 81)))


## @knitr 
merge(dfA, dfC)
merge(dfA, dfC, all.y=TRUE)
merge(dfA, dfC, all.x=TRUE, all.y=TRUE)


