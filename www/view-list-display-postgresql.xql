<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="select_list_items">
<querytext>
	select  
         to_char(start_date, 'J') as julian_start_date,
         to_char(start_date, 'HH24') as start_hour,
         to_char(start_date, 'YYYY-MM-DD') as pretty_start_date,
         to_char(start_date, 'HH24:MI:SS') as start_time,
         to_char(end_date, 'YYYY-MM-DD') as pretty_end_date,
         to_char(start_date, 'HH24:MI') as pretty_start_time,
         to_char(end_date, 'HH24:MI') as pretty_end_time,
         coalesce(e.name, a.name) as name,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type,
         to_char(start_date, 'Day') as pretty_weekday,
	 cals.calendar_id,
	 cals.calendar_name
from     acs_activities a,
         acs_events e,
         timespans s,
         time_intervals t,
         cal_items ci,
         calendars cals
where    e.timespan_id = s.timespan_id
and      s.interval_id = t.interval_id
and      e.activity_id = a.activity_id
and      cal_items.cal_item_id= e.event_id
and      (start_date >= to_date(:start_date,:date_format) or :start_date is null) 
and      (start_date <= to_date(:end_date,:date_format) or :end_date is null)
and      cals.package_id= :package_id
and      (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))
and      cals.calendar_id = ci.on_which_calendar
and      e.event_id = ci.cal_item_id
order by $sort_by
	
</querytext>
</fullquery>


 
</queryset>
