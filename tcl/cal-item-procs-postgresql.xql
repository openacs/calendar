<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="cal_assign_item_permission.1_grant_calendar_permissions_to_items">      
      <querytext>
	select acs_permission__grant_permission (
					:cal_item_id,
					:party_id,
					'cal_item_read'
	)

      </querytext>
</fullquery>


<fullquery name="cal_assign_item_permission.2_grant_calendar_permissions_to_items">      
      <querytext>
	select acs_permission__grant_permission (
					:cal_item_id,
					:party_id,
					:permission
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_assign_item_permission.3_grant_calendar_permissions_to_items"> 
      <querytext>
	select acs_permission__revoke_permission (
					:cal_item_id,
					:party_id,
					:permission
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_item_create.insert_activity">      
      <querytext>
	select acs_activity__new (
					null,
					:name,
					:description,
					'f',
					null,
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
	select timespan__new (    
					timestamp(:start_date),
					timestamp(:end_date)
	) 

      </querytext>
</fullquery>

 
<fullquery name="cal_item_create.cal_item_add">      
      <querytext>
	select cal_item__new (
					null,
					:on_which_calendar,
					null,
					null,
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

 
<fullquery name="cal_item_create.4_grant_calendar_permissions_to_items">      
      <querytext>
	select acs_permission__grant_permission (
					:cal_item_id,
					:grantee_id,
					:privilege
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_item_update.update_interval">      
      <querytext>
	select time_interval__edit (
					:interval_id,
					timestamp(:start_date),
					timestamp(:end_date)
	)

      </querytext>
</fullquery>

 
<fullquery name="cal_item_delete.delete_cal_item">      
      <querytext>
	select cal_item__delete (
					:cal_item_id
	)

      </querytext>
</fullquery>

<fullquery name="cal_item_delete_recurrence.delete_cal_item_recurrence">      
      <querytext>
	select cal_item__delete_all (
					:recurrence_id
	)

      </querytext>
</fullquery>

<fullquery name="cal_item_edit_recurrence.recurrence_timespan_update">
<querytext>
select
  acs_event__recurrence_timespan_edit (
    :event_id,
    :start_date,
    :end_date
  )
</querytext>
</fullquery>
 
</queryset>
