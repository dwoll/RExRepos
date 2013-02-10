
## @knitr 
3 + 7
9 / 3
9 * (3+2)
12^2 + 1.5*10
10 %/% 3
10 %% 3


## @knitr 
"/"(1, 10)
"+"(2, 3)


## @knitr 
sqrt(4)
sin(pi/2)
abs(-4)
log10(100)
exp(1)


## @knitr 
round(1.271)
round(pi, digits=3)
ceiling(1.2)
floor(3.7)
trunc(22.913)


## @knitr 
exp(1)^((0+1i)*pi)
exp(1)^(-pi/2) - (0+1i)^(0+1i)
sqrt(-1)
sqrt(-1+0i)


## @knitr 
.Machine$integer.max
.Machine$double.eps


## @knitr 
1/0
is.infinite(1/0)
0/0
is.nan(0/0)
NULL
is.null(NULL)


## @knitr 
x1 <- 2
x2 <- 10
x3 <- -7
x1 * 2
x2^x1 + x3


## @knitr 
TRUE
FALSE
!TRUE
!FALSE


## @knitr 
isTRUE(TRUE)
isTRUE(FALSE)


## @knitr 
TRUE == TRUE
TRUE == FALSE
TRUE != TRUE
TRUE != FALSE
TRUE & TRUE
TRUE & FALSE
FALSE & FALSE
FALSE & TRUE
TRUE | TRUE
TRUE | FALSE
FALSE | FALSE
FALSE | TRUE
xor(TRUE, FALSE)
xor(TRUE, TRUE)


## @knitr 
c(TRUE,  FALSE, FALSE) && c(TRUE,  TRUE, FALSE)
c(FALSE, FALSE, TRUE)  || c(FALSE, TRUE, FALSE)


## @knitr 
4 < 8
7 < 3
4 > 4
4 >= 4


## @knitr 
any(c(FALSE, FALSE, FALSE))
any(c(FALSE, FALSE, TRUE))
all(c(TRUE, TRUE, FALSE))
any(c(TRUE, TRUE, TRUE))


## @knitr 
all(numeric(0))


## @knitr 
any(numeric(0))


## @knitr 
4L == 4
identical(4L, 4)


## @knitr 
0.1 + 0.2 == 0.3
1 %/% 0.1
sin(pi)
1 - ((1/49) * 49)
1 - ((1/48) * 48)


## @knitr 
isTRUE(all.equal(0.123450001, 0.123450000))
0.123400001 == 0.123400000
all.equal(0.12345001, 0.12345000)
isTRUE(all.equal(0.12345001,  0.12345000))


