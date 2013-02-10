
## @knitr 
numeric(4)
character(3)
logical(5)


## @knitr 
(age <- c(18, 20, 30, 24, 23, 21))
addAge  <- c(27, 21, 19)
(ageNew <- c(age, addAge))
append(age, c(17, 31))


## @knitr 
charVec1 <- c("Z", "Y", "X")
(charVec2 <- c(charVec1, "T", "S", "R"))
LETTERS[c(1, 2, 3)]
letters[c(5, 9, 13)]
(chars <- c("ipsum", "dolor", "sit"))


## @knitr 
length(age)
length(chars)
nchar(chars)


## @knitr 
age[4]
age[4] <- 22
age


## @knitr 
(ageLast <- age[length(age)])
age[length(age) + 1]


## @knitr 
c(11, 12, 13, 14)[2]


## @knitr 
idx <- c(1, 2, 4)
age[idx]
age[c(3, 5, 6)]
age[c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6)]
age[c(4, NA, 1)]


## @knitr 
age[idx] <- c(17, 30, 25)
age


## @knitr 
age[-3]
age[c(-1, -2, -4)]
age[-c(1, 2, 4)]
age[-idx]


## @knitr 
charVec4 <- "word"
numVec   <- c(10, 20, 30)
(combVec <- c(charVec4, numVec))
mode(combVec)


## @knitr 
(namedVec1 <- c(elem1="first", elem2="second"))
namedVec1["elem1"]
(namedVec2 <- c(val1=10, val2=-12, val3=33))
names(namedVec2)
names(namedVec2) <- c("A", "B", "C")
namedVec2


## @knitr 
vec <- c(10, 20, 30, 40, 50)
vec <- vec[c(-4, -5)]
vec
vec <- c(1, 2, 3, 4, 5)
length(vec) <- 3
vec


## @knitr 
age <- c(17, 30, 30, 24, 23, 21)
age < 24
x <- c(2, 4, 8)
y <- c(3, 4, 5)
x == y
x < y


## @knitr 
res <- age > 30
any(res)
any(age < 18)
all(x == y)
res <- age < 24
sum(res)
which(age < 24)
length(which(age < 24))


## @knitr 
x <- c(4, 5, 6)
y <- c(4, 5, 6)
z <- c(1, 2, 3)
all.equal(x, y)
all.equal(y, z)
isTRUE(all.equal(y, z))


## @knitr 
(age <= 20) | (age >= 30)
(age > 20) & (age < 30)


## @knitr 
age[c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE)]
(idx <- (age <= 20) | (age >= 30))
age[idx]
age[(age >= 30) | (age <= 20)]


## @knitr 
age[c(TRUE, FALSE)]
age[c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)]


## @knitr 
vecNA   <- c(-3, 2, 0, NA, -7, 5)
(logIdx <- vecNA > 0)
vecNA[logIdx]


## @knitr 
(numIdx <- which(logIdx))
vecNA[numIdx]
seq(along=logIdx) %in% numIdx


