
ad_page_contract {
    
    Viewing Calendar Stuff
    
    @author Ben Adida (ben@openforce)
    @creation-date May 29, 2002
    @cvs-id $Id$
} {
    {view day}
    {date ""}
    {julian_date ""}
    {calendar_list:multiple,optional {}}
}

set package_id [ad_conn package_id]

if {[empty_string_p $date]} {
    if {![empty_string_p $julian_date]} {
        set date [dt_julian_to_ansi $julian_date]
    } else {
        set date [dt_sysdate]
    }
}

# Calendar ID list

# Set up some template
set item_template "<a href=\"cal-item?cal_item_id=\$item_id\">\$item</a>"
set hour_template "<a href=\"cal-item-add?date=$date&start_time=\$start_time&end_time=\$end_time\">\$hour</a>"
set item_add_template "<a href=\"cal-item-add?julian_date=\$julian_date&start_time=&end_time=\">ADD</a>"

# Depending on the view, make a different widget
if {$view == "day"} {
    set cal_stuff [calendar::one_day_display \
            -prev_nav_template "<a href=\"?view=$view&date=\$yesterday\">&lt;</a>" \
            -next_nav_template "<a href=\"?view=$view&date=\$tomorrow\">&gt;</a>" \
            -item_template $item_template \
            -hour_template $hour_template \
            -date $date -start_hour 7 -end_hour 22 \
            -calendar_id_list $calendar_list]

}

if {$view == "week"} {
    set cal_stuff [calendar::one_week_display \
            -item_template $item_template \
            -day_template "<font size=-1><b>\$day</b> - <a href=\"view?date=\$date&view=day\">\$pretty_date</a> &nbsp; &nbsp; <a href=\"cal-item-add?date=\$date&start_time=&end_time=\">(Add Item)</a></font>" \
            -date $date \
            -calendar_id_list $calendar_list \
            -prev_week_template "<a href=\"?date=\$last_week&view=week\">&lt;</a>" \
            -next_week_template "<a href=\"?date=\$next_week&view=week\">&gt;</a>"
    ]
}

if {$view == "month"} {
    set cal_stuff [calendar::one_month_display \
            -item_template "<font size=-2>$item_template</font>" \
            -day_template "<font size=-1><b><a href=view?julian_date=\$julian_date&view=day>\$day_number</a></b></font>" \
            -date $date \
            -item_add_template "<font size=-3>$item_add_template</font>" \
            -calendar_id_list $calendar_list \
            -prev_month_template "<a href=view?view=month&date=\$ansi_date>&lt;</a>" \
            -next_month_template "<a href=view?view=month&date=\$ansi_date>&gt;</a>"]
}

if {$view == "list"} {
    set sort_by [ns_queryget sort_by]

    set cal_stuff [calendar::list_display \
            -item_template $item_template \
            -date $date \
            -calendar_id_list $calendar_list \
            -sort_by $sort_by \
            -url_template "?view=list&sort_by=\$order_by"]
}

set cal_nav [dt_widget_calendar_navigation "view" $view $date "calendar_list="]

ad_return_template 





































