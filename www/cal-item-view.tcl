# /packages/calendar/www/index.tcl

ad_page_contract {
    View one event
    
    @author Ben Adida (ben@openforce)
    @creation-date April 09, 2002
    @cvs-id $Id$
} {
    cal_item_id
    {return_url ""}
    {show_cal_nav 1}
}

# find out the user_id 
set user_id [ad_verify_and_get_user_id]

set package_id [ad_conn package_id]

# write permission
set edit_p [ad_permission_p $cal_item_id cal_item_write]

# delete permission
set delete_p [ad_permission_p $cal_item_id cal_item_delete] 

# admin permission
set admin_p [ad_permission_p $cal_item_id calendar_admin]

calendar::item::get -cal_item_id $cal_item_id -array cal_item

# no time?
set cal_item(no_time_p) [dt_no_time_p -start_time $cal_item(start_time) -end_time $cal_item(end_time)]

# cal nav
set cal_nav [dt_widget_calendar_navigation "view" day $cal_item(start_date) "calendar_id="]

ad_return_template 

