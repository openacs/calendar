<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
<fullquery name="select_monthly_items">
      <querytext>
	select   to_char(start_date, 'J') as start_date,
                 to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
                 to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
	         coalesce(e.name, a.name) as name,
	         coalesce(e.description, a.description) as description,
                 coalesce(e.status_summary, a.status_summary) as status_summary,
	         e.event_id as item_id,
		 (select on_which_calendar from cal_items where cal_item_id = e.event_id) as calendar_id,
		 (select calendar_name from calendars 
		 where calendar_id = (select on_which_calendar from cal_items where cal_item_id= e.event_id))
		 as calendar_name
	from     acs_activities a,
	         acs_events e,
	         timespans s,
	         time_intervals t
	where    e.timespan_id = s.timespan_id
	and      s.interval_id = t.interval_id
	and      e.activity_id = a.activity_id
	and      e.event_id
	in       (
	         select  cal_item_id
	         from    cal_items
	         where   on_which_calendar in ([join $calendar_id_list ","])
         )
         order by start_date,end_date	

</querytext>
</fullquery>


 
</queryset>
