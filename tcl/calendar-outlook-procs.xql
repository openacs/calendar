<?xml version="1.0"?>
<queryset>

<fullquery name="calendar::outlook::format_item.select_recurrence">      
<querytext>
select 
recurrence_id, recurrences.interval_type, interval_name,
every_nth_interval, days_of_week, recur_until
from recurrences, recurrence_interval_types
where recurrence_id= :recurrence_id
and recurrences.interval_type = recurrence_interval_types.interval_type
</querytext>
</fullquery>

 
</queryset>
