-- Create the cal_item object
--
-- @author Gary Jin (gjin@arsdigita.com)
-- @creation-date Nov 17, 2000
-- @cvs-id $Id$
--



begin

        acs_object_type.create_type (
                supertype       =>      'acs_event',
                object_type     =>      'cal_item',
                pretty_name     =>      'Calendar Item',
                pretty_plural   =>      'Calendar Items',
                table_name      =>      'cal_items',
                id_column       =>      'cal_item_id'
        );
 
end;
/
show errors
 

declare 
        attr_id acs_attributes.attribute_id%TYPE; 
begin
        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'cal_item', 
                attribute_name  =>      'on_which_calendar', 
                pretty_name     =>      'On Which Calendar', 
                pretty_plural   =>      'On Which Calendars', 
                datatype        =>      'integer' 
        );
end;
/
show errors


  -- Each cal_item has the super_type of ACS_EVENTS
  -- Table cal_items supplies additional information
create table cal_items (
          -- primary key
        cal_item_id             integer 
                                constraint cal_item_cal_item_id_fk 
                                references acs_events
                                constraint cal_item_cal_item_id_pk
                                primary key,            
        on_which_calendar       integer
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

create index cal_items_on_which_cal_idx on cal_items (on_which_calendar);

-------------------------------------------------------------
CREATE TABLE cal_uids (
        -- primary key
        cal_uid          varchar 
                         constraint cal_uid_pk 
                         primary key,            
        on_which_activity integer
                          constraint cal_uid_fk
                          not null
                          references acs_activities
                          on delete cascade,
       ical_vars varchar2(4000)
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
                                                        
                                                        
create or replace package cal_item
as
        function new (
                cal_item_id             in cal_items.cal_item_id%TYPE           default null,
                on_which_calendar       in calendars.calendar_id%TYPE           ,
                name                    in acs_activities.name%TYPE             default null,
                description             in acs_activities.description%TYPE      default null,
                html_p                  in acs_activities.html_p%TYPE           default 'f',
                status_summary          in acs_activities.status_summary%TYPE   default null,
                timespan_id             in acs_events.timespan_id%TYPE          default null,
                activity_id             in acs_events.activity_id%TYPE          default null,  
                recurrence_id           in acs_events.recurrence_id%TYPE        default null,
                item_type_id            in cal_items.item_type_id%TYPE default null,
                object_type             in acs_objects.object_type%TYPE         default 'cal_item',
                context_id              in acs_objects.context_id%TYPE          default null,
                creation_date           in acs_objects.creation_date%TYPE       default sysdate,
                creation_user           in acs_objects.creation_user%TYPE       default null,
                creation_ip             in acs_objects.creation_ip%TYPE         default null                                 
        ) return cal_items.cal_item_id%TYPE;
 
          -- delete cal_item
        procedure del (
                cal_item_id             in cal_items.cal_item_id%TYPE
        );

        procedure delete_all (
                recurrence_id           in acs_events.recurrence_id%TYPE
        );
        
end cal_item;
/
show errors;


                                                        
create or replace package body cal_item
as
        function new (
                cal_item_id             in cal_items.cal_item_id%TYPE           default null,
                on_which_calendar       in calendars.calendar_id%TYPE           ,
                name                    in acs_activities.name%TYPE             default null,
                description             in acs_activities.description%TYPE      default null,
                html_p                  in acs_activities.html_p%TYPE           default 'f',
                status_summary          in acs_activities.status_summary%TYPE   default null,
                timespan_id             in acs_events.timespan_id%TYPE          default null,
                activity_id             in acs_events.activity_id%TYPE          default null,  
                recurrence_id           in acs_events.recurrence_id%TYPE        default null,
                item_type_id            in cal_items.item_type_id%TYPE default null,
                object_type             in acs_objects.object_type%TYPE         default 'cal_item',
                context_id              in acs_objects.context_id%TYPE          default null,
                creation_date           in acs_objects.creation_date%TYPE       default sysdate,
                creation_user           in acs_objects.creation_user%TYPE       default null,
                creation_ip             in acs_objects.creation_ip%TYPE         default null,
                package_id              in acs_objects.package_id%TYPE          default null,
                location                in acs_event.location%TYPE              default null                                 
	) return cal_items.cal_item_id%TYPE

        is
                v_cal_item_id           cal_items.cal_item_id%TYPE;
                v_grantee_id            acs_permissions.grantee_id%TYPE;
                v_privilege             acs_permissions.privilege%TYPE;

        begin
                v_cal_item_id := acs_event.new (
                        event_id        =>      cal_item_id,
                        name            =>      name,
                        description     =>      description,
                        html_p          =>      html_p,
                        status_summary  =>      status_summary,
                        timespan_id     =>      timespan_id,
                        activity_id     =>      activity_id,
                        recurrence_id   =>      recurrence_id,
                        object_type     =>      object_type,
                        creation_date   =>      creation_date,
                        creation_user   =>      creation_user,
                        creation_ip     =>      creation_ip,
                        context_id      =>      context_id,
                        package_id      =>      package_id,
                        location        =>      location
                );

                insert into     cal_items
                                (cal_item_id, on_which_calendar, item_type_id)
                values          (v_cal_item_id, on_which_calendar, item_type_id);

                  -- assign the default permission to the cal_item
                  -- by default, cal_item are going to inherit the 
                  -- calendar permission that it belongs too. 
                
                  -- first find out the permissions. 
                --select          grantee_id into v_grantee_id
                --from            acs_permissions
                --where           object_id = cal_item.new.on_which_calendar;                     

                --select          privilege into v_privilege
                --from            acs_permissions
                --where           object_id = cal_item.new.on_which_calendar;                     

                  -- now we grant the permissions       
                --acs_permission.grant_permission (       
                 --       object_id       =>      v_cal_item_id,
                  --      grantee_id      =>      v_grantee_id,
                   --     privilege       =>      v_privilege

                --);

                return v_cal_item_id;
        
        end new;
 
        procedure del (
                cal_item_id             in cal_items.cal_item_id%TYPE
        )
        is
          v_activity_id     acs_events.activity_id%TYPE;
	  v_recurrence_id   acs_events.recurrence_id%TYPE;
        begin

                select activity_id, recurrence_id into v_activity_id, v_recurrence_id
		from   acs_events
		where  event_id = cal_item_id;

                  -- Erase the cal_item associated with the id
                delete from     cal_items
                where           cal_item_id = cal_item.del.cal_item_id;
                
                  -- Erase all the privileges
                delete from     acs_permissions
                where           object_id = cal_item.del.cal_item_id;

                acs_event.del(cal_item_id);

		IF instances_exist_p(recurrence_id) = 'f' THEN
		    --
		    -- There are no more events for the activity, we can clean up
		    -- both, the activity and - if given - the recurrence.
		    --
		    acs_activity.del(v_activity_id);
	
	           IF v_recurrence_id is not null THEN
		       recurrence.del(v_recurrence_id);
		   END IF;
	        END IF;
		
        end del;
                  
        procedure delete_all (
                recurrence_id           in acs_events.recurrence_id%TYPE
        ) is
          v_event_id            acs_events%ROWTYPE;
        begin
                FOR v_event_id in 
                    (select * from acs_events 
                    where recurrence_id = delete_all.recurrence_id)
                LOOP
                        cal_item.del(v_event_id.event_id);
                end LOOP;

                recurrence.del(recurrence_id);
        end delete_all;
end cal_item;
/
show errors


create or replace package cal_uid
as
    procedure upsert (
       p_cal_uid     in cal_uids.cal_uid%TYPE,
       p_activity_id in cal_uids.on_which_activity%TYPE,
       p_ical_vars   in cal_uids.ical_vars%TYPE
    );
end cal_uid;
/
show errors

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





