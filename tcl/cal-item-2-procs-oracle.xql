<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="calendar::item::get.select_item_data">      
<querytext>
            
            select   
            cal_items.cal_item_id,
            to_char(start_date,'HH:MIpm')as start_time,
            start_date as start_date,
            to_char(start_date, 'MM/DD/YYYY') as pretty_short_start_date,
            to_char(end_date, 'HH:MIpm') as end_time,
            nvl(e.name, a.name) as name,
            nvl(e.description, a.description) as description,
            recurrence_id,
            cal_items.item_type_id,
            cal_item_types.type as item_type,
            on_which_calendar as calendar_id
            from     acs_activities a,
            acs_events e,
            timespans s,
            time_intervals t,
            cal_items,
            cal_item_types
            where    e.timespan_id = s.timespan_id
            and      s.interval_id = t.interval_id
            and      e.activity_id = a.activity_id
            and      e.event_id = :cal_item_id
            and      cal_items.cal_item_id= :cal_item_id
            and      cal_item_types.item_type_id(+)= cal_items.item_type_id
</querytext>
</fullquery>

</queryset>
