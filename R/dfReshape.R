
## @knitr 
set.seed(1.234)
Nj     <- 4
cond1  <- sample(1:10, Nj, replace=TRUE)
cond2  <- sample(1:10, Nj, replace=TRUE)
cond3  <- sample(1:10, Nj, replace=TRUE)
dfTemp <- data.frame(cond1, cond2, cond3)
(res   <- stack(dfTemp, select=c("cond1", "cond3")))
str(res)


## @knitr 
unstack(res)


## @knitr 
res$IVnew <- factor(sample(rep(c("A", "B"), Nj), 2*Nj, replace=FALSE))
res$DVnew <- sample(100:200, 2*Nj)
head(res)
unstack(res, DVnew ~ IVnew)


## @knitr 
Nj      <- 2
P       <- 2
Q       <- 3
id      <- 1:(P*Nj)
DV_t1   <- round(rnorm(P*Nj, -1, 1), 2)
DV_t2   <- round(rnorm(P*Nj,  0, 1), 2)
DV_t3   <- round(rnorm(P*Nj,  1, 1), 2)
IVbtw   <- factor(rep(c("A", "B"), Nj))
(dfWide <- data.frame(id, IVbtw, DV_t1, DV_t2, DV_t3))


## @knitr 
idL    <- rep(id, Q)
DVl    <- c(DV_t1, DV_t2, DV_t3)
IVwth  <- factor(rep(1:3, each=P*Nj))
IVbtwL <- rep(IVbtw, times=Q)
dfLong <- data.frame(id=idL, IVbtw=IVbtwL, IVwth=IVwth, DV=DVl)
dfLong[order(dfLong$id), ]


## @knitr 
resLong <- reshape(dfWide, varying=c("DV_t1", "DV_t2", "DV_t3"),
                   direction="long", idvar=c("id", "IVbtw"),
                   v.names="DV", timevar="IVwth")
resLong[order(resLong$id), ]


## @knitr 
resLong$IVwth <- factor(resLong$IVwth)
all.equal(dfLong, resLong, check.attributes=FALSE)


## @knitr 
reshape(dfLong, v.names="DV", timevar="IVwth", idvar=c("id", "IVbtw"),
        direction="wide")


## @knitr 
Nj   <- 4
id   <- 1:Nj
t_11 <- round(rnorm(Nj,  8, 2), 2)
t_21 <- round(rnorm(Nj, 13, 2), 2)
t_31 <- round(rnorm(Nj, 13, 2), 2)
t_12 <- round(rnorm(Nj, 10, 2), 2)
t_22 <- round(rnorm(Nj, 15, 2), 2)
t_32 <- round(rnorm(Nj, 15, 2), 2)
dfW  <- data.frame(id, t_11, t_21, t_31, t_12, t_22, t_32)


## @knitr 
(dfL1 <- reshape(dfW, varying=list(c("t_11", "t_21", "t_31"),
                                   c("t_12", "t_22", "t_32")),
                 direction="long", timevar="IV1", idvar="id",
                 v.names=c("IV2-1", "IV2-2")))


## @knitr 
dfL2 <- reshape(dfL1, varying=c("IV2-1", "IV2-2"),
				direction="long", timevar="IV2",
				idvar=c("id", "IV1"), v.names="DV")
head(dfL2)


## @knitr 
dfW1 <- reshape(dfL2, v.names="DV", timevar="IV1",
                idvar=c("id", "IV2"), direction="wide")


## @knitr 
dfW2 <- reshape(dfW1, v.names=c("DV.1", "DV.2", "DV.3"),
                timevar="IV2", idvar="id", direction="wide")

all.equal(dfW, dfW2, check.attributes=FALSE)


