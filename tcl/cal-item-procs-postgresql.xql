<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="cal_assign_item_permission.grant_calendar_permissions_to_items_1">      
      <querytext>

    <!--FIX ME PLSQL
	FIX ME PLSQL

		begin
		  acs_permission.grant_permission (
			object_id       =>      :cal_item_id,
			grantee_id      =>      :party_id,
			privilege       =>      'cal_item_read'
		  );
		end;
	-->   

	select acs_permission__grant_permission (
					:cal_item_id,
					:party_id,
					'cal_item_read'
	)

      </querytext>
</fullquery>


<fullquery name="cal_assign_item_permission.grant_calendar_permissions_to_items_2">      
      <querytext>

   <!--  FIX ME PLSQL
	FIX ME PLSQL

		begin
		  acs_permission__grant_permission (
			object_id       =>      :cal_item_id,
			grantee_id      =>      :party_id,
			privilege       =>      :permission
		  );
		end;
-->
	
	select acs_permission__grant_permission (
					:cal_item_id,
					:party_id,
					:permission
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_assign_item_permission.grant_calendar_permissions_to_items_3"> 
      <querytext>

     <! --FIX ME PLSQL
	FIX ME PLSQL

	    begin
	      acs_permission.revoke_permission (
			object_id       =>      :cal_item_id,
			grantee_id      =>      :party_id,
			privilege       =>      :permission
	    );
	    end;
-->

	select acs_permission__revokke_permission (
					:cal_item_id,
					:party_id,
					:permission
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_item_create.insert_activity">      
      <querytext>

<!--      FIX ME PLSQL
	FIX ME PLSQL
	begin
	  :1 := acs_activity.new (
		name          => :name,
		description   => :description,
		creation_user => :creation_user,
		creation_ip   => :creation_ip
	  );
	end;
-->

	select acs_activity__new (
					null,
					:name,
					:description,
					'f',
					'acs_activity', 
					now(),
					:creation_user,
					:creation_ip,
					null
	)

      </querytext>
</fullquery>


<fullquery name="cal_item_create.insert_timespan">      
      <querytext>

<!--      FIX ME PLSQL
	FIX ME PLSQL

	begin
	  :1 := timespan.new (  
		start_date => to_date(:start_date,:date_format),
		end_date   => to_date(:end_date,:date_format)
	  );
	end;
-->
  
	select timespan__new (    

				<!--NOT PROPERLY DONE
		THESE ARE THE ONLY ARGS NEEDED DUNNO THE FORMAT THOU-->

					:to_date(:start_date,:date_format),
					:to_date(:end_date,:date_format)
	) 

      </querytext>
</fullquery>

 
<fullquery name="cal_item_create.cal_item_add">      
      <querytext>

<!--      FIX ME PLSQL
	FIX ME PLSQL

	begin
	  :1 := cal_item__new(
  		on_which_calendar  => :on_which_calendar,
		activity_id        => :activity_id,
		timespan_id        => :timespan_id,
		creation_user      => :creation_user,
		creation_ip        => :creation_ip
	  );
	end;
-->
    
	select cal_item__new (
					null,
					:on_which_calendar,
					null,
					null,
					:timespan_id,
					:activity_id,
					null,
					'cal_item',
					null,
					now(),
					:creation_user,
					:creation_ip
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_item_create.grant_calendar_permissions_to_items_4">      
      <querytext>

<!--      FIX ME PLSQL
	FIX ME PLSQL
	    begin
  	      acs_permission.grant_permission (
                object_id       =>      :cal_item_id,
                grantee_id      =>      :grantee_id,
                privilege       =>      :privilege
              );
	    end;
-->

	select acs_permission__grant_permission (
					:cal_item_id,
					:grantee_id,
					:privilege
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_item_update.update_interval">      
      <querytext>

<!--      FIX ME PLSQL
	FIX ME PLSQL
	begin
	  time_interval.edit (
	    interval_id  => :interval_id,
	    start_date   => to_date(:start_date,:date_format),
	    end_date     => to_date(:end_date,:date_format)
	  );
	end;
-->
    
	select time_interval__edit (
					:interval_id,
					to_date(:start_date,:date_format),
					to_date(:end_date,:date_format)
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_item_delete.delete_cal_item">      
      <querytext>

<!--      FIX ME PLSQL
	FIX ME PLSQL

	begin
	  cal_item.delete (
	    cal_item_id  => :cal_item_id
	  );
	end;
-->
 
<!-- THIS IS DONE AND CHECK CORRECTLY  -->

	select cal_item__delete (
					:cal_item_id
	)

      </querytext>
</fullquery>

 
</queryset>
