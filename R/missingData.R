
## @knitr 
vec <- c(2, 5, 7)
vec[5]


## @knitr 
(vec1 <- c(10, 20, NA, 40, 50, NA))
length(vec1)


## @knitr 
is.na(vec1)
any(is.na(vec1))
which(is.na(vec1))
sum(is.na(vec1))


## @knitr 
vec2   <- c(NA, 7, 9, 10, 1, 8)
(matNA <- rbind(vec1, vec2))
is.na(matNA)


## @knitr 
LETTERS[c(1, NA, 3)]


## @knitr 
factor(LETTERS[c(1, NA, 3)])
factor(LETTERS[c(1, NA, 3)], exclude=NULL)


## @knitr 
NA & TRUE
TRUE | NA


## @knitr 
vecNA   <- c(-3, 2, 0, NA, -7, 5)
(logIdx <- vecNA > 0)
vecNA[logIdx]
vecNA[which(logIdx)]


## @knitr 
vec <- c(30, 25, 23, 21, -999, 999)
is.na(vec) <- vec %in% c(-999, 999)
vec


## @knitr 
(mat <- matrix(c(30, 25, 23, 21, -999, 999), nrow=2, ncol=3))
is.na(mat) <- mat %in% c(-999, 999)
mat


## @knitr 
vecNA <- c(-3, 2, 0, NA, -7, 5)
mean(vecNA)


## @knitr 
goodIdx <- !is.na(vecNA)
mean(vecNA[goodIdx])
sd(na.omit(vecNA))
sum(vecNA, na.rm=TRUE)


## @knitr 
ageNA  <- c(18, NA, 27, 22)
DV1    <- c(NA, 1, 5, -3)
DV2    <- c(9, 4, 2, 7)
(matNA <- cbind(ageNA, DV1, DV2))


## @knitr 
apply(matNA, 1, FUN=mean)
apply(matNA, 1, FUN=mean, na.rm=TRUE)


## @knitr 
(rowNAidx <- apply(is.na(matNA), 1, any))
matNA[!rowNAidx, ]


## @knitr 
na.omit(matNA)
colMeans(na.omit(matNA))


## @knitr 
cov(matNA, use="complete.obs")
all(cov(matNA, use="complete.obs") == cov(na.omit(matNA)))


## @knitr eval=FALSE
options(na.action="na.omit")


## @knitr 
rowMeans(matNA)
rowMeans(mat, na.rm=TRUE)
cov(matNA, use="pairwise.complete.obs")


