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
        
set day_template "<font size=-1><b>\$day</b> - <a href=\"view?date=\[ns_urlencode \$date]&view=day\">\$pretty_date</a> &nbsp; &nbsp; <a href=\"cal-item-new?date=\$date&start_time=&end_time=\">([_ calendar.Add_Item])</a></font>"

set foobar [dt_widget_week -calendar_details $items -date $date -day_template $day_template ]
