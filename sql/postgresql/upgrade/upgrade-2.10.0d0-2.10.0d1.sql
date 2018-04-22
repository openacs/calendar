
CREATE TABLE IF NOT EXISTS cal_uids (
        -- primary key
        cal_uid          text 
                         constraint cal_uid_pk 
                         primary key,            
        on_which_activity integer
                          constraint cal_uid_fk
                          not null
                          references acs_activities
                          on delete cascade,
       ical_vars text
);

---
--- The new ical_vars are now triples, contaning the tag name, the tag
--- parameters and the value. Previously it wer just pairs.
---
UPDATE cal_uids SET ical_vars = NULL;


select define_function_args('cal_uid__upsert','cal_uid,activity_id,ical_vars');

CREATE OR REPLACE FUNCTION cal_uid__upsert(
       p_cal_uid     text,
       p_activity_id integer,
       p_ical_vars   text
) RETURNS void as
$$
BEGIN
    LOOP
    --
    -- We might have duplicates on the activity_id and on the cal_uid,
    -- both should be unique.
    --
    update cal_uids
        set   ical_vars = p_ical_vars
	where cal_uid = p_cal_uid;
        IF found THEN
            return;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
	    -- Try to delete entry to avoid duplicates (might fail)
	    delete from cal_uids where on_which_activity = p_activity_id;
	    -- Insert value
	    insert into cal_uids 
                (cal_uid, on_which_activity, ical_vars)
            values
                (p_cal_uid, p_activity_id,  p_ical_vars);
            RETURN;
            EXCEPTION WHEN unique_violation THEN
            -- Do nothing, and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

