# Show calendar items per one week.
#
# Parameters:
#
# date (YYYY-MM-DD) - optional


# calendar-portlet uses this stuff
if { ![info exists url_stub_callback] } {
    set url_stub_callback ""
}

if { ![info exists day_template] } {
    set day_template "<a href=?date=\$date>\$day &nbsp; - &nbsp; \$pretty_date</a>"
}

if { ![info exists item_template] } {
    set item_template "<a href=cal-item-view?cal_item_id=\$item_id>\$item</a>"
}
# calendar-portlet


if {[empty_string_p $date]} {
    # Default to todays date in the users (the connection) timezone
    set server_now_time [dt_systime]
    set user_now_time [lc_time_system_to_conn $server_now_time]
    set date [lc_time_fmt $user_now_time "%x"]
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set ansi_date_format "YYYY-MM-DD HH24:MI:SS"

set start_date $date

# If we were given no calendars, we assume we display the 
# private calendar. It makes no sense for this to be called with
# no data whatsoever.
if {[empty_string_p $calendar_id_list]} {
    set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
}

# Convert date from user timezone to system timezone
#set system_start_date [lc_time_conn_to_system "$date 00:00:00"]

db_1row select_weekday_info {}
db_1row select_week_info {}
    
set current_weekday 0

# Loop through the calendars
multirow create week_items name item_id start_date calendar_name status_summary day_of_week start_date_weekday start_time end_time no_time_p full_item

# Convert date from user timezone to system timezone
set sunday_of_the_week_system [lc_time_conn_to_system "$sunday_of_the_week 00:00:00"]
set saturday_of_the_week_system [lc_time_conn_to_system "$saturday_of_the_week 00:00:00"]

db_foreach select_week_items {} {
    # Convert from system timezone to user timezone
    set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
    set ansi_end_date [lc_time_system_to_conn $ansi_end_date]

    set day_of_week [lc_time_fmt $ansi_start_date "%f"]
    set start_date_weekday [lc_time_fmt $ansi_start_date "%A"]

    set start_date [lc_time_fmt $ansi_start_date "%x"]
    set end_date [lc_time_fmt $ansi_end_date "%x"]

    set start_time [lc_time_fmt $ansi_start_date "%X"]
    set end_time [lc_time_fmt $ansi_end_date "%X"]

    if {$day_of_week > $current_weekday} {
        # need to add dummy entries to show all days
        for {  } { $current_weekday < $day_of_week } { incr current_weekday } {
	    set ansi_this_date [dt_julian_to_ansi [expr $sunday_julian + $current_weekday]]
            multirow append week_items "" "" [lc_time_fmt $ansi_this_date "%x"] "" "" $current_weekday [lc_time_fmt $ansi_this_date %A] "" "" "" ""
        }
    }

    if {[string equal $start_time "12:00 AM"] && [string equal $end_time "12:00 AM"]} {
        set no_time_p t
    } else {
        set no_time_p f
    }

    # In case we need to dispatch to a different URL (ben)
    if {![empty_string_p $url_stub_callback]} {
        # Cache the stuff
        if {![info exists url_stubs($calendar_id)]} {
            set url_stubs($calendar_id) [$url_stub_callback $calendar_id]
        }
        
        set url_stub $url_stubs($calendar_id)
    }
    
    set item "$name"
    set full_item "[subst $item_template]"

    multirow append week_items $name $item_id $start_date $calendar_name $status_summary $day_of_week $start_date_weekday $start_time $end_time $no_time_p $full_item
    set current_weekday $day_of_week
}

if {$current_weekday < 7} {
    # need to add dummy entries to show all hours
    for {  } { $current_weekday < 7 } { incr current_weekday } {
	set ansi_this_date [dt_julian_to_ansi [expr $sunday_julian + $current_weekday]]
	multirow append week_items "" "" [lc_time_fmt $ansi_this_date "%x"] "" "" $current_weekday [lc_time_fmt $ansi_this_date %A] "" "" "" ""
    }
}

# Navigation Bar
set dates "[util_AnsiDatetoPrettyDate $sunday_date] - [util_AnsiDatetoPrettyDate $saturday_date]"
set url_previous_week "<a href=\"view?calendar_list=&view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $sunday_julian - 7]]]\">"
set url_next_week "<a href=\"view?calendar_list=&view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $sunday_julian + 7]]]\">"
