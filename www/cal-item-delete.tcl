ad_page_contract {
    Delete a calendar item
    
    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-06-02
} {
    cal_item_id:naturalnum,notnull
    {return_url:localurl "view"}
    {confirm_p:boolean 0}
}

permission::require_permission -object_id $cal_item_id -privilege delete

if {!$confirm_p} {
    ad_returnredirect "cal-item-delete-confirm?cal_item_id=$cal_item_id"
    ad_script_abort
}

calendar::item::delete -cal_item_id $cal_item_id

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
