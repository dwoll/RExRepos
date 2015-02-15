## ------------------------------------------------------------------------
wants <- c("DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
set.seed(123)
(myLetters <- sample(LETTERS[1:5], 12, replace=TRUE))
(tab <- table(myLetters))
names(tab)
tab["B"]

## ----rerFrequencies01----------------------------------------------------
barplot(tab, main="Counts")

## ------------------------------------------------------------------------
(relFreq <- prop.table(tab))

## ------------------------------------------------------------------------
cumsum(relFreq)

## ------------------------------------------------------------------------
letFac <- factor(myLetters, levels=c(LETTERS[1:5], "Q"))
letFac
table(letFac)

## ------------------------------------------------------------------------
(vec <- rep(rep(c("f", "m"), 3), c(1, 3, 2, 4, 1, 2)))

## ------------------------------------------------------------------------
(res <- rle(vec))

## ------------------------------------------------------------------------
length(res$lengths)

## ------------------------------------------------------------------------
inverse.rle(res)

## ------------------------------------------------------------------------
N    <- 10
(sex <- factor(sample(c("f", "m"), N, replace=TRUE)))
(work <- factor(sample(c("home", "office"), N, replace=TRUE)))
(cTab <- table(sex, work))

## ------------------------------------------------------------------------
summary(cTab)

## ----rerFrequencies02----------------------------------------------------
barplot(cTab, beside=TRUE, legend.text=rownames(cTab), ylab="absolute frequency")

## ------------------------------------------------------------------------
counts   <- sample(0:5, N, replace=TRUE)
(persons <- data.frame(sex, work, counts))

## ------------------------------------------------------------------------
xtabs(~ sex + work, data=persons)
xtabs(counts ~ sex + work, data=persons)

## ------------------------------------------------------------------------
apply(cTab, MARGIN=1, FUN=sum)
colMeans(cTab)
addmargins(cTab, c(1, 2), FUN=mean)

## ------------------------------------------------------------------------
(relFreq <- prop.table(cTab))

## ------------------------------------------------------------------------
prop.table(cTab, margin=1)

## ------------------------------------------------------------------------
prop.table(cTab, margin=2)

## ------------------------------------------------------------------------
(group <- factor(sample(c("A", "B"), 10, replace=TRUE)))
ftable(work, sex, group, row.vars="work", col.vars=c("sex", "group"))

## ------------------------------------------------------------------------
library(DescTools)
Untable(cTab)

## ------------------------------------------------------------------------
as.data.frame(cTab, stringsAsFactors=TRUE)

## ------------------------------------------------------------------------
(vec <- round(rnorm(10), 2))
Fn <- ecdf(vec)
Fn(vec)
100 * Fn(0.1)
Fn(sort(vec))
knots(Fn)

## ----rerFrequencies03----------------------------------------------------
plot(Fn, main="cumulative frequencies")

## ------------------------------------------------------------------------
try(detach(package:DescTools))

