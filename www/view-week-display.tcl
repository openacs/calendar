# Show calendar items per one week.
#
# Parameters:
#
# date (YYYY-MM-DD) - optional

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
    
set current_weekday 1

# this needs to be I18Nized
set weekday_english_names {Sunday Monday Tuesday Wednesday Thursday Friday Saturday}

# Loop through the calendars
multirow create week_items name item_id start_date calendar_name status_summary day_of_week start_date_weekday start_time end_time no_time_p

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
            multirow append week_items "" "" [lc_time_fmt [dt_julian_to_ansi [expr $sunday_julian + $current_weekday -1]] "%x"] "" "" $current_weekday [lindex $weekday_english_names [expr $current_weekday -1]] "" "" ""
        }
    }
    if {[string equal $start_time "00:00"]} {
        set no_time_p t
    } else {
        set no_time_p f
    }

    multirow append week_items $name $item_id $start_date $calendar_name $status_summary $day_of_week $start_date_weekday $start_time $end_time $no_time_p
    set current_weekday $day_of_week
}

if {$current_weekday < 8} {
    # need to add dummy entries to show all hours
    for {  } { $current_weekday < 8 } { incr current_weekday } {
        multirow append week_items "" "" [lc_time_fmt [dt_julian_to_ansi [expr $sunday_julian + $current_weekday -1]] "%x"] "" "" $current_weekday [lindex $weekday_english_names [expr $current_weekday -1]] "" "" ""
    }
}

# Navigation Bar
set dates "[util_AnsiDatetoPrettyDate $sunday_date] - [util_AnsiDatetoPrettyDate $saturday_date]"
set url_previous_week "<a href=\"view?calendar_list=&view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $sunday_julian - 7]]]\">"
set url_next_week "<a href=\"view?calendar_list=&view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $sunday_julian + 7]]]\">"
