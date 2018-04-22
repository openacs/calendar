
--
-- procedure cal_item__delete/1
--
select define_function_args('cal_item__delete','cal_item_id');

create or replace function cal_item__delete(
   delete__cal_item_id integer
) returns integer AS $$
declare
   v_activity_id   integer;
   v_recurrence_id integer;
begin

    select activity_id, recurrence_id into v_activity_id, v_recurrence_id
    from   acs_events
    where  event_id = delete__cal_item_id;

    -- Erase the cal_item associated with the id
    delete from 	cal_items
    where		cal_item_id = delete__cal_item_id;

    -- Erase all individual permissions Should be handled via CASCADE;
    -- not sure, why this is here.
    --
    -- delete from 	acs_permissions
    -- where		object_id = delete__cal_item_id;

    PERFORM acs_event__delete(delete__cal_item_id);

    IF NOT acs_event__instances_exist_p(v_recurrence_id) THEN
        --
	-- There are no more events for the activity, we can clean up
	-- both, the activity and - if given - the recurrence.
	--
        PERFORM acs_activity__delete(v_activity_id);
	
        IF v_recurrence_id is not null THEN
	    PERFORM recurrence__delete(v_recurrence_id);
	END IF;
    END IF;

    return 0;
end;
$$ LANGUAGE plpgsql;
