<?xml version="1.0"?>
<queryset>

<fullquery name="calendar::outlook::format_item.select_calendar_item">      
<querytext>
select 
to_char(start_date, :date_format) as start_date,
to_char(end_date, :date_format) as end_date,
nvl(e.name,a.name) as name,
nvl(e.description, a.description) as description,
recurrence_id,
item_type_id
from acs_activities a, acs_events e, timespans s, time_intervals t, cal_items
	where    e.timespan_id = s.timespan_id
	and      s.interval_id = t.interval_id
	and      e.activity_id = a.activity_id
	and      e.event_id = :cal_item_id
        and      cal_items.cal_item_id = :cal_item_id
</querytext>
</fullquery>

 
</queryset>
