<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
<fullquery name="select_weekday_info">
<querytext>
        select   to_char(to_date(:start_date, 'YYYY-MM-DD'), 'D') 
        as       day_of_the_week,
        to_char(next_day(to_date(:start_date, 'YYYY-MM-DD')- '1 week'::interval, 'Sunday'), 'YYYY-MM-DD')
        as       sunday_of_the_week,
        to_char(next_day(to_date(:start_date, 'YYYY-MM-DD'), 'Saturday'), 'YYYY-MM-DD')
        as       saturday_of_the_week
        from     dual
</querytext>
</fullquery>

<fullquery name="select_week_items">
<querytext>
select   to_char(start_date, :ansi_date_format) as ansi_start_date,
         to_char(end_date, :ansi_date_format) as ansi_end_date,
         coalesce(e.name, a.name) as name,
         coalesce(e.status_summary, a.status_summary) as status_summary,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= cal_items.item_type_id) as item_type,
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
         to_date(:sunday_of_the_week_system, :ansi_date_format) and
         to_date(:saturday_of_the_week_system, :ansi_date_format)
and      cals.package_id= :package_id
and      (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))
and      cals.calendar_id = ci.on_which_calendar
and      e.event_id = ci.cal_item_id
order by to_char(start_date, 'J'), to_char(start_date,'HH24:MI')
</querytext>
</fullquery>

<fullquery name="select_week_info">      
<querytext>
select   to_char(to_date(:start_date, 'YYYY-MM-DD'), 'D') 
as day_of_the_week,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') as date)
as sunday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday'),'J') 
as sunday_julian,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('1 day' as interval) as date)
as monday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('1 day' as interval),'J')
as monday_julian,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('2 days' as interval) as date)
as tuesday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('2 days' as interval),'J') 
as tuesday_julian,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('3 days' as interval) as date)
as wednesday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('3 days' as interval),'J') 
as wednesday_julian,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('4 days' as interval) as date)
as thursday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('4 days' as interval),'J') 
as thursday_julian,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('5 days' as interval) as date)
as friday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('5 days' as interval),'J') 
as friday_julian,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('6 days' as interval) as date)
as saturday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), 'Sunday') + cast('6 days' as interval),'J') 
as saturday_julian,
cast(:start_date::timestamptz - cast('7 days' as interval) as date) as last_week,
to_char(:start_date::timestamptz - cast('7 days' as interval), 'Month DD, YYYY') as last_week_pretty,
cast(:start_date::timestamptz + cast('7 days' as interval) as date) as next_week,
to_char(:start_date::timestamptz + cast('7 days' as interval), 'Month DD, YYYY') as next_week_pretty
from     dual
</querytext>
</fullquery>

</queryset>
