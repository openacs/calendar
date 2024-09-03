<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="calendar::create.create_new_calendar">      
  <querytext>
    select calendar__new(
    	null,
    	:calendar_name,
    	'calendar',
    	:owner_id,
    	:private_p,
    	:package_id,
    	null,
    	now(),
    	:creation_user,
    	:creation_ip
    );
  </querytext>
</fullquery>

<fullquery name="calendar::delete.delete_calendar">
  <querytext>
        select calendar__delete(:calendar_id)
  </querytext>
</fullquery>

</queryset>
