TODO
=========================

Workflow
-------------------------

### R-Markdown

Additional content
-------------------------

 * Internal links
 * More tags
 * Code comments & explanations
 * New: lists, model formula
 * aggregate -> `do.call("cbind", lapply(ls(pattern="V[[:digit:]]"), get))`
 * dfImportExport ->

```r
fPaths <- list.files(path="D:/Julian/CSV", pattern="csv", full.names=TRUE)
DFlist <- lapply(fPaths, function(f) {
                 read.table(f, header=TRUE, stringsAsFactors=FALSE) } )
DFroh <- do.call("rbind", DFlist)
```

 * anovaCRFpq -> `model.tables()`
 * anovaMixed -> RBF-pq, SPF-p.q with compound symmetry
 * crossvalidation -> `rms::validate()` for `rms::ols()`, `rms::lrm()`, `rms::cph()`
 * diagMultivariate -> `psych::cor.plot()`
