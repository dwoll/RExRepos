---
title: "R basics"
rerCat: R_Basics
---

Introductory topics
----------------

<%= render 'rerPostList' %>

Other online introductions to R
----------------

Currently, this site does not offer an introduction to the basics of working with R (installing packages, basic algebra, indexing vectors, data input). Instead, have a look at the following online resources:

 - [Quick-R: R interface](http://www.statmethods.net/interface/)
 - [Quick-R: Data input](http://www.statmethods.net/input/)
 - [Cookbook for R: Basics](http://www.cookbook-r.com/Basics/)
 - [Cookbook for R: Data input and output](http://www.cookbook-r.com/Data_input_and_output/)
 - [Longhow Lam: Intro to R](http://www.splusbook.com/RIntro/RCourse.pdf) (pdf)

User interfaces to R
----------------

Compared to the standard user interface that is already included with R, there are several better alternative options:

 - [RStudio](http://www.rstudio.org/) integrated development environment: Cross platform (Windows, MacOS, Linux), great support for the [workflow for these posts](<%= @config[:rer][:baseurl] %>/rerWorkflow.html), my preferred choice
 - [Eclipse](http://www.eclipse.org/eclipse) integrated development environment with [StatET](http://www.walware.de/goto/statet) plugin: Cross platform (Windows, MacOS, Linux), powerful, visual debugging support, somewhat complicated to set up ([installation instructions](http://www.splusbook.com/RIntro/R_Eclipse_StatET.pdf)), somewhat sluggish on older computers
 - [RKWard](http://rkward.sourceforge.net/) graphical user interface to R: Linux and limited Windows support
 - [TinnR](http://sourceforge.net/projects/tinn-r) text editor with good support for communicating with R: Windows only
 - [Emacs](http://www.gnu.org/software/emacs/) / [XEmacs](http://www.xemacs.org/) text editor with [Emacs Speaks Statistics](http://ess.r-project.org/) add-on: Cross platform (Windows, MacOS, Linux), very powerful, somewhat hard to learn
