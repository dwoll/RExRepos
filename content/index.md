---
rerCat: Index
title: RExRepos
---

### R code examples for a number of common data analysis tasks

The examples on this site aim to show how a number of common data analysis tasks can be performed using the [R environment for statistical computing](http://www.r-project.org/).
The focus is on basic statistical methods for the social and life sciences.
The examples assume a reader who is already familiar with the statistical underpinnings, and who knows when a particular analysis should be carried out.

### Reproducible documents

The posts on this site were created automatically from within R, using a workflow that makes use of [knitr](http://yihui.name/knitr/), a static site generator like [Jekyll](http://jekyllrb.com/) or [nanoc](http://nanoc.ws/), and the [Bootstrap framework](http://twitter.github.com/bootstrap/). For details, see this [page explaining the workflow](<%= @config[:rer][:baseurl] %>/rerWorkflow.html). This website, including all examples (R markdown, markdown, and plain R code files), is [available on GitHub](https://github.com/dwoll/RExRepos). The repository also contains the Makefiles and an R-script necessary for automatically building the website.

### Topics

 - [R Basics](<%= @config[:rer][:baseurl] %>/rerR_Basics.html)
 - [Descriptive statistics](<%= @config[:rer][:baseurl] %>/rerDescriptive.html)
 - [Work with data frames](<%= @config[:rer][:baseurl] %>/rerData_Frames.html)
 - [Univariate methods](<%= @config[:rer][:baseurl] %>/rerUnivariate.html)
 - [Nonparametric and resampling methods](<%= @config[:rer][:baseurl] %>/rerNonparametric.html)
 - [Multivariate methods](<%= @config[:rer][:baseurl] %>/rerMultivariate.html)
 - [Diagrams](<%= @config[:rer][:baseurl] %>/rerDiagrams.html)

The examples mostly come from my [book](http://www.uni-kiel.de/psychologie/dwoll/r/), and are currently bare-bones R code. They will be complemented with comments and short explanations over time.

Some methods within the intended scope of this repository are currently missing:

 - Cluster analysis
 - Canonical correlation analysis
 - Time series

Contributed examples are very welcome, please contact me if you would like to add your code to this repository.

[Daniel Wollschlaeger](http://www.uni-kiel.de/psychologie/dwoll/)
