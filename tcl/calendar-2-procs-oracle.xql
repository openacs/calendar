<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="calendar::calendar_list.select_calendar_list">
    <querytext>
        select calendar_name, 
               calendar_id, 
               acs_permission.permission_p(calendar_id, :user_id, 'calendar_admin') as calendar_admin_p
        from   calendars
        where  (private_p = 'f' and package_id = :package_id $permissions_clause) or
               (private_p = 't' and owner_id = :user_id)
        order  by private_p asc, upper(calendar_name)
    </querytext>
    </fullquery>

    <partialquery name="calendar::calendar_list.permissions_clause">
    <querytext>
            and acs_permission.permission_p(calendar_id, :user_id, :privilege) = 't'
    </querytext>
    </partialquery>

    <fullquery name="calendar::delete.delete_calendar">
    <querytext>
            begin
                calendar.del(:calendar_id);
            end;
    </querytext>
    </fullquery>

</queryset>
