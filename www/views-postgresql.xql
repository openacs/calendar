<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="select_items">
<querytext>
select   to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
         coalesce(e.name, a.name) as name,
         coalesce(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= ci.item_type_id) as item_type,
	 cals.calendar_id,
	 cals.calendar_name
$additional_select_clause
from     acs_activities a,
         acs_events e,
         timespans s,
         time_intervals t,
         cal_items ci,
         calendars cals
where    e.timespan_id = s.timespan_id
and      s.interval_id = t.interval_id
and      e.activity_id = a.activity_id
and      start_date between $interval_limitation_clause
and      ci.cal_item_id= e.event_id
and      cals.calendar_id = ci.on_which_calendar
and      e.event_id = ci.cal_item_id
$additional_limitations_clause
$calendars_clause
$order_by_clause
</querytext>
</fullquery>

<fullquery name="select_day_info">      
<querytext>
  select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 
    'Day, DD Month YYYY') as day_of_the_week,
  to_char(to_date(:current_date, 'yyyy-mm-dd') - 
    cast('1 day' as interval), 'yyyy-mm-dd')   as yesterday,
  to_char(to_date(:current_date, 'yyyy-mm-dd') + 
    cast('1 day' as interval), 'yyyy-mm-dd')
  as tomorrow
from     dual
</querytext>
</fullquery>

<partialquery name="month_interval_limitation">      
 <querytext>
    to_timestamp(:first_date_of_month_system,'YYYY-MM-DD HH24:MI:SS')
    and to_timestamp(:last_date_in_month_system, 'YYYY-MM-DD HH24:MI:SS')
</querytext>
</partialquery>



</queryset>
