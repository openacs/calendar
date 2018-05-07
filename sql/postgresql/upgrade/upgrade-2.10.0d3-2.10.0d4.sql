DROP function if exists
cal_item__new(integer, integer, character varying, character varying, boolean, character varying, integer, integer, integer, character varying, integer, timestamp with time zone, integer, character varying, integer, character varying);

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
