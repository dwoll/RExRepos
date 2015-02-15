## ------------------------------------------------------------------------
age <- c(17, 30, 30, 25, 23, 21)
matrix(age, nrow=3, ncol=2, byrow=FALSE)
(ageMat <- matrix(age, nrow=2, ncol=3, byrow=TRUE))

## ------------------------------------------------------------------------
age    <- c(19, 19, 31, 19, 24)
weight <- c(95, 76, 94, 76, 76)
height <- c(197, 178, 189, 184, 173)
rbind(age, weight, height)
cbind(age, weight, height)

## ------------------------------------------------------------------------
dim(ageMat)
nrow(ageMat)
ncol(ageMat)
prod(dim(ageMat))

## ------------------------------------------------------------------------
t(ageMat)

## ------------------------------------------------------------------------
as.matrix(1:3)
c(ageMat)

## ------------------------------------------------------------------------
P       <- 2
Q       <- 3
(pqMat  <- matrix(1:(P*Q), nrow=P, ncol=Q))
(rowMat <- row(pqMat))
(colMat <- col(pqMat))

## ------------------------------------------------------------------------
cbind(rowIdx=c(rowMat), colIdx=c(colMat), val=c(pqMat))

## ------------------------------------------------------------------------
mat <- matrix(sample(1:10, 16, replace=TRUE), 4, 4)
upper.tri(mat)
lower.tri(mat)

## ------------------------------------------------------------------------
ageMat <- matrix(sample(16:35, 6, replace=TRUE), nrow=2, ncol=3)
ageMat[2, 2]
ageMat[2, 2] <- 24
ageMat[2, 2]
ageMat[2,  ]
ageMat[ , 1]
ageMat[ ,  ]
ageMat[ , 1, drop=FALSE]
ageMat[ , 2:3]
ageMat[ , c(1, 3)]

## ------------------------------------------------------------------------
idxVec <- c(1, 3, 4)
ageMat[idxVec]

## ------------------------------------------------------------------------
ageMatNew   <- ageMat
(replaceMat <- matrix(c(11, 21, 12, 22), nrow=2, ncol=2))
ageMatNew[ , c(1, 3)] <- replaceMat
ageMatNew

## ------------------------------------------------------------------------
(idxMatLog <- ageMat >= 25)
ageMat[idxMatLog]

## ------------------------------------------------------------------------
(idxMatNum <- which(idxMatLog, arr.ind=TRUE))
ageMat[idxMatNum]
(idxMat <- arrayInd(idxVec, dim(ageMat)))

## ------------------------------------------------------------------------
age    <- c(19, 19, 31, 19, 24)
weight <- c(95, 76, 94, 76, 76)
height <- c(197, 178, 189, 184, 173)
mat    <- cbind(age, weight, height)
(rowOrder1 <- order(mat[ , "age"]))
mat[rowOrder1, ]

## ------------------------------------------------------------------------
rowOrder2 <- order(mat[ , "age"], partial=mat[ , "weight"])
mat[rowOrder2, ]

## ------------------------------------------------------------------------
rowOrder3 <- order(mat[ , "weight"], -mat[ , "height"])
mat[rowOrder3, ]

## ------------------------------------------------------------------------
(myArr1 <- array(1:12, c(2, 3, 2),
                 dimnames=list(row=c("f", "m"), column=c("CG", "WL", "T"),
                               layer=c("high", "low"))))

## ------------------------------------------------------------------------
myArr1[1, 3, 2]
myArr1[2, 1, 2] <- 19
myArr2 <- myArr1*2
myArr2[ , , "high"]

## ------------------------------------------------------------------------
aperm(myArr1, c(2, 1, 3))

## ------------------------------------------------------------------------
aperm(myArr1, c(3, 2, 1))

