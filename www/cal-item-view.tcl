ad_page_contract {
    View one event
    
    @author Ben Adida (ben@openforce.net)
    @creation-date April 09, 2002
    @cvs-id $Id$
} {
    cal_item_id:integer
    {return_url ""}
}

set user_id [ad_verify_and_get_user_id]
set package_id [ad_conn package_id]

#ad_require_permission $cal_item_id read

set edit_p [ad_permission_p $cal_item_id cal_item_write]
set delete_p [ad_permission_p $cal_item_id cal_item_delete] 
set admin_p [ad_permission_p $cal_item_id calendar_admin]

calendar::item::get -cal_item_id $cal_item_id -array cal_item

# Attachments?
if {$cal_item(n_attachments) > 0} {
    set item_attachments [attachments::get_attachments -object_id $cal_item(cal_item_id)]
} else {
    set item_attachments [list]
}

# no time?
set cal_item(no_time_p) [dt_no_time_p -start_time $cal_item(start_time) -end_time $cal_item(end_time)]

# Attachment URLs
if {[calendar::attachments_enabled_p]} {
    set attachment_options " | <A href=\"[attachments::add_attachment_url -object_id $cal_item(cal_item_id) -return_url "../cal-item-view?cal_item_id=$cal_item(cal_item_id)"]\">add attachment</a>"
} else { 
    set attachment_options {} 
}

set date $cal_item(start_date)

ad_return_template 

