---
rerCat: Index
title: "R Examples Repository"
---

### R code examples for a number of common data analysis tasks

The examples on this site aim to show how a number of common data analysis tasks can be performed using the [R environment for statistical computing](https://www.r-project.org/).
The focus is on basic statistical methods for the social and life sciences.
The examples assume a reader who is already familiar with the statistical underpinnings, and who knows when a particular analysis should be carried out.

### Reproducible documents

The posts on this site were created automatically from [R markdown](https://rmarkdown.rstudio.com/) documents, using a workflow that makes use of [knitr](https://yihui.name/knitr/), the static site generator [nanoc](https://nanoc.ws/), and the [Bootstrap framework](https://getbootstrap.com/). For details, see this [page explaining the workflow](<%= @config[:base_url] %>/posts/rerWorkflowJN.html). This website, including all examples (R markdown, markdown, and plain R code files), is [available on GitHub](https://github.com/dwoll/RExRepos). The repository also contains the Makefiles and an R-script necessary for automatically building the website.

All content on this site is licensed under the [Creative Commons BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) license.

### Topics

 - [R Basics](<%= @config[:base_url] %>/rerR_Basics.html)
 - [Descriptive statistics](<%= @config[:base_url] %>/rerDescriptive.html)
 - [Work with data frames](<%= @config[:base_url] %>/rerData_Frames.html)
 - [Univariate methods](<%= @config[:base_url] %>/rerUnivariate.html)
 - [Nonparametric and resampling methods](<%= @config[:base_url] %>/rerNonparametric.html)
 - [Multivariate methods](<%= @config[:base_url] %>/rerMultivariate.html)
 - [Diagrams](<%= @config[:base_url] %>/rerDiagrams.html)

The examples mostly come from my [book](http://www.dwoll.de/r/gddmr.php), and are currently bare-bones R code.

Some methods within the intended scope of this repository are currently missing:

 - Psychometrics (classical test theory and item response theory)
 - Cluster analysis and other classification techniques
 - Time series

Contributed examples are very welcome, please contact me if you would like to add your code to this repository.

[Daniel Wollschlaeger](http://www.dwoll.de/)
