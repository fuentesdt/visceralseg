SHELL := /bin/bash
DATADIR=nashvisceral
WORKDIR=Processed
LISTUID= $(shell sed 1d nashvisceral/wide.csv | cut -d, -f2 )
LISTPATH= $(shell sed 1d nashvisceral/wide.csv | cut -d, -f5 )

nashvisceral/wide.csv:
	 cat wide.sql  | sqlite3
raw: $(addprefix $(WORKDIR)/,$(addsuffix /image.nii.gz,$(LISTUID)))
qainput:
	@echo UID $(words $(LISTUID))
	@echo PATH $(words $(LISTPATH))
$(WORKDIR)/%/image.nii.gz:
	mkdir -p $(@D)
	dcm2niix  -o $(@D) -f $(basename $(basename $(@F)))  -z y /mnt/$(word $(shell sed 1d nashvisceral/wide.csv | cut -d, -f2 | grep -n $* |cut -f1 -d: ), $(LISTPATH)) 
