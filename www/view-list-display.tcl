ad_include_contract {
    Display list calendar view

    Expects:
      date: ignored, looks like passed in for symmetry
      start_date: starting date for the list
      period_days:integer
      show_calendar_name_p (optional): 0 or 1
      calendar_id_list: optional list of calendar_ids
      export: may be "print"
} {
    {period_days:integer,notnull {[parameter::get -parameter ListView_DefaultPeriodDays -default 31]}}
    {show_calendar_name_p:boolean 1}
    {sort_by "start_date"}
    {start_date {[clock format [clock seconds] -format "%Y-%m-%d 00:00"]}}
    {cal_system_type ""}
    {date:optional}
    {calendar_id_list ""}
    {export ""}
    {return_url:optional}
} -validate {
    valid_period_days -requires { period_days } {
        # Tcl allows in for relative times just 6 digits, including the "+"
        if {$period_days > 99999} {
            ad_complain "Invalid time period"
        }
    }
    valid_start_date -requires { start_date } {
        if {[catch {clock scan $start_date} errorMsg]} {
            ad_complain "invalid start date"
        }
    }
}

#
# sort_by is passed down, maybe as empty
#
if {$sort_by eq ""} {
    set sort_by "start_date"
}

if { $calendar_id_list ne "" } {
    set calendars_clause [db_map dbqd.calendar.www.views.openacs_in_portal_calendar]
} else {
    set calendars_clause [db_map dbqd.calendar.www.views.openacs_calendar]
}

set end_date [clock format [clock scan "+${period_days} days" -base [clock scan $start_date]] -format "%Y-%m-%d 00:00"]
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

# The title
if {$start_date eq "" && $end_date eq ""} {
    set title ""
}

if {$start_date eq "" && $end_date ne ""} {
    set title "[_ acs-datetime.to] [lc_time_fmt $end_date "%q"]"
}

if {$start_date ne "" && $end_date eq ""} {
    set title "[_ acs-datetime.Items_from] [lc_time_fmt $start_date "%q"]"
}

if {$start_date ne "" && $end_date ne ""} {
    set title "[_ acs-datetime.Items_from] [lc_time_fmt $start_date "%q"] [_ acs-datetime.to] [lc_time_fmt $end_date "%q"]"
}

set today_date [dt_sysdate]
set today_ansi_list [dt_ansi_to_list $today_date]
set today_julian_date [dt_ansi_to_julian [lindex $today_ansi_list 0] [lindex $today_ansi_list 1] [lindex $today_ansi_list 2]]

set view list
set form_vars [export_vars -form -entire_form -exclude {period_days}]
set url_vars [export_vars -entire_form -exclude {period_days}]

multirow create items \
    event_name \
    event_url \
    calendar_name \
    item_type \
    weekday \
    start_date \
    end_date \
    start_time \
    end_time \
    today \
    description \
    calendar_name

set last_pretty_start_date ""
# Loop through the events, and add them

set interval_limitation_clause [db_map dbqd.calendar.www.views.list_interval_limitation]
set order_by_clause " order by $sort_by"
set additional_limitations_clause ""
if { $cal_system_type ne "" } {
    append additional_limitations_clause " and system_type = :cal_system_type "
}

set additional_select_clause " , to_char(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') as ansi_today, recurrence_id"

db_foreach dbqd.calendar.www.views.select_items {} {
    # Timezonize
    set ansi_start_date [lc_time_system_to_conn $ansi_start_date]
    set ansi_end_date [lc_time_system_to_conn $ansi_end_date]
    set ansi_today [lc_time_system_to_conn $ansi_today]

    # Localize
    set pretty_weekday [lc_time_fmt $ansi_start_date "%A"]
    set pretty_start_date [lc_time_fmt $ansi_start_date "%Q"]
    set pretty_end_date [lc_time_fmt $ansi_end_date "%Q"]
    set pretty_start_time [lc_time_fmt $ansi_start_date "%X"]
    set pretty_end_time [lc_time_fmt $ansi_end_date "%X"]
    set pretty_today [lc_time_fmt $ansi_today "%Q"]

    set start_date_seconds [clock scan [lc_time_fmt $ansi_start_date "%Y-%m-%d"]]
    set today_seconds [clock scan [lc_time_fmt $ansi_today "%Y-%m-%d"]]

    # Adjust the display of no-time items
    if {[dt_no_time_p -start_time $pretty_start_date -end_time $pretty_end_date]} {
        set pretty_start_time "--"
        set pretty_end_time "--"
    }

    if {$pretty_start_time eq "00:00"} {
        set pretty_start_time "--"
    }

    if {$pretty_end_time eq "00:00"} {
        set pretty_end_time "--"
    }

    if {$pretty_start_date ne $last_pretty_start_date } {
        set last_pretty_start_date $pretty_start_date
    }

    # Give the row different appearance depending on whether it's before today, today, or after today
    if {$start_date_seconds == $today_seconds} {
        set today cal-row-hi
    } elseif {$start_date_seconds < $today_seconds} {
        set today cal-row-lo
    } else {
        set today ""
    }

    set event_url [export_vars -base [site_node::get_url_from_object_id -object_id $cal_package_id]cal-item-view {
        return_url {cal_item_id $item_id}
    }]

    if { !$show_calendar_name_p } {
        set calendar_name ""
    }

    multirow append items \
        $name \
        $event_url \
        $calendar_name \
        $item_type \
        $pretty_weekday \
        $pretty_start_date \
        $pretty_end_date \
        $pretty_start_time \
        $pretty_end_time \
        $today \
    $description \
        $calendar_name
}

template::list::create -name "items-list" -multirow items -no_data [_ calendar.No_Items] -caption $title -elements {
    start_date {
        label "[_ calendar.Date_1]"
    }
    time {
        label "[_ calendar.Time_1]"
        display_template {
              <if @items.start_time@ ne @items.end_time@>
                @items.start_time@ &ndash; @items.end_time@
              </if>
              <else>
                #calendar.All_Day_Event#
              </else>
        }
    }
    event {
        label "[_ calendar.Event]"
        display_col event_name
        link_url_col event_url
        link_html {title "#calendar.goto_items_event_name#"}
    }
    calendar {
        label "[_ calendar.Calendar]"
        display_col calendar_name
    }
    description {
        label "[_ calendar.Description]"
        display_template {@items.description;noquote@}
    }
}

set start_year [lc_time_fmt $start_date "%Y"]
set start_month [lc_time_fmt $start_date "%B"]
set start_day [lc_time_fmt $start_date "%d"]
set end_year [lc_time_fmt $end_date "%Y"]
set end_month [lc_time_fmt $end_date "%B"]
set end_day [lc_time_fmt $end_date "%d"]

set self_url [ad_conn url]

# URLs for period picker
foreach i {1 7 14 21 30 60} {
    set period_url_$i "[export_vars -base $self_url -url -entire_form {{period_days $i}}]\#calendar"
}

if { $export eq "print" } {
    set print_html [template::adp_parse [acs_root_dir]/packages/calendar/www/view-print-display \
                        [list &items items show_calendar_name_p $show_calendar_name_p]]
    ns_return 200 text/html $print_html
    ad_script_abort
}


set excluded_vars {}
set the_form [ns_getform]
if { $the_form ne "" } {
    for { set i 0 } { $i < [ns_set size $the_form] } { incr i } {
        set varname [ns_set key $the_form $i]
        if {$varname eq "period_days" ||
            [string match "__*" $varname] ||
            [string match "form:*" $varname]} {
            lappend excluded_vars $varname
        }
    }
}

set exported_vars [export_vars -entire_form -no_empty -form -exclude $excluded_vars]

ad_form -name frmdays -has_submit 1 -html {class "inline-form"} -form {
    {period_days:integer,optional
        {label "[_ calendar.days]"}
        {html {size 3 maxlength 3 class "cal-input-field"}}
        {value "$period_days"}
    }
} -on_submit { }

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
