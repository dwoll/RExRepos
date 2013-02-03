## call make jekyll or make nanoc to build the website
## currently configured for Windows7
## get make for Windows here:
## http://gnuwin32.sourceforge.net/packages/make.htm
all: knit

knit: 
	$(MAKE) -C Rmd

nanoc: nanocPandoc

nanocPandoc:
	$(MAKE) nanocPandoc -C Rmd
	nanoc

nanocKramdown:
	$(MAKE) nanocKramdown -C Rmd
	nanoc

.PHONY: clean
clean:
#	$(RM) -rf _site/*
#	$(RM) -rf output/*
	cmd /c for /d %f in (_site\\*) do rmdir /s /q %f
	cmd /c del /s /q _site\\*.*
	cmd /c for /d %f in (output\\*) do rmdir /s /q %f
	cmd /c del /q output\\*.*
	$(MAKE) clean -C Rmd
