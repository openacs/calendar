<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
    <fullquery name="select_list_items">
      <querytext>
	select to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
         to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as ansi_today,
         coalesce(e.name, a.name) as name,
         coalesce(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         recurrence_id,
         (select type from cal_item_types where item_type_id= ci.item_type_id)
         as item_type,	 
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
and      ci.cal_item_id= e.event_id
and      (start_date > to_date(:start_date,'YYYY-MM-DD HH24:MI') or :start_date is null) and
         (start_date < to_date(:end_date,'YYYY-MM-DD HH24:MI') or :end_date is null)
and      cals.calendar_id = ci.on_which_calendar
$calendars_clause
order by $sort_by

      </querytext>
    </fullquery>

</queryset>

