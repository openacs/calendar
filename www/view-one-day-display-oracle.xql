<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	
<fullquery name="select_day_items">
<querytext>
select   to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
         nvl(e.name, a.name) as name,
         nvl(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type,
	 on_which_calendar as calendar_id,
	 (select calendar_name from calendars 
	 where calendar_id = on_which_calendar)
	 as calendar_name
from     acs_activities a,
         acs_events e,
         timespans s,
         time_intervals t,
         cal_items
where    e.timespan_id = s.timespan_id
and      s.interval_id = t.interval_id
and      e.activity_id = a.activity_id
and      start_date between
         to_date(:current_date,:date_format) and
         (to_date(:current_date,:date_format) + (24 - 1/3600)/24)
and     cal_items.cal_item_id= e.event_id
and      e.event_id
in       (
         select  cal_item_id
         from    cal_items
         where   on_which_calendar in ([join $calendar_id_list ","])
         )
	
</querytext>
</fullquery>


<fullquery name="select_day_info">      
<querytext>
select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 'Day, DD Month YYYY') 
as day_of_the_week,
to_char(to_date(:current_date, 'yyyy-mm-dd') - cast('1 day' as interval), 'yyyy-mm-dd')
as yesterday,
to_char(to_date(:current_date, 'yyyy-mm-dd') + cast('1 day' as interval), 'yyyy-mm-dd')
as tomorrow
from     dual
</querytext>
</fullquery>


</queryset>

