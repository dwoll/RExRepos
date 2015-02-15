## ------------------------------------------------------------------------
wants <- c("DescTools")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
randVals <- round(rnorm(5), 2)
toString(randVals)

## ------------------------------------------------------------------------
formatC(c(1, 2.345), width=5, format="f")

## ------------------------------------------------------------------------
length("ABCDEF")
nchar("ABCDEF")
nchar(c("A", "BC", "DEF"))

## ------------------------------------------------------------------------
paste("group", LETTERS[1:5], sep="_")
paste(1:5, palette()[1:5], sep=": ")
paste(1:5, letters[1:5], sep=".", collapse=" ")

## ------------------------------------------------------------------------
paste(1, NA, 2, NULL, 3, character(0), sep="_")

## ------------------------------------------------------------------------
N     <- 20
gName <- "A"
mVal  <- 14.2
sprintf("For %d particpants in group %s, the mean was %f", N, gName, mVal)
sprintf("%.3f", 1.23456)

## ------------------------------------------------------------------------
cVar <- "A string"
cat(cVar, "with\n", 4, "\nwords\n", sep="+")

## ------------------------------------------------------------------------
print(cVar, quote=FALSE)
noquote(cVar)

## ------------------------------------------------------------------------
tolower(c("A", "BC", "DEF"))
toupper(c("ghi", "jk", "i"))
abbreviate("AfairlyLongString", minlength=6)

## ------------------------------------------------------------------------
library(DescTools)
StrRev(c("Lorem", "ipsum", "dolor", "sit"))

## ------------------------------------------------------------------------
substring(c("ABCDEF", "GHIJK", "LMNO", "PQR"), first=4, last=5)

## ------------------------------------------------------------------------
strsplit(c("abc_def_ghi", "jkl_mno"), split="_")
strsplit("Xylophon", split=NULL)

## ------------------------------------------------------------------------
match(c("abc", "de", "f", "h"), c("abcde", "abc", "de", "fg", "ih"))
pmatch(c("abc", "de", "f", "h"), c("abcde", "abc", "de", "fg", "ih"))

## ------------------------------------------------------------------------
grep( "A[BC][[:blank:]]", c("AB ", "AB", "AC ", "A "))
grepl("A[BC][[:blank:]]", c("AB ", "AB", "AC ", "A "))

## ------------------------------------------------------------------------
pat    <- "[[:upper:]]+"
txt    <- c("abcDEFG", "ABCdefg", "abcdefg")
(start <- regexpr(pat, txt))

## ------------------------------------------------------------------------
len <- attr(start, "match.length")
end <- start + len - 1
substring(txt, start, end)

## ------------------------------------------------------------------------
glob2rx("asdf*.txt")

## ------------------------------------------------------------------------
charVec <- c("ABCDEF", "GHIJK", "LMNO", "PQR")
substring(charVec, 4, 5) <- c("..", "xx", "++", "**"); charVec

## ------------------------------------------------------------------------
sub("em", "XX", "Lorem ipsum dolor sit Lorem ipsum")
gsub("em", "XX", "Lorem ipsum dolor sit Lorem ipsum")
gsub("^[[:alpha:]]+-([[:digit:]]+)-[[:alpha:]]+$", "\\1", "abc-412-def")

## ------------------------------------------------------------------------
obj1 <- parse(text="3 + 4")
obj2 <- parse(text=c("vec <- c(1, 2, 3)", "vec^2"))
eval(obj1)
eval(obj2)

## ------------------------------------------------------------------------
try(detach(package:DescTools))

