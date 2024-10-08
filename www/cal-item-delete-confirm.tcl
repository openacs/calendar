ad_page_contract {
    Confirm deletion of a calendar item.
} {
    cal_item_id:naturalnum,notnull
}

auth::require_login

try {
    calendar::item::get \
        -cal_item_id $cal_item_id \
        -array cal_item
} on error {errmsg} {
    ad_log warning $errmsg
    ad_return_complaint 1 [_ acs-templating.Invalid_item]
    ad_script_abort
}

# no time?
set cal_item(no_time_p) [expr {!$cal_item(time_p)}]

set date $cal_item(start_date)

# Header stuff
template::head::add_css -href "/resources/calendar/calendar.css" -media all
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"


set view_url [export_vars -base "view" {{view day} {date $cal_item(start_date)}}]

if {  $cal_item(recurrence_id) ne "" } {
    set delete_one [export_vars -base "cal-item-delete" {cal_item_id {confirm_p 1}}]
    set delete_all [export_vars -base "cal-item-delete-all-occurrences" {{recurrence_id $cal_item(recurrence_id)}}]
} else {
    set delete_confirm [export_vars -base "cal-item-delete" {cal_item_id {confirm_p 1}}]
    set delete_cancel [export_vars -base "cal-item-view" {cal_item_id}]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
