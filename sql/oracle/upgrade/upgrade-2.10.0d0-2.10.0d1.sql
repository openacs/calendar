---
--- CREATE TABLE IF NOT EXISTS for Oracle ...
---

DECLARE count NUMBER;
BEGIN
count := 0;
SELECT COUNT(1) INTO count from user_tables WHERE table_name= 'CAL_UIDS';
IF COL_COUNT = 0 THEN
  EXECUTE IMMEDIATE '
    CREATE TABLE IF NOT EXISTS cal_uids (
        cal_uid          varchar 
                         constraint cal_uid_pk 
                         primary key,            
        on_which_activity integer
                          constraint cal_uid_fk
                          not null
                          references acs_activities
                          on delete cascade,
       ical_vars varchar
    )';
END IF;
END;
/

create or replace package body cal_uid
as
    procedure upsert (
       p_cal_uid     in cal_uids.cal_uid%TYPE,
       p_activity_id in cal_uids.on_which_activity%TYPE,
       p_ical_vars   in cal_uids.ical_vars%TYPE
    )
    is
    BEGIN
        --
        -- We might have duplicates on the activity_id and on the cal_uid,
	-- both should be unique.
	--
        -- Try to delete entry to avoid duplicates (might fail)
    	delete from cal_uids where on_which_activity = p_activity_id;
	-- Insert value
	insert into cal_uids 
                (cal_uid, on_which_activity, ical_vars)
        values  (p_cal_uid, p_activity_id, p_ical_vars);

    exception
        when dup_val_on_index then
	     update cal_uids
             set    ical_vars = p_ical_vars
	     where  cal_uid = p_cal_uid;
   END upsert;

end sec_session_property;
/
show errors
