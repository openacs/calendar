<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="select_weekday_info">
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

<fullquery name="select_week_items">
<querytext>
select   to_char(start_date, 'J') as start_date_julian,
         to_char(start_date,'HH24:MI') as start_date,
         to_char(end_date,'HH24:MI') as end_date,
         to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
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
and      e.event_id = cal_items.cal_item_id       
and      start_date >= to_date(:first_day_of_week_julian, 'J') 
and      start_date <= to_date(:first_day_of_week_julian + 7, 'J')
and      e.event_id
in       (
         select  cal_item_id
         from    cal_items
         where   on_which_calendar in ([join $calendar_id_list ","])
         )
order by start_date
</querytext>
</fullquery>

<fullquery name="select_week_info">      
<querytext>
select   to_char(to_date(:start_date, 'yyyy-mm-dd'), 'D') 
as day_of_the_week,
cast(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') as date)
as sunday_date,
to_char(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday'),'J') 
as sunday_julian,
cast(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('1 day' as interval) as date)
as monday_date,
to_char(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('1 day' as interval),'J')
as monday_julian,
cast(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('2 days' as interval) as date)
as tuesday_date,
to_char(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('2 days' as interval),'J') 
as tuesday_julian,
cast(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('3 days' as interval) as date)
as wednesday_date,
to_char(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('3 days' as interval),'J') 
as wednesday_julian,
cast(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('4 days' as interval) as date)
as thursday_date,
to_char(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('4 days' as interval),'J') 
as thursday_julian,
cast(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('5 days' as interval) as date)
as friday_date,
to_char(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('5 days' as interval),'J') 
as friday_julian,
cast(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('6 days' as interval) as date)
as saturday_date,
to_char(next_day(to_date(:start_date, 'yyyy-mm-dd') - cast('7 days' as interval), 'Sunday') + cast('6 days' as interval),'J') 
as saturday_julian,
cast(:start_date::timestamptz - cast('7 days' as interval) as date) as last_week,
to_char(:start_date::timestamptz - cast('7 days' as interval), 'Month DD, YYYY') as last_week_pretty,
cast(:start_date::timestamptz + cast('7 days' as interval) as date) as next_week,
to_char(:start_date::timestamptz + cast('7 days' as interval), 'Month DD, YYYY') as next_week_pretty
from     dual
</querytext>
</fullquery>

<fullquery name="select_day_info">      
<querytext>
select   to_char(to_date(:start_date, 'yyyy-mm-dd'), 'Day, DD Month YYYY') 
as day_of_the_week,
to_char(to_date(:start_date, 'yyyy-mm-dd') - cast('1 day' as interval), 'yyyy-mm-dd')
as yesterday,
to_char(to_date(:start_date, 'yyyy-mm-dd') + cast('1 day' as interval), 'yyyy-mm-dd')
as tomorrow
from     dual
</querytext>
</fullquery>

 

</queryset>

