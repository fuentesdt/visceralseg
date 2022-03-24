.mode csv
.import nashvisceral/cases.csv    cases
.import nashvisceral/controls.csv controls
.import nashvisceral/nashfattycontrol.csv newdb

create table nashimaging  as
select 'fatty' status ,mrn,seriesUID,studyUID from cases where path !="" union
select 'controls' status ,mrn,seriesUID,studyUID from controls where path !="";

.output nashvisceral/wide.csv 
select distinct status ,mrn,seriesUID,studyUID, '/FUS4/IPVL_research/' || mrn ||  '/*/' ||studyUID ||  '/' ||seriesUID path from  newdb;
-- cat wide.sql  | sqlite3
.quit

