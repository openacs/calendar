
ad_page_contract {
    
    Viewing Calendar Stuff
    
    @author Ben Adida (ben@openforce.net)
    @creation-date May 29, 2002
    @cvs-id $Id$
} {
    {view day}
    {date ""}
    {julian_date ""}
    {calendar_list:multiple ""}
    {sort_by ""}
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

set calendar_list [calendar::adjust_calendar_list -calendar_list $calendar_list -package_id $package_id -user_id $user_id]
set date [calendar::adjust_date -date $date -julian_date $julian_date]

# Calendar ID list

# Set up some template
set item_template "<a href=\"cal-item-view?cal_item_id=\$item_id\">\$item</a>"
set hour_template "<a href=\"cal-item-new?date=\[ns_urlencode \$date]&start_time=\$start_time&end_time=\$end_time\">\$hour</a>"
set item_add_template "<a href=\"cal-item-new?julian_date=\$julian_date&start_time=&end_time=\" title=\"[_ calendar.Add_Item]\"><img border=0 align=\"right\" valign=\"top\" src=\"/shared/images/add.gif\" alt=\"[_ calendar.Add_Item]\"></a>"


# Depending on the view, make a different widget
if {$view == "day"} {

    # Check that the previous and next days are in the tcl boundaries
    # so that the calendar widget doesn't bomb when it creates the next/prev links
    if {[catch {set yest [clock format [clock scan "1 day ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set previous_link ""
    } else {
	if {[catch {clock scan $yest}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=\"view?view=$view&date=\[ns_urlencode \$yesterday]\">&lt;</a>"
	}
    }

    if {[catch {set tomor [clock format [clock scan "1 day" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set next_link ""
    } else {
	if {[catch {clock scan $tomor}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=\"view?view=$view&date=\[ns_urlencode \$tomorrow]\">&gt;</a>"
	}
    }
}

if {$view == "week"} {

    # Check that the previous and next weeks are in the tcl boundaries
    # so that the calendar widget doesn't bomb when it creates the next/prev links
    if {[catch {set prev_w [clock format [clock scan "1 week ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set previous_link ""
    } else {
	if {[catch {clock scan $prev_w}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=\"view?date=\[ns_urlencode \$last_week]&view=week\">&lt;</a>"
	}
    }

    if {[catch {set next_w [clock format [clock scan "1 week" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set next_link ""
    } else {
	if {[catch {clock scan $next_w}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=\"view?date=\[ns_urlencode \$next_week]&view=week\">&gt;</a>"
	}
    }
}

if {$view == "month"} {
    
    # Check that the previous and next months are in the tcl boundaries
    # so that the calendar widget doesn't bomb when it creates the next/prev links
    if {[catch {set prev_m [clock format [clock scan "1 month ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set previous_link ""
    } else {
	if {[catch {clock scan $prev_m}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=view?view=month&date=\$ansi_date>&lt;</a>"
	}
    }

    if {[catch {set next_m [clock format [clock scan "1 month" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set next_link ""
    } else {
	if {[catch {clock scan $next_m}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=view?view=month&date=\$ansi_date>&gt;</a>"
	}
    }

}

if {$view == "list"} {
    set start_date $date
    set ansi_list [split $date "- "]
    set ansi_year [lindex $ansi_list 0]
    set ansi_month [string trimleft [lindex $ansi_list 1] "0"]
    set ansi_day [string trimleft [lindex $ansi_list 2] "0"]
    set end_date [dt_julian_to_ansi [expr [dt_ansi_to_julian $ansi_year $ansi_month $ansi_day ] + 31]]
}

set cal_nav [dt_widget_calendar_navigation "view" $view $date "calendar_list="]

ad_return_template 
