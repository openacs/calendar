
ad_library {

    Utility functions for Displaying Calendar Things

    @author Ben Adida (ben@openforce)
    @creation-date Jan 21, 2002
    @cvs-id $Id$

}

namespace eval calendar {

    ad_proc -public one_month_display {
        {-calendar_id_list ""}
        {-one_day_link ""}
        {-one_item_link ""}
        {-item_add_link ""}
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
                set item "$name ($calendar_name)"
                if {![empty_string_p $one_item_link]} {
                    set item "<a href=${one_item_link}$item_id>$item</a><br>"
                }

                ns_set put $items  $start_date $item
            }            
        }
        
        # Display stuff
        if {[empty_string_p $one_day_link]} {
            set one_day_template {$day_number}
        } else {
            set one_day_template "<a href=$one_day_link\$day_number>\$day_number</a>"
        }

        if {[empty_string_p $item_add_link]} {
            set day_number_template "<font size=1>$one_day_template</font>"
        } else {
            set day_number_template "<font size=1><a href=${item_add_link}>ADD</a> &nbsp; &nbsp; $one_day_template</font>"
        }

        return [dt_widget_month -calendar_details $items -date $date -day_number_template $day_number_template -today_bgcolor #cccccc]
    }

    ad_proc -public one_week_display {
        {-calendar_id_list ""}
        {-one_day_link ""}
        {-one_item_link ""}
        {-item_add_link ""}
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
                if {![empty_string_p $one_item_link]} {
                    set item "<a href=${one_item_link}$item_id>$item</a><br>"
                }

                ns_set put $items $start_date $item
            }

        }

        # display stuff
        if {[empty_string_p $one_day_link]} {
            set one_day_template {$day}
        } else {
            set one_day_template "<a href=$one_day_link\$julian>\$day</a>"
        }
        
        if {[empty_string_p $item_add_link]} {
            set day_number_template "$one_day_template"
        } else {
            set day_number_template "$one_day_template &nbsp; &nbsp; <a href=${item_add_link}>(ADD)</a>"
        }
        
        return [dt_widget_week -calendar_details $items -date $date -day_template $day_number_template -today_bgcolor #cccccc]
        
    }

    ad_proc -public one_day_display {
        {-date ""}
        {-calendar_id_list ""}
        {-one_hour_link ""}
        {-one_item_link ""}
    } {
        Creates a day widget
    } {
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

            db_foreach select_day_items {} {
                set item "$pretty_start_date - $pretty_end_date: $name ($calendar_name)"
                if {![empty_string_p $one_item_link]} {
                    set item "<a href=${one_item_link}$item_id>$item</a><br>"
                }

                ns_set put $items $start_hour $item
            }

        }

        return [dt_widget_day -calendar_details $items -date $date]
        
    }

}
