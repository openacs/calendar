ad_page_contract {
    
    Creating a new Calendar Item

    @author Dirk Gomez (openacs@dirkgomez.de)
    @author Ben Adida (ben@openforce.net)
    @creation-date May 29, 2002
    @cvs-id $Id$
} {
    {calendar_id:integer ""}
    cal_item_id:integer,optional
    item_type_id:integer,optional
    {date ""}
    {julian_date ""}
    {start_time ""}
    {end_time ""}
}

if {![info exists item_type_id]} {
    set item_type_id ""
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set date [calendar::adjust_date -date $date -julian_date $julian_date]
set calendar_list [calendar::calendar_list]

if {![info exists cal_item_id]} {
    if {[llength $calendar_list] > 1 && [empty_string_p $calendar_id]} {
        set return_url [ad_urlencode "cal-item-new?date=[ns_urlencode $date]&start_time=$start_time&end_time=$end_time"]
        ad_returnredirect "calendar-choose?return_url=$return_url"
        ad_script_abort
    } else {
	set calendar_id [lindex [lindex $calendar_list 0] 1]
    }
} else {
    set calendar_id [db_string get_calendar_id {select 
         on_which_calendar as calendar_id
         from cal_items 
        where cal_item_id = :cal_item_id} -default ""]

}

if { [exists_and_not_null cal_item_id] } {
    set page_title "One calendar item"
    set ad_form_mode display
} else {
    set page_title "Add a calendar item"
    set ad_form_mode edit
}

ad_form -name cal_item  -form {
    cal_item_id:key

    {title:text(text)
        {label "[_ calendar.Title_1]"}
        {html {size 60} maxlength 255}
    }

    {date:date
        {label "[_ calendar.Date_1]"}
    }

    {time_p:text(radio)     
        {label "&nbsp;"}
        {html {onchange "javascript:TimePChanged();"}} 
        {options {{"[_ calendar.All_Day_Event]" 0}
                  {"[_ calendar.Use_Hours_Below]" 1} }}
    }

    {start_time:date,optional
        {label "[_ calendar.Start_Time]"}
        {format {[lc_get formbuilder_time_format]}}
    }

    {end_time:date,optional
        {label "[_ calendar.End_Time]"}
        {format {[lc_get formbuilder_time_format]}}
    }

    {description:text(textarea),optional
        {label "[_ calendar.Description]"}
        {html {cols 60 rows 3 wrap soft} maxlength 255}
    }

    {repeat_p:text(radio)     
        {label "[_ calendar.Repeat_1]"}
        {options {{"[_ calendar.Yes]" 1}
                  {"[_ calendar.No]" 0} }}
    }

    {calendar_id:text(hidden) {value $calendar_id}}
}

set cal_item_types [calendar::get_item_types -calendar_id $calendar_id]

if {[llength $cal_item_types] > 1} {
    ad_form -extend -name cal_item -form {
        {item_type_id:integer(select),optional
            {label "[_ calendar.Type_1]"}
            {options {$cal_item_types}}
        }
    }
}


ad_form -extend -name cal_item -validate { 
    {title {[string length $title] <= 4000}
        " TITLE MUST BE 4"
    }
} -new_request {
    set date [template::util::date::from_ansi $date]
    set time_p 0
    set repeat_p 0
} -edit_request {
    calendar::item::get -cal_item_id $cal_item_id -array cal_item
    set cal_item_id $cal_item(cal_item_id)
    set n_attachments $cal_item(n_attachments)
    set ansi_start_date $cal_item(start_date_ansi)
    set ansi_end_date $cal_item(end_date_ansi)
    set start_time $cal_item(start_time)
    set end_time $cal_item(end_time)
    set title $cal_item(name)
    set description $cal_item(description)
    set repeat_p $cal_item(recurrence_id)
    set item_type $cal_item(item_type)
    set item_type_id $cal_item(item_type_id)
    set calendar_id $cal_item(calendar_id)

    if {[string equal $start_time "12:00 AM"] && [string equal $end_time "12:00 AM"]} {
        set time_p 0
    } else {
        set time_p 1
    }

    if {[empty_string_p $repeat_p]} {
        set repeat_p 0
    } else {
        set repeat_p 1
    }
    set date [template::util::date::from_ansi $ansi_start_date]
    set start_time [template::util::date::from_ansi $ansi_start_date [lc_get formbuilder_time_format]]
    set end_time [template::util::date::from_ansi $ansi_end_date [lc_get formbuilder_time_format]]
} -new_data {
    set start_date [calendar::to_sql_datetime -date $date -time $start_time -time_p $time_p]
    set end_date [calendar::to_sql_datetime -date $date -time $end_time -time_p $time_p]

    set cal_item_id [calendar::item::new -start_date $start_date \
            -end_date $end_date \
            -name $title \
            -description $description \
            -calendar_id $calendar_id \
            -item_type_id $item_type_id]
} -edit_data {
    # set up the datetimes
    set start_date [calendar::to_sql_datetime -date $date -time $start_time -time_p $time_p]
    set end_date [calendar::to_sql_datetime -date $date -time $end_time -time_p $time_p]

    # Do the edit
    calendar::item::edit -cal_item_id $cal_item_id \
            -start_date $start_date \
            -end_date $end_date \
            -name $title \
            -description $description \
            -item_type_id $item_type_id \
            -edit_all_p $repeat_p
} -after_submit {
    if {$repeat_p} {
        ad_returnredirect "cal-item-create-recurrence?cal_item_id=$cal_item_id"
    } else {
        ad_returnredirect "cal-item-view?cal_item_id=$cal_item_id"
    }
    ad_script_abort
}


ad_return_template
