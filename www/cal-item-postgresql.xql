<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_item_data">      
      <querytext>
       
	select   to_char(start_date, 'MM/DD/YYYY') as start_date,
	         to_char(start_date, 'HH24:MI') as start_time,
	         to_char(end_date, 'HH24:MI') as end_time,
	         coalesce(a. name, e.name) as name,
	         coalesce(e.description, a.description) as description
	from     acs_activities a,
	         acs_events e,
	         timespans s,
	         time_intervals t
	where    e.timespan_id = s.timespan_id
	and      s.interval_id = t.interval_id
	and      e.activity_id = a.activity_id
	and      e.event_id = :cal_item_id
    
      </querytext>
</fullquery>

 
<fullquery name="list_calendars">      
      <querytext>
      

	select    object_id as calendar_id,
    	          calendar__name(object_id) as calendar_name
	from      acs_permissions
	where     privilege in ( 
	            'calendar_write',
	            'calendar_admin'
	          )
	and       grantee_id = :user_id
        and       acs_object_util__object_type_p(
                    object_id, 
                    'calendar'
                  ) = 't'
        and       calendar__private_p(
                    object_id
                  ) = 'f'
	          

    
      </querytext>
</fullquery>

 
</queryset>
