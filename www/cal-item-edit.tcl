# /packages/calendar/www/cal-item-edit.tcl

ad_page_contract {
    
    edit an existing calendar item
    (totally rewritten, this was nasty)

    @author Ben Adida (ben@openforce)
    @creation-date 2002-06-02
    @cvs-id $Id$
} {
    cal_item_id:integer,notnull
} 

# Permissions
# FIXME: we need to add a permissions check here!

# Create the form
form create cal_item

element create cal_item cal_item_id \
        -label "Calendar Item ID" -datatype integer -widget hidden -value $cal_item_id

element create cal_item title \
        -label "Title" -datatype text -widget text -html {size 60}

element create cal_item date \
        -label "Date" -datatype date -widget date

element create cal_item time_p \
        -label "&nbsp;" -datatype text -widget radio -options {{{All Day Event} 0} {{Use Hours Below:} 1}}

element create cal_item start_time \
        -label "Start Time" -datatype date -widget date -format "HH12:MI AM"

element create cal_item end_time \
        -label "End Time" -datatype date -widget date -format "HH12:MI AM"

element create cal_item description \
        -label "Description" -datatype text -widget textarea -html {cols 60 rows 3 wrap soft}

element create cal_item item_type_id \
        -label "Type" -datatype integer -widget select -optional

element create cal_item repeat_p \
        -label "Edit All Occurrences?" -datatype text -widget radio -options {{Yes 1} {No 0}} -value 0


if {[form is_valid cal_item]} {
    template::form get_values cal_item cal_item_id title date time_p start_time end_time description item_type_id repeat_p

    # set up the datetimes
    set start_date [calendar::to_sql_datetime -date $date -time $start_time -time_p $time_p]
    set end_date [calendar::to_sql_datetime -date $date -time $end_time -time_p $time_p]

    ns_log Notice "BMA3: $repeat_p"

    # Do the edit
    calendar::item::edit -cal_item_id $cal_item_id \
            -start_date $start_date \
            -end_date $end_date \
            -name $title \
            -description $description \
            -item_type_id $item_type_id \
            -edit_all_p $repeat_p

    # Redirect
    ad_returnredirect "cal-item-view?cal_item_id=$cal_item_id"
    ad_script_abort
}

# Select info for the item
calendar::item::get -cal_item_id $cal_item_id -array cal_item

# Prepare the form nicely
element set_properties cal_item item_type_id -options [calendar::get_item_types -calendar_id $cal_item(calendar_id)] 

element set_properties cal_item cal_item_id -value $cal_item(cal_item_id)
element set_properties cal_item title -value $cal_item(name)
element set_properties cal_item date -value [calendar::from_sql_datetime -sql_date $cal_item(start_date) -format {YYYY-MM-DD}]
element set_properties cal_item start_time -value [calendar::from_sql_datetime -sql_date $cal_item(start_time) -format {HH12:MIam}]
element set_properties cal_item end_time -value [calendar::from_sql_datetime -sql_date $cal_item(end_time) -format {HH12:MIam}]
element set_properties cal_item description -value $cal_item(description)
element set_properties cal_item item_type_id -value $cal_item(item_type_id)

if {[dt_no_time_p -start_time $cal_item(start_time) -end_time $cal_item(end_time)]} {
    element set_properties cal_item time_p -value 0
} else {
    element set_properties cal_item time_p -value 1
}

# if no recurrence, don't show the repeat stuff
if {[empty_string_p $cal_item(recurrence_id)]} {
    element set_properties cal_item repeat_p -widget hidden
}

set cal_nav [dt_widget_calendar_navigation "view" day $cal_item(start_date) "calendar_id"]

ad_return_template

