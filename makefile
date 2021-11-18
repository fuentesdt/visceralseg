SHELL := /bin/bash
DATADIR=nashvisceral
WORKDIR=Processed
LISTUID= $(shell sed 1d nashvisceral/wide.csv | cut -d, -f2 )
LISTPATH= $(shell sed 1d nashvisceral/wide.csv | cut -d, -f3 )

qainput:
	@echo UID $(words $(LISTUID))
	@echo PATH $(words $(LISTPATH))
