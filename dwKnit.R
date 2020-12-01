## TODO R bug 15012 is fixed -> use gsub() instead of external sed

## add GitHub links to the bottom of a post
gitHubLinks <- function(fIn, fOut) {
    ## determine names for files we link to on GitHub
    fName  <- basename(tools::file_path_sans_ext(fIn))
    fRmd   <- paste(fName, ".Rmd", sep="")
    fMd    <- paste(fName, ".md",  sep="")
    fR     <- paste(fName, ".R",   sep="")
    ghURL  <- "https://github.com/dwoll/RExRepos"
    fCont  <- readLines(fIn)
    nLines <- length(fCont)

    fCont[nLines + 1] <- ""
    fCont[nLines + 2] <- "Get the article source from GitHub"
    fCont[nLines + 3] <- "----------------------------------------------"
    fCont[nLines + 4] <- ""
    fCont[nLines + 5] <-
    paste("[R markdown](", ghURL, "/raw/master/Rmd/", fRmd, ") - ",
          "[markdown](",   ghURL, "/raw/master/md/",  fMd,  ") - ",
          "[R code](",     ghURL, "/raw/master/R/",   fR,   ") - ",
          "[all posts](",  ghURL, "/)", sep="")

    writeLines(fCont, fOut)
}

## necessary post-processing required for building the site with Jekyll or nanoc
## TODO: ensure presence of YAML front matter with relevant entries like in
## https://github.com/jjallaire/rcpp-gallery/blob/gh-pages/_scripts/knit.sh
postProcess <- function(fIn, fOutPre,
                        markdEngine=c("kramdown", "redcarpet", "pandoc"),
                        siteGen=c("jekyll", "nanoc", "none")) {
    markdEngine <- match.arg(markdEngine)
    siteGen     <- match.arg(siteGen)

    ## determine names for new files
    fName   <- basename(tools::file_path_sans_ext(fIn))
    fInTmp  <- paste("../tmp/", fName, "Tmp.md", sep="")
    tocRepl <- c("", "")

    fCont <- sanitizeMath(fIn, markdEngine)  ## replace math delimiters \( and \)
    writeLines(fCont, fIn)                   ## overwrite original file with sanitized one

    if(markdEngine == "kramdown") {
        ## kramdown needs a ToC placeholder -> add that later instead of title
        tocRepl <- c("* ToC", "{:toc}")

        ## replace all remaining ``` with ~~~ for fenced code blocks
        fCont <- gsub("```", "~~~", fCont)
    }

    ## remove h1 title since it will be built from YAML title
    tL          <- grep("^========*\\s*$", fCont) - 1  ## line number with title
    fCont[tL]   <- tocRepl[1]        ## old: title
    fCont[tL+1] <- tocRepl[2]        ## old: =====

    if(siteGen == "jekyll") {
        ## set Jekyll's date prefix
        datePrefix <- "2012-08-08"

        ## replace {{ and }} with { { and } } for Jekyll's template engine liquid
        fCont <- gsub("\\{\\{", "{ {", fCont)
        fCont <- gsub("\\}\\}", "} }", fCont)

        ## output filename with date-prefix notation
        fOut <- paste(dirname(fOutPre), "/", datePrefix, "-", fName, ".md", sep="")
    } else {
        fOut <- paste(dirname(fOutPre), "/", fName, ".md", sep="")
    }

    writeLines(fCont, fOut)
}

## replace MathJax inline math \( and \)
## with $$ (for kramdown) or with $ (for Redcarpet2 and pandoc)
## R bug 15012 makes R eat all resources and lock up for the following regexp
## fCont <- gsub('\\\\)', "$$", fCont)
## -> use external sed instead
## sed for Windows: <http://gnuwin32.sourceforge.net/packages/sed.htm>
sanitizeMath <- function(fIn, markdEngine=c("kramdown", "redcarpet", "pandoc")) {
    markdEngine <- match.arg(markdEngine)

    ## calling external sed differs between platforms
    ## -> find out where we are
    if(.Platform$OS.type == "windows") {
        winRelease <- Sys.info()[["release"]]
        if(winRelease %in% c("7 x64", "7 x32")) {
            if(markdEngine == "kramdown") {
                sedCall <- paste('sed -e "s/\\\\(/\\$\\$/g" -e "s/\\\\)/\\$\\$/g" <', fIn)
            } else {
                sedCall <- paste('sed -e "s/\\\\(/\\$/g" -e "s/\\\\)/\\$/g" <', fIn)
            }
        } else if(winRelease == "XP") {
            ## TODO: this doesn't work on XP
            if(markdEngine == "kramdown") {
                sedCall <- paste('sed -e "s/\\\\\\(/\\\\$\\\\$/g" -e "s/\\\\\\)/\\\\$\\\\$/g" <', fIn)
            } else {
                sedCall <- paste('sed -e "s/\\\\\\(/\\\\$/g" -e "s/\\\\\\)/\\\\$/g" <', fIn)
            }
        }
        shell(sedCall, intern=TRUE)
    } else if(.Platform$OS.type == "unix") {
        if(markdEngine == "kramdown") {
            sedCall <- paste('sed -e "s/\\\\\\(/\\$\\$/g" -e "s/\\\\\\)/\\$\\$/g" <', fIn)
        } else {
            sedCall <- paste('sed -e "s/\\\\\\(/\\$/g" -e "s/\\\\\\)/\\$/g" <', fIn)
        }
        system(sedCall, intern=TRUE)
    }
}

## get arguments and call knit
args <- commandArgs(TRUE)
## input Rmd file
fIn <- args[1]
## output md file
fOut <- args[2]
## which markdown engine wille be used?
markdEngine <- args[3]
## which static site generator will be used?
siteGen     <- args[4]

markdEngine <- match.arg(markdEngine, choices=c("kramdown", "redcarpet", "pandoc"))
siteGen     <- match.arg(siteGen,     choices=c("jekyll", "nanoc", "none"))

## knit one input Rmd file to one output md file
require(knitr)
require(stringr)

## set some directories and get base file name
dirTmp <- "../tmp"
dirMd  <- "../md"
dirR   <- "../R"
fName  <- basename(tools::file_path_sans_ext(fIn))

## configure knitr chunk options
knitr::opts_chunk$set(cache.path=file.path("../tmp/cache/"),
                      fig.path=file.path("../content/assets/figure/"),
                      tidy=FALSE, message=FALSE, warning=FALSE, comment=NA)

## configure hooks for different types of markdown output
knitr::render_markdown(strict=FALSE)

## for Jekyll + Redcarpet2, as well as for nanoc + pandoc,
## code blocks can start with knitr's default fenced code block ```r, otherwise:
if((siteGen == "jekyll") && (markdEngine == "kramdown")) {
    ## for Jekyll + kramdown, code blocks need to start with {% highlight r %}
    knitr::render_jekyll()
} else if((siteGen == "nanoc") && (markdEngine == "kramdown")) {
    ## for nanoc + kramdown, fenced code blocks need to start with ~~~ r
    hook.t <- function(x, options) stringr::str_c("\n\n~~~\n", x, "~~~\n\n")
    hook.r <- function(x, options) { 
        stringr::str_c("\n\n~~~ ", tolower(options$engine), "\n", x, "~~~\n\n")
    }
} else if((siteGen == "nanoc") && (markdEngine == "redcarpet")) {
    ## for nanoc + Redcarpet2, fenced code blocks need to start with ```language-r
    hook.t <- function(x, options) stringr::str_c("\n\n```\n", x, "```\n\n")
    hook.r <- function(x, options) { 
        stringr::str_c("\n\n```language-", tolower(options$engine), "\n", x, "```\n\n")
    }
}

## apply newly defined hooks
if(exists("hook.t") && exists("hook.r")) {
    knitr::knit_hooks$set(source=hook.r, output=hook.t, warning=hook.t,
                          error=hook.t, message=hook.t)
}

## add GitHub-Links, knit to markdown, post-process, and extract R code
gitHubLinks(fIn, paste(dirTmp, "/", fName, "Tmp.Rmd", sep=""))
knitr::knit(     paste(dirTmp, "/", fName, "Tmp.Rmd", sep=""),
                 paste(dirMd,  "/", fName, ".md",     sep=""))
postProcess(     paste(dirMd,  "/", fName, ".md",     sep=""), fOut,
                 markdEngine, siteGen)
knitr::purl(fIn, paste(dirR,   "/", fName, ".R",  sep=""))
