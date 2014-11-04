
## ----eval=FALSE----------------------------------------------------------
install.packages("RWordPress", repos="http://www.omegahat.org/R", build=TRUE)


## ----eval=FALSE----------------------------------------------------------
library(RWordPress)
options(WordpressLogin=c(user="password"),
        WordpressURL="http://your_wp_installation.org/xmlrpc.php")


## ----eval=FALSE----------------------------------------------------------
knit_hooks$set(output=function(x, options) paste("\\[code\\]\n", x, "\\[/code\\]\n", sep=""))
knit_hooks$set(source=function(x, options) paste("\\[code lang='r'\\]\n", x, "\\[/code\\]\n", sep=""))


## ----eval=FALSE----------------------------------------------------------
knit2wp <- function(file) {
    require(XML)
    content <- readLines(file)
    content <- htmlTreeParse(content, trim=FALSE)

    ## WP will add the h1 header later based on the title, so delete here
    content$children$html$children$body$children$h1 <- NULL
    content <- paste(capture.output(print(content$children$html$children$body,
                                          indent=FALSE, tagSeparator="")),
                     collapse="\n")
    content <- gsub("<?.body>", "", content)         # remove body tag
    
    ## enclose code snippets in SyntaxHighlighter format
    content <- gsub("<?pre><code class=\"r\">", "\\[code lang='r'\\]\\\n",
                    content)
    content <- gsub("<?pre><code class=\"no-highlight\">", "\\[code\\]\\\n",
                    content)
    content <- gsub("<?pre><code>", "\\[code\\]\\\n", content)
    content <- gsub("<?/code></pre>", "\\[/code\\]\\\n", content)
    return(content)
}


## ----eval=FALSE----------------------------------------------------------
newPost(content=list(description=knit2wp('rerWorkflow.html'),
                     title='Workflow: Post R markdown to WordPress',
                     categories=c('R')),
        publish=FALSE)


## ----eval=FALSE----------------------------------------------------------
postID <- 99                    # post id returned by newPost()
editPost(postID,
         content=list(description=knit2wp('rerWorkflow.html'),
                      title='Workflow: Post R markdown to WordPress',
                      categories=c('R')),
         publish=FALSE)


