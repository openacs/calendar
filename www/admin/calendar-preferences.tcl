# /packages/calendar/www/admin/calendar-selection.tcl

ad_page_contract {
    
    support page for the selection of calendars

    user can select a list of calendars
        
    @action which action to perform        
    @calendar_list  a list that keep track of the call the calendar

    @author Gary Jin (gjin@arsdigita.com)
    @creation-date Dec 14, 2000
    @cvs-id $Id$
} {

    {action "view"}
    {calendar_old_list:multiple,optional {}}
    {calendar_hide_list:multiple,optional {}}

} -properties {

    party_id:onevalue
    party_name:onevalue
    calendar_name:onevalue
    action:onevalue

    privileges:multirow
    calendars:multirow
    parties:multirow

} 


# get user_id and check permission of the user
set party_id [ad_verify_and_get_user_id]    

# get party name
set party_name [db_string get_party_name {
                  select   acs_object.name(:party_id)
                  from     dual
               } -default ""]



# ----------------------------------------------
# view, greant, or revoke

if { [string equal $action "view"] } {
    db_multirow calendars get_viewable_calendar { }    
} elseif { [string equal $action "edit"] } {
    foreach old_items $calendar_old_list {
	if { [string equal [lsearch -exact $calendar_hide_list [lindex $old_items 0]] "-1"] } {
	    # revoke permission	    
	    calendar_assign_permissions [lindex $old_items 0] $party_id "calendar_read" 
	} else {
	   calendar_assign_permissions [lindex $old_items 0] $party_id "calendar_read" "revoke"
	}
    }

    set action view
    ad_returnredirect "calendar-preferences?[export_url_vars action]"
    ad_script_abort
} 

ad_return_template














