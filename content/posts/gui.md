---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "R user interfaces"
categories: [RBasics]
rerCat: R_Basics
tags: [GUI, "Command line"]
---




R's default user interface
----------------

### R console

Command prompt

```
>
```

For interactive data analysis: type in commands, hit `Return` key and get text output as a result.


```r
1+7
```

```
[1] 8
```

Comments start with `#`, they are not executed as a command


```r
9 * 3     # this is a comment
```

```
[1] 27
```

 * Copy and paste to and from the clipboard as usual (Windows: `Ctrl+c` and `Ctrl+v`)
 * Interrupt R with `ESC` (on Windows) or `Ctrl+c` (Linux)
 * Quit with `q()`
 * Save a protocol of your commands and the output with `sink("fileName.txt", split=TRUE)`

### Non-interactive use

For batch mode:

`Rscript.exe input.r`

`Rterm.exe --no-restore --no-save < input.r > output.txt`

### Get and set options


```r
getOption("width")
```

```
[1] 75
```

Change option, save previous value, and restore previous value


```r
op <- options(width=70)
options(op)
```

Also see `help(Startup)` for files controlling the startup options.

Contributed user interfaces to R
----------------

Compared to the standard user interface that is already included with R, there are several better alternative options.

### For working with R commands

 - [RStudio](https://posit.co/download/rstudio-desktop/) integrated development environment (IDE): Cross platform (Windows, MacOS, Linux), great support for the [workflow for these posts](<%= @config[:base_url] %>/posts/rerWorkflowJN.html), my preferred choice
 - [Positron](https://positron.posit.co/) integrated development environment (IDE): Cross platform (Windows, MacOS, Linux), great support for the [workflow for these posts](<%= @config[:base_url] %>/posts/rerWorkflowJN.html), my preferred choice
 - [Eclipse](https://www.eclipse.org/eclipse/) IDE with [StatET](https://eclipse.org/statet/) plugin: Cross platform (Windows, MacOS, Linux), powerful, visual debugging support
 - [Bio7](https://bio7.org/) another customization of the Eclipse IDE for working with R
 - [Emacs](https://www.gnu.org/software/emacs/) / [XEmacs](https://www.xemacs.org/) text editor with [Emacs Speaks Statistics](https://ess.r-project.org/) add-on: Cross platform (Windows, MacOS, Linux), very powerful, hard to learn

### Graphical front-ends for R functions

 - [Jamovi](https://www.jamovi.org/): Graphical statistical spreadsheet based on R
 - [RKWard](https://rkward.kde.org/): Graphical user interface to R: Linux and limited Windows support

Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/gui.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/gui.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/gui.R) - [all posts](https://github.com/dwoll/RExRepos/)
