# Usually, only these lines need changing
RDIR= .
FIGDIR= .

# list R files
RFILES := $(wildcard $(RDIR)/*.Rmd)

# Indicator files to show R file has run
OUT_FILES:= $(RFILES:.Rmd=.Rout)


all: $(OUT_FILES)

# RUN EVERY R FILE
$(RDIR)/%.Rout: $(RDIR)/%.R $(RDIR)/MSDSCaseStudy1.Rmd
	R CMD BATCH $<

# Run R files
R: $(OUT_FILES)

clean:
	rm -fv $(OUT_FILES) 
	
