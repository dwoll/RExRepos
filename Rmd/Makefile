# currently configured for Windows7
# get make for Windows here:
## http://gnuwin32.sourceforge.net/packages/make.htm
KNIT = Rscript ../dwKnit.r
RMD_DIR = .

## dwKnit.r knits all Rmd files it finds in the given directory
all: knit

knit:
	$(KNIT) $(RMD_DIR) ../md redcarpet none

nanoc: nanocPandoc

## make sure you also set filter :pandoc in config.yaml
nanocPandoc:
	$(KNIT) $(RMD_DIR) ../content/posts pandoc nanoc

## make sure you also set filter :kramdown in config.yaml
nanocKramdown:
	$(KNIT) $(RMD_DIR) ../content/posts kramdown nanoc

.PHONY: clean
clean:
#	$(RM) ../R/*
#	$(RM) ../md/*
#	$(RM) -rf ../tmp/*.md
#	$(RM) -rf ../tmp/*.Rmd
#	$(RM) ../content/posts/*
#	$(RM) ../content/assets/figure/*
	cmd /c del /q ..\R\\*.*
	cmd /c del /q ..\md\\*.*
	cmd /c for /d %f in (..\tmp\\*) do rmdir /s /q %f
	cmd /c del /q ..\tmp\\*.md
	cmd /c del /q ..\tmp\\*.Rmd
	cmd /c del /q ..\content\posts\\*.*
	cmd /c del /q ..\content\assets\figure\\*.*
