# Show calendar items per one day.

# This needs to be internationalized! -- Dirk
set date_format "YYYY-MM-DD HH24:MI"

if {[empty_string_p $date]} {
    set date [dt_sysdate]
}
set current_date $date

# The following code is original code which I don't really grasp yet. (Dirk)
# ----------------------
# If we were given no calendars, we assume we display the 
# private calendar. It makes no sense for this to be called with
# no data whatsoever.
if {[empty_string_p $calendar_id_list]} {
    set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
}
# ----------------------

# Loop through the calendars
multirow create day_items_without_time name status_summary item_id calendar_name

db_foreach select_day_items {} {
    multirow append day_items_without_time $name $status_summary $item_id $calendar_name
}

multirow create day_items_with_time current_hour name item_id calendar_name status_summary start_hour end_hour start_time end_time colspan rowspan

for {set i 0 } { $i < 24 } { incr i } {
    set items_per_hour($i) 0
}

set day_items_per_hour {}
db_foreach select_day_items_with_time {} {
    set start_hour [expr int($start_hour)]

    for { set item_current_hour $start_hour } { $item_current_hour < $end_hour } { incr item_current_hour } {
        if {$start_hour == $item_current_hour} {
            lappend day_items_per_hour [list $item_current_hour $name $item_id $calendar_name $status_summary $start_hour $end_hour $start_time $end_time]
        } else {
            lappend day_items_per_hour [list $item_current_hour "" $item_id $calendar_name $status_summary $start_hour $end_hour $start_time $end_time]
        }
        incr items_per_hour($item_current_hour)

    }

}

set day_items_per_hour [lsort -command calendar::compare_day_items_by_current_hour $day_items_per_hour]
set day_current_hour 0

# Get the maximum items per hour
set max_items_per_hour 0
for {set i 0 } { $i < 24 } { incr i } {
    if {$items_per_hour($i) > $max_items_per_hour} {
        set max_items_per_hour $items_per_hour($i)
    }
}

# Get the colspan for each hour
for {set i 0 } { $i < 24 } { incr i } {
    set colspan($i) $max_items_per_hour
}

foreach item $day_items_per_hour {
    set item_id [lindex $item 1]
    set item_start_hour [lindex $item 5]
    set item_end_hour [lindex $item 6]
}


foreach item $day_items_per_hour {
    set item_start_hour [lindex $item 5]
    set item_end_hour [lindex $item 6]
    set rowspan [expr $item_end_hour - $item_start_hour]
    if {$item_start_hour > $day_current_hour} {
        # need to add dummy entries to show all hours
        for {  } { $day_current_hour < $item_start_hour } { incr day_current_hour } {
            multirow append day_items_with_time $day_current_hour "" "" "" "" "" "" "" "" 0 0
        }
    }
    multirow append day_items_with_time [lindex $item 0] [lindex $item 1] [lindex $item 2] [lindex $item 3] [lindex $item 4] [lindex $item 5] [lindex $item 6] [lindex $item 7] [lindex $item 8] [expr $max_items_per_hour - $items_per_hour($item_start_hour) +1] $rowspan
    set day_current_hour [expr [lindex $item 0] +1 ]
}

if {$day_current_hour < 24} {
    # need to add dummy entries to show all hours
    for {  } { $day_current_hour < 24 } { incr day_current_hour } {
        multirow append day_items_with_time $day_current_hour "" "" "" "" "" 0 0
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

set dates "[util_AnsiDatetoPrettyDate $date]"
set ansi_list [split $date "- "]
set ansi_year [lindex $ansi_list 0]
set ansi_month [string trimleft [lindex $ansi_list 1] "0"]
set ansi_day [string trimleft [lindex $ansi_list 2] "0"]
set julian_date [dt_ansi_to_julian $ansi_year $ansi_month $ansi_day]

set url_previous_week "<a href=\"view?view=day&date=[ad_urlencode [dt_julian_to_ansi [expr $julian_date - 1]]]\">"
set url_next_week "<a href=\"view?view=day&date=[ad_urlencode [dt_julian_to_ansi [expr $julian_date + 1]]]\">"
