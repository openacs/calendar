<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="calendar::one_month_display.select_monthly_items">      
      <querytext>
      
	select   to_char(start_date, 'j') as start_date,
                 to_char(start_date, 'HH:MIpm') as start_time,
                 to_char(end_date, 'HH:MIpm') as end_time,
	         nvl(e.name, a.name) as name,
	         nvl(e.description, a.description) as description,
                 nvl(e.status_summary, a.status_summary) as status_summary,
	         e.event_id as item_id
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
	         where   on_which_calendar = :calendar_id
         )
         order by start_date,end_date
	
      </querytext>
</fullquery>


<fullquery name="calendar::one_week_display.select_weekday_info">
<querytext>
        select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 'D') 
        as       day_of_the_week,
        to_char(next_day(to_date(:current_date, 'yyyy-mm-dd')-7, 'SUNDAY')) 
        as       sunday_of_the_week,
        to_char(next_day(to_date(:current_date, 'yyyy-mm-dd'), 'Saturday')) 
        as       saturday_of_the_week
        from     dual
</querytext>
</fullquery>


<fullquery name="calendar::one_week_display.select_week_items">
<querytext>
select   to_char(start_date, 'J') as start_date_julian,
         to_char(start_date, 'HH:MIpm') as pretty_start_date,
         to_char(end_date, 'HH:MIpm') as pretty_end_date,
         to_char(start_date,'HH24:MI') as start_date,
         to_char(end_date,'HH24:MI') as end_date,
         nvl(e.name, a.name) as name,
         nvl(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type
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
         where   on_which_calendar = :calendar_id
         )
order by start_date
</querytext>
</fullquery>

<fullquery name="calendar::one_day_display.select_day_items">
<querytext>
	select   to_char(start_date, 'HH24') as start_hour,
         to_char(start_date, 'HH:MIpm') as pretty_start_date,
         to_char(end_date, 'HH:MIpm') as pretty_end_date,
         to_char(start_date, 'HH24:MI') as start_date,
         to_char(end_date, 'HH24:MI') as end_date,
         nvl(e.name, a.name) as name,
         nvl(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type
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
         to_date(:current_date,:date_format) + (24 - 1/3600)/24
and     cal_items.cal_item_id= e.event_id
and      e.event_id
in       (
         select  cal_item_id
         from    cal_items
         where   on_which_calendar = :calendar_id
         )
	
</querytext>
</fullquery>

<fullquery name="calendar::list_display.select_list_items">
<querytext>
	select   to_char(start_date, 'HH24') as start_hour,
         to_char(start_date, 'HH:MIpm') as pretty_start_date,
         to_char(end_date, 'HH:MIpm') as pretty_end_date,
         nvl(e.name, a.name) as name,
         nvl(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         recurrence_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type
from     acs_activities a,
         acs_events e,
         timespans s,
         time_intervals t,
where    e.timespan_id = s.timespan_id
and      s.interval_id = t.interval_id
and      e.activity_id = a.activity_id
and      start_date between
         to_date(:start_date,:date_format) and
         to_date(:end_date,:date_format)
and      e.event_id
in       (
         select  cal_item_id
         from    cal_items
         where   on_which_calendar = :calendar_id
         )
order by $sort_by	
</querytext>
</fullquery>


<fullquery name="calendar::list_display.select_day_items">
<querytext>
	select   to_char(start_date, 'HH24') as start_hour,
         to_char(start_date, 'HH:MIpm') as pretty_start_date,
         to_char(end_date, 'HH:MIpm') as pretty_end_date,
         nvl(e.name, a.name) as name,
         nvl(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id
from     acs_activities a,
         acs_events e,
         timespans s,
         time_intervals t
where    e.timespan_id = s.timespan_id
and      s.interval_id = t.interval_id
and      e.activity_id = a.activity_id
and      start_date between
         to_date(:current_date,:date_format) and
         to_date(:current_date,:date_format) + (24 - 1/3600)/24
and      e.event_id
in       (
         select  cal_item_id
         from    cal_items
         where   on_which_calendar = :calendar_id
         )
	
</querytext>
</fullquery>
 
</queryset>
