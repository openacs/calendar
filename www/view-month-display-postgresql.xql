<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
<fullquery name="select_monthly_items">
      <querytext>
	select   to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
                 to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
	         coalesce(e.name, a.name) as name,
	         coalesce(e.description, a.description) as description,
                 coalesce(e.status_summary, a.status_summary) as status_summary,
	         e.event_id as item_id,
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
        and      start_date between  to_timestamp(:first_date_of_month_system, 'YYYY-MM-DD HH24:MI:SS') 
        and      to_timestamp(:last_date_in_month_system, 'YYYY-MM-DD HH24:MI:SS')
        and      cals.calendar_id = ci.on_which_calendar
	and      e.event_id = ci.cal_item_id
	$calendars_clause
        order by ansi_start_date, ansi_end_date
</querytext>
</fullquery>
 
</queryset>
