
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
    {show_cal_nav 1}
}

# Select information about the calendar item
if {![db_0or1row get_item_data { 
    select   to_char(start_date,'HH:MIpm')as start_time,
    start_date as raw_start_date,
    to_char(start_date, 'MM/DD/YYYY') as start_date,
    to_char(end_date, 'HH:MIpm') as end_time,
    nvl(a. name, e.name) as name,
    nvl(e.description, a.description) as description,
    recurrence_id,
    cal_item_types.type as item_type,
    on_which_calendar as calendar_id
    from     acs_activities a,
    acs_events e,
    timespans s,
    time_intervals t,
    cal_items,
    cal_item_types
    where    e.timespan_id = s.timespan_id
    and      s.interval_id = t.interval_id
    and      e.activity_id = a.activity_id
    and      e.event_id = :cal_item_id
    and      cal_items.cal_item_id= :cal_item_id
    and      cal_item_types.item_type_id(+)= cal_items.item_type_id
}]} {
    ad_returnredirect "./"
    return
}

set item_data(start_time) $start_time
set item_data(start_date) $start_date
set item_data(end_time) $end_time
set item_data(name) $name
set item_data(description) $description
set item_data(item_type) $item_type
set item_data(recurrence_id) $recurrence_id

# no time?
set item_data(no_time_p) [dt_no_time_p -start_time $start_time -end_time $end_time]

ad_return_template
