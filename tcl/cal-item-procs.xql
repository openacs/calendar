<?xml version="1.0"?>
<queryset>

<fullquery name="cal_item_create.get_permissions_to_items">      
      <querytext>
      
	select          grantee_id,
                  	privilege
	from            acs_permissions
	where           object_id = :on_which_calendar
    
      </querytext>
</fullquery>

<fullquery name="cal_item_update.update_activity">
    <querytext>
    update acs_activities 
    set    name = :name,
           description = :description
    where  activity_id
    in     (
           select activity_id
           from   acs_events
           where  event_id = :cal_item_id
           )
    </querytext>
</fullquery>

<fullquery name="cal_item_update.get_interval_id">
    <querytext>
    select interval_id 
    from   timespans
    where  timespan_id
    in     (
           select timespan_id
           from   acs_events
           where  event_id = :cal_item_id
           )
    </querytext>
</fullquery>
 
</queryset>
