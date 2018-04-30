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
                creation_ip             in acs_objects.creation_ip%TYPE         default null,
                package_id              in acs_objects.package_id%TYPE          default null,
                location                in acs_event.location%TYPE              default null,
                related_link_url        in acs_event.related_link_url%TYPE      default null,
		related_link_text       in acs_event.related_link_text%TYPE     default null,
                redirect_to_rel_link_p  in acs_event.redirect_to_rel_link_p%TYPE default null
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
                location                in acs_event.location%TYPE              default null,
                related_link_url        in acs_event.related_link_url%TYPE      default null,
		related_link_text       in acs_event.related_link_text%TYPE     default null,
                redirect_to_rel_link_p  in acs_event.redirect_to_rel_link_p%TYPE default null
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
                        location        =>      location,
                        related_link_url =>     related_link_url,
			related_link_text =>    related_link_text,
                        redirect_to_rel_link_p => redirect_to_rel_link_p
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
