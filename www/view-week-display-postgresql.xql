<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
<fullquery name="select_weekday_info">
<querytext>
        select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 'D') 
        as       day_of_the_week,
        to_char(next_day(to_date(:current_date, 'yyyy-mm-dd')- '1 week'::interval, 'Sunday'), 'YYYY-MM-DD')
        as       sunday_of_the_week,
        to_char(next_day(to_date(:current_date, 'yyyy-mm-dd'), 'Saturday'), 'YYYY-MM-DD')
        as       saturday_of_the_week
        from     dual
</querytext>
</fullquery>

<fullquery name="select_week_items">
<querytext>
select   to_char(start_date, 'J') as start_date_julian,
         to_char(start_date,'HH24:MI') as start_date,
         to_char(end_date,'HH24:MI') as end_date,
         to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
         coalesce(e.name, a.name) as name,
         coalesce(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type,
	 (select on_which_calendar from cal_items where cal_item_id = e.event_id) as calendar_id,
	 (select calendar_name from calendars 
	 where calendar_id = (select on_which_calendar from cal_items where cal_item_id= e.event_id))
	 as calendar_name
from     acs_activities a,
         acs_events e,
         timespans s,
         time_intervals t,
         cal_items
where    e.timespan_id = s.timespan_id
and      s.interval_id = t.interval_id
and      e.activity_id = a.activity_id
and     e.event_id = cal_items.cal_item_id       
and      start_date between
         to_date(:sunday_of_the_week,'YYYY-MM-DD') and
         to_date(:saturday_of_the_week,'YYYY-MM-DD')
and      e.event_id
in       (
         select  cal_item_id
         from    cal_items
         where   on_which_calendar in ([join $calendar_id_list ","])
         )
</querytext>
</fullquery>


</queryset>

