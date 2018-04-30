<?xml version="1.0"?>
<queryset>

<fullquery name="calendar::item::new.insert_cal_uid">
    <querytext>
        insert into cal_uids 
            (cal_uid, on_which_activity, ical_vars)
        values
            (:cal_uid, :activity_id, :ical_vars)
    </querytext>
</fullquery>

<fullquery name="calendar::item::dates_valid_p.dates_valid_p_select">      
<querytext>          
  select CASE
    WHEN cast(:start_date as timestamp with time zone) <= cast(:end_date as timestamp with time zone) THEN 1
    ELSE 0
  END from dual
</querytext>
</fullquery>

<fullquery name="calendar::item::get.select_item_data">      
<querytext>
      select
         i.cal_item_id,
         0 as n_attachments,
         to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as start_date_ansi,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as end_date_ansi,
         coalesce(e.name, a.name) as name,
         coalesce(e.description, a.description) as description,
         recurrence_id,
         i.item_type_id,
         it.type as item_type,
         on_which_calendar as calendar_id,
         c.calendar_name,
         o.creation_user,
         c.package_id as calendar_package_id,
         e.related_link_url,
         e.related_link_text,
         e.redirect_to_rel_link_p,
	 e.location,
	 e.related_link_url,
	 e.related_link_text,
	 e.redirect_to_rel_link_p
       from
         acs_events e join timespans s
           on (e.timespan_id = s.timespan_id)
         join time_intervals t
           on (s.interval_id = t.interval_id)
         join acs_activities a
           on (e.activity_id = a.activity_id)
         join cal_items i
           on (e.event_id = i.cal_item_id)
         left join cal_item_types it
           on (it.item_type_id = i.item_type_id)
         left join calendars c
           on (c.calendar_id = i.on_which_calendar)
         left join acs_objects o
           on (o.object_id = i.cal_item_id)
       where
         e.event_id = :cal_item_id
</querytext>
</fullquery>

<fullquery name="calendar::item::get.select_item_data_with_attachment">      
<querytext>
       select
         i.cal_item_id,
         (select count(*) from attachments where object_id = cal_item_id) as n_attachments,
         to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as start_date_ansi,
         to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as end_date_ansi,
         coalesce(e.name, a.name) as name,
         coalesce(e.description, a.description) as description,
         recurrence_id,
         i.item_type_id,
         it.type as item_type,
         on_which_calendar as calendar_id,
         c.calendar_name,
         o.creation_user,
         c.package_id as calendar_package_id,
         e.related_link_url,
         e.related_link_text,
         e.redirect_to_rel_link_p,
 	 e.location,
	 e.related_link_url,
	 e.related_link_text,
	 e.redirect_to_rel_link_p
       from
         acs_events e join timespans s
           on (e.timespan_id = s.timespan_id)
         join time_intervals t
           on (s.interval_id = t.interval_id)
         join acs_activities a
           on (e.activity_id = a.activity_id)
         join cal_items i
           on (e.event_id = i.cal_item_id)
         left join cal_item_types it
           on (it.item_type_id = i.item_type_id)
         left join calendars c
           on (c.calendar_id = i.on_which_calendar)
         left join acs_objects o
           on (o.object_id = i.cal_item_id)
       where
         e.event_id = :cal_item_id
</querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.recurrence_events_update">
    <querytext>
    update acs_events set
    [join $colspecs ", "]
    where recurrence_id= :recurrence_id
    and event_id in
            (select e.event_id
            from acs_events e, timespans t, time_intervals i
            where e.recurrence_id = :recurrence_id
            and t.timespan_id = e.timespan_id
            and i.interval_id = t.interval_id
            and (:edit_past_events_p = 't'
                 or i.start_date >= :start_date)
            )
    </querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.recurrence_items_update">
    <querytext>
            update cal_items
            set    [join $colspecs ", "]
            where  cal_item_id in (select e.event_id
            from acs_events e, timespans t, time_intervals i
            where e.recurrence_id = :recurrence_id
            and t.timespan_id = e.timespan_id
            and i.interval_id = t.interval_id
            and (:edit_past_events_p = 't'
                 or i.start_date >= :start_date)
            )
    </querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.update_context_id">
    <querytext>
        update acs_objects
        set    context_id = :calendar_id
        where  object_id in
            (select e.event_id
            from acs_events e, timespans t, time_intervals i
            where e.recurrence_id = :recurrence_id
            and t.timespan_id = e.timespan_id
            and i.interval_id = t.interval_id
            and (:edit_past_events_p = 't'
                 or i.start_date >= :start_date)
            )
    </querytext>
</fullquery>

<fullquery name="calendar::item::add_recurrence.update_event">
<querytext>
update acs_events 
set recurrence_id= :recurrence_id
where event_id= :cal_item_id
</querytext>
</fullquery>

<fullquery name="calendar::item::add_recurrence.insert_cal_items">
<querytext>
insert into cal_items 
(cal_item_id, on_which_calendar, item_type_id)
select
event_id, 
(select on_which_calendar 
as calendar_id from cal_items 
where cal_item_id = :cal_item_id),
(select item_type_id 
as item_type from cal_items 
where cal_item_id = :cal_item_id)
from acs_events where recurrence_id= :recurrence_id 
and event_id <> :cal_item_id
</querytext>
</fullquery>

<fullquery name="calendar::item::edit.select_recurrence_id">
<querytext>
select recurrence_id from acs_events where event_id= :cal_item_id
</querytext>
</fullquery>

<fullquery name="calendar::item::edit.update_activity">
    <querytext>
    update acs_activities 
    set    name = :name,
           description = :description
    where  activity_id
    in     (
           select activity_id
           from   acs_events
           where  event_id = :cal_item_id
           )
    </querytext>
</fullquery>

<fullquery name="calendar::item::edit.update_event">
    <querytext>
    update acs_events
    set    name = :name,
           description = :description,
           location = :location,
	   related_link_url = :related_link_url,
	   related_link_text = :related_link_text,
	   redirect_to_rel_link_p = :redirect_to_rel_link_p
    where  event_id = :cal_item_id
    </querytext>
</fullquery>

<fullquery name="calendar::item::edit.get_interval_id">
    <querytext>
    select interval_id 
    from   timespans
    where  timespan_id
    in     (
           select timespan_id
           from   acs_events
           where  event_id = :cal_item_id
           )
    </querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.select_recurrence_id">
<querytext>
select recurrence_id from acs_events where event_id= :event_id
</querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.recurrence_activities_update">
    <querytext>
    update acs_activities 
    set    name = :name,
           description = :description
    where  activity_id
    in     (
           select activity_id
           from   acs_events
           where  recurrence_id = :recurrence_id
           )
    </querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.recurrence_events_update">
    <querytext>
    update acs_events set
    name= :name, description= :description
    where recurrence_id= :recurrence_id
    </querytext>
</fullquery>


<fullquery name="calendar::item::edit_recurrence.recurrence_items_update">
    <querytext>
            update cal_items
            set    [join $colspecs ", "]
            where  cal_item_id in (select event_id from acs_events where recurrence_id = :recurrence_id)
    </querytext>
</fullquery>
  
</queryset>
