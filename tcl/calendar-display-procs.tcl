
ad_library {

    Utility functions for Displaying Calendar Things
    NOTE: this needs some serious refactoring. This code is already refactored from Tcl scripts.
    I'm working as fast as I can to fix this, but there is a LOT to fix (ben).


    @author Ben Adida (ben@openforce.net)
    @creation-date Jan 21, 2002
    @cvs-id $Id$

}

namespace eval calendar {

    ad_proc -public one_week_display {
        {-calendar_id_list ""}
        {-day_template "<a href=?date=\$date>\$day &nbsp; - &nbsp; \$pretty_date</a>"}
        {-item_template "<a href=?action=edit&cal_item_id=\$item_id>\$item</a>"}
        {-item_add_template ""}
        {-date ""}
        {-url_stub_callback ""}
        {-prev_week_template ""}
        {-next_week_template ""}
        {-show_calendar_name_p 1}
    } {
        Creates a week widget

        The url_stub_callback parameter allows a parameterizable URL stub
        for each calendar_id. If the parameter is non-null, it is considered a proc
        that can be called on a calendar_id to generate a URL stub.
    } {
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

        # This isn't going to be pretty. First we make it work, though. (ben)

        db_1row select_weekday_info {}

        # Loop through the calendars
	db_foreach select_week_items {} {
	    ns_log Notice "ONE WEEK ITEM"

	    # now selected from the query
	    # set calendar_name [calendar_get_name $calendar_id]
	    
	    # In case we need to dispatch to a different URL (ben)
	    if {![empty_string_p $url_stub_callback]} {
		# Cache the stuff
		if {![info exists url_stubs($calendar_id)]} {
		    set url_stubs($calendar_id) [$url_stub_callback $calendar_id]
		}

		set url_stub $url_stubs($calendar_id)
	    }
	    
	    set item "$name"
	    set item_details "[subst $item_template]"
	    
	    # Add time details
	    if {[dt_no_time_p -start_time $start_date -end_time $end_date]} {
		set time_details ""
	    } else {
		set time_details "<b>$ansi_start_date - $ansi_end_date</b>:"
	    }
	    
	    set item "$time_details $item_details"
	    
	    if {$show_calendar_name_p} {
		append item "<font size=-1>($calendar_name)</font><br>"
	    }
	    
	    if { [string length $status_summary] > 0 } {
		append item " <font color=\"red\">$status_summary</font> "
	    }
	    
	    ns_set put $items $start_date_julian $item
        }

        # display stuff
        
        if {[empty_string_p $item_add_template]} {
            set day_number_template "$day_template"
        } else {
            set day_number_template "$day_template &nbsp; &nbsp; $item_add_template"
        }
        
        return [dt_widget_week -calendar_details $items -date $date -day_template $day_number_template -prev_week_template $prev_week_template -next_week_template $next_week_template]
        
    }

    ad_proc -public one_day_display {
        {-date ""}
        {-calendar_id_list ""}
        {-hour_template {$hour}}
        {-item_template {$item}}
        {-prev_nav_template {<a href=".?date=[ns_urlencode $yesterday]"><img border=0 src=\"[dt_left_arrow]\" alt=\"back one day\"></a>}}
        {-next_nav_template {<a href=".?date=[ns_urlencode $tomorrow]"><img border=0 src=\"[dt_right_arrow]\" alt=\"forward one day\"></a>}}
        {-start_hour 0}
        {-end_hour 23}
        {-url_stub_callback ""}
        {-show_calendar_name_p 1}
    } {
        Creates a day widget

        The url_stub_callback parameter allows a parameterizable URL stub
        for each calendar_id. If the parameter is non-null, it is considered a proc
        that can be called on a calendar_id to generate a URL stub.
    } {
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
        
        return [dt_widget_day -hour_template $hour_template \
                -prev_nav_template $prev_nav_template \
                -next_nav_template $next_nav_template \
                -start_hour $widget_start_hour -end_hour $widget_end_hour \
                -calendar_details $items -date $date -overlap_p 1]
        
    }
}
