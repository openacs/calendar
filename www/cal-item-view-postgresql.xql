<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_item_data">      
      <querytext>
       
	select   to_char(start_date, 'HH24:MI') as start_time,
                 start_date as raw_start_date,
		 to_char(start_date, 'MM/DD/YYYY') as start_date,
	         to_char(end_date, 'HH:MIpm') as end_time,
	         coalesce(a. name, e.name) as name,
	         coalesce(e.description, a.description) as description,
                 recurrence_id,
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
        and      cal_item_types.item_type_id= cal_items.item_type_id
    
      </querytext>
</fullquery>
 
<fullquery name="select_item_data">      
  <querytext>
   select
     i.cal_item_id,
     0 as n_attachments,
     to_char(start_date, 'YYYY-MM-DD HH:MI:SS') as start_date,
     end_date as end_date,
     to_char(start_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_start_date,
     to_char(end_date, 'YYYY-MM-DD HH24:MI:SS') as ansi_end_date,
     coalesce(e.name, a.name) as name,
     coalesce(e.description, a.description) as description,
     recurrence_id,
     i.item_type_id,
     it.type as item_type,
     on_which_calendar as calendar_id
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
   where
     e.event_id = :cal_item_id
  </querytext>
</fullquery>

</queryset>
