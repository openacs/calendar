<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="select_list_items">
<querytext>
<fullquery name="calendar::list_display.select_list_items">
<querytext>
	select   to_char(start_date, 'HH24') as start_hour,
         to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
         nvl(e.name, a.name) as name,
         nvl(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         recurrence_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type
from     acs_activities a,
         acs_events e,
         timespans s,
         time_intervals t,
         cal_items
where    e.timespan_id = s.timespan_id
and      s.interval_id = t.interval_id
and      e.activity_id = a.activity_id
and      cal_items.cal_item_id= e.event_id
and      (start_date > to_date(:start_date,:date_format) or :start_date is null) and
         (start_date < to_date(:end_date,:date_format) or :end_date is null)
and      e.event_id
in       (
         select  cal_item_id
         from    cal_items
         where   on_which_calendar = :calendar_id
         )
order by $sort_by	
</querytext>
</fullquery>
 
</queryset>
