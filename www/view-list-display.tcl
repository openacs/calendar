# Calendar-portlet makes use of this stuff
if { ![info exists url_stub_callback] } {
    set url_stub_callback ""
}
if { ![info exists url_template] } {
    set url_template {?sort_by=$sort_by}
}
if { ![info exists item_template] } {
    set item_template "<a href=cal-item-view?cal_item_id=\$item_id>\[ad_quotehtml \$item\]</a>"
}
if { ![info exists show_calendar_name_p] } {
    set show_calendar_name_p 1
}
if { ![exists_and_not_null sort_by] } {
    set sort_by "start_date"
}
if { ![exists_and_not_null start_date] } {
    set start_date [clock format [clock seconds] -format "%Y-%m-%d 00:00"]
}
if { ![exists_and_not_null end_date] } {
    set end_date [clock format [clock scan "+30 days" -base [clock scan $start_date]] -format "%Y-%m-%d 00:00"]
}


if {[exists_and_not_null calendar_id_list]} {
    set calendars_clause "and on_which_calendar in ([join $calendar_id_list ","]) and (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))"
} else {
    set calendars_clause "and ((cals.package_id= :package_id and cals.private_p='f') or (cals.private_p='t' and cals.owner_id= :user_id))"
}

if { ![info exists period_days] } {
    set period_days 31
}

if {[exists_and_not_null page_num]} {
    set page_num_formvar [export_form_vars page_num]
    set page_num "&page_num=$page_num"
} else {
    set page_num_formvar ""
    set page_num ""
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

# The title
if {[empty_string_p $start_date] && [empty_string_p $end_date]} {
    set title ""
}

if {[empty_string_p $start_date] && ![empty_string_p $end_date]} {
    set title "[_ acs-datetime.to] [lc_time_fmt $end_date "%q"]"
}

if {![empty_string_p $start_date] && [empty_string_p $end_date]} {
    set title "[_ acs-datetime.Items_from] [lc_time_fmt $start_date "%q"]"
}

if {![empty_string_p $start_date] && ![empty_string_p $end_date]} {
    set title "[_ acs-datetime.Items_from] [lc_time_fmt $start_date "%q"] [_ acs-datetime.to] [lc_time_fmt $end_date "%q"]"
}

set today_date [dt_sysdate]    
set today_ansi_list [dt_ansi_to_list $today_date]
set today_julian_date [dt_ansi_to_julian [lindex $today_ansi_list 0] [lindex $today_ansi_list 1] [lindex $today_ansi_list 2]]

set item_type_url "?view=list&sort_by=item_type&start_date=$start_date&period_days=$period_days$page_num"
set start_date_url "?view=list&sort_by=start_date&start_date=$start_date&period_days=$period_days$page_num"

set view list
set form_vars [export_form_vars start_date sort_by view]

set flip -1

multirow create calendar_items calendar_name item_id name item_type pretty_weekday pretty_start_date pretty_end_date pretty_start_time pretty_end_time flip today full_item

set last_pretty_start_date ""
# Loop through the events, and add them

if {[string match [db_type] "postgresql"]} {
    set interval_limitation_clause " to_timestamp(:start_date,'YYYY-MM-DD HH24:MI:SS')  and      to_timestamp(:end_date, 'YYYY-MM-DD HH24:MI:SS')"
} else {
    set interval_limitation_clause " to_date(:start_date,'YYYY-MM-DD HH24:MI:SS')  and      to_date(:end_date, 'YYYY-MM-DD HH24:MI:SS')"
}
set order_by_clause " order by $sort_by"
set additional_limitations_clause ""

if {[string match [db_type] "postgresql"]} {
    set sysdate "now()"
} else {
    set sysdate "sysdate"
}
set additional_select_clause " , to_char($sysdate, 'YYYY-MM-DD HH24:MI:SS') as ansi_today, recurrence_id"

db_foreach dbqd.calendar.www.views.select_items {} {
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

    # reset url stub
    set url_stub ""
    
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

    multirow append calendar_items $calendar_name $item_id $name $item_type $pretty_weekday $pretty_start_date $pretty_end_date $pretty_start_time $pretty_end_time $flip $today $full_item

}
