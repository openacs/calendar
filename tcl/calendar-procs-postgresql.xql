<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="calendar_create.create_new_calendar">      
      <querytext>
      <!--FIX ME PLSQL
FIX ME PLSQL

	begin
	:1 := calendar__new(
	  owner_id      => :owner_id,
	  private_p     => :private_p,
	  calendar_name => :calendar_name,
	  package_id    => :package_id,
	  creation_user => :creation_user,
	  creation_ip   => :creation_ip
	);	
	end;
      -->
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

 
<fullquery name="calendar_assign_permissions.assign_calendar_permissions">      
      <querytext>
      <!--FIX ME PLSQL
FIX ME PLSQL

	    begin
	      acs_permission__grant_permission (
	        object_id       =>      :calendar_id,
	        grantee_id      =>      :party_id,
	        privilege       =>      :cal_privilege
	      );
	    end;
      -->
	    select ac_permission__grant_permission(
			:calendar_id,
			:party_id,
			:cal_privilege
	    );	
      </querytext>
</fullquery>

 
<fullquery name="calendar_assign_permissions.revoke_calendar_permissions">      
      <querytext>
      <!--FIX ME PLSQL
FIX ME PLSQL

	    begin
	      acs_permission__revoke_permission (
	        object_id       =>      :calendar_id,
	        grantee_id      =>      :party_id,
	        privilege       =>      :cal_privilege
	      );
	    end;
      -->
	    select acs_permission_revoke_permission (
			:calendar_id,
			:party_id,
			:cal_privilege
	    );
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

 
</queryset>
