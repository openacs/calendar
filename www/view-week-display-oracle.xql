<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="select_weekday_info">
<querytext>
        select   to_char(to_date(:start_date, 'yyyy-mm-dd'), 'D') 
        as       day_of_the_week,
        to_char(next_day(to_date(:start_date, 'yyyy-mm-dd')-7, :first_us_weekday)) 
        as       first_weekday_of_the_week,
        to_char(next_day(to_date(:start_date, 'yyyy-mm-dd'), :last_us_weekday)) 
        as       last_weekday_of_the_week
        from dual
</querytext>
</fullquery>

<fullquery name="select_week_items">
<querytext>
select   to_char(start_date, :ansi_date_format) as ansi_start_date,
         to_char(end_date, :ansi_date_format) as ansi_end_date,
         trunc(start_date - to_date(:first_weekday_of_the_week_tz,
         :ansi_date_format)) as day_of_week,
         nvl(e.name, a.name) as name,
         nvl(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= ci.item_type_id) as item_type,
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
and      start_date between
         to_date(:first_weekday_of_the_week_tz, :ansi_date_format) and
         to_date(:last_weekday_of_the_week_tz, :ansi_date_format)
and      cals.calendar_id = ci.on_which_calendar
and      e.event_id = ci.cal_item_id
$calendars_clause
order by to_char(start_date, 'J'), to_char(start_date,'HH24:MI')
</querytext>
</fullquery>

<fullquery name="select_week_info">
<querytext>
select  to_char(to_date(:start_date, 'YYYY-MM-DD'), 'D') as day_of_the_week, 
next_day(to_date(:start_date, 'YYYY-MM-DD') - 7, :first_us_weekday) as first_weekday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - 7, :first_us_weekday),'J') as first_weekday_julian,
next_day(to_date(:start_date, 'YYYY-MM-DD') - 7, :first_us_weekday) + 6 as last_weekday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - 7, :first_us_weekday) + 6,'J') as last_weekday_julian,
to_char(to_date(:start_date) - 7, 'YYYY-MM-DD') as last_week,
to_char(to_date(:start_date) - 7, 'Month DD, YYYY') as last_week_pretty,
to_char(to_date(:start_date) + 7, 'YYYY-MM-DD') as next_week,
to_char(to_date(:start_date) + 7, 'Month DD, YYYY') as next_week_pretty
from dual
</querytext>
</fullquery>

</queryset>
