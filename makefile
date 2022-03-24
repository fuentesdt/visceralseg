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
	echo $*
	echo $(shell sed 1d nashvisceral/wide.csv | cut -d, -f2 | grep -n $* |cut -f1 -d: )
	dcm2niix -m y -o $(@D) -f $(basename $(basename $(@F)))  -z y /mnt/$(word $(shell sed 1d nashvisceral/wide.csv | cut -d, -f2 | grep -n $* |cut -f1 -d: ), $(LISTPATH)) 
$(WORKDIR)/%/generatetrain: $(WORKDIR)/%/image.nii.gz
	c3d -verbose $<  -info 
	mkdir -p  nashvisceral/$*
	if [ ! -f nashvisceral/$*/train.nii.gz ] ; then echo creating file; c3d $< -scale 0 -type uchar nashvisceral/$*/train.nii.gz  ;fi
	export AMIRA_DATADIR=nashvisceral/$*;vglrun /opt/apps/Amira/2020.2/bin/start -tclcmd "load $<; load nashvisceral/$*/train.nii.gz; create HxCastField ConvertImage; ConvertImage data connect train.nii.gz; ConvertImage fire; ConvertImage outputType setIndex 0 7; ConvertImage create result setLabel ; train.nii.to-labelfield-8_bits ImageData connect image.nii.gz; echo save mask as nashvisceral/$*/train.nii.gz;" & vglrun itksnap -g  $<  -s nashvisceral/$*/train.nii.gz & SOLNSTATUS=$$(zenity  --list --title="QA" --text="$*"  --editable  --column "Status" ImageOrder Usable ) ; echo $$SOLNSTATUS; echo $$SOLNSTATUS >  $(@D)/reviewsolution.txt ;   pkill -9 ITK-SNAP
	
