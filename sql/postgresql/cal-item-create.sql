-- Create the cal_item object
--
-- @author Gary Jin (gjin@arsdigita.com)
-- @creation-date Nov 17, 2000
-- @cvs-id $Id$
--

-- ported by Lilian Tong (tong@ebt.ee.usyd.edu.au)

---------------------------------------------------------- 
--  cal_item_ojbect 
----------------------------------------------------------

CREATE OR REPLACE FUNCTION inline_0 () RETURNS integer AS $$
BEGIN
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
END;
$$ LANGUAGE plpgsql;

SELECT inline_0 (); 

DROP FUNCTION inline_0 ();

CREATE OR REPLACE FUNCTION inline_1 ()  RETURNS integer AS $$
BEGIN
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
END;
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
-- create package cal_item
-------------------------------------------------------------


--
-- procedure cal_item__new/14
--
select define_function_args('cal_item__new','cal_item_id;null,on_which_calendar;null,name,description,html_p;null,status_summary;null,timespan_id;null,activity_id;null,recurrence_id;null,object_type;"cal_item",context_id;null,creation_date;now(),creation_user;null,creation_ip;null');


CREATE OR REPLACE FUNCTION cal_item__new(
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
   new__creation_user              -- creation_date	acs_objects.creation_date%TYPE
    integer,                       -- default null
   new__creation_ip varchar        -- default null

) RETURNS integer AS $$
DECLARE
    v_cal_item_id		cal_items.cal_item_id%TYPE;

BEGIN
    v_cal_item_id := acs_event__new(
	new__cal_item_id,	-- event_id
	new__name,		-- name
	new__description,	-- description
        new__html_p,		-- html_p
        new__status_summary,    -- status_summary
	new__timespan_id,	-- timespan_id
	new__activity_id,	-- activity_id
	new__recurrence_id,	-- recurrence_id
	new__object_type,	-- object_type
	new__creation_date,	-- creation_date
	new__creation_user,	-- creation_user
	new__creation_ip,	-- creation_ip
	new__context_id		-- context_id
	);

    insert into cal_items
	(cal_item_id, on_which_calendar)
    values          
	(v_cal_item_id, new__on_which_calendar);

    return v_cal_item_id;

END;
$$ LANGUAGE plpgsql;


------------------------------------------------------------
-- the delete operation
------------------------------------------------------------

--
-- procedure cal_item__delete/1
--
select define_function_args('cal_item__delete','cal_item_id');

CREATE OR REPLACE FUNCTION cal_item__delete(
   delete__cal_item_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
	-- Erase the cal_item associated with the id
    delete from 	cal_items
    where		cal_item_id = delete__cal_item_id;
 	
	-- Erase all the privileges
    delete from 	acs_permissions
    where		object_id = delete__cal_item_id;

    PERFORM acs_event__delete(delete__cal_item_id);

    return 0;
END;
$$ LANGUAGE plpgsql;



--
-- procedure cal_item__delete_all/1
--
select define_function_args('cal_item__delete_all','recurrence_id');

CREATE OR REPLACE FUNCTION cal_item__delete_all(
   delete__recurrence_id integer
) RETURNS integer AS $$
DECLARE
    v_event                             RECORD;
BEGIN
    for v_event in 
	select event_id from acs_events
        where recurrence_id= delete__recurrence_id
    LOOP
        PERFORM cal_item__delete(v_event.event_id);
    END LOOP;

    PERFORM recurrence__delete(delete__recurrence_id);

    return 0;

END;
$$ LANGUAGE plpgsql;
