<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_party_name">      
      <querytext>
      
                  select   acs_object__name(:party_id)
                  from     dual
               
      </querytext>
</fullquery>

 
<fullquery name="get_viewable_calendar">      
      <querytext>
      
	
	select   unique(object_id) as calendar_id, 
	         calendar__name(object_id) as calendar_name,
                 calendar__show_p(object_id, :party_id) as show_p
	from     acs_object_party_privilege_map 
	where    calendar__readable_p(object_id, :party_id) = 't'
	and      party_id = :party_id
	and      acs_object_util__object_type_p(object_id, 'calendar') = 't'
	and      calendar__private_p(object_id) = 'f'
	
	union

	select   cal_item__on_which_calendar(object_id) as calendar_id, 
	         calendar__name(cal_item__on_which_calendar(object_id)) as calendar_name,
	         calendar__show_p(cal_item__on_which_calendar(object_id), :party_id) as show_p
	from     acs_object_party_privilege_map 
	where    privilege = 'cal_item_read'
	and      party_id = :party_id
	and      acs_object_util__object_type_p(object_id, 'cal_item') = 't'
	and      calendar__private_p(cal_item__on_which_calendar(object_id)) = 'f'

	
    
      </querytext>
</fullquery>

 
</queryset>
