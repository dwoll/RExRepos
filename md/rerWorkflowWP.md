---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Build websites with R and WordPress"
categories: [Workflow]
rerCat: Workflow
tags: [knitr, WordPress]
---

Build websites with R and WordPress
=========================

**Note: The described setup was last tested on 02/2013 and may require changes to work with current versions of WordPress**

Setup for WordPress
-------------------------

### Install required R packages and WP plugins

For blogging from R to WP, I recommend:

 - [SyntaxHighlighter](http://wordpress.org/extend/plugins/syntaxhighlighter/) plugin for WordPress for code boxes with R syntax highlighting
 - [MathJax](http://wordpress.org/extend/plugins/mathjax-latex/) plugin for WordPress for nice math rendering using $\LaTeX$ syntax
 - [`RWordPress`](http://www.omegahat.org/RWordPress/) R package for uploading posts from R to WP

You will need to build `RWordPress` yourself, even on Windows. `RWordPress` depends on the packages `RCurl`, `XML`, and `XMLRPC`. Note that `XMLRPC` is available from the [BioConductor](http://bioconductor.org/packages/release/extra/html/XMLRPC.html) repository. On Linux, all build tools should already be installed, on Windows, download `Rtools<version>.exe` and follow the instructions from [Building R for Windows](http://cran.r-project.org/bin/windows/Rtools/). Then build and install `RWordPress`:


```r
install.packages("RWordPress", repos="http://www.omegahat.org/R", build=TRUE)
```

Set up `RWordPress` with your login credentials and the site URL.


```r
library(RWordPress)
options(WordpressLogin=c(user="password"),
        WordpressURL="http://your_wp_installation.org/xmlrpc.php")
```

To make syntax highlighting work in WP with the [SyntaxHighlighter](http://wordpress.org/extend/plugins/syntaxhighlighter/) plugin, R code should be enclosed in WP-shortcode instead of the knitr html output default `<pre><code class="r">...</code></pre>` like so:

```
[code lang='r']
...
[/code]
```

One option is to set up knitr itself to wrap code into WP-shortcode format. The downside to this option is that the output html is only usable within WP, but not as a standalone html page. Adapted from [Carl Boettiger](http://www.carlboettiger.info/2012/02/27/using-knitr-and-rwordpress-to-publish-results-directly-from-r-6.html):


```r
knit_hooks$set(output=function(x, options) paste("\\[code\\]\n", x, "\\[/code\\]\n", sep=""))
knit_hooks$set(source=function(x, options) paste("\\[code lang='r'\\]\n", x, "\\[/code\\]\n", sep=""))
```

As an alternative, you can use the `XML` package to extract the html body produced by knitr and clean it to make it work for WordPress. Adapted with small modifications from [William K. Morris](http://wkmor1.wordpress.com/2012/07/01/rchievement-of-the-day-3-bloggin-from-r-14/):


```r
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
```

### Send the post from R to WordPress

In WP, you have to enable the "XML-RPC" option in Settings -> Writing -> Remote Publishing.

In R, first set the working directory to the one containing the html page. Then use `newPost(..., publish=FALSE)` to stage the post in WP as a draft to actually publish later from the dashboard. This uses `knit2wp()` as defined above:


```r
newPost(content=list(description=knit2wp('rerWorkflow.html'),
                     title='Workflow: Post R markdown to WordPress',
                     categories=c('R')),
        publish=FALSE)
```

If you plan to edit the post later and upload the changed html, save the return value from `newPost()`: It is the post id, necessary to identify the post using `editPost()`.


```r
postID <- 99                    # post id returned by newPost()
editPost(postID,
         content=list(description=knit2wp('rerWorkflow.html'),
                      title='Workflow: Post R markdown to WordPress',
                      categories=c('R')),
         publish=FALSE)
```


For me, all this works fine, but I need to make sure the draft is opened first with the WP html editor, not the visual editor. So the html editor has to be "active", i.e., was used last. After openening the draft with the html editor, I have to switch to the visual editor, and then hit "publish". Publishing the post while still in the html editor does not work. Further switching between visual and html editor messes everything up.

### Use knitr's `knit2wp()` function

knitr now provides it's own `knit2wp()` function that is similar to the one defined above. In addition, it also wraps the call to `newPost()`: see the [knitr to WP example](http://yihui.name/knitr/demo/wordpress/).

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/rerWorkflowWP.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/rerWorkflowWP.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/rerWorkflowWP.R) - [all posts](https://github.com/dwoll/RExRepos/)
