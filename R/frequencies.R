
## @knitr 
wants <- c("epitools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## @knitr 
set.seed(1.234)
(myLetters <- sample(LETTERS[1:5], 12, replace=TRUE))
(tab <- table(myLetters))
names(tab)
tab["B"]


## @knitr rerFrequencies01
barplot(tab, main="Counts")


## @knitr 
(relFreq <- prop.table(tab))


## @knitr 
cumsum(relFreq)


## @knitr 
letFac <- factor(myLetters, levels=c(LETTERS[1:5], "Q"))
letFac
table(letFac)


## @knitr 
(vec <- rep(rep(c("f", "m"), 3), c(1, 3, 2, 4, 1, 2)))


## @knitr 
(res <- rle(vec))


## @knitr 
length(res$lengths)


## @knitr 
inverse.rle(res)


## @knitr 
N    <- 10
(sex <- factor(sample(c("f", "m"), N, replace=TRUE)))
(work <- factor(sample(c("home", "office"), N, replace=TRUE)))
(cTab <- table(sex, work))


## @knitr 
summary(cTab)


## @knitr rerFrequencies02
barplot(cTab, beside=TRUE, legend.text=rownames(cTab), ylab="absolute frequency")


## @knitr 
counts   <- sample(0:5, N, replace=TRUE)
(persons <- data.frame(sex, work, counts))


## @knitr 
xtabs(~ sex + work, data=persons)
xtabs(counts ~ sex + work, data=persons)


## @knitr 
apply(cTab, MARGIN=1, FUN=sum)
colMeans(cTab)
addmargins(cTab, c(1, 2), FUN=mean)


## @knitr 
(relFreq <- prop.table(cTab))


## @knitr 
prop.table(cTab, 1)


## @knitr 
prop.table(cTab, 2)


## @knitr 
(group <- factor(sample(c("A", "B"), 10, replace=TRUE)))
ftable(work, sex, group, row.vars="work", col.vars=c("sex", "group"))


## @knitr 
library(epitools)
expand.table(cTab)


## @knitr 
as.data.frame(cTab, stringsAsFactors=TRUE)


## @knitr 
(vec <- round(rnorm(10), 2))
Fn <- ecdf(vec)
Fn(vec)
100 * Fn(0.1)
Fn(sort(vec))
knots(Fn)


## @knitr rerFrequencies03
plot(Fn, main="cumulative frequencies")


## @knitr 
try(detach(package:epitools))


