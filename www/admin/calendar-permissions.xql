<?xml version="1.0"?>
<queryset>

<fullquery name="get_existing_permissions">      
      <querytext>
      
    select   unique(child_privilege) as privilege 
    from     acs_privilege_hierarchy 
    where    child_privilege like 'calendar%'

      </querytext>
</fullquery>

 
<fullquery name="get_party_privileges">      
      <querytext>
      
	select    privilege 	        
	from      acs_object_party_privilege_map 
	where     object_id = :calendar_id
	and       party_id = :party_id
	and       privilege like '%calendar%'
    
      </querytext>
</fullquery>

 
</queryset>
