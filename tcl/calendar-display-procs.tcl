
ad_library {

    Utility functions for Displaying Calendar Things

    NOTE: this needs some serious refactoring. This code is already refactored from Tcl scripts.
    I'm working as fast as I can to fix this, but there is a LOT to fix (ben).

    @author Ben Adida (ben@openforce)
    @creation-date Jan 21, 2002
    @cvs-id $Id$

}

namespace eval calendar {

    ad_proc -public one_month_display {
        {-calendar_id_list ""}
        {-day_template "<a href=?julian_date=\$julian_date>\$day_number</a>"}
        {-item_template "<a href=?action=edit&cal_item_id=\$item_id>\$item</a>"}
        {-item_add_template ""}
        {-date ""}
    } {
        Creates a month widget with events for that month
    } {
        if {[empty_string_p $date]} {
            set date [dt_systime]
        }

        # If we were given no calendars, we assume we display the 
        # private calendar. It makes no sense for this to be called with
        # no data whatsoever.
        if {[empty_string_p $calendar_id_list]} {
            set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
        }
        
        set items [ns_set create]
        
        # Loop through calendars
        foreach calendar_id $calendar_id_list {
            set calendar_name [calendar_get_name $calendar_id]

            db_foreach select_monthly_items {} {
                set item "$name"
                set item "[subst $item_template]<br>"

                ns_set put $items $start_date $item
            }            
        }
        
        # Display stuff
        if {[empty_string_p $item_add_template]} {
            set day_number_template "<font size=1>$day_template</font>"
        } else {
            set day_number_template "<font size=1>$item_add_template &nbsp; &nbsp; $day_template</font>"
        }

        return [dt_widget_month -calendar_details $items -date $date -day_number_template $day_number_template -today_bgcolor #cccccc]
    }

    ad_proc -public one_week_display {
        {-calendar_id_list ""}
        {-day_template "<a href=?date=\$julian>\$day</a>"}
        {-item_template "<a href=?action=edit&cal_item_id=\$item_id>\$item</a>"}
        {-item_add_template ""}
        {-date ""}
    } {
        Creates a week widget
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
        foreach calendar_id $calendar_id_list {
            set calendar_name [calendar_get_name $calendar_id]

            db_foreach select_week_items {} {
                set item "$pretty_start_date - $pretty_end_date: $name ($calendar_name)"
                set item "[subst $item_template]<br>"

                ns_set put $items $start_date $item
            }

        }

        # display stuff
        
        if {[empty_string_p $item_add_template]} {
            set day_number_template "$day_template"
        } else {
            set day_number_template "$day_template &nbsp; &nbsp; $item_add_template"
        }
        
        return [dt_widget_week -calendar_details $items -date $date -day_template $day_number_template -today_bgcolor #cccccc]
        
    }

    ad_proc -public one_day_display {
        {-date ""}
        {-calendar_id_list ""}
        {-hour_template {$hour}}
        {-item_template {$item}}
        {-start_hour 0}
        {-end_hour 23}
    } {
        Creates a day widget
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
        foreach calendar_id $calendar_id_list {
            set calendar_name [calendar_get_name $calendar_id]
            # ns_log Notice "bma: one calendar $calendar_name"

            db_foreach select_day_items {} {
                if {$pretty_start_date == "00:00" && $pretty_end_date == "00:00"} {
                    # Hack for no-time items
                    set item "$name ($calendar_name)"
                    set ns_set_pos "X"
                } else {
                    set item "$pretty_start_date - $pretty_end_date: $name ($calendar_name)"
                    set ns_set_pos $start_hour
                }

                set item [subst $item_template]

                # ns_log Notice "bma-calendar: adding $item at $start_hour"
                ns_set put $items $ns_set_pos $item
            }

        }

        set hour {$display_hour}
        set start_time {$hour}
        
        set hour_template [subst $hour_template]
        
        return [dt_widget_day -hour_template $hour_template \
                -start_hour $widget_start_hour -end_hour $widget_end_hour \
                -calendar_details $items -date $date]
        
    }

    ad_proc -public list_display {
        {-date ""}
        {-calendar_id_list ""}
        {-item_template {$item}}
    } {
        Creates a list widget
    } {
        if {[empty_string_p $date]} {
            set date [dt_sysdate]
        }

        set date_format "YYYY-MM-DD HH24:MI"
        set current_date $date

        # If we were given no calendars, we assume we display the 
        # private calendar. It makes no sense for this to be called with
        # no data whatsoever.
        if {[empty_string_p $calendar_id_list]} {
            set calendar_id_list [list [calendar_have_private_p -return_id 1 [ad_get_user_id]]]
        }
        
        set items [ns_set create]

        # Loop through the calendars
        foreach calendar_id $calendar_id_list {
            set calendar_name [calendar_get_name $calendar_id]
            # ns_log Notice "bma: one calendar $calendar_name"

            db_foreach select_day_items {} {
                # ns_log Notice "bma: one item"
                set item "$pretty_start_date - $pretty_end_date: $name ($calendar_name)"
                set item [subst $item_template]

                ns_set put $items $start_hour $item
            }

        }

        set return_html "Items for [util_AnsiDatetoPrettyDate $date]:<p><ul>\n"

        for {set i 0} {$i <= 23} {incr i} {
            if {$i < 10} {
                set index_hour "0$i"
            } else {
                set index_hour $i
            }

            while {1} {
                set index [ns_set find $items $index_hour]
                if {$index == -1} {
                    break
                }

                # ns_log Notice "bma: one item found !!"

                append return_html "<li> [ns_set value $items $index]\n"
                ns_set delete $items $index
            }
            append return_html "<p>"
        }

        append return_html "</ul>"

        return $return_html
    }
        
}