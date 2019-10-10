#
# Makefile for LaTex document.
#
# Repository path   : $HeadURL: svn://heros.hephy.oeaw.ac.at/GlobalTriggerUpgrade/utils/templates/document/firmware-specification/makefile $
# Last committed    : $Revision: 32 $
# Last changed by   : $Author: rahbaran $
# Last changed date : $Date: 2011-05-17 12:17:08 +0200 (Tue, 17 May 2011) $
# Description       : Makfile for Gloab Trigger Upgrade LaTex document,
#                     including environment makefile rules.
#

# Check for installed Global Trigger Upgrade Environment.
ifndef GT_UPGRADE_ENVIRONMENT
 $(error `GT_UPGRADE_ENVIRONMENT' is not defined.)
endif

# Define master document name, without *.tex extension.
DOCUMENT_NAME = gt-mp7-firmware-specification

# Include makefile rules.
include $(GT_UPGRADE_ENVIRONMENT)/include/pdflatex.mk

# eof
