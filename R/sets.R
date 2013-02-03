
## @knitr 
wants <- c("sets")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
a <- c(4, 5, 6)
b <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
m <- c(2, 1, 3, 2, 1)
n <- c(5, 3, 1, 3, 4, 4)
x <- c(1, 1, 2, 2)
y <- c(2, 1)


## @knitr 
setequal(x, y)
duplicated(c(1, 1, 1, 3, 3, 4, 4))
unique(c(1, 1, 1, 3, 3, 4, 4))
length(unique(c("A", "B", "C", "C", "B", "B", "A", "C", "C", "A")))


## @knitr 
union(m, n)


## @knitr 
intersect(m, n)


## @knitr 
setdiff(m, n)
setdiff(n, m)
union(setdiff(m, n), setdiff(n, m))


## @knitr 
is.element(c(29, 23, 30, 17, 30, 10), c(30, 23))
c("A", "Z", "B") %in% c("A", "B", "C", "D", "E")


## @knitr 
(AinB <- all(a %in% b))
(BinA <- all(b %in% a))
AinB & !BinA


## @knitr 
library(sets)
sa <- set(4, 5, 6)
sb <- set(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
sm <- set(2, 1, 3, 2, 1)
sn <- set(5, 3, 1, 3, 4, 4)
sx <- set(1, 1, 2, 2)
sy <- set(2, 1)
se <- 4

set_is_empty(sa)
set_cardinality(sx)
set_power(sm)
set_cartesian(sa, sx)
set_is_equal(sx, sy)
set_union(sm, sn)
set_intersection(sm, sn)
set_symdiff(sa, sb)
set_complement(sm, sn)
set_is_subset(sa, sb)
set_is_proper_subset(sa, sb)
set_contains_element(sa, se)


## @knitr 
try(detach(package:sets))


