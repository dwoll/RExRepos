
## @knitr 
age <- c(17, 30, 30, 25, 23, 21)
sum(age)
cumsum(age)


## @knitr 
diff(age)
diff(age, lag=2)


## @knitr 
prod(age)
cumprod(age)
factorial(5)


## @knitr 
min(age)
max(age)
range(c(17, 30, 30, 25, 23, 21))
diff(range(c(17, 30, 30, 25, 23, 21)))


## @knitr 
which.max(age)


## @knitr 
vec <- c(-5, -8, -2, 10, 9)
val <- 0
which.min(abs(vec-val))


## @knitr 
vec1 <- c(5, 2, 0, 7)
vec2 <- c(3, 3, 9, 2)
pmax(vec1, vec2)
pmin(vec1, vec2)


