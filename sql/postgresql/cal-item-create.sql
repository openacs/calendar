-- Create the cal_item object
--
-- @author Gary Jin (gjin@arsdigita.com)
-- @creation-date Nov 17, 2000
-- @cvs-id $Id$
--

-- ported by Lilian Tong (tong@ebt.ee.usyd.edu.au)

---------------------------------------------------------- 
--  cal_item_object
----------------------------------------------------------

create or replace function inline_0 () returns integer AS $$
begin
    PERFORM acs_object_type__create_type (
	'cal_item',		-- object_type
 	'Calendar Item',	-- pretty_name
	'Calendar Items',	-- pretty_plural
	'acs_event',		-- supertype
	'cal_items',		-- table_name
	'cal_item_id',	-- id_column
	null,			-- package_name
	'f',			-- abstract_p
	null,			-- type_extension_table
	null			-- name_method
	);
    return 0;
end;
$$ LANGUAGE plpgsql;

SELECT inline_0 (); 

DROP FUNCTION inline_0 ();

create or replace function inline_1 ()  returns integer AS $$
begin
    PERFORM acs_attribute__create_attribute (
	'cal_item',		-- object_type
	'on_which_calendar',	-- attribute_name
	'integer',		-- datatype
	'On Which Calendar',	-- pretty_name
	'On Which Calendars',	-- pretty_plural
	null,			-- table_name (default)
  	null,			-- column_name (default)
	null,			-- default_value (default)
	1,			-- min_n_values (default)
	1,			-- max_n_values (default)
	null,			-- sort_order (default)
	'type_specific',	-- storage (default)
 	'f'			-- static_p (default)
 	);
    return 0;
end;
$$ LANGUAGE plpgsql;

SELECT inline_1 ();

DROP FUNCTION inline_1 ();


--  -- Each cal_item has the super_type of ACS_EVENTS
--  -- Table cal_items supplies additional information

CREATE TABLE cal_items (
          -- primary key
        cal_item_id	  integer 
			  constraint cal_item_cal_item_id_fk 
                          references acs_events
                          constraint cal_item_cal_item_id_pk 
                          primary key,            
          -- a references to calendar
          -- Each cal_item is owned by one calendar
        on_which_calendar integer
                          constraint cal_item_which_cal_fk
                          references calendars
                          on delete cascade,
        item_type_id            integer,
        constraint cal_items_type_fk
        foreign key (on_which_calendar, item_type_id)
        references cal_item_types(calendar_id, item_type_id)
);

comment on table cal_items is '
        Table cal_items maps the ownership relation between 
        an cal_item_id to calendars. Each cal_item is owned
        by a calendar
';

comment on column cal_items.cal_item_id is '
        Primary Key
';

comment on column cal_items.on_which_calendar is '
        Mapping to calendar. Each cal_item is owned
        by a calendar
';

create index cal_items_on_which_calendar_idx on cal_items (on_which_calendar);


-------------------------------------------------------------
CREATE TABLE cal_uids (
        -- primary key
        cal_uid          text 
                         constraint cal_uid_pk 
                         primary key,            
        on_which_activity integer
                          constraint cal_uid_fk
                          not null
                          references acs_activities
                          on delete cascade,
       ical_vars varchar
);

comment on table cal_uids is '
        Table cal_uids maps a unique (external) key to an
        activity. This is needed for syncing calendars via
        ical; the field uid should go into acs_activities
';


comment on column cal_uids.cal_uid is '
        Primary Key
';

comment on column cal_uids.on_which_activity is '
        Reference to an activity, for which the key is used
';

comment on column cal_uids.ical_vars is '
        List with attributes and values from external ical calendar programs
';


-------------------------------------------------------------
-- create package cal_item
-------------------------------------------------------------


--
-- procedure cal_item__new/15-16
--
select define_function_args('cal_item__new','cal_item_id;null,on_which_calendar;null,name,description,html_p;null,status_summary;null,timespan_id;null,activity_id;null,recurrence_id;null,object_type;"cal_item",context_id;null,creation_date;now(),creation_user;null,creation_ip;null,package_id;null,location;null');

create or replace function cal_item__new(
   new__cal_item_id integer,       -- default null
   new__on_which_calendar integer, -- default null
   new__name varchar,
   new__description varchar,
   new__html_p boolean,            -- default null
   new__status_summary varchar,    -- default null
   new__timespan_id integer,       -- default null
   new__activity_id integer,       -- default null
   new__recurrence_id integer,     -- default null
   new__object_type varchar,       -- default "cal_item"
   new__context_id integer,        -- default null
   new__creation_date timestamptz, -- default now()
   new__creation_user integer,     -- acs_objects.creation_date%TYPE default null
   new__creation_ip varchar,       -- default null
   new__package_id integer,        -- default null
   new__location varchar default NULL,
   new__related_link_url varchar default NULL,
   new__related_link_text varchar default NULL,
   new__redirect_to_rel_link_p boolean default NULL

) returns integer AS $$
declare
    v_cal_item_id        cal_items.cal_item_id%TYPE;
begin
    v_cal_item_id := acs_event__new(
        new__cal_item_id,    -- event_id
    	new__name,           -- name
        new__description,    -- description
        new__html_p,         -- html_p
        new__status_summary, -- status_summary
        new__timespan_id,    -- timespan_id
        new__activity_id,    -- activity_id
        new__recurrence_id,  -- recurrence_id
        new__object_type,    -- object_type
        new__creation_date,  -- creation_date
        new__creation_user,  -- creation_user
        new__creation_ip,    -- creation_ip
        new__context_id,     -- context_id
        new__package_id,     -- package_id
	new__location,        -- location
	new__related_link_url,
	new__related_link_text,
	new__redirect_to_rel_link_p
    );

    insert into cal_items (cal_item_id,   on_which_calendar)
    values                (v_cal_item_id, new__on_which_calendar);

    return v_cal_item_id;
end;
$$ LANGUAGE plpgsql;



------------------------------------------------------------
-- the delete operation
------------------------------------------------------------

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



--
-- procedure cal_item__delete_all/1
--
select define_function_args('cal_item__delete_all','recurrence_id');

create or replace function cal_item__delete_all(
   delete__recurrence_id integer
) returns integer AS $$
declare
    v_event                             RECORD;
begin
    for v_event in 
	select event_id from acs_events
        where recurrence_id= delete__recurrence_id
    LOOP
        PERFORM cal_item__delete(v_event.event_id);
    END LOOP;

    PERFORM recurrence__delete(delete__recurrence_id);

    return 0;

end;
$$ LANGUAGE plpgsql;




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
