# If we were given no calendars, we assume we display the 
# private calendar. It makes no sense for this to be called with
# no data whatsoever.
if {[empty_string_p $calendar_id_list]} {
    set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
    set calendar_where_clause " and e.event_id in ([join $calendar_id_list ","])"
} else {
    set calendar_where_clause ""
}

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
    set title "Items until [util_AnsiDatetoPrettyDate $end_date]"
}

if {![empty_string_p $start_date] && [empty_string_p $end_date]} {
    set title "Items starting [util_AnsiDatetoPrettyDate $start_date]"
}

if {![empty_string_p $start_date] && ![empty_string_p $end_date]} {
    set title "Items from [util_AnsiDatetoPrettyDate $start_date] to [util_AnsiDatetoPrettyDate $end_date]"
}

set today_date [dt_sysdate]    
set today_ansi_list [dt_ansi_to_list $today_date]
set today_julian_date [dt_ansi_to_julian [lindex $today_ansi_list 0] [lindex $today_ansi_list 1] [lindex $today_ansi_list 2]]

set item_type_url "view?view=list&sort_by=item_type&start_date=$start_date"
set start_date_url "view?view=list&sort_by=start_date&start_date=$start_date"
set view list
set form_vars [export_form_vars start_date sort_by view]

set flip -1

multirow create calendar_items calendar_name item_id name item_type pretty_weekday pretty_start_date pretty_end_date pretty_start_time pretty_end_time flip today

set last_pretty_start_date ""
# Loop through the events, and add them
    
db_foreach select_list_items {} {
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

    if {$julian_start_date == $today_julian_date} {
        set today row-hi
    } elseif {$julian_start_date < $today_julian_date} {
        set today row-lo
    } else {
        set today ""
    }

    multirow append calendar_items $calendar_name $item_id $name $item_type $pretty_weekday $pretty_start_date $pretty_end_date $pretty_start_time $pretty_end_time $flip $today

}

