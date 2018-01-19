ad_page_contract {
    Delete calendar
} {
    calendar_id:naturalnum,notnull
}

# We know we have admin privs here

calendar::delete -calendar_id $calendar_id

ad_returnredirect .
ad_script_abort

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
