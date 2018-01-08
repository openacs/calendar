<?xml version="1.0"?>
<queryset>

<partialquery name="openacs_calendar">      
  <querytext>
        and ((cals.package_id = :package_id and cals.private_p = 'f') 
             or (cals.private_p = 't' and cals.owner_id = :user_id))
  </querytext>
</partialquery>

<partialquery name="openacs_in_portal_calendar">      
  <querytext>
    and on_which_calendar in ([join $calendar_id_list ","])
    and (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))
  </querytext>
</partialquery>

<fullquery name="select_items">
  <querytext>
    select   to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
             to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
             to_number(to_char(start_date,'HH24'),'90') as start_hour,
             to_number(to_char(start_date,'MI'),'90') as start_minutes,
             to_number(to_char(start_date,'SSSSS'),'99990') as start_seconds,
             to_number(to_char(end_date,'HH24'),'90') as end_hour,
             to_number(to_char(end_date,'MI'),'90') as end_minutes,
             to_number(to_char(end_date,'SSSSS'),'99990') as end_seconds,
             coalesce(e.name, a.name) as name,
             coalesce(e.status_summary, a.status_summary) as status_summary,
             coalesce(e.description, a.description) as description,
             e.event_id as item_id,
             cit.type as item_type,
             cals.calendar_id,
             cals.calendar_name,
             cals.package_id as cal_package_id,
             (select count(1) from attachments where object_id=e.event_id) as num_attachments
             $additional_select_clause
    from     acs_activities a,
             acs_events e,
             timespans s,
             time_intervals t,
             calendars cals,
             cal_items ci left join
             cal_item_types cit on cit.item_type_id = ci.item_type_id
    where    e.timespan_id = s.timespan_id
    and      s.interval_id = t.interval_id
    and      e.activity_id = a.activity_id
    and      $interval_limitation_clause
    and      ci.cal_item_id= e.event_id
    and      cals.calendar_id = ci.on_which_calendar
    and      e.event_id = ci.cal_item_id
    $additional_limitations_clause
    $calendars_clause
    $order_by_clause
  </querytext>
</fullquery>

<fullquery name="select_all_day_items">
  <querytext>
    select 
         to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
         to_number(to_char(start_date,'HH24'),'90') as start_hour,
         to_number(to_char(end_date,'HH24'),'90') as end_hour,
         to_number(to_char(end_date,'MI'),'90') as end_minutes,
         coalesce(e.name, a.name) as name,
         coalesce(e.status_summary, a.status_summary) as status_summary,
         coalesce(e.description, a.description) as description,
         e.event_id as item_id,
         (select type from cal_item_types where item_type_id= ci.item_type_id) as item_type,
	 cals.calendar_id,
	 cals.calendar_name,
         cals.package_id as cal_package_id,
         (select count(1) from attachments where object_id=e.event_id) as num_attachments
         $additional_select_clause
    from cal_items ci,
         acs_events e,
         timespans s,
         time_intervals t,
         acs_activities a,
         calendars cals
    where    e.timespan_id = s.timespan_id
    and      s.interval_id = t.interval_id
    and      e.activity_id = a.activity_id
    and      $interval_limitation_clause
    and      ci.cal_item_id = e.event_id
    and      cals.calendar_id = ci.on_which_calendar
    and      e.event_id = ci.cal_item_id
    $additional_limitations_clause
    $calendars_clause
    $order_by_clause
  </querytext>
</fullquery>

<fullquery name="select_day_info">
  <querytext>
    select to_char(to_date(:current_date, 'yyyy-mm-dd'), 'Day, DD Month YYYY') as day_of_the_week,
      to_char(to_date(:current_date, 'yyyy-mm-dd') - interval '1' day, 'yyyy-mm-dd') as yesterday,
      to_char(to_date(:current_date, 'yyyy-mm-dd') + interval '1' day, 'yyyy-mm-dd') as tomorrow
      from dual
  </querytext>
</fullquery>

<partialquery name="month_interval_limitation">      
  <querytext>
    start_date between cast(:first_date_of_month_system as timestamp with time zone)
    and cast(:last_date_in_month_system as timestamp with time zone)
  </querytext>
</partialquery>

<partialquery name="day_interval_limitation">      
  <querytext>
    start_date between to_date(:current_date,'YYYY-MM-DD') 
    and to_date(:current_date,'YYYY-MM-DD') + cast('23 hours 59 minutes 59 seconds' as interval)
  </querytext>
</partialquery>

<partialquery name="week_interval_limitation">      
  <querytext>
    start_date between to_date(:first_weekday_of_the_week_tz, 'YYYY-MM-DD HH24:MI:SS')
    and to_date(:last_weekday_of_the_week_tz, 'YYYY-MM-DD HH24:MI:SS')
  </querytext>
</partialquery>

<partialquery name="list_interval_limitation">      
  <querytext>
    start_date between cast(:start_date as timestamp with time zone)
    and cast(:end_date as timestamp with time zone)
  </querytext>
</partialquery>

</queryset>
