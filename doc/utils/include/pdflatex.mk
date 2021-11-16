# Makefile rules for Global Trigger Upgrade documents using LaTeX.

# Filename of master document, without extension.
ifndef DOCUMENT_NAME
 $(error `DOCUMENT_NAME' is not defined.)
endif

# Document directories.
INCLUDE_DIR    = ../../../utils/latex
UTILS_DIR      = $(GT_UPGRADE_UTILS)/general/latex
IMAGE_DIR      = figures
TARGET_DIR     = ../../pdf

# Master document files.
MASTER_DOC     = $(DOCUMENT_NAME:%.tex=%)
# Dia figures.
DIAGRAMS       = $(wildcard $(IMAGE_DIR)/*.dia)
DIAGRAMS_EPS   = $(DIAGRAMS:%.dia=%.eps)
# SVG figures.
VECTORS        = $(wildcard $(IMAGE_DIR)/*.svg)
VECTORS_EPS    = $(VECTORS:%.svg=%.eps)
# Pattern to converte EPS to PDF.
CONV_EPS_FILES = $(wildcard $(IMAGE_DIR)/*-eps-converted-to.pdf)
# Temporary files.
TMP_SUFFIX     = *.aux *.bbl *.blg *.brf *.dvi *.idx *.ilg *.ind *.lof *.log *.lot *.out *.toc
TMP_FILES      = $(CONV_EPS_FILES) $(TMP_SUFFIX:*.%=$(MASTER_DOC).%)

# Executables.
PDFLATEX       = pdflatex --shell-escape
BIBTEX         = bibtex
MAKEINDEX      = makeindex
DIA            = dia
INKSCAPE       = inkscape
RM             = rm -rf
MV             = mv
MKDIR          = mkdir -p

# Set include directory for LaTeX style definitions.
ifndef TEXINPUTS
 export TEXINPUTS := .:$(INCLUDE_DIR)/:$(UTILS_DIR)/:
endif

.PHONY: all $(MASTER_DOC) clean

# Build document.
all: $(MASTER_DOC)

# Build document by name.
$(MASTER_DOC): clean $(DIAGRAMS_EPS) $(VECTORS_EPS)
	$(PDFLATEX)  $(MASTER_DOC)
	$(PDFLATEX)  $(MASTER_DOC)
	$(BIBTEX)    $(MASTER_DOC) || true
#	$(MAKEINDEX) $(MASTER_DOC)
	$(PDFLATEX)  $(MASTER_DOC)
	$(PDFLATEX)  $(MASTER_DOC)
	$(MKDIR)     $(TARGET_DIR)
	$(MV) $(MASTER_DOC).pdf $(TARGET_DIR)

# Clean up temp files.
clean:
	@echo "Cleaning up all temporary generated files..."
	$(RM) $(TMP_FILES)
	$(RM) $(DIAGRAMS_EPS)
	$(RM) $(VECTORS_EPS)
	$(RM) $(MASTER_DOC).pdf

# Convert Dia files to postscript files.
$(DIAGRAMS_EPS):
	$(DIA) $(@:%.eps=%.dia) -e $@ -t eps 2>/dev/null

# Convert SVG files to postscript files using inkscape.
$(VECTORS_EPS):
	@echo "$(INKSCAPE) -f $(@:%.eps=%.svg) -E $@"
	$(INKSCAPE) -f $(@:%.eps=%.svg) -E $@
