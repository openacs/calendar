# Show a calendar month widget
#
# Parameters:
#
# date (YYYY-MM-DD) - optional

if {![info exists date] || [empty_string_p $date]} {
    # Default to todays date in the users (the connection) timezone
    set server_now_time [dt_systime]
    set user_now_time [lc_time_system_to_conn $server_now_time]
    set date [lc_time_fmt $user_now_time "%x"]
}
dt_get_info $date

set ansi_date_format "YYYY-MM-DD HH24:MI:SS"

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set today_date [dt_sysdate]    
set next_month_url "<a href=\"view?calendar_list=&view=month&date=[ad_urlencode $next_month]\">"
set prev_month_url "<a href=\"view?calendar_list=&view=month&date=[ad_urlencode $prev_month]\">"

multirow create weekday_names weekday_short
foreach weekday [calendar::get_weekday_list] {
    multirow append weekday_names $weekday
}

# Get the beginning and end of the month in the system timezone
set first_date_of_month [dt_julian_to_ansi $first_julian_date_of_month]
set first_date_of_month_system [lc_time_conn_to_system "$first_date_of_month 00:00:00"]
set last_date_in_month [dt_julian_to_ansi $last_julian_date_in_month]
set last_date_in_month_system [lc_time_conn_to_system "$last_date_in_month 23:59:59"]

calendar::i18n_display_parameters

set number_day_cells 0

set day_number $first_day

set today_ansi_list [dt_ansi_to_list $today_date]
set today_julian_date [dt_ansi_to_julian [lindex $today_ansi_list 0] [lindex $today_ansi_list 1] [lindex $today_ansi_list 2]]


multirow create days_of_a_month calendar_item item_id ansi_start_date ansi_start_time day_number calendar_name beginning_of_week_p end_of_week_p today_p outside_month_p 

for {set current_day $first_julian_date} {$current_day < $first_julian_date_of_month} {incr current_day} {
    if {$current_day == $first_julian_date} {
        set beginning_of_week_p t
    } else {
        set beginning_of_week_p f
    }
    multirow append days_of_a_month "" "" [dt_julian_to_ansi [expr $first_julian_date_of_month + $current_day -1]] "" "" "" $beginning_of_week_p f "" t 
}

set current_day $first_julian_date_of_month

db_foreach select_monthly_items {} {

    # Convert from system timezone to user timezone
    set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
    set ansi_end_date [lc_time_system_to_conn $ansi_end_date]
    
    set ansi_start_time [lc_time_fmt $ansi_start_date "%X"]
    set ansi_end_time [lc_time_fmt $ansi_end_date "%X"]

    set julian_start_date [dt_ansi_to_julian_single_arg $ansi_start_date]

    if {$current_day < $julian_start_date} {
        for {} {$current_day < $julian_start_date} {incr current_day} {
            array set display_information [calendar::get_month_multirow_information -current_day $current_day -today_julian_date $today_julian_date -first_julian_date_of_month $first_julian_date_of_month]
            multirow append days_of_a_month "" "" [dt_julian_to_ansi $current_day] "" $display_information(day_number) "" $display_information(beginning_of_week_p) $display_information(end_of_week_p) $display_information(today_p) f 
        } 
    }

    if {[string equal $ansi_start_time "00:00"] && [string equal $ansi_end_time "00:00"]} {
        set ansi_start_time "--"
    }

    array set display_information [calendar::get_month_multirow_information -current_day $current_day -today_julian_date $today_julian_date -first_julian_date_of_month $first_julian_date_of_month]
    multirow append days_of_a_month $name $item_id [dt_julian_to_ansi $current_day] $ansi_start_time $display_information(day_number) $calendar_name $display_information(beginning_of_week_p) $display_information(end_of_week_p) $display_information(today_p)  f 
}


for {} {$current_day <= $last_julian_date_in_month} {incr current_day} {
    array set display_information [calendar::get_month_multirow_information -current_day $current_day -today_julian_date $today_julian_date -first_julian_date_of_month $first_julian_date_of_month]
    multirow append days_of_a_month "" "" [dt_julian_to_ansi $current_day] "" $display_information(day_number) "" $display_information(beginning_of_week_p) $display_information(end_of_week_p) $display_information(today_p) f 
    incr number_day_cells
}

set remaining_days [expr 6 - $current_day % 7] 

if {$remaining_days > 0 } {
    for {} {$current_day <= [expr $last_julian_date_in_month + $remaining_days]} {incr current_day} {
        multirow append days_of_a_month "" "" "" "" "" "" f f "" t 
    }
}