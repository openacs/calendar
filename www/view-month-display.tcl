#        Creates a month widget with events for that month
#
#        The url_stub_callback parameter allows a parameterizable URL stub
#        for each calendar_id. If the parameter is non-null, it is considered a proc
#        that can be called on a calendar_id to generate a URL stub.


if {![info exists date] || [empty_string_p $date]} {
    set date [dt_systime]
}

if {![info exists day_template] || [empty_string_p $day_template]} {
    set day_template "<a href=?julian_date=\$julian_date>\$day_number</a>"
}

if {![info exists item_template] || [empty_string_p $item_template]} {
	    set item_template "<a href=?action=edit&cal_item_id=\$item_id>\$item</a>"
}

if {![info exists show_calendar_name_p] || [empty_string_p $show_calendar_name_p]} {
    set show_calendar_name_p 1
}
# If we were given no calendars, we assume we display the 
# private calendar. It makes no sense for this to be called with
# no data whatsoever.
if {![info exists calendar_id_list] || [empty_string_p $calendar_id_list]} {
    set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
}
        
set items [ns_set create]
db_foreach select_monthly_items {} {
    # Calendar name now set in query
    # set calendar_name [calendar_get_name $calendar_id]
    
    # reset url stub
    set url_stub ""
    
    # In case we need to dispatch to a different URL (ben)
    if {[info exists url_stub_callback] && ![empty_string_p $url_stub_callback]} {
	# Cache the stuff
	if {![info exists url_stubs($calendar_id)]} {
	    set url_stubs($calendar_id) [$url_stub_callback $calendar_id]
	}
	
	set url_stub $url_stubs($calendar_id)
    }
    
    set item "$name"
    set item "[subst $item_template]"
    
    if {![dt_no_time_p -start_time $ansi_start_date -end_time $ansi_end_date]} {
	set item "<font size=-2><b>$ansi_start_date</b></font> $item"
    }
    
    if {$show_calendar_name_p} {
	append item " <font size=-2>($calendar_name)</font>"
    }
    
    # DRB: This ugly hack was added for dotlrn-events, to give us a way to
    # flag event status in red in accordance with the spec.  When calendar
    # is rewritten we should come up with a way for objects derived from
    # acs-events to render their own name summary and full descriptions.
    
    if { [string length $status_summary] > 0 } {
	append item " <font color=\"red\">$status_summary</font> "
	    }
    
    append item "<br>"
    
    ns_set put $items $start_date $item
}
    
    
# Display stuff
set day_number_template "<font size=1>$day_template</font>"

set foobar [dt_widget_month -calendar_details $items -date $date \
                -master_bgcolor black \
		-header_bgcolor lavender \
		-header_text_color black \
		-header_text_size "+1" \
		-day_header_bgcolor lavender \
		-day_bgcolor white \
		-today_bgcolor #FFF8DC \
		-empty_bgcolor lightgrey \
		-day_text_color black \
		-prev_next_links_in_title 1 \
		-day_number_template $day_number_template]

