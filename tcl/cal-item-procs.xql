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

 
</queryset>
