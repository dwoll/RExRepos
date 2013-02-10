---
license: Creative Commons BY-SA
author: Daniel Wollschlaeger
title: "Add-on packages"
categories: [RBasics]
rerCat: R_Basics
tags: [Packages, CRAN]
---




TODO
-------------------------

 - link to workspace for `search()`

Install required packages
-------------------------

[`coin`](http://cran.r-project.org/package=coin)


```r
wants <- c("coin")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])
```


Useful online resources
-------------------------

 * [Comprehensive R Archive Network (CRAN)](http://cran.r-project.org/web/packages/): These mirror servers are the primary hosts for contributed R add-on packages
 * [CRAN Task Views](http://cran.r-project.org/web/views/): An organized and maintained list of packages useful for a specific data analysis task (e.g., multivariate statistics or psychometric models)
 * [BioConductor](http://www.bioconductor.org/): A host for add-on packages especially useful for genomic data analysis
 * [r4stats package overview](http://r4stats.com/articles/add-ons/): A list of popular R packages and how their functionality compares to SPSS/SAS

Install and update add-on packages
-------------------------

### Information about installed packages


```r
.libPaths()
```

```
[1] "C:/Users/Daniel/Documents/R/win-library/2.15"
[2] "C:/Program Files/R/R-2.15.2patched/library"  
```



```r
installed.packages()
# not shown (very long output)
```



```r
rownames(installed.packages())
```

```
  [1] "abind"                   "adimpro"                
  [3] "Amelia"                  "bdsmatrix"              
  [5] "binom"                   "Biobase"                
  [7] "BiocGenerics"            "BiocInstaller"          
  [9] "bitops"                  "boot"                   
 [11] "brew"                    "BSDA"                   
 [13] "cairoDevice"             "car"                    
 [15] "caTools"                 "CircStats"              
 [17] "class"                   "cluster"                
 [19] "coda"                    "coin"                   
 [21] "colorspace"              "compositions"           
 [23] "corpcor"                 "coxme"                  
 [25] "DAAG"                    "dichromat"              
 [27] "digest"                  "e1071"                  
 [29] "EBImage"                 "effects"                
 [31] "ellipse"                 "energy"                 
 [33] "Epi"                     "epitools"               
 [35] "evaluate"                "expm"                   
 [37] "ez"                      "fastmatch"              
 [39] "fdrtool"                 "fields"                 
 [41] "filehash"                "foreign"                
 [43] "formatR"                 "Formula"                
 [45] "gam"                     "gdata"                  
 [47] "GeneNet"                 "ggm"                    
 [49] "ggplot2"                 "glmnet"                 
 [51] "googleVis"               "GPArotation"            
 [53] "gplots"                  "graph"                  
 [55] "gRbase"                  "gridBase"               
 [57] "gtable"                  "gtools"                 
 [59] "gWidgets"                "gWidgetsRGtk2"          
 [61] "hexbin"                  "Hmisc"                  
 [63] "HSAUR2"                  "ICS"                    
 [65] "ICSNP"                   "igraph"                 
 [67] "igraph0"                 "iplots"                 
 [69] "irr"                     "JavaGD"                 
 [71] "JGR"                     "knitr"                  
 [73] "labeling"                "lattice"                
 [75] "latticeExtra"            "lavaan"                 
 [77] "leaps"                   "lme4"                   
 [79] "lmPerm"                  "lmtest"                 
 [81] "longitudinal"            "lpSolve"                
 [83] "lubridate"               "markdown"               
 [85] "MASS"                    "Matrix"                 
 [87] "matrixcalc"              "maxLik"                 
 [89] "MBESS"                   "mediation"              
 [91] "memoise"                 "mgcv"                   
 [93] "mice"                    "miscTools"              
 [95] "mlogit"                  "mnormt"                 
 [97] "modeest"                 "modeltools"             
 [99] "multcomp"                "multcompView"           
[101] "multilevel"              "multtest"               
[103] "munsell"                 "mvoutlier"              
[105] "mvtnorm"                 "nFactors"               
[107] "nlme"                    "nnet"                   
[109] "nortest"                 "numDeriv"               
[111] "nutshell"                "nutshell.audioscrobbler"
[113] "nutshell.bbdb"           "ordinal"                
[115] "outliers"                "parcor"                 
[117] "pbivnorm"                "pcaPP"                  
[119] "permute"                 "perturb"                
[121] "playwith"                "plotrix"                
[123] "plyr"                    "polycor"                
[125] "ppls"                    "pracma"                 
[127] "pROC"                    "proto"                  
[129] "pscl"                    "psych"                  
[131] "pwr"                     "quadprog"               
[133] "QuantPsyc"               "R2HTML"                 
[135] "randomForest"            "RBGL"                   
[137] "RColorBrewer"            "rcom"                   
[139] "Rcpp"                    "RcppArmadillo"          
[141] "RcppEigen"               "RCurl"                  
[143] "reshape2"                "RExcelInstaller"        
[145] "rgl"                     "RGtk2"                  
[147] "rJava"                   "RJSONIO"                
[149] "RMediation"              "rms"                    
[151] "robCompositions"         "robust"                 
[153] "robustbase"              "ROCR"                   
[155] "RODBC"                   "rpart"                  
[157] "rrcov"                   "rscproxy"               
[159] "RWordPress"              "SAGx"                   
[161] "sandwich"                "scales"                 
[163] "scatterplot3d"           "sem"                    
[165] "sets"                    "sfsmisc"                
[167] "sgeostat"                "shotGroups"             
[169] "sos"                     "spam"                   
[171] "spatial"                 "statmod"                
[173] "stringr"                 "survey"                 
[175] "survival"                "svMisc"                 
[177] "svSocket"                "TeachingDemos"          
[179] "tensorA"                 "tikzDevice"             
[181] "timeDate"                "TinnR"                  
[183] "tourr"                   "tseries"                
[185] "ucminf"                  "vcd"                    
[187] "vegan"                   "verification"           
[189] "VGAM"                    "waveslim"               
[191] "XLConnect"               "XLConnectJars"          
[193] "XML"                     "XMLRPC"                 
[195] "zoo"                     "base"                   
[197] "boot"                    "class"                  
[199] "cluster"                 "codetools"              
[201] "compiler"                "datasets"               
[203] "foreign"                 "graphics"               
[205] "grDevices"               "grid"                   
[207] "KernSmooth"              "lattice"                
[209] "MASS"                    "Matrix"                 
[211] "methods"                 "mgcv"                   
[213] "nlme"                    "nnet"                   
[215] "parallel"                "rpart"                  
[217] "spatial"                 "splines"                
[219] "stats"                   "stats4"                 
[221] "survival"                "tcltk"                  
[223] "tools"                   "utils"                  
```



```r
library()
# not shown (opens separate window)
```


### Install and remove add-on packages


```r
setRepositories("http://cran.ma.imperial.ac.uk/")
install.packages(c("coin", "car"))
install.packages("coin", repos="http://cran.at.r-project.org/")
update.packages()
# remove.packages("coin")
# not shown
```


### Information provided by add-on packages


```r
help(package=coin)
vignette()
vignette("coin_implementation")
# not shown (opens separate window)
```


Use add-on packages
-------------------------

### Load add-on package

`library()` throws an error if the package cannot be found


```r
library(coin)
```


Get a return value `TRUE` or `FALSE` that indicates whether package could be loaded


```r
library(coin, logical.return=TRUE)
```

```
[1] TRUE
```


`require()` gives a warning if the package cannot be found


```r
require(doesNotExist)
```

```
Warning: there is no package called 'doesNotExist'
```


### Know which packages are currently loaded


```r
sessionInfo()
```

```
R version 2.15.2 Patched (2013-01-31 r61797)
Platform: i386-w64-mingw32/i386 (32-bit)

locale:
[1] LC_COLLATE=German_Germany.1252  LC_CTYPE=German_Germany.1252   
[3] LC_MONETARY=German_Germany.1252 LC_NUMERIC=C                   
[5] LC_TIME=German_Germany.1252    

attached base packages:
 [1] stats4    grDevices datasets  splines   graphics  stats     methods  
 [8] tcltk     utils     base     

other attached packages:
 [1] coin_1.0-21       modeltools_0.2-19 mvtnorm_0.9-9994 
 [4] stringr_0.6.2     knitr_1.0.5       svSocket_0.9-54  
 [7] TinnR_1.0-5       R2HTML_2.2        Hmisc_3.10-1     
[10] survival_2.37-2  

loaded via a namespace (and not attached):
 [1] binom_1.0-5          boot_1.3-7           car_2.0-15          
 [4] class_7.3-5          cluster_1.14.3       colorspace_1.2-1    
 [7] digest_0.6.2         e1071_1.6-1          effects_2.2-3       
[10] ellipse_0.3-7        energy_1.4-0         epitools_0.5-7      
[13] evaluate_0.4.3       expm_0.99-0          formatR_0.7         
[16] gdata_2.12.0         GPArotation_2012.3-1 grid_2.15.2         
[19] gtools_2.7.0         hexbin_1.26.1        ICS_1.2-3           
[22] ICSNP_1.0-9          irr_0.84             KernSmooth_2.23-8   
[25] lattice_0.20-13      lme4_0.999999-0      lpSolve_5.6.6       
[28] MASS_7.3-23          Matrix_1.0-11        modeest_2.1         
[31] multcomp_1.2-15      nlme_3.1-108         nnet_7.3-5          
[34] nortest_1.0-2        pcaPP_1.9-48         permute_0.7-0       
[37] plotrix_3.4-5        plyr_1.8             polycor_0.7-8       
[40] pracma_1.3.8         pROC_1.5.4           psych_1.2.12        
[43] quadprog_1.5-4       QuantPsyc_1.5        RColorBrewer_1.0-5  
[46] rgl_0.93.928         rms_3.6-3            robustbase_0.9-4    
[49] sfsmisc_1.0-23       survey_3.29          svMisc_0.9-68       
[52] tools_2.15.2         tseries_0.10-30      vcd_1.2-13          
[55] vegan_2.0-5          zoo_1.7-9           
```

```r
search()
```

```
 [1] ".GlobalEnv"         "package:coin"       "package:modeltools"
 [4] "package:stats4"     "package:mvtnorm"    "package:stringr"   
 [7] "package:knitr"      "package:grDevices"  "package:datasets"  
[10] "package:svSocket"   "package:TinnR"      "package:R2HTML"    
[13] "package:Hmisc"      "package:survival"   "package:splines"   
[16] "package:graphics"   "package:stats"      "package:methods"   
[19] "package:tcltk"      "package:utils"      "SciViews:TempEnv"  
[22] "Autoloads"          "package:base"      
```


### Un-load a package


```r
detach(package:coin)
```


Data sets from add-on packages
-------------------------


```r
data(package="coin")
data(jobsatisfaction, package="coin")
# not shown (opens separate window)
```


Detach (automatically) loaded packages (if possible)
-------------------------


```r
try(detach(package:coin))
try(detach(package:modeltools))
try(detach(package:survival))
try(detach(package:mvtnorm))
try(detach(package:splines))
try(detach(package:stats4))
```


Get the article source from GitHub
----------------------------------------------

[R markdown](https://github.com/dwoll/RExRepos/raw/master/Rmd/packages.Rmd) - [markdown](https://github.com/dwoll/RExRepos/raw/master/md/packages.md) - [R code](https://github.com/dwoll/RExRepos/raw/master/R/packages.R) - [all posts](https://github.com/dwoll/RExRepos/)
