<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_party_name">      
      <querytext>
      
                  select   acs_object.name(:party_id)
                  from     dual
               
      </querytext>
</fullquery>

 
<fullquery name="get_viewable_calendar">      
      <querytext>
      
	
	select   unique(object_id) as calendar_id, 
	         calendar.name(object_id) as calendar_name,
                 calendar.show_p(object_id, :party_id) as show_p
	from     acs_object_party_privilege_map 
	where    calendar.readable_p(object_id, :party_id) = 't'
	and      party_id = :party_id
	and      acs_object_util.object_type_p(object_id, 'calendar') = 't'
	and      calendar.private_p(object_id) = 'f'
	
	union

	select   cal_item.on_which_calendar(object_id) as calendar_id, 
	         calendar.name(cal_item.on_which_calendar(object_id)) as calendar_name,
	         calendar.show_p(cal_item.on_which_calendar(object_id), :party_id) as show_p
	from     acs_object_party_privilege_map 
	where    privilege = 'cal_item_read'
	and      party_id = :party_id
	and      acs_object_util.object_type_p(object_id, 'cal_item') = 't'
	and      calendar.private_p(cal_item.on_which_calendar(object_id)) = 'f'

	
    
      </querytext>
</fullquery>

 
</queryset>
