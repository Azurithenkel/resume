
default: corp

.PHONY: tidy sweep clean corp

tidy:
	@ $(RM) *.aux *.bbl *.blg *.brf *.idx *.log *.lof *.lot *.toc *.out

corp:
	@ pdflatex corp.tex

sweep:
	@ $(RM) `find -name '*~'` `find -regex '.*\/\.*\#.*'`

clean: tidy sweep
