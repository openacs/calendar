# If we were given no calendars, we assume we display the 
# private calendar. It makes no sense for this to be called with
# no data whatsoever.
if {[empty_string_p $calendar_id_list]} {
    set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
}

# sort by cannot be empty
if {[empty_string_p $sort_by]} {
    set sort_by "item_type"
}

set date_format "YYYY-MM-DD HH24:MI"

# The title
if {[empty_string_p $start_date] && [empty_string_p $end_date]} {
    #This used to be All Items but that was just taking up space and not adding value so now we assume All Items and only give a title if its something else. - Caroline@meekshome.com
    set title ""
}

if {[empty_string_p $start_date] && ![empty_string_p $end_date]} {
    set title "Items until [util_AnsiDatetoPrettyDate $end_date]"
}

if {![empty_string_p $start_date] && [empty_string_p $end_date]} {
    set title "Items starting [util_AnsiDatetoPrettyDate $start_date]"
}

if {![empty_string_p $start_date] && ![empty_string_p $end_date]} {
    set title "Items from [util_AnsiDatetoPrettyDate $start_date] to [util_AnsiDatetoPrettyDate $end_date]"
}

set return_html ""

# Prepare the templates
set url_template "view?view=list&sort_by=\$sort_by"
set real_sort_by $sort_by
set sort_by "item_type"
set item_type_url [subst $url_template]
set sort_by "start_date"
set start_date_url [subst $url_template]

# initialize the item_type so we can do intermediate titles
set old_item_type ""

set flip 0

# Loop through the events, and add them
foreach calendar_id $calendar_id_list {
    set calendar_name [calendar_get_name $calendar_id]
    
    db_foreach select_list_items {} {
	set item_details "<a href=\"cal-item-view?cal_item_id=$item_id\">$name</a> ($calendar_name)"
	# Adjust the display of no-time items
	if {[dt_no_time_p -start_time $pretty_start_date -end_time $pretty_end_date]} {
	    set start_time "--"
	    set end_time "--"
	}
	
	# Do we need a title?
	if {$real_sort_by == "item_type" && $item_type != "$old_item_type"} {
	    if {[empty_string_p $item_type]} {
		set item_type_for_title "(No Item Type)"
	    } else {
		set item_type_for_title $item_type
	    }
	    append return_html "<tr class=\"table-title\"><td colspan=5><b>$item_type_for_title</b></td></tr>\n"
	    set flip 0
	}
	
	set old_item_type $item_type
	
	if {[expr $flip % 2] == 0} {
	    set z_class odd
	} else {
	    set z_class even
	}
	
	append return_html "
        <tr class=$z_class><td>$pretty_weekday</td><td>$pretty_start_date</td><td>$pretty_start_date</td><td>$pretty_end_date</td>"
	
	if {$real_sort_by != "item_type"} {
	    append return_html "<td>$item_type</td>"
	}
	
	append return_html "<td>$item_details</td></tr>\n"
	incr flip
    }
}	



