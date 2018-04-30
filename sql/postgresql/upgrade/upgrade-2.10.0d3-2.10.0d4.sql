DROP function if exists
cal_item__new(integer, integer, character varying, character varying, boolean, character varying, integer, integer, integer, character varying, integer, timestamp with time zone, integer, character varying, integer, character varying);

select define_function_args('acs_event__new','event_id;null,name;null,description;null,html_p;null,status_summary;null,timespan_id;null,activity_id;null,recurrence_id;null,object_type;acs_event,creation_date;now(),creation_user;null,creation_ip;null,context_id;null,package_id;null,location;null,related_link_url;null,related_link_text;null,redirect_to_rel_link_p;null');

CREATE OR REPLACE FUNCTION acs_event__new(
   new__event_id  integer,         -- default null,
   new__name varchar,              -- default null,
   new__description text,          -- default null,
   new__html_p boolean,            -- default null
   new__status_summary text,       -- default null
   new__timespan_id integer,       -- default null,
   new__activity_id integer,       -- default null,
   new__recurrence_id integer,     -- default null,
   new__object_type varchar,       -- default 'acs_event',
   new__creation_date timestamptz, -- default now(),
   new__creation_user integer,     -- default null,
   new__creation_ip varchar,       -- default null,
   new__context_id integer,        -- default null
   new__package_id integer,        -- default null
   new__location varchar default NULL,
   new__related_link_url varchar default NULL,
   new__related_link_text varchar default NULL,
   new__redirect_to_rel_link_p boolean default NULL

) RETURNS integer AS $$
	-- acs_events.event_id%TYPE
DECLARE
       v_event_id	    acs_events.event_id%TYPE;
BEGIN
       v_event_id := acs_object__new(
            new__event_id,	-- object_id
            new__object_type,	-- object_type
            new__creation_date, -- creation_date
            new__creation_user,	-- creation_user
            new__creation_ip,	-- creation_ip
            new__context_id,	-- context_id
            't',		-- security_inherit_p
            new__name,		-- title
            new__package_id	-- package_id
	    );

       insert into acs_events
            (event_id, name, description, html_p, status_summary,
	    activity_id, timespan_id, recurrence_id, location,
	    related_link_url, related_link_text, redirect_to_rel_link_p)
       values
            (v_event_id, new__name, new__description, new__html_p, new__status_summary,
	    new__activity_id, new__timespan_id, new__recurrence_id, new__location,
	    new__related_link_url, new__related_link_text, new__redirect_to_rel_link_p);

       return v_event_id;

END;
$$ LANGUAGE plpgsql;

