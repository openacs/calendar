<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="calendar::item::add_recurrence.create_recurrence">
<querytext>
select recurrence__new(:interval_type,
    	:every_n,
    	:days_of_week,
    	:recur_until,
	NULL)
</querytext>
</fullquery>

<fullquery name="calendar::item::add_recurrence.insert_instances">
<querytext>
select acs_event__insert_instances(:cal_item_id, NULL);
</querytext>
</fullquery>

<fullquery name="calendar::item::new.insert_activity">      
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


<fullquery name="calendar::item::new.insert_timespan">      
      <querytext>
	select timespan__new (    
					:start_date::timestamptz,
					:end_date::timestamptz
	) 

      </querytext>
</fullquery>

 
<fullquery name="calendar::item::new.cal_item_add">      
      <querytext>
	select cal_item__new (
					null,
					:calendar_id,
					:name,
					null,
                                        null,
                                        null,
					:timespan_id,
					:activity_id,
					null, 
					'cal_item',
					:calendar_id,
					now(),
					:creation_user,
					:creation_ip,
					:package_id,					
					:location,
					:related_link_url,
					:related_link_text,
					:redirect_to_rel_link_p
	)

     </querytext>
</fullquery>

 
<fullquery name="calendar::item::delete.delete_cal_item">      
      <querytext>
	select cal_item__delete (
					:cal_item_id
	)

      </querytext>
</fullquery>

<fullquery name="calendar::item::edit.update_interval">      
      <querytext>
	select time_interval__edit (
					:interval_id,
					:start_date::timestamptz,
					:end_date::timestamptz
	)

      </querytext>
</fullquery>

 
<fullquery name="calendar::item::delete_recurrence.delete_cal_item_recurrence">      
      <querytext>
	select cal_item__delete_all (
					:recurrence_id
	)

      </querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.recurrence_timespan_update">
<querytext>
select
  acs_event__recurrence_timespan_edit (
    :event_id,
    :start_date,
    :end_date
  )
</querytext>
</fullquery>

<fullquery name="calendar::item::edit.cal_uid_upsert">      
  <querytext>
    select cal_uid__upsert(:cal_uid, :activity_id, :ical_vars) from dual
  </querytext>
</fullquery> 


</queryset>
