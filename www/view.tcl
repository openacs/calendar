ad_page_contract {
    
    Viewing Calendar Information. Currently offers list, day, week, month view.
    
    @author Dirk Gomez (openacs@dirkgomez.de)
    @author Ben Adida (ben@openforce.net)
    @creation-date May 29, 2002
    @cvs-id $Id$
} {
    {view:word {[parameter::get -parameter DefaultView -default day]}}
    {date ""}
    {sort_by ""}
    {start_date ""}
    {period_days:integer,notnull {[parameter::get -parameter ListView_DefaultPeriodDays -default 31]}}
} -validate {
    
    valid_date -requires { date } {
        if {$date ne "" } {
            if {[catch {set date [clock format [clock scan $date -format "%Y-%m-%d"] -format "%Y-%m-%d"]} err]
                && [catch {set date [clock format [clock scan $date  -format "%Y%m%d"] -format "%Y-%m-%d"]} err]
            } {
                ad_complain "Your input was not valid. It has to be in the form YYYY-MM-DD."
            }
        }
    }
    
    valid_period_days  -requires { period_days } {
        # Tcl allows in for relative times just 6 digits, including the "+"
        if {$period_days > 99999} {
            ad_complain "Invalid time period."
        }
    }
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set ad_conn_url [ad_conn url]

set export [ns_queryget export]

if {$export eq "print"} {
    set view "list"
}

set return_url [ad_return_url]
set add_item_url [export_vars -base "cal-item-new" {{return_url [ad_return_url]} view date}]

set admin_p [permission::permission_p -object_id $package_id -privilege calendar_admin]

set show_calendar_name_p [parameter::get -parameter Show_Calendar_Name_p -default 1]

set date [calendar::adjust_date -date $date]

if {$view eq "list"} {
    if {$start_date eq ""} {
        set start_date $date
    }

    set ansi_list [split $start_date "- "]
    set ansi_year [lindex $ansi_list 0]
    set ansi_month [string trimleft [lindex $ansi_list 1] "0"]
    set ansi_day [string trimleft [lindex $ansi_list 2] "0"]
    set end_date [dt_julian_to_ansi [expr {[dt_ansi_to_julian $ansi_year $ansi_month $ansi_day ] + $period_days}]]
}
if { $user_id eq 0 } {
    set calendar_personal_p 0
} else {
    set calendar_personal_p [calendar::personal_p -calendar_id [lindex [calendar::calendar_list -package_id $package_id  ] 0 1] ]
}
set instance_name [ad_conn instance_name]

# Header stuff
template::head::add_css -href "/resources/calendar/calendar.css" -media all 
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
