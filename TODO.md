TODO
=========================

Workflow
-------------------------

### R-Markdown

These posts currently need manual knitting in RStudio -> fix

 * regressionDiag (`ncvTest(fit)`, `pRes <- perturb(fit, pvars=c("X1", "X2", "X3"), prange=c(1, 1, 1))`)
 * regressionOrdinal (`exp(confint(polrFit))`, `summary(polrFit)`)
 * regressionPoisson (`odTest(glmFitNB)`)

Additional content
-------------------------

 * [knitr to WP](http://yihui.name/en/2013/02/publishing-from-r-knitr-to-wordpress/)
 * Internal links
 * More tags
 * Code comments
 * Explanations
 * Examples: arithmetic, vectors, matrices/arrays, lists, data input/output, model formula
 * resamplingBootALM -> GLM
 * anovaCRFpq -> `model.tables()`
 * anovaMixed -> RBF-pq, SPF-p.q with compound symmetry
 * diagMultivariate -> `psych::cor.plot()`
 * dataTransform -> `grepl()` for subsetting variables
 * dataImportExport -> mention `read.xport()`, `read.dta()`, `write.dta()`