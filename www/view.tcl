ad_page_contract {
    
    Viewing Calendar Information. Currently offers list, day, week, month view.
    
    @author Dirk Gomez (openacs@dirkgomez.de)
    @author Ben Adida (ben@openforce.net)
    @creation-date May 29, 2002
    @cvs-id $Id$
} {
    {view day}
    {date ""}
    {julian_date ""}
    {sort_by ""}
    {start_date ""}
    {period_days:integer "31"}
} -validate {
    valid_date -requires { date } {
        if {![string equal $date ""]} {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input was not valid. It has to be in the form YYYYMMDD."
            }
        }
    }
}



set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set admin_p [ad_permission_p $package_id calendar_admin]

set calendar_list [calendar::calendar_list]
set date [calendar::adjust_date -date $date -julian_date $julian_date]

if {$view == "list"} {
    if {[empty_string_p $start_date]} {
        set start_date $date
    }

    set ansi_list [split $start_date "- "]
    set ansi_year [lindex $ansi_list 0]
    set ansi_month [string trimleft [lindex $ansi_list 1] "0"]
    set ansi_day [string trimleft [lindex $ansi_list 2] "0"]
    set end_date [dt_julian_to_ansi [expr [dt_ansi_to_julian $ansi_year $ansi_month $ansi_day ] + $period_days]]
}

ad_return_template 
