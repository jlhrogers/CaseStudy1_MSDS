# Working directory locations for files to read/write
RDIR= .
FIGDIR= .

# list R files in wd
RFILES := $(wildcard $(RDIR)/*.R)

# Indicator files to show R file has run
OUT_FILES:= $(RFILES:.R=.html)


all: $(OUT_FILES)

# RUN THE R FILES
$(RDIR)/%.html: $(RDIR)/%.R $(RDIR)/MSDSCaseStudy1_Final.R
	R CMD BATCH $<

# Run R files
R: $(OUT_FILES)

clean:
	rm -fv $(OUT_FILES) 
	
