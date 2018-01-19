
ad_page_contract {
    delete all occurrences of a recurring item
    
    @author Ben Adida (ben@openforce.net)
    @creation-date April 25, 2002
} {
    recurrence_id:naturalnum,notnull
    {return_url:localurl "./"}
}

calendar::item::delete_recurrence -recurrence_id $recurrence_id

ad_returnredirect $return_url
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
