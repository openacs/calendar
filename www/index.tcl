# /packages/calendar/www/index.tcl

ad_page_contract {
    
    Main Calendar Page
    totally redone by Ben
    
    @author Ben Adida (ben@openforce)
    @creation-date June 2, 2002
    @cvs-id $Id$
} {
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

# If there are no calendars at all, we should create a personal one
set calendar_list [calendar::adjust_calendar_list -calendar_list {} -package_id $package_id -user_id $user_id]

# If no calendars, we need at least a personal one!
if {[llength $calendar_list] == 0} {
    # Create a personal calendar for the user
    calendar::new -owner_id $user_id -private_p "t" -calendar_name "Personal" -package_id $package_id
}

ad_returnredirect "view"    
