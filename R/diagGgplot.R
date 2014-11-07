
## ------------------------------------------------------------------------
wants <- c("ggplot2")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])


## ------------------------------------------------------------------------
Njk    <- 50
P      <- 3
Q      <- 2
IQ     <- rnorm(P*Q*Njk, mean=100, sd=15)
height <- rnorm(P*Q*Njk, mean=175, sd=7)
rating <- sample(LETTERS[1:3], Njk*P*Q, replace=TRUE)
sex    <- factor(rep(c("f", "m"), times=P*Njk))
group  <- factor(rep(c("control", "placebo", "treatment"), each=Q*Njk))
sgComb <- interaction(sex, group)
myDf   <- data.frame(sex, group, sgComb, IQ, height, rating)


## ----diagGgplot01--------------------------------------------------------
library(ggplot2)
pA1 <- ggplot(myDf, aes(x=height, y=IQ, colour=sex, shape=group))
pA2 <- pA1 + geom_point(size=3)
print(pA2)


## ----diagGgplot02--------------------------------------------------------
pA3 <- pA2 + facet_grid(. ~ group)
pA4 <- pA3 + ggtitle("IQ ~ height split by sex and group")
pA5 <- pA4 + guides(shape=FALSE)
print(pA5)


## ----diagGgplot03--------------------------------------------------------
pB1 <- ggplot(myDf, aes(x=rating, group=sex, fill=sex))
pB2 <- pB1 + geom_bar(stat="bin", position=position_dodge())
pB3 <- pB2 + facet_grid(. ~ group)
pB4 <- pB3 + ggtitle("Rating frequencies by sex and group")
print(pB4)


## ----diagGgplot04--------------------------------------------------------
pC1 <- ggplot(myDf, aes(x=IQ, fill=group))
pC2 <- pC1 + geom_histogram()
pC3 <- pC2 + facet_grid(. ~ group)
pC4 <- pC3 + ggtitle("Histogram IQ by group")
pC5 <- pC4 + theme(legend.position="none")
print(pC5)


## ----diagGgplot05--------------------------------------------------------
pD1 <- ggplot(myDf, aes(x=sex, y=height, fill=sex))
pD2 <- pD1 + geom_boxplot()
pD3 <- pD2 + facet_grid(. ~ group)
pD4 <- pD3 + ggtitle("Height by sex and group")
pD5 <- pD4 + theme(legend.position="none")
print(pD5)


## ----diagGgplot06--------------------------------------------------------
pE01 <- ggplot(myDf, aes(x=height, y=IQ, colour=sex:group, shape=sex))
pE02 <- pE01 + geom_hline(aes(yintercept=100), linetype=2)
pE03 <- pE02 + geom_vline(aes(xintercept=180), linetype=2)
pE04 <- pE03 + geom_point(size=3)
pE05 <- pE04 + geom_smooth(method=lm, se=TRUE, size=1.2, fullrange=TRUE)
pE06 <- pE05 + facet_grid(sex ~ group)
pE07 <- pE06 + ggtitle("IQ ~ height split by sex and group")
pE08 <- pE07 + theme(legend.position="none")
pE09 <- pE08 + geom_text(aes(x=190, y=70, label=sgComb))
pE10 <- pE09 + annotate("text", x=165, y=130, label="annotation")
print(pE10)


## ------------------------------------------------------------------------
try(detach(package:ggplot2))

