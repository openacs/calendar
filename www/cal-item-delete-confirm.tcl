#
# A script that assumes
#
# cal_item_id
#
# This will pull out information about the event and 
# display it with some options.
#

ad_page_contract {
    Confirm Deletion
} {
    cal_item_id
}

auth::require_login

calendar::item::get -cal_item_id $cal_item_id -array cal_item

# no time?
set cal_item(no_time_p) [dt_no_time_p -start_time $cal_item(start_time) -end_time $cal_item(end_time)]

set date $cal_item(start_date)

# To be replaced by a call to template::head API
if {![template::multirow exists link]} {
    template::multirow create link rel type href title lang media
}
template::multirow append link \
    stylesheet \
    "text/css" \
    "/resources/calendar/calendar.css" \
    "" \
    en \
    "all"

ad_return_template
