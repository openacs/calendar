<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>
	
<fullquery name="select_monthly_items">
      <querytext>
	select   to_char(start_date, :ansi_date_format) as ansi_start_date,
                 to_char(end_date, :ansi_date_format) as ansi_end_date,
	         nvl(e.name, a.name) as name,
	         nvl(e.description, a.description) as description,
                 nvl(e.status_summary, a.status_summary) as status_summary,
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
        and      start_date between  to_date(:first_date_of_month_system, :ansi_date_format) 
        and      to_date(:last_date_in_month_system, :ansi_date_format)
        and      cals.package_id= :package_id
        and      (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))
        and      cals.calendar_id = ci.on_which_calendar
	and      e.event_id = ci.cal_item_id
        order by ansi_start_date
      </querytext>
</fullquery> 
</queryset>
