<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
	
<fullquery name="select_weekday_info">
<querytext>
        select   to_char(to_date(:start_date, 'YYYY-MM-DD'), 'D') 
        as       day_of_the_week,
        to_char(next_day(to_date(:start_date, 'YYYY-MM-DD')- '1 week'::interval, :first_us_weekday), 'YYYY-MM-DD')
        as       first_weekday_of_the_week,
        to_char(next_day(to_date(:start_date, 'YYYY-MM-DD'), :last_us_weekday), 'YYYY-MM-DD')
        as       last_weekday_of_the_week
        from     dual
</querytext>
</fullquery>


<fullquery name="select_week_items">
<querytext>
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


</querytext>
</fullquery>

<fullquery name="select_week_info">      
<querytext>
select   to_char(to_date(:start_date, 'YYYY-MM-DD'), 'D') 
as day_of_the_week,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), :first_us_weekday) as date)
as first_weekday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), :first_us_weekday),'J')
as first_weekday_julian,
cast(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), :first_us_weekday) + cast('6 days' as interval) as date)
as last_weekday_date,
to_char(next_day(to_date(:start_date, 'YYYY-MM-DD') - cast('7 days' as interval), :first_us_weekday) + cast('6 days' as interval),'J') 
as last_weekday_julian,
cast(:start_date::timestamptz - cast('7 days' as interval) as date) as last_week,
to_char(:start_date::timestamptz - cast('7 days' as interval), 'Month DD, YYYY') as last_week_pretty,
cast(:start_date::timestamptz + cast('7 days' as interval) as date) as next_week,
to_char(:start_date::timestamptz + cast('7 days' as interval), 'Month DD, YYYY') as next_week_pretty
from     dual
</querytext>
</fullquery>

</queryset>
