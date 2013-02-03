
## @knitr 
randVals <- round(rnorm(5), 2)
toString(randVals)


## @knitr 
formatC(c(1, 2.345), width=5, format="f")


## @knitr 
length("ABCDEF")
nchar("ABCDEF")
nchar(c("A", "BC", "DEF"))


## @knitr 
paste("group", LETTERS[1:5], sep="_")
paste(1:5, palette()[1:5], sep=": ")
paste(1:5, letters[1:5], sep=".", collapse=" ")


## @knitr 
N     <- 20
gName <- "A"
mVal  <- 14.2
sprintf("For %d particpants in group %s, the mean was %f", N, gName, mVal)
sprintf("%.3f", 1.23456)


## @knitr 
cVar <- "A string"
cat(cVar, "with\n", 4, "\nwords\n", sep="+")


## @knitr 
print(cVar, quote=FALSE)
noquote(cVar)


## @knitr 
tolower(c("A", "BC", "DEF"))
toupper(c("ghi", "jk", "i"))


## @knitr 
strReverse <- function(x) { sapply(lapply(strsplit(x, NULL), rev), paste, collapse="") }
strReverse(c("Lorem", "ipsum", "dolor", "sit"))


## @knitr 
substring(c("ABCDEF", "GHIJK", "LMNO", "PQR"), first=4, last=5)


## @knitr 
strsplit(c("abc_def_ghi", "jkl_mno"), split="_")
strsplit("Xylophon", split=NULL)


## @knitr 
match(c("abc", "de", "f", "h"), c("abcde", "abc", "de", "fg", "ih"))
pmatch(c("abc", "de", "f", "h"), c("abcde", "abc", "de", "fg", "ih"))


## @knitr 
grep( "A[BC][[:blank:]]", c("AB ", "AB", "AC ", "A "))
grepl("A[BC][[:blank:]]", c("AB ", "AB", "AC ", "A "))


## @knitr 
pat    <- "[[:upper:]]+"
txt    <- c("abcDEFG", "ABCdefg", "abcdefg")
(start <- regexpr(pat, txt))


## @knitr 
len <- attr(start, "match.length")
end <- start + len - 1
substring(txt, start, end)


## @knitr 
glob2rx("asdf*.txt")


## @knitr 
charVec <- c("ABCDEF", "GHIJK", "LMNO", "PQR")
substring(charVec, 4, 5) <- c("..", "xx", "++", "**"); charVec


## @knitr 
sub("em", "XX", "Lorem ipsum dolor sit Lorem ipsum")
gsub("em", "XX", "Lorem ipsum dolor sit Lorem ipsum")


## @knitr 
obj1 <- parse(text="3 + 4")
obj2 <- parse(text=c("vec <- c(1, 2, 3)", "vec^2"))
eval(obj1)
eval(obj2)


