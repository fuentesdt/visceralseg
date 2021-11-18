.mode csv
.import nashvisceral/cases.csv    cases
.import nashvisceral/controls.csv controls

create table nashimaging  as
select 'cases' status ,mrn,seriesUID,studyUID from cases where path !="" union
select 'controls' status ,mrn,seriesUID,studyUID from controls where path !="";
.output nashvisceral/wide.csv 
select *, '/FUS4/IPVL_research/' || mrn ||  '/*/' ||studyUID ||  '/' ||seriesUID path from  nashimaging  ;
-- cat wide.sql  | sqlite3
.quit

