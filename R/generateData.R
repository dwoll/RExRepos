## ------------------------------------------------------------------------
N <- 5
numeric(N)
matrix(numeric(N))
character(N)
vector(mode="list", length=N)

## ------------------------------------------------------------------------
20:26
26:20
-4:2
-(4:2)
seq(from=2, to=12, by=2)
seq(from=2, to=11, by=2)
seq(from=0, to=-1, length.out=5)

## ------------------------------------------------------------------------
age <- c(18, 20, 30, 24, 23, 21)
seq(along=age)
vec <- numeric(0)
length(vec)
1:length(vec)
seq(along=vec)

## ------------------------------------------------------------------------
rep(1:3, times=5)
rep(c("A", "B", "C"), times=c(2, 3, 4))
rep(age, each=2)

## ------------------------------------------------------------------------
set.seed(123)
sample(1:6, size=20, replace=TRUE)
sample(c("rot", "gruen", "blau"), size=8, replace=TRUE)
x <- c(2, 4, 6, 8)
sample(x[(x %% 4) == 0])
sample(x[(x %% 8) == 0])

## ------------------------------------------------------------------------
runif(5, min=1, max=6)
rbinom(20, size=5, prob=0.3)
rchisq(4, df=7)
rnorm(6, mean=100, sd=15)
rt(5, df=5, ncp=1)
rf(5, df1=2, df2=10)

