<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="calendar_create.create_new_calendar">      
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

 
<fullquery name="calendar_assign_permissions.get_magic_id">      
      <querytext>
      
	    select  acs__magic_object_id('the_public')
	            as party_id
	    from    dual
	
      </querytext>
</fullquery>

 
 
<fullquery name="calendar_create_private.get_user_name">      
      <querytext>
      
	select   acs_object__name(:private_id) 
	from     dual
    
      </querytext>
</fullquery>

 
<fullquery name="calendar_get_name.get_calendar_name">      
      <querytext>
      
	       select  calendar__name(:calendar_id)
	       from    dual
    
      </querytext>
</fullquery>

 
<fullquery name="calendar_public_p.check_calendar_permission">      
      <querytext>
      
              select   acs_permission__permission_p(
                         :calendar_id, 
                         acs__magic_object_id('the_public'),
                         'calendar_read'
                       ) 
              from     dual

            
      </querytext>
</fullquery>

 
    <fullquery name="calendar::calendar_list.select_calendar_list">
    <querytext>
        select calendar_name, 
               calendar_id, 
               acs_permission__permission_p(calendar_id, :user_id, 'calendar_admin') as calendar_admin_p
        from   calendars
        where  (private_p = 'f' and package_id = :package_id $permissions_clause) or 
               (private_p = 't' and owner_id = :user_id)
        order  by private_p asc, upper(calendar_name)
    </querytext>
    </fullquery>

    <partialquery name="calendar::calendar_list.permissions_clause">
    <querytext>
            and acs_permission__permission_p(calendar_id, :user_id, :privilege) = 't'
    </querytext>
    </partialquery>

    <fullquery name="calendar::delete.delete_calendar">
    <querytext>
            select calendar__delete(:calendar_id)
    </querytext>
    </fullquery>

</queryset>
