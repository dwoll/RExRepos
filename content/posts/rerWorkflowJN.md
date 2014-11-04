---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Build websites with R and nanoc or Jekyll"
categories: [Workflow]
rerCat: Workflow
tags: [knitr, Jekyll, nanoc]
---




Workflow for static site generators
-------------------------

Using static website generators (SSG) like [nanoc](http://nanoc.ws/) or [Jekyll](http://jekyllrb.com) to automatically build a website based on [R markdown](http://rmarkdown.rstudio.com/) documents currently requires dealing with a couple of technical details.

 * The first step of the workflow requires [`knitr`](http://yihui.name/knitr/) to turn the R markdown documents into regular markdown. I use an [R script](https://github.com/dwoll/RExRepos/blob/master/dwKnit.r) that gets called from a [Makefile](https://github.com/dwoll/RExRepos/blob/master/Rmd/Makefile).
 * The plain markdown files are then processed into regular HTML by the SSG. This is done by a markdown engine - popular choices are [pandoc](http://johnmacfarlane.net/pandoc/), [kramdown](http://kramdown.rubyforge.org/), and [Redcarpet](https://github.com/vmg/redcarpet). Unfortunately, not all engines are supported out-of-the-box by nanoc and Jekyll. Also unfortunately, the engines have slightly different behavior and feature sets when it comes to markdown extensions.
 * SSGs require markdown files with [YAML front matter](https://github.com/mojombo/jekyll/wiki/yaml-front-matter) that describes the type of layout, post title, categories and tags. `knitr` ignores YAML front matter in R markdown files, so this is fine.

Setup for nanoc
-------------------------

This website is currently built with [nanoc](http://nanoc.ws/) (version 3.7.3), the design uses the [Bootstrap framework](http://getbootstrap.com/) (version 3.2). As a markdown engine, I use pandoc (version 1.12.2.1) because it provides

 * automatical creation of a table-of-contents
 * [MathJax](http://www.mathjax.org/) support for great math rendering based on $\LaTeX$ syntax
 * support for "fenced code blocks" in GitHub flavor (code stands between backticks) - the `knitr` default
 * built-in fast syntax highlighting for R code

The build-process is automatically managed with a [Makefile](https://github.com/dwoll/RExRepos/blob/master/Makefile) that calls an [R-script](https://github.com/dwoll/RExRepos/blob/master/dwKnit.r) for knitting R markdown files to plain markdown. To build this website yourself:

 * You need R with the `knitr` package. Set a permanent R option which CRAN mirror to use by creating a file `.Rprofile` in your home directory, containing the line `options(repos=structure(c(CRAN="http://cran.rstudio.com/")))`. Also install pandoc, Ruby, as well as the Ruby gems nanoc and pandoc-ruby.
 * Clone the RExRepos GitHub repository at `https://github.com/dwoll/RExRepos.git`.
 * In the RExRepos directory, just run `nanoc` to build the already present markdown files. To build from R markdown, run `make clean` and `make nanoc`. On Windows, this requires editing the Makefiles first, commenting the Linux `rm` commands, und un-commenting the Windows `del` commands. On Windows, you need to have [make](http://gnuwin32.sourceforge.net/packages/make.htm) and [sed](http://gnuwin32.sourceforge.net/packages/sed.htm) installed, and in your path.

Setup for Jekyll
-------------------------

A website like this could also be built with [Jekyll](http://jekyllrb.com). However, Jekyll is less suited for building a navigation structure as it does not let you use embedded Ruby ([ERB](http://ruby-doc.org/stdlib-1.9.3/libdoc/erb/rdoc/ERB.html)) in templates (like nanoc does). The best choice for a markdown engine currently seems to be [kramdown](http://kramdown.rubyforge.org/). Using Jekyll with kramdown has some extra requirements:

 * Call `knitr::render_jekyll()` before you knit an R markdown file to plain markdown. This embeds code snippets in curly braces - kramdown doesn't support fenced code blocks with backticks (knitr's default).
 * kramdown natively supports [MathJax](http://www.mathjax.org/). However, it needs double dollar signs as inline math delimiters instead of single dollar signs. Double dollar signs are normally reserved for display math. If you use single dollar signs with kramdown, inline math underscores are erroneously interpreted as markdown emphasis syntax (and not subscripts).
 * kramdown supports automatical generation of a table-of-contents, but needs a toc-placeholder.
 * Jekyll can also use [Redcarpet](https://github.com/vmg/redcarpet) which supports fenced code blocks, inline math with single dollar signs and has an option to turn off inline emphasis. Redcarpet supports automatical creation of a table of contents, but Jekyll currently doesn't implement the [two necessary rendering passes](http://dev.af83.com/2012/02/27/howto-extend-the-redcarpet2-markdown-lib.html).
 * Posts cannot contain double braces as these are delimiters for Jekyll's template engine [liquid](http://wiki.shopify.com/UsingLiquid). Unfortunately, double braces are valid R output, e.g., from package `sets`. You have to replace them before running Jekyll.
 * The post filenames have to conform to Jekyll standards (start with the date), i.e., have the format "YYYY-MM-DD-title.md".
 * See [knitr-jekyll](https://github.com/yihui/knitr-jekyll) for an example setup.

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/rerWorkflowJN.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/rerWorkflowJN.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/rerWorkflowJN.R) - [all posts](https://github.com/dwoll/RExRepos/)
