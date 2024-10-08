ad_include_contract {
    Display one week calendar view

    Expects:
      date (empty string okay): YYYY-MM-DD
      show_calendar_name_p (optional): 0 or 1
      calendar_id_list: optional list of calendar_ids
      export: may be "print"
} {
    {date ""}
    {show_calendar_name_p:boolean,notnull 1}
    {calendar_id_list ""}
    {export ""}
    {return_url:optional}
}

set system_type ""
if {$date eq ""} {
    # Default to today's date in the users (the connection) timezone
    set server_now_time [dt_systime]
    set user_now_time [lc_time_system_to_conn $server_now_time]
    set date [lc_time_fmt $user_now_time "%x"]
}

if { $export ne "" } {
    set exporting_p 1
} else {
    set exporting_p 0
}

if {![info exists return_url]} {
    set return_url [ad_urlencode "../"]
}

if {$calendar_id_list ne ""} {
    set calendars_clause [db_map dbqd.calendar.www.views.openacs_in_portal_calendar]
} else {
    set calendars_clause [db_map dbqd.calendar.www.views.openacs_calendar]
}

lassign [dt_ansi_to_list $date] this_year this_month this_day
set dt_info [dt_get_info -dict $date]
set prev_month                 [dict get $dt_info prev_month]
set next_month                 [dict get $dt_info next_month]
set first_julian_date_of_month [dict get $dt_info first_julian_date_of_month]
set last_julian_date_in_month  [dict get $dt_info last_julian_date_in_month]
set first_day                  [dict get $dt_info first_day]

set month_string [lindex [dt_month_names] $this_month-1]

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set today_date [dt_sysdate]

set previous_month_url ?[export_vars {{view month} {date $prev_month} page_num}]
set next_month_url ?[export_vars {{view month} {date $next_month} page_num}]

set first_day_of_week [lc_get firstdayofweek]
set last_day_of_week [expr {($first_day_of_week + 6) % 7}]

set week_days [lc_get day]
multirow create weekday_names weekday_num weekday_long
for {set i 0} {$i < 7} {incr i} {
    set i_day [expr {($i + $first_day_of_week) % 7}]
    multirow append weekday_names $i_day [lindex $week_days $i_day]
}


# Get the beginning and end of the month in the system timezone
set first_date_of_month [dt_julian_to_ansi $first_julian_date_of_month]
set last_date_in_month [dt_julian_to_ansi $last_julian_date_in_month]

set first_date_of_month_system "$first_date_of_month 00:00:00"
set last_date_in_month_system "$last_date_in_month 23:59:59"

set day_number $first_day

set today_ansi_list [dt_ansi_to_list $today_date]
set today_julian_date [dt_ansi_to_julian [lindex $today_ansi_list 0] [lindex $today_ansi_list 1] [lindex $today_ansi_list 2]]


# Create the multirow that holds the calendar information
multirow create items \
    event_name \
    event_url \
    description \
    calendar_name \
    pretty_date \
    start_date \
    end_date \
    start_time \
    end_time \
    status_summary \
    day_number \
    beginning_of_week_p \
    end_of_week_p \
    today_p \
    outside_month_p \
    time_p \
    add_url \
    day_url \
    style_class \
    num_attachments \
    weekday_num \
    id

# Calculate number of greyed days and then add them to the calendar mulitrow
set greyed_days_before_month [expr {[dt_first_day_of_month $this_year $this_month] - 1}]
set greyed_days_before_month [expr {($greyed_days_before_month + 7 - $first_day_of_week) % 7}]

if { !$exporting_p } {

    # These "items" are for used for display purposes only.
    for {set current_day 0} {$current_day < $greyed_days_before_month} {incr current_day} {
        if {$current_day == 0} {
            set beginning_of_week_p t
        } else {
            set beginning_of_week_p f
        }
        multirow append items \
            "" \
            "" \
            "" \
            "" \
            "" \
            "" \
            "" \
            "" \
            "" \
            "" \
            "" \
            $beginning_of_week_p \
            f \
            "" \
            t \
            "" \
            "" \
            "" \
            "" \
            "" \
            "" \
            ""
    }
}

set current_day $first_julian_date_of_month

set order_by_clause " order by ansi_start_date, ansi_end_date"
set additional_limitations_clause ""
set additional_select_clause ""
set interval_limitation_clause [db_map dbqd.calendar.www.views.month_interval_limitation]

db_foreach dbqd.calendar.www.views.select_items {} {
    if { $ansi_start_date eq $ansi_end_date } {
        set time_p 0
    } else {
        set time_p 1
        # Convert from system timezone to user timezone
        set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
        set ansi_end_date [lc_time_system_to_conn $ansi_end_date]

    }

    # Localize
    set pretty_weekday    [lc_time_fmt $ansi_start_date "%A"]
    set pretty_start_date [lc_time_fmt $ansi_start_date "%x"]
    set pretty_end_date   [lc_time_fmt $ansi_end_date "%x"]
    set pretty_start_time [lc_time_fmt $ansi_start_date "%X"]
    set pretty_end_time   [lc_time_fmt $ansi_end_date "%X"]

    set julian_start_date [dt_ansi_to_julian_single_arg $ansi_start_date]

    if {!$exporting_p && $current_day < $julian_start_date} {
        for {} {$current_day < $julian_start_date} {incr current_day} {
            array set display_information \
                [calendar::get_month_multirow_information \
                     -current_day $current_day \
                     -today_julian_date $today_julian_date \
                     -first_julian_date_of_month $first_julian_date_of_month]

            set current_day_ansi [dt_julian_to_ansi $current_day]
            set add_url  [export_vars -base ${calendar_url}cal-item-new {
                {date $current_day_ansi} {start_time ""} {end_time ""}
            }]
            multirow append items \
                "" \
                "" \
                "" \
                "" \
                [lc_time_fmt [dt_julian_to_ansi $current_day] %Q] \
                "" \
                "" \
                "" \
                "" \
                "" \
                $display_information(day_number) \
                $display_information(beginning_of_week_p) \
                $display_information(end_of_week_p) \
                $display_information(today_p) \
                f \
                0 \
                $add_url \
                ?[export_vars {{view day} {date $current_day_ansi} page_num}] \
                "calendar-${system_type}Item" \
                $num_attachments \
                [lc_time_fmt $current_day_ansi %w] \
                month-calendar-$current_day_ansi

            add_body_script -script [subst {
                var e =  document.getElementById('month-calendar-$current_day_ansi');
                e.addEventListener('click', function (event) {
                    if (event.target.className == 'cal-month-day') {
                        location.href = '$add_url';
                    }
                });
                e.addEventListener('keypress', function (event) {
                    event.preventDefault();
                    acs_KeypressGoto('$add_url',event);
                });
            }]
        }
    }

    array set display_information \
        [calendar::get_month_multirow_information \
             -current_day $current_day \
             -today_julian_date $today_julian_date \
             -first_julian_date_of_month $first_julian_date_of_month]

    set current_day_ansi [dt_julian_to_ansi $current_day]
    set add_url [export_vars -base ${calendar_url}cal-item-new {
        {date $current_day_ansi} {start_time ""} {end_time ""}
    }]
    multirow append items \
        $name \
        [export_vars -base [site_node::get_url_from_object_id -object_id $cal_package_id]cal-item-view {
            return_url {cal_item_id $item_id}
        }] \
        $description \
        $calendar_name \
        [lc_time_fmt $current_day_ansi %Q] \
        $pretty_start_date \
        $pretty_end_date \
        $pretty_start_time \
        $pretty_end_time \
        "" \
        $display_information(day_number) \
        $display_information(beginning_of_week_p) \
        $display_information(end_of_week_p) \
        $display_information(today_p) \
        f \
        $time_p \
        $add_url \
        ?[export_vars {{view day} {date $current_day_ansi} page_num}] \
        "calendar-${system_type}Item" \
        $num_attachments \
        [lc_time_fmt $current_day_ansi %w] \
        month-calendar-$current_day_ansi

}

if { !$exporting_p } {

    # These "items" are for used for display purposes only.

    # Add cells for remaining days inside the month
    for {} {$current_day <= $last_julian_date_in_month} {incr current_day} {
        array set display_information \
            [calendar::get_month_multirow_information \
                 -current_day $current_day \
                 -today_julian_date $today_julian_date \
                 -first_julian_date_of_month $first_julian_date_of_month]

        set current_day_ansi [dt_julian_to_ansi $current_day]
        set add_url [export_vars -base ${calendar_url}cal-item-new {
            {date $current_day_ansi} {start_time ""} {end_time ""}
        }]

        multirow append items \
            "" \
            "" \
            "" \
            "" \
            [lc_time_fmt $current_day_ansi %Q] \
            "" \
            "" \
            "" \
            "" \
            "" \
            $display_information(day_number) \
            $display_information(beginning_of_week_p) \
            $display_information(end_of_week_p) \
            $display_information(today_p) \
            f \
            0 \
            $add_url \
            ?[export_vars {{view day} {date $current_day_ansi} page_num}] \
            "" \
            "" \
            [lc_time_fmt $current_day_ansi %w] \
            month-calendar-$current_day_ansi

            add_body_script -script [subst {
                var e =  document.getElementById('month-calendar-$current_day_ansi');
                e.addEventListener('click', function (event) {
                    location.href = '$add_url';
                });
                e.addEventListener('keypress', function (event) {
                    event.preventDefault();
                    acs_KeypressGoto('$add_url',event);
                });
            }]

    }

    # Add cells for remaining days outside the month
    set remaining_days [expr {($first_day_of_week + 6 - $current_day % 7) % 7}]

    if {$remaining_days > 0} {
        for {} {$current_day <= $last_julian_date_in_month + $remaining_days} {incr current_day} {
            multirow append items \
                "" \
                "" \
                "" \
                "" \
                "" \
                "" \
                "" \
                "" \
                "" \
                "" \
                "" \
                f \
                f \
                "" \
                t \
                "" \
                "" \
                "" \
                "" \
                "" \
                "" \
                ""
        }
    }
}

if { $export eq "print" } {
    set print_html [template::adp_parse [acs_root_dir]/packages/calendar/www/view-print-display [list &items items show_calendar_name_p $show_calendar_name_p]]
    ns_return 200 text/html $print_html
    ad_script_abort
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
