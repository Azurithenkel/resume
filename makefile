
PROJECT = cv

INPUTS = format

default: $(PROJECT)

.PHONY: tidy sweep clean targz corp

$(PROJECT): $(PROJECT).pdf

MAIN    = main.tex

CHAPTERS = $(filter-out $(MAIN),$(wildcard *.tex fit/*.tex)) $(INPUTS)/format.tex $(INPUTS)/cmd.tex
PLOTS    = $(wildcard */png/*.png */eps/*.eps)
SOURCES  = $(MAIN) $(CHAPTERS) $(PLOTS) $(MAKEFILE_LIST)

PDFLATEX = pdflatex -halt-on-error

$(PROJECT).pdf: $(SOURCES) corp
	@ echo --------------------------------------------
	@ $(PDFLATEX) $<					\
		| sed -e '/./{H;$!d};x' -e '/\(Missing\|Error\)/!d'	\
		| sed 's/.*/\x1b[31m&\x1b[0m/g'
	@ echo --------------------------------------------
	@ $(PDFLATEX) $<					\
		| grep -i warning				\
		| grep -v 'float specifier'			\
		| grep -v 'You have requested package'		\
		| grep -v 'Command \\textordmasculine'		\
		| grep -v 'Package hyperref Warning'		\
		| grep -v 'Label(s) may have changed'		\
		| grep -v '^LaTeX Font Warning'			\
		| sed     '/Label/s/.*/\x1b[33m&\x1b[0m/g'	\
		| sed '/Reference/s/.*/\x1b[33m&\x1b[0m/g'
	@ echo --------------------------------------------
	@ $(PDFLATEX) $<					\
		| grep -i warning				\
		| grep -v 'float specifier'			\
		| grep -v 'You have requested package'		\
		| grep -v 'Command \\textordmasculine'		\
		| grep -v 'Package hyperref Warning'		\
		| grep -v 'Label(s) may have changed'		\
		| grep -v '^LaTeX Font Warning'			\
		| sed     '/Label/s/.*/\x1b[33m&\x1b[0m/g'	\
		| sed '/Reference/s/.*/\x1b[33m&\x1b[0m/g'
	@ echo --------------------------------------------
	@ mv $(patsubst %.tex,%.pdf,$<) $@
	@ $(MAKE) clean

$(PROJECT).ps: $(SOURCES)
	@ latex $< > /dev/null
	@ latex $< > /dev/null
	@ latex $< > /dev/null
	@ dvips $(patsubst %.tex,%.dvi,$<)
	@ $(RM) $(patsubst %.tex,%.dvi,$<)
	@ mv $(patsubst %.tex,%.ps,$<) $@
	@ $(MAKE) clean

tidy:
	@ $(RM) *.aux *.bbl *.blg *.brf *.idx *.log *.lof *.lot *.toc *.out

corp:
	@ pdflatex corp.tex

sweep:
	@ $(RM) `find -name '*~'` `find -regex '.*\/\.*\#.*'`

clean: tidy sweep

targz:
	@ if [ -e $(PROJECT).tar.gz ];					\
	then								\
		echo "File \"$(PROJECT).tar.gz\" does already exist";	\
	else								\
		tar czf $(PROJECT).tar.gz *;				\
	fi
