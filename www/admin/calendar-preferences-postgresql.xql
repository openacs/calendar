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
	select   calendar_id,
	         calendar_name,
	         calendar__show_p(calendar_id, :party_id) as show_p
	from     calendars
	where    acs_permission__permission_p(calendar_id, :party_id, 'calendar_read') = 't'
        and      private_p='f'
     </querytext>
</fullquery>

 
</queryset>
