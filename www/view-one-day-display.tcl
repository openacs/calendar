set widget_start_hour $start_hour
set widget_end_hour $end_hour

set date_format "YYYY-MM-DD HH24:MI"

if {[empty_string_p $date]} {
    set date [dt_sysdate]
}

set current_date $date

# If we were given no calendars, we assume we display the 
# private calendar. It makes no sense for this to be called with
# no data whatsoever.
if {[empty_string_p $calendar_id_list]} {
    set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
}

set items [ns_set create]

# Loop through the calendars
db_foreach select_day_items {} {
    # Not needed anymore
    # set calendar_name [calendar_get_name $calendar_id]
    
    # In case we need to dispatch to a different URL (ben)
    if {![empty_string_p $url_stub_callback]} {
	# Cache the stuff
	if {![info exists url_stubs($calendar_id)]} {
	    set url_stubs($calendar_id) [$url_stub_callback $calendar_id]
		}
	
	set url_stub $url_stubs($calendar_id)
    }
    
    set item_details ""
    
    if {$show_calendar_name_p} {
	append item_details $calendar_name
    }
    
    if {![empty_string_p $item_type]} {
	if {![empty_string_p $item_details]} {
	    append item_details " - "
	}
	
	append item_details "$item_type"
    }
    
    set item $name
    set item_subst [subst $item_template]
    
    if {[dt_no_time_p -start_time $ansi_start_date -end_time $ansi_end_date]} {
	# Hack for no-time items
	set item "$item_subst"
	if {![empty_string_p $item_details]} {
	    append item " <font size=-1>($item_details)</font>"
	}
	
		set ns_set_pos "X"
    } else {
	set item "<b>$ansi_start_date - $ansi_end_date</b>: $item_subst"
	if {![empty_string_p $item_details]} {
	    append item " <font size=-1>($item_details)</font>"
	}
	set ns_set_pos $start_hour
    }
    
    if { [string length $status_summary] > 0 } {
	append item " <font color=\"red\">$status_summary</font> "
    }
    
    # ns_log Notice "bma-calendar: adding $item at $start_hour"
    ns_set put $items $ns_set_pos [list $start_date $end_date $item]
}

set hour {$display_hour}
set start_time {$hour}
set end_time {$next_hour}

set hour_template [subst $hour_template]

set foobar [dt_widget_day -hour_template $hour_template \
                -prev_nav_template $prev_nav_template \
                -next_nav_template $next_nav_template \
                -start_hour $widget_start_hour -end_hour $widget_end_hour \
                -calendar_details $items -date $date -overlap_p 1]

