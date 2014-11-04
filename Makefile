## call make nanoc to build the website
## currently configured for Windows 7
## make for Windows <http://gnuwin32.sourceforge.net/packages/make.htm>
all: knit

knit: 
	$(MAKE) -C Rmd
	nanoc

.PHONY: clean
clean:
## uncomment if on Linux
	$(RM) -rf output/*
## comment if on Linux
#	cmd /c for /d %f in (output\\*) do rmdir /s /q %f
#	cmd /c del /q output\\*.*
	$(MAKE) clean -C Rmd
