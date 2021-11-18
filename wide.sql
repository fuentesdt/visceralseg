.mode csv
.import nashvisceral/cases.csv    cases
.import nashvisceral/controls.csv controls

create table nashimaging  as
select 'cases' status ,mrn,path from cases where path !="" union
select 'controls' status ,mrn,path from controls where path !="";
.output nashvisceral/wide.csv 
select * from  nashimaging  ;
-- cat wide.sql  | sqlite3
.quit

