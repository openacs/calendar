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

CREATE FUNCTION inline_0 ()
RETURNS integer AS '
begin
    PERFORM acs_object_type__create_type (
	''cal_item'',		-- object_type
 	''Calendar Item'',	-- pretty_name
	''Calendar Items'',	-- pretty_plural
	''acs_event'',		-- supertype
	''cal_items'',		-- table_name
	''cal_item_id'',	-- id_column
	null,			-- package_name
	''f'',			-- abstract_p
	null,			-- type_extension_table
	null			-- name_method
	);
    return 0;
end;' LANGUAGE 'plpgsql';

SELECT inline_0 (); 

DROP FUNCTION inline_0 ();

--begin

--        acs_object_type.create_type (
--                supertype       =>      'acs_event',
--                object_type     =>      'cal_item',
--                pretty_name     =>      'Calendar Item',
--                pretty_plural   =>      'Calendar Items',
--                table_name      =>      'cal_items',
--                id_column       =>      'cal_item_id'
--        );
 
--end;
--/
--show errors

CREATE FUNCTION inline_1 () 
RETURNS integer AS '
begin
    PERFORM acs_attribute__create_attribute (
	''cal_item'',		-- object_type
	''on_which_calendar'',	-- attribute_name
	''integer'',		-- datatype
	''On Which Calendar'',	-- pretty_name
	''On Which Calendars'',	-- pretty_plural
	null,			-- table_name (default)
  	null,			-- column_name (default)
	null,			-- default_value (default)
	1,			-- min_n_values (default)
	1,			-- max_n_values (default)
	null,			-- sort_order (default)
	''type_specific'',	-- storage (default)
 	''f''			-- static_p (default)
 	);
    return 0;
end;' LANGUAGE 'plpgsql';

SELECT inline_1 ();

DROP FUNCTION inline_1 ();


--declare 
--        attr_id acs_attributes.attribute_id%TYPE; 
--begin
--        attr_id := acs_attribute.create_attribute ( 
--                object_type     =>      'cal_item', 
--                attribute_name  =>      'on_which_caledar', 
--                pretty_name     =>      'On Which Calendar', 
--                pretty_plural   =>      'On Which Calendars', 
--                datatype        =>      'integer' 
--        );
--end;
--/
--show errors


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
                          on delete cascade
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

 
-------------------------------------------------------------
-- create package cal_item
-------------------------------------------------------------

CREATE FUNCTION cal_item__new (
    integer,	-- cal_item_id		cal_items.cal_item_id%TYPE
    integer,	-- on_which_calendar	calenders.calendar_id%TYPE
    varchar,	-- name			acs_activities.name%TYPE
    varchar,	-- description		acs_activities.description%TYPE
    integer,	-- timespan_id		acs_events.timespan_id%TYPE
    integer,	-- activity_id		acs_events.activity_id%TYPE
    integer,	-- recurrence_id	acs_events.recurrence_id%TYPE
    varchar,	-- object_type		acs_objects.object_type%TYPE
    integer,	-- context_id		acs_objects.context_id%TYPE
    timestamp,	-- createion_date	acs_objects.creation_date%TYPE
    integer,	-- creation_user	acs_objects.creation_user%TYPE
    varchar	-- creation_ip		acs_objects.creation_ip%TYPE
)
RETURNS integer AS '
declare
    new__cal_item_id		alias for $1;	-- default null
    new__on_which_calendar	alias for $2;	-- default null
    new__name			alias for $3;	
    new__description		alias for $4;	
    new__timespan_id		alias for $5;	-- default null
    new__activity_id		alias for $6;	-- default null
    new__recurrence_id		alias for $7;	-- default null
    new__object_type		alias for $8;	-- default "cal_item"
    new__context_id		alias for $9;	-- default null
    new__creation_date		alias for $10;	-- default now()
    new__creation_user		alias for $11;	-- default null
    new__creation_ip		alias for $12;	-- default null
    v_cal_item_id		cal_items.cal_item_id%TYPE;

begin
    v_cal_item_id := acs_event__new(
	new__cal_item_id,	-- event_id
	new__name,		-- name
	new__description,	-- description
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

end;' LANGUAGE 'plpgsql';


------------------------------------------------------------
-- the delete operation
------------------------------------------------------------

CREATE FUNCTION cal_item__delete (
	integer
)
RETURNS integer AS '
declare
    delete__cal_item_id		alias for $1;
begin
	-- Erase the cal_item associated with the id
    delete from 	cal_items
    where		cal_item_id = delete__cal_item_id;
 	
	-- Erase all the priviledges
    delete from 	acs_permissions
    where		object_id = delete__cal_item_id;

    PERFORM acs_event__delete(delete__cal_item_id);

    return 0;

end;' LANGUAGE 'plpgsql';


-------------------------------------------------------------
-- the name function
-------------------------------------------------------------

    -- function to return the name of the cal_item
CREATE FUNCTION cal_item__name (
    integer
)
RETURNS varchar AS '
declare 
    name__cal_item_id	alias for $1;
    v_name	acs_activities.name%TYPE;
begin
    select  name 
    into    v_name
    from    acs_activities
    where   activity_id = 
    (
	select  activity_id
        from    acs_events
        where   event_id = name__cal_item_id
    );
               
    return v_name;

end;' LANGUAGE 'plpgsql';


---------------------------------------------------------------
-- the on_which_calendar function
---------------------------------------------------------------

    -- function to return the calendar that owns the cal_item
CREATE FUNCTION cal_item__on_which_calendar (
    integer
)
RETURNS integer AS '
declare
    on_which_calendar__cal_item_id	alias for $1;
    v_calendar_id			calendars.calendar_id%TYPE;
begin
    select  on_which_calendar
    into    v_calendar_id
    from    cal_items
    where   cal_item_id = on_which_calendar__cal_item_id;
        
    return  v_calendar_id;

end;' LANGUAGE 'plpgsql';



--create or replace package cal_item
--as
--        function new (
--                cal_item_id             in cal_items.cal_item_id%TYPE           default null,
--                on_which_calendar       in calendars.calendar_id%TYPE           ,
--                name                    in acs_activities.name%TYPE             default null,
--                description             in acs_activities.description%TYPE      default null,
--                timespan_id             in acs_events.timespan_id%TYPE          default null,
--                activity_id             in acs_events.activity_id%TYPE          default null,  
--                recurrence_id           in acs_events.recurrence_id%TYPE        default null,
--                object_type             in acs_objects.object_type%TYPE         default 'cal_item',
--                context_id              in acs_objects.context_id%TYPE          default null,
--                creation_date           in acs_objects.creation_date%TYPE       default sysdate,
--                creation_user           in acs_objects.creation_user%TYPE       default null,
--                creation_ip             in acs_objects.creation_ip%TYPE         default null                                 
--        ) return cal_items.cal_item_id%TYPE;
-- 
--           delete cal_item
--        procedure delete (
--                cal_item_id             in cal_items.cal_item_id%TYPE
--        );
--
--          -- functions to return the name of the cal_item
--        function name (
--                cal_item_id             in cal_items.cal_item_id%TYPE   
--        ) return acs_activities.name%TYPE;
--
--          -- functions to return the calendar that owns the cal_item
--        function on_which_calendar (
--                cal_item_id             in cal_items.cal_item_id%TYPE   
--        ) return calendars.calendar_id%TYPE;
--
--end cal_item;
--/
--show errors;
--
--                                                        
--create or replace package body cal_item
--as
--        function new (
--                cal_item_id             in cal_items.cal_item_id%TYPE           default null,
--                on_which_calendar       in calendars.calendar_id%TYPE           ,
--                name                    in acs_activities.name%TYPE             default null,
--                description             in acs_activities.description%TYPE      default null,
--                timespan_id             in acs_events.timespan_id%TYPE          default null,
--                activity_id             in acs_events.activity_id%TYPE          default null,  
--                recurrence_id           in acs_events.recurrence_id%TYPE        default null,
--                object_type             in acs_objects.object_type%TYPE         default 'cal_item',
--                context_id              in acs_objects.context_id%TYPE          default null,
--                creation_date           in acs_objects.creation_date%TYPE       default sysdate,
--                creation_user           in acs_objects.creation_user%TYPE       default null,
--                creation_ip             in acs_objects.creation_ip%TYPE         default null  
--               
--       ) return cal_items.cal_item_id%TYPE
--
--        is
--                v_cal_item_id           cal_items.cal_item_id%TYPE;
--                v_grantee_id            acs_permissions.grantee_id%TYPE;
--                v_privilege             acs_permissions.privilege%TYPE;
--
--        begin
--                v_cal_item_id := acs_event.new (
--                        event_id        =>      cal_item_id,
--                        name            =>      name,
--                        description     =>      description,
--                        timespan_id     =>      timespan_id,
--                        activity_id     =>      activity_id,
--                        recurrence_id   =>      recurrence_id,
--                        object_type     =>      object_type,
--                        creation_date   =>      creation_date,
--                        creation_user   =>      creation_user,
--                        creation_ip     =>      creation_ip,
--                        context_id      =>      context_id
--                );
--
--                insert into     cal_items
--                                (cal_item_id, on_which_calendar)
--                values          (v_cal_item_id, on_which_calendar);
--
--                  -- assign the default permission to the cal_item
--                  -- by default, cal_item are going to inherit the 
--                  -- calendar permission that it belongs too. 
--                
--                  -- first find out the permissions. 
--                --select          grantee_id into v_grantee_id
--                --from            acs_permissions
--                --where           object_id = cal_item.new.on_which_calendar;                     
--
--                --select          privilege into v_privilege
--                --from            acs_permissions
--                --where           object_id = cal_item.new.on_which_calendar;                     
--
--                  -- now we grant the permissions       
--                --acs_permission.grant_permission (       
--                 --       object_id       =>      v_cal_item_id,
--                  --      grantee_id      =>      v_grantee_id,
--                   --     privilege       =>      v_privilege
--
--                --);
--
--                return v_cal_item_id;
--        
--        end new;
-- 
--        procedure delete (
--                cal_item_id             in cal_items.cal_item_id%TYPE
--        )
--        is
--
--       begin
--                  -- Erase the cal_item assoicated with the id
--                delete from     cal_items
--                where           cal_item_id = cal_item.delete.cal_item_id;
--                
--                  -- Erase all the privileges
--                delete from     acs_permissions
--                where           object_id = cal_item.delete.cal_item_id;
--
--                acs_event.delete(cal_item_id);
--        end delete;
--                  
--          -- functions to return the name of the cal_item
--        function name (
--                cal_item_id             in cal_items.cal_item_id%TYPE   
--        ) 
--        return acs_activities.name%TYPE
--
--        is
--                v_name                  acs_activities.name%TYPE;
--        begin
--                select  name 
--                into    v_name
--                from    acs_activities
--                where   activity_id = 
--                        (
--                        select  activity_id
--                        from    acs_events
--                        where   event_id = cal_item.name.cal_item_id
--                        );
--                
--                return v_name;
--        end name;
--                 
--
--          -- functions to return the calendar that owns the cal_item
--        function on_which_calendar (
--                cal_item_id             in cal_items.cal_item_id%TYPE   
--        ) 
--        return calendars.calendar_id%TYPE
--
--        is
--                v_calendar_id           calendars.calendar_id%TYPE;
--        begin
--                select  on_which_calendar
--                into    v_calendar_id
--                from    cal_items
--                where   cal_item_id = cal_item.on_which_calendar.cal_item_id;
--        
--                return  v_calendar_id;
--        end on_which_calendar;
--
--end cal_item;
--/
--show errors;
