
## ------------------------------------------------------------------------
dev.new(); dev.new(); dev.new()
dev.list()
dev.cur()
dev.set(3)
dev.set(dev.next())
dev.off()
graphics.off()


## ----eval=FALSE----------------------------------------------------------
pdf("pdf_test.pdf")
plot(1:10, rnorm(10))
dev.off()


## ----eval=FALSE----------------------------------------------------------
plot(1:10, rnorm(10))
dev.copy(jpeg, filename="copied.jpg", quality=90)
graphics.off()

