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
    multirow append views [_ acs-datetime.[string toupper $viewname 0]] $viewname $active_p
}

set list_of_vars [list]

# Get the current month, day, and the first day of the month
if {[catch {
    dt_get_info $date
} errmsg]} {
    set date [dt_sysdate]
    dt_get_info $date
}

set date_list [dt_ansi_to_list $date]
set year [dt_trim_leading_zeros [lindex $date_list 0]]
set month [dt_trim_leading_zeros [lindex $date_list 1]]
set day [dt_trim_leading_zeros [lindex $date_list 2]]

set now        [clock scan $date]
set output ""

set months_list [dt_month_names]
set curr_month_idx  [expr [dt_trim_leading_zeros [clock format $now -format "%m"]]-1]
if [string equal $view month] {
    set curr_year [clock format $now -format "%Y"]
    set prev_year [clock format [clock scan "1 year ago" -base $now] -format "%Y-%m-%d"]
    set next_year [clock format [clock scan "1 year" -base $now] -format "%Y-%m-%d"]
    set prev_year_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $prev_year]\">"
    set next_year_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $next_year]\">"

    set now         [clock scan $date]

    multirow create months name current_month_p new_row_p target_date

    for {set i 0} {$i < 12} {incr i} {

        set month [lindex $months_list $i]

        # show 3 months in a row

        if {($i != 0) && ([expr $i % 3] == 0)} {
            set new_row_p t
        } else {
            set new_row_p f
        }

        if {$i == $curr_month_idx} {
            set current_month_p t 
            set encoded_target_date ""
        } else {
            set current_month_p f
            set target_date [clock format \
                                 [clock scan "[expr $i-$curr_month_idx] month" -base $now] -format "%Y-%m-%d"]
            set encoded_target_date [ad_urlencode $target_date]
        }
        multirow append months $month $current_month_p $new_row_p $encoded_target_date
        
    }
} else {
    set curr_month [lindex $months_list $curr_month_idx ]
    set prev_month [clock format [clock scan "1 month ago" -base $now] -format "%Y-%m-%d"]
    set next_month [clock format [clock scan "1 month" -base $now] -format "%Y-%m-%d"]
    set prev_month_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $prev_month]\">"
    set next_month_url "<a href=\"$base_url?view=$view&date=[ad_urlencode $next_month]\">"
    
    set first_day_of_week [lc_get firstdayofweek]
    set week_days [lc_get abday]
    multirow create days_of_week day_short
    for {set i 0} {$i < 7} {incr i} {
        multirow append days_of_week [lindex $week_days [expr [expr $i + $first_day_of_week] % 7]]
    }


    multirow create days day_number ansi_date beginning_of_week_p end_of_week_p today_p greyed_p

    set day_of_week 1

    # Calculate number of greyed days
    set greyed_days_before_month [expr [expr [dt_first_day_of_month $year $month]] -1 ]
    # Adjust for i18n
    set greyed_days_before_month [expr [expr $greyed_days_before_month + 7 - $first_day_of_week] % 7]

    set calendar_starts_with_julian_date [expr $first_julian_date_of_month - $greyed_days_before_month]
    set day_number [expr $days_in_last_month - $greyed_days_before_month + 1]

    for {set julian_date $calendar_starts_with_julian_date} {$julian_date <= [expr $last_julian_date + 7]} {incr julian_date} {
        if {$julian_date > $last_julian_date_in_month && [string equal $end_of_week_p t] } {
            break
        }
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

        if {$julian_date == $julian_date_today} {
            set today_p t
        }

        if { $day_of_week == 0} {
            set beginning_of_week_p t
        } else {
            set beginning_of_week_p f
        }

        if { $day_of_week == 7 } {
            set day_of_week 0
            set end_of_week_p t
        } else {
            set end_of_week_p f
        }
        multirow append days $day_number [ad_urlencode $ansi_date] $beginning_of_week_p $end_of_week_p $today_p $greyed_p
        incr day_number
        incr day_of_week
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
