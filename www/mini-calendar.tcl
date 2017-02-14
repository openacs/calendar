if {![info exists base_url] || $base_url eq ""} {
    set base_url [ad_conn url]
}

if {![info exists date] || $date eq ""} {
    set date [dt_sysdate]
}

ad_form -name go-to-date -method get -has_submit 1 -action $base_url  \
    -export [lappend list_of_vars page_num] \
    -html {class inline-form} \
    -form {
        {date:text,nospell,optional
            {label "[_ acs-datetime.Date]"}
            {html {size 10}}
        }
        {btn_ok:text(submit)
            {label "[_ calendar.Go_to_date]"}
        } 
        {view:text(hidden)
            {value "day"}
        }
    } -on_submit {}


if {[info exists page_num] && $page_num ne ""} {
    set page_num_formvar [export_vars -form {page_num}]
    set page_num "&page_num=$page_num"
} else {
    set page_num_formvar ""
    set page_num ""
}

# Determine whether we need to pass on the period_days variable from the list view
if {$view eq "list"} {
    if {(![info exists period_days] || $period_days eq "") 
	|| $period_days eq [parameter::get -parameter ListView_DefaultPeriodDays -default 31]
    } {
	set url_stub_period_days ""
    } else {
	set url_stub_period_days "&period_days=${period_days}"
    }
} else {
    set url_stub_period_days ""
}

array set message_key_array {
    list #acs-datetime.List#
    day #acs-datetime.Day#
    week #acs-datetime.Week#
    month #acs-datetime.Month#
}

# Create row with existing views
multirow create views name text active_p url
foreach viewname {list day week month} {
    if {$viewname eq $view} {
        set active_p t
    } else {
        set active_p f
    }
    if {$viewname eq "list"} {
	multirow append views [lang::util::localize $message_key_array($viewname)] $viewname $active_p \
	    "[export_vars -base $base_url {date {view $viewname}}]${page_num}${url_stub_period_days}"
    } else {
	multirow append views [lang::util::localize $message_key_array($viewname)] $viewname $active_p \
	    "[export_vars -base $base_url {date {view $viewname}}]${page_num}"
    }
}

set list_of_vars [list]

# Get the current month, day, and the first day of the month
if {[catch {
    dt_get_info $date
} errmsg]} {
    set date [dt_sysdate]
    dt_get_info $date
}

set now              [clock scan $date]
set date_list        [dt_ansi_to_list $date]
set year             [util::trim_leading_zeros [lindex $date_list 0]]
set month            [util::trim_leading_zeros [lindex $date_list 1]]
set day              [util::trim_leading_zeros [lindex $date_list 2]]

set months_list      [dt_month_names]
set curr_month_idx   [expr [util::trim_leading_zeros [clock format $now -format "%m"]]-1]
set curr_day         [clock format $now -format "%d"]
set curr_month       [clock format $now -format "%B"]
set curr_year        [clock format $now -format "%Y"]
set curr_date_pretty [lc_time_fmt $date "%q"]

set today [lc_time_fmt [dt_sysdate] "%q"]

if {$view eq "month"} {
    set prev_year [clock format [clock scan "1 year ago" -base $now] -format "%Y-%m-%d"]
    set next_year [clock format [clock scan "1 year" -base $now] -format "%Y-%m-%d"]
    set prev_year_url "$base_url?view=$view&date=[ad_urlencode $prev_year]${page_num}${url_stub_period_days}"
    set next_year_url "$base_url?view=$view&date=[ad_urlencode $next_year]${page_num}${url_stub_period_days}"
    set now       [clock scan $date]

    multirow create months name current_month_p new_row_p url

    for {set i 0} {$i < 12} {incr i} {

        set month [lindex $months_list $i]

        # show 3 months in a row
        set new_row_p [expr {$i / 3}]

        if {$i == $curr_month_idx} {
            set current_month_p t 
        } else {
            set current_month_p f
        }
        set target_date [clock format \
                             [clock scan "[expr {$i-$curr_month_idx}] month" -base $now] -format "%Y-%m-%d"]
        multirow append months $month $current_month_p $new_row_p  \
            "[export_vars -base $base_url {{date $target_date} view}]${page_num}${url_stub_period_days}"
        
    }
} else {
    set prev_month [clock format [clock scan "1 month ago" -base $now] -format "%Y-%m-%d"]
    set next_month [clock format [clock scan "1 month" -base $now] -format "%Y-%m-%d"]
    set prev_month_url "$base_url?view=$view&date=[ad_urlencode $prev_month]${page_num}${url_stub_period_days}"
    set next_month_url "$base_url?view=$view&date=[ad_urlencode $next_month]${page_num}${url_stub_period_days}"
    
    set first_day_of_week [lc_get firstdayofweek]
    set week_days [lc_get abday]
    set long_weekdays [lc_get day]
    multirow create days_of_week day_short day_num
    for {set i 0} {$i < 7} {incr i} {
        multirow append days_of_week \
            [lindex $week_days [expr {($i + $first_day_of_week) % 7}]] \
            $i
    }

    multirow create days day_number beginning_of_week_p end_of_week_p today_p active_p url weekday day_num pretty_date id

    set day_of_week 1

    # Calculate number of active days
    set active_days_before_month [expr {[dt_first_day_of_month $year $month] - 1} ]
    set active_days_before_month [expr {($active_days_before_month + 7 - $first_day_of_week) % 7}]

    set calendar_starts_with_julian_date [expr {$first_julian_date_of_month - $active_days_before_month}]
    set day_number [expr {$days_in_last_month - $active_days_before_month + 1}]

    for {set julian_date $calendar_starts_with_julian_date} {$julian_date <= $last_julian_date + 7} {incr julian_date} {
        if {$julian_date > $last_julian_date_in_month && $end_of_week_p == "t" } {
            break
        }
        set today_p f
        set active_p t

        if {$julian_date < $first_julian_date_of_month} {
            set active_p f
        } elseif {$julian_date > $last_julian_date_in_month} {
            set active_p f
        } 
        set ansi_date [dt_julian_to_ansi $julian_date]
        set pretty_date [lc_time_fmt $ansi_date %Q]
        
        if {$julian_date == $first_julian_date_of_month} {
            set day_number 1
        } elseif {$julian_date == $last_julian_date_in_month + 1} {
            set day_number 1
        }

        if {$julian_date == $julian_date_today} {
            set today_p t
        }

        set day_num [expr { $day_of_week - 1 }]
        if { $day_of_week == 1} {
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

        set weekday [lindex $long_weekdays $day_of_week]
        set url "[export_vars -base $base_url {{date $ansi_date} view}]${page_num}${url_stub_period_days}"
        multirow append days $day_number $beginning_of_week_p $end_of_week_p $today_p $active_p \
            $url \
            $weekday \
            $day_num \
            $pretty_date \
            mini-calendar-$ansi_date

        template::add_body_script -script [subst {
            var e =  document.getElementById('mini-calendar-$ansi_date');
            e.addEventListener('click', function (event) {
                event.preventDefault();
                location.href = '$url#calendar';
            });
            e.addEventListener('keypress', function (event) {
                event.preventDefault();
                acs_KeypressGoto('$url#calendar',event);
            });
        }]
        
        incr day_number
        incr day_of_week
    }
}

set today_url "$base_url?view=day&date=[ad_urlencode [dt_sysdate]]${page_num}${url_stub_period_days}"

if { $view eq "day" && [dt_sysdate] eq $date } {
    set today_p t
} else {
    set today_p f
}


set form_vars ""
foreach var $list_of_vars {
    append form_vars "<INPUT TYPE=hidden name=[lindex $var 0] value=[lindex $var 1]>"
}

ad_form -name choose_new_date -show_required_p f -has_edit 0 -has_submit 0 -form {
    {new_date:date
        {label ""}
        {format {MM DD YYYY}}}
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
