## currently configured for Windows 7
## make for Windows <http://gnuwin32.sourceforge.net/packages/make.htm>
KNIT = Rscript ../dwKnit.r
RMD_DIR = .

POSTS_DIR = ../content/posts
MD_FILES := $(patsubst %.Rmd, $(POSTS_DIR)/%.md, $(wildcard *.Rmd))

all: $(MD_FILES)

$(POSTS_DIR)/%.md: %.Rmd
	$(KNIT) $< $@ pandoc nanoc

.PHONY: clean
clean:
## uncomment if on Linux
#	$(RM) ../R/*
#	$(RM) ../md/*
#	$(RM) -rf ../tmp/*.Rmd
#	$(RM) ../content/posts/*
#	$(RM) ../content/assets/figure/*
## comment if on Linux
	cmd /c del /q ..\R\\*.*
	cmd /c del /q ..\md\\*.*
	cmd /c for /d %f in (..\tmp\\*) do rmdir /s /q %f
	cmd /c del /q ..\tmp\\*.Rmd
	cmd /c del /q ..\content\posts\\*.*
	cmd /c del /q ..\content\assets\figure\\*.*
