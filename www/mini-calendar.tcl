if {![exists_and_not_null base_url]} {
    set base_url [ad_conn url]
}

if {![exists_and_not_null date]} {
    set date [dt_sysdate]
}

# Create row with existing views
multirow create views name text active_p
foreach viewname {list day week month} {
    if { [string equal $viewname $view] } {
        set active_p t
    } else {
        set active_p f
    }
    multirow append views [string toupper $viewname 0] $viewname $active_p
}

set list_of_vars [list]

# Get the current month, day, and the first day of the month

dt_get_info $date


set now        [clock scan $date]
set output ""

if [string equal $view month] {
    set curr_year [clock format $now -format "%Y"]
    set prev_year [clock format [clock scan "1 year ago" -base $now] -format "%Y-%m-%d"]
    set next_year [clock format [clock scan "1 year" -base $now] -format "%Y-%m-%d"]
    set prev_year_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $prev_year]\">"
    set next_year_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $next_year]\">"

    set months_list [dt_month_names]
    set now         [clock scan $date]
    set curr_month  [expr [dt_trim_leading_zeros [clock format $now -format "%m"]]-1]

    multirow create months name current_month_p new_row_p target_date

    for {set i 0} {$i < 12} {incr i} {

        set month [lindex $months_list $i]

        # show 3 months in a row

        if {($i != 0) && ([expr $i % 3] == 0)} {
            set new_row_p t
        } else {
            set new_row_p f
        }

        if {$i == $curr_month} {
            set current_month_p t 
            set encoded_target_date ""
        } else {
            set current_month_p f
            set target_date [clock format \
                                 [clock scan "[expr $i-$curr_month] month" -base $now] -format "%Y-%m-%d"]
            set encoded_target_date [ad_urlencode $target_date]
        }
        multirow append months $month $current_month_p $new_row_p $encoded_target_date
        
    }
} else {
    set curr_month [clock format $now -format "%B"]
    set prev_month [clock format [clock scan "1 month ago" -base $now] -format "%Y-%m-%d"]
    set next_month [clock format [clock scan "1 month" -base $now] -format "%Y-%m-%d"]
    set prev_month_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $prev_month]\">"
    set next_month_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $next_month]\">"
    
    multirow create days_of_week day_short
    # I18N !
    foreach day_of_week [list S M T W T F S] {
        multirow append days_of_week $day_of_week
    }

    set day_of_week 1
    set day_number  $first_day

    multirow create days day_number ansi_date beginning_of_week_p end_of_week_p today_p greyed_p

    for {set julian_date $first_julian_date} {$julian_date <= $last_julian_date} {incr julian_date} {
        set today_p f
        set greyed_p f

        if {$julian_date < $first_julian_date_of_month} {
            set greyed_p t
        } elseif {$julian_date > $last_julian_date_in_month} {
            set greyed_p t
        } 
        set ansi_date [dt_julian_to_ansi $julian_date]
        
        if {$julian_date == $first_julian_date_of_month} {
            set day_number 1
        } elseif {$julian_date == [expr $last_julian_date_in_month +1]} {
            set day_number 1
        }

        if { $day_of_week == 1} {
            set beginning_of_week_p t
        } else {
            set beginning_of_week_p f
        }

        if {$julian_date == $julian_date_today} {
            set today_p t
        }

        if { $day_of_week == 7 } {
            set day_of_week 0
            set end_of_week_p t
        } else {
            set end_of_week_p f
        }
        multirow append days $day_number [ad_urlencode $ansi_date] $beginning_of_week_p $end_of_week_p $today_p $greyed_p
        incr day_of_week
        incr day_number
    }
}

set today_url "$base_url?view=day&date=[ad_urlencode [dt_sysdate]]"

if { $view == "day" && [dt_sysdate] == $date } {
    set today_p t
} else {
    set today_p f
}


set form_vars ""
foreach var $list_of_vars {
    append form_vars "<INPUT TYPE=hidden name=[lindex $var 0] value=[lindex $var 1]>"
}
