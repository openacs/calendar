if { ![info exists url_stub_callback] } {
    set url_stub_callback ""
}

if { ![info exists day_template] } {
    set day_template "<a href=?date=\$date>\$day &nbsp; - &nbsp; \$pretty_date</a>"
}

if { ![info exists item_template] } {
    set item_template "<a href=cal-item-view?cal_item_id=\$item_id>\[ad_quotehtml \$item\]</a>"
}

if {[exists_and_not_null page_num]} {
    set page_num_formvar [export_form_vars page_num]
    set page_num "&page_num=$page_num"
} else {
    set page_num_formvar ""
    set page_num ""
}

if {![exists_and_not_null base_url]} {
    set base_url ""
}

if { ![info exists url_stub_callback] } {
    set url_stub_callback ""
}

if {[exists_and_not_null calendar_id_list]} {
    set calendars_clause "and on_which_calendar in ([join $calendar_id_list ","]) and (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))"
} else {
    set calendars_clause "and ((cals.package_id= :package_id and cals.private_p='f') or (cals.private_p='t' and cals.owner_id= :user_id))"
}

if {[empty_string_p $date]} {
    # Default to todays date in the users (the connection) timezone
    set server_now_time [dt_systime]
    set user_now_time [lc_time_system_to_conn $server_now_time]
    set date [lc_time_fmt $user_now_time "%x"]
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set start_date $date

# Convert date from user timezone to system timezone
#set system_start_date [lc_time_conn_to_system "$date 00:00:00"]

set first_day_of_week [lc_get firstdayofweek]
set first_us_weekday [lindex [lc_get -locale en_US day] $first_day_of_week]
set last_us_weekday [lindex [lc_get -locale en_US day] [expr [expr $first_day_of_week + 6] % 7]]

db_1row select_weekday_info {}
db_1row select_week_info {}
    
set current_weekday 0

multirow create week_items name item_id ansi_start_date start_date calendar_name status_summary day_of_week start_date_weekday start_time end_time no_time_p full_item

# Convert date from user timezone to system timezone
set first_weekday_of_the_week_tz [lc_time_conn_to_system "$first_weekday_of_the_week 00:00:00"]
set last_weekday_of_the_week_tz [lc_time_conn_to_system "$last_weekday_of_the_week 00:00:00"]

db_foreach select_week_items {} {
    # Convert from system timezone to user timezone
    set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
    set ansi_end_date [lc_time_system_to_conn $ansi_end_date]

    set start_date_weekday [lc_time_fmt $ansi_start_date "%A"]

    set start_date [lc_time_fmt $ansi_start_date "%x"]
    set end_date [lc_time_fmt $ansi_end_date "%x"]

    set start_time [lc_time_fmt $ansi_start_date "%X"]
    set end_time [lc_time_fmt $ansi_end_date "%X"]

    # need to add dummy entries to show all days
    for {  } { $current_weekday < $day_of_week } { incr current_weekday } {
        set ansi_this_date [dt_julian_to_ansi [expr $first_weekday_julian + $current_weekday]]
        multirow append week_items "" "" $ansi_this_date [lc_time_fmt $ansi_this_date "%x"] "" "" $current_weekday [lc_time_fmt $ansi_this_date %A] "" "" "" ""
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
    multirow append week_items $name $item_id $ansi_start_date $start_date $calendar_name $status_summary $day_of_week $start_date_weekday $start_time $end_time $no_time_p $full_item
    set current_weekday $day_of_week
}

if {$current_weekday < 7} {
    # need to add dummy entries to show all hours
    for {  } { $current_weekday < 7 } { incr current_weekday } {
	set ansi_this_date [dt_julian_to_ansi [expr $first_weekday_julian + $current_weekday]]
	multirow append week_items "" "" $ansi_this_date [lc_time_fmt $ansi_this_date "%x"] "" "" $current_weekday [lc_time_fmt $ansi_this_date %A] "" "" "" ""
    }
}

# Navigation Bar
set dates "[lc_time_fmt $first_weekday_date "%q"] - [lc_time_fmt $last_weekday_date "%q"]"
if { ![info exists prev_week_template] } {
    set url_previous_week "<a href=\"view?view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $first_weekday_julian - 7]]]\"><img src=\"/resources/acs-subsite/left.gif\" alt=\"back one week\" border=\"0\">"
} else {
    set url_previous_week [subst $prev_week_template]
}

if { ![info exists next_week_template] } {
    set url_next_week "<a href=\"view?view=week&date=[ad_urlencode [dt_julian_to_ansi [expr $first_weekday_julian + 7]]]\"><img src=\"/resources/acs-subsite/right.gif\" alt=\"forward one week\" border=\"0\">"
    set next_week_template ""
} else {
    set url_next_week [subst $next_week_template]
}


