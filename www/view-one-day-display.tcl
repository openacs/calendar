# Show calendar items per one day.
#
# Parameters:
#shour_tem
# date (YYYY-MM-DD) - optional
# start_display_hour and end_display_hour

# Calendar-portlet makes use of this stuff
if { ![info exists url_stub_callback] } {
    set url_stub_callback ""
}

if { ![info exists hour_template] } {
    set hour_template {<a href=cal-item-new?date=$current_date&start_time=$day_current_hour>$localized_day_current_hour</a>}
}

if { ![info exists day_template] } {
    set day_template "<a href=?julian_date=\$julian_date>\$day_number</a>"
}

if { ![info exists item_template] } {
    set item_template "<a href=cal-item-view?cal_item_id=\$item_id>\$item</a>"
}

if { ![info exists prev_nav_template] } {
    set prev_nav_template {<a href="view?view=day&date=[ns_urlencode $yesterday]"><img border=0 src=\"[dt_left_arrow]\" alt=\"back one day\"></a>}
}

if { ![info exists next_nav_template] } {
    set next_nav_template {<a href="view?view=day&date=[ns_urlencode $tomorrow]"><img border=0 src=\"[dt_right_arrow]\" alt=\"forward one day\"></a>}
}

if { ![info exists show_calendar_name_p] } {
    set show_calendar_name_p 1
}

if {![exists_and_not_null base_url]} {
    set base_url ""
}

set current_date $date
if { [info exists start_display_hour]} {
    set current_date_system "$current_date $start_display_hour:00:00"
} else {
    set current_date_system "$current_date 00:00:00"
    set start_display_hour 0
}

if { ![info exists end_display_hour]} {
    set end_display_hour 24
}

if {[exists_and_not_null calendar_id_list]} {
    set calendars_clause "and on_which_calendar in ([join $calendar_id_list ","]) and (cals.private_p='f' or (cals.private_p='t' and cals.owner_id= :user_id))"
} else {
    set calendars_clause "and ((cals.package_id= :package_id and cals.private_p='f') or (cals.private_p='t' and cals.owner_id= :user_id))"
}

# The database needs this for proper formatting.
set ansi_date_format "YYYY-MM-DD HH24:MI:SS"

if {[empty_string_p $date]} {
    # Default to todays date in the users (the connection) timezone
    set server_now_time [dt_systime]
    set user_now_time [lc_time_system_to_conn $server_now_time]
    set date [lc_time_fmt $user_now_time "%F"]
}


set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

# Loop through the items without time
multirow create day_items_without_time name status_summary item_id calendar_name full_item

db_foreach select_day_items {} {
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

    multirow append day_items_without_time $name $status_summary $item_id $calendar_name $full_item
}


set day_current_hour 0
set localized_day_current_hour {<img border="0" align="left" src="/resources/acs-subsite/add.gif" alt="No Time">}
set item_add_without_time [subst $hour_template]

# Now items with time

# There's quite some extra code here to be able to display overlapping
# items. Will be properly implemented in OpenACS 5.1 (or so) -- Dirk
multirow create day_items_with_time current_hour_link current_hour localized_current_hour name item_id calendar_name status_summary start_hour end_hour start_time end_time colspan rowspan full_item

for {set i $start_display_hour } { $i < $end_display_hour } { incr i } {
    set items_per_hour($i) 0
}


set day_items_per_hour {}
db_foreach select_day_items_with_time {} {
    set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
    set ansi_end_date [lc_time_system_to_conn $ansi_end_date]

    set start_hour [lc_time_fmt $ansi_start_date "%H"]
    set end_hour [lc_time_fmt $ansi_end_date "%H"]
    set start_time [lc_time_fmt $ansi_start_date "%X"]
    set end_time [lc_time_fmt $ansi_end_date "%X"]

    for { set item_current_hour $start_hour } { $item_current_hour < $end_hour } { incr item_current_hour } {
        set item_current_hour [expr [string trimleft $item_current_hour 0]+0]
        if {$start_hour == $item_current_hour && $start_hour >= $start_display_hour } {
            lappend day_items_per_hour [list $item_current_hour $name $item_id $calendar_name $status_summary $start_hour $end_hour $start_time $end_time]
        } elseif { $end_hour <= $end_display_hour } {
            lappend day_items_per_hour [list $item_current_hour "" $item_id $calendar_name $status_summary $start_hour $end_hour $start_time $end_time]
            }
        incr items_per_hour($item_current_hour)
    }
}

set day_items_per_hour [lsort -command calendar::compare_day_items_by_current_hour $day_items_per_hour]
set day_current_hour $start_display_hour

# Get the maximum items per hour
set max_items_per_hour 0
for {set i $start_display_hour } { $i < $end_display_hour } { incr i } {
    if {$items_per_hour($i) > $max_items_per_hour} {
        set max_items_per_hour $items_per_hour($i)
    }
}

foreach this_item $day_items_per_hour {
    set item_start_hour [expr [string trimleft [lindex $this_item 5] 0]+0]
    set item_end_hour [expr [string trimleft [lindex $this_item 6] 0]+0]
    set rowspan [expr $item_end_hour - $item_start_hour]
    if {$item_start_hour > $day_current_hour} {
        # need to add dummy entries to show all hours
        for {  } { $day_current_hour < $item_start_hour } { incr day_current_hour } {
	    set localized_day_current_hour [lc_time_fmt "$current_date $day_current_hour:00:00" "%X"]
            multirow append day_items_with_time  "[subst $hour_template]" $day_current_hour $localized_day_current_hour "" "" "" "" "" "" "" "" 0 0 ""
        }
    }

    set localized_day_current_hour [lc_time_fmt "$current_date $day_current_hour:00:00" "%X"]

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

    set start_time [lindex $this_item 7] 
    set end_time [lindex $this_item 8]

    set item [lindex $this_item 1]
    set full_item "[subst $item_template]"

    set current_hour_link "[subst $hour_template]"

    multirow append day_items_with_time $current_hour_link $day_current_hour $localized_day_current_hour [lindex $this_item 1] [lindex $this_item 2] [lindex $this_item 3] [lindex $this_item 4] [lindex $this_item 5] [lindex $this_item 6] [lindex $this_item 7] [lindex $this_item 8] 0 $rowspan $full_item
    set day_current_hour [expr [lindex $this_item 0] +1 ]
}

if {$day_current_hour < $end_display_hour } {
    # need to add dummy entries to show all hours
    for {  } { $day_current_hour <= $end_display_hour } { incr day_current_hour } {
	set localized_day_current_hour [lc_time_fmt "$current_date $day_current_hour:00:00" "%X" [ad_conn locale]]
        multirow append day_items_with_time  "[subst $hour_template]"  $day_current_hour $localized_day_current_hour "" "" "" "" "" 0 0 ""
    }
}

# Select some basic stuff, sets day_of_the_week, yesterday, tomorrow vars
db_1row select_day_info {}

# Check that the previous and next days are in the tcl boundaries
# so that the calendar widget doesn't bomb when it creates the next/prev links
if {[catch {set yest [clock format [clock scan "1 day ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
    set previous_link ""
} else {
    if {[catch {clock scan $yest}]} {
	set previous_link ""
    } else {
	set previous_link "<a href=\"view?view=day&date=[ns_urlencode $yesterday]\">&lt;</a>"
    }
}

if {[catch {set tomor [clock format [clock scan "1 day" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
    set next_link ""
} else {
    if {[catch {clock scan $tomor}]} {
	set next_link ""
    } else {
	set next_link "<a href=\"view?view=day&date=[ns_urlencode $tomorrow]\">&gt;</a>"
    }
}

set dates [lc_time_fmt $date "%q"]
set ansi_list [split $date "- "]
set ansi_year [lindex $ansi_list 0]
set ansi_month [string trimleft [lindex $ansi_list 1] "0"]
set ansi_day [string trimleft [lindex $ansi_list 2] "0"]
set julian_date [dt_ansi_to_julian $ansi_year $ansi_month $ansi_day]

set url_previous_week [subst $prev_nav_template]
set url_next_week [subst $next_nav_template]

