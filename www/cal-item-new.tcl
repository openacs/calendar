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
auth::require_login

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

if { [string equal $calendar_id "-1"] || [empty_string_p $calendar_id]} {
    # Seamlessly create a private calendar if the user doesn't have one

    if { ![calendar_have_private_p $user_id] } {
	calendar::new -owner_id $user_id -private_p "t" -calendar_name "Personal" -package_id $package_id
    } 
} else {
    ad_require_permission $calendar_id cal_item_create
}

if {![info exists item_type_id]} {
    set item_type_id ""
}

set date [calendar::adjust_date -date $date -julian_date $julian_date]
set ansi_date $date
set calendar_list [calendar::calendar_list]


# TODO: Move into ad_form
if { ![ad_form_new_p -key cal_item_id] } {
    set calendar_id [db_string get_calendar_id {
        select on_which_calendar as calendar_id
         from  cal_items 
        where  cal_item_id = :cal_item_id
    } -default ""]
}

# TODO: Move into ad_form
if { [exists_and_not_null cal_item_id] } {
    set page_title "One calendar item"
    set ad_form_mode display
} else {
    set page_title "Add a calendar item"
    set ad_form_mode edit
}

ad_form -name cal_item  -form {
    {cal_item_id:key}

    {title:text(text)
        {label "[_ calendar.Title_1]"}
        {html {size 60} maxlength 255}
    }

    {date:date
        {label "[_ calendar.Date_1]"}
    }

    {time_p:text(radio)     
        {label "&nbsp;"}
        {html {onClick "javascript:TimePChanged(this);"}} 
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

    {calendar_id:integer(radio)
        {label "[_ calendar.Sharing]"}
        {options $calendar_list}
    }
}

if { [ad_form_new_p -key cal_item_id] } {
    ad_form -extend -name cal_item -form {
        {repeat_p:text(radio)     
            {label "[_ calendar.Repeat_1]"}
            {options {{"[_ calendar.Yes]" 1}
                {"[_ calendar.No]" 0} }}
        }
    }
} else {
    ad_form -extend -name cal_item -form {
        {edit_all_p:text(radio)     
            {label "[_ calendar.Apply_to_all]"}
            {options {{"[_ calendar.Yes]" 1}
                {"[_ calendar.No]" 0} }}
        }
    }
}


#----------------------------------------------------------------------
# LARS: Hack to make enable/disable time widgets work with i18n
#----------------------------------------------------------------------

set format_string [lc_get formbuilder_time_format]

multirow create time_format_elms name

while { ![empty_string_p $format_string] } {
    # Snip off the next token
    regexp {([^/\-.: ]*)([/\-.: ]*)(.*)} \
          $format_string match word sep format_string
    # Extract the trailing "t", if any
    regexp -nocase $template::util::date::token_exp $word \
          match token type

    # Output the widget
    set fragment_def $template::util::date::fragment_widgets([string toupper $token])

    multirow append time_format_elms [lindex $fragment_def 1]
}




#----------------------------------------------------------------------
# Finishing definition of form
#----------------------------------------------------------------------

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
        "Title is too long"
    }
} -new_request {
    set date [template::util::date::from_ansi $date]
    set repeat_p 0
    if {[info exists start_time] && ![empty_string_p $start_time] && $start_time != 0} {
	# Set the start time
	set start_hour $start_time
	set start_time "{} {} {} $start_time 0 {} {HH24:MI}"
	set end_time "{} {} {} [expr $start_hour + 1] 0 {} {HH24:MI}"
	set time_p 1 
    } else {
	set time_p 0
	set start_hour $start_time
	set start_time "{} {} {} 0 0 {} {HH24:MI}"
	set end_time "{} {} {} 0 0 {} {HH24:MI}"
    }
    set calendar_id [lindex [lindex $calendar_list 0] 1]
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
    set time_p $cal_item(time_p)

    if { [empty_string_p $repeat_p] } {
        set repeat_p 0
    } else {
        set repeat_p 1
    }
    set edit_all_p $repeat_p
    if { !$repeat_p } {
        element set_property cal_item edit_all_p -widget hidden
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

    if {$repeat_p} {
        ad_returnredirect [export_vars -base cal-item-create-recurrence { cal_item_id }]
    } else {
        ad_returnredirect [export_vars -base cal-item-view { cal_item_id }]
    }
    ad_script_abort

} -edit_data {
    # set up the datetimes
    set start_date [calendar::to_sql_datetime -date $date -time $start_time -time_p $time_p]
    set end_date [calendar::to_sql_datetime -date $date -time $end_time -time_p $time_p]

    # Do the edit
    calendar::item::edit \
        -cal_item_id $cal_item_id \
        -start_date $start_date \
        -end_date $end_date \
        -name $title \
        -description $description \
        -item_type_id $item_type_id \
        -edit_all_p $edit_all_p \
        -calendar_id $calendar_id
    
    ad_returnredirect [export_vars -base cal-item-view { cal_item_id }]
    ad_script_abort
}


