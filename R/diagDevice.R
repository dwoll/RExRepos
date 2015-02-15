## ------------------------------------------------------------------------
wants <- c("Cairo")
has   <- wants %in% rownames(installed.packages())
if(any(!has)) install.packages(wants[!has])

## ------------------------------------------------------------------------
dev.new(); dev.new(); dev.new()
dev.list()
dev.cur()
dev.set(3)
dev.set(dev.next())
dev.off()
graphics.off()

## ----eval=FALSE----------------------------------------------------------
pdf("pdf_test.pdf", width=5, height=5)
plot(1:10, rnorm(10))
dev.off()

## ----eval=FALSE----------------------------------------------------------
plot(1:10, rnorm(10))
dev.copy(jpeg, filename="copied.jpg", quality=90)
graphics.off()

## ----eval=FALSE----------------------------------------------------------
library(Cairo)
Cairo(width=5, height=5, units="in", file="Cairo_pdf.pdf", type="pdf",
      bg="white", canvas="white", dpi=120)
plot(1:10, rnorm(10))
dev.off()

## ------------------------------------------------------------------------
try(detach(package:Cairo))

