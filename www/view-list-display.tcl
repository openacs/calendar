# Calendar-portlet makes use of this stuff

# Calendar-portlet makes use of this stuff
if { ![info exists url_stub_callback] } {
    set url_stub_callback ""
}

if { ![info exists item_template] } {
    set item_template "<a href=cal-item-view?cal_item_id=\$item_id>\$item</a>"
}

if { ![info exists show_calendar_name_p] } {
    set show_calendar_name_p 1
}

if {[exists_and_not_null $calendar_id_list]} {
    set calendars_clause "and on_which_calendar in ([join $calendar_id_list ","]) and (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))"
} else {
    set calendars_clause "and (cals.package_id= :package_id or (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id)))"
}
# --calendar-portlet

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
# sort by cannot be empty
if {[empty_string_p $sort_by]} {
    set sort_by "start_date"
}

set date_format "YYYY-MM-DD HH24:MI"

# The title
if {[empty_string_p $start_date] && [empty_string_p $end_date]} {
    set title ""
}

if {[empty_string_p $start_date] && ![empty_string_p $end_date]} {
    set title "[_ acs-datetime.to] [util_AnsiDatetoPrettyDate $end_date]"
}

if {![empty_string_p $start_date] && [empty_string_p $end_date]} {
    set title "[_ acs-datetime.Items_from] [util_AnsiDatetoPrettyDate $start_date]"
}

if {![empty_string_p $start_date] && ![empty_string_p $end_date]} {
    set title "[_ acs-datetime.Items_from] [util_AnsiDatetoPrettyDate $start_date] [_ acs-datetime.to] [util_AnsiDatetoPrettyDate $end_date]"
}

set today_date [dt_sysdate]    
set today_ansi_list [dt_ansi_to_list $today_date]
set today_julian_date [dt_ansi_to_julian [lindex $today_ansi_list 0] [lindex $today_ansi_list 1] [lindex $today_ansi_list 2]]

set item_type_url "view?view=list&sort_by=item_type&start_date=$start_date"
set start_date_url "view?view=list&sort_by=start_date&start_date=$start_date"
set view list
set form_vars [export_form_vars start_date sort_by view]

set flip -1

multirow create calendar_items calendar_name item_id name item_type pretty_weekday pretty_start_date pretty_end_date pretty_start_time pretty_end_time flip today full_item

set last_pretty_start_date ""
# Loop through the events, and add them
    
db_foreach select_list_items {} {
    # Timezonize
    set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
    set ansi_end_date [lc_time_system_to_conn $ansi_end_date]
    set ansi_today [lc_time_system_to_conn $ansi_today]

    # Localize
    set pretty_weekday [lc_time_fmt $ansi_start_date "%A"]
    set pretty_start_date [lc_time_fmt $ansi_start_date "%x"]
    set pretty_end_date [lc_time_fmt $ansi_end_date "%x"]
    set pretty_start_time [lc_time_fmt $ansi_start_date "%X"]
    set pretty_end_time [lc_time_fmt $ansi_end_date "%X"]
    set pretty_today [lc_time_fmt $ansi_today "%x"]

    set start_date_seconds [clock scan [lc_time_fmt $ansi_start_date "%Y-%m-%d"]]
    set today_seconds [clock scan [lc_time_fmt $ansi_today "%Y-%m-%d"]]

    # Adjust the display of no-time items
    if {[dt_no_time_p -start_time $pretty_start_date -end_time $pretty_end_date]} {
        set pretty_start_time "--"
        set pretty_end_time "--"
    }

    if {[string equal $pretty_start_time "00:00"]} {
        set pretty_start_time "--"
    }

    if {[string equal $pretty_end_time "00:00"]} {
        set pretty_end_time "--"
    }

    if {![string equal $pretty_start_date $last_pretty_start_date]} {
        set last_pretty_start_date $pretty_start_date
        incr flip
    }

    # Give the row different appearance depending on whether it's before today, today, or after today
    if {$start_date_seconds == $today_seconds} {
        set today cal-row-hi
    } elseif {$start_date_seconds < $today_seconds} {
        set today cal-row-lo
    } else {
        set today ""
    }

    # In case we need to dispatch to a different URL (ben)
    if {![empty_string_p $url_stub_callback]} {
        set url_stub [$url_stub_callback $calendar_id]
    }
    
    set item "$name"
    set item [subst $item_template]
                
    multirow append calendar_items $calendar_name $item_id $name $item_type $pretty_weekday $pretty_start_date $pretty_end_date $pretty_start_time $pretty_end_time $flip $today $item

}
