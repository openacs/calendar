ad_page_contract {

    Creating a new Calendar Item

    @author Dirk Gomez (openacs@dirkgomez.de)
    @author Ben Adida (ben@openforce.net)
    @creation-date May 29, 2002
    @cvs-id $Id$
} {
    {calendar_id:object_type(calendar) ""}
    cal_item_id:object_id,optional
    {item_type_id:object_id ""}
    {date:clock(%Y-%m-%d) ""}
    {julian_date:clock(%J) ""}
    {start_time:clock(%H:%M) ""}
    {end_time:clock(%H:%M) ""}
    {view:token "day"}
    {return_url:localurl "./"}
} -validate {
    cal_item_id_valid -requires {cal_item_id:object_id} {
        #
        # Note that we need to let through ids that are not objects,
        # these are normally the new entries, which were not persisted
        # yet.
        #
        if { [db_0or1row check_type {
            select 1 from acs_objects where object_id = :cal_item_id
            and object_type <> 'cal_item'
        }] } {
            ad_complain [_ acs-tcl.lt_invalid_object_type]
        }
    }
}

auth::require_login

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

if {$date eq ""} {
    if {$julian_date ne ""} {
        set date [dt_julian_to_ansi $julian_date]
    } else {
        set date [dt_sysdate]
    }
}

set ansi_date $date
set calendar_list [calendar::calendar_list]
set calendar_options [calendar::calendar_list -privilege create]

# Header stuff
template::add_body_handler -event "load" -script "TimePChanged();"
template::head::add_css -href "/resources/calendar/calendar.css" -media all
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"

# TODO: Move into ad_form
if { ![ad_form_new_p -key cal_item_id] } {
    set calendar_id [db_string get_calendar_id {
        select on_which_calendar as calendar_id
        from   cal_items
        where  cal_item_id = :cal_item_id
    } -default ""]
} else {
    set calendar_id [lindex $calendar_options 0 1]
}
# TODO: Move into ad_form
if { [info exists cal_item_id] && $cal_item_id ne "" } {
    set page_title [_ calendar.Calendar_Edit_Item]
    set ad_form_mode display
} else {
    set page_title [_ calendar.Calendar_Add_Item]
    set ad_form_mode edit
}

ad_form -name cal_item  -export { return_url } -form {
    {cal_item_id:key}
    {title:text(text)
        {label "[_ calendar.Title_1]"}
        {maxlength 255}
        {html {size 45}}
    }
    {date:h5date
        {label "[_ calendar.Date_1]"}
    }
    {time_p:text(radio)
        {label "&nbsp;"}
        {options {{"[_ calendar.All_Day_Event]" 0}
            {"[_ calendar.Use_Hours_Below]" 1} }}
    }
    {start_time:h5time,optional
        {label "[_ calendar.Start_Time]"}
    }
    {end_time:h5time,optional
        {label "[_ calendar.End_Time]"}
    }
    {location:text(text),optional
        {label "[_ calendar.Location]"}
        {maxlength 255}
        {html {size 44}}
    }
    {description:text(textarea),optional
        {label "[_ calendar.Description]"}
        {html {cols 45 rows 10}}
    }
    {related_link_url:text(url),optional
        {label "[_ calendar.RelatedLink]"}
        {maxlength 255}
        {html {size 45}}
    }
    {calendar_id:integer(radio)
        {label "[_ calendar.Sharing]"}
        {options $calendar_options}
    }
}

template::add_body_script -script {
    function TimePChanged(elm) {
        var form_name = "cal_item";

        if (elm == null) return;
        if (document.forms == null) return;
        if (document.forms[form_name] == null) return;
        if (elm.value == 0) {
            disableTime(form_name);
        } else {
            enableTime(form_name);
        }
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
        {edit_what:text(radio)
            {label "[_ calendar.Apply_Changes_to]"}
            {options {{"[_ calendar.This_Event]" this}
                {"[_ calendar.All_Past_and_Future_Events]" all}
                {"[_ calendar.This_and_All_Future_Events]" future}}}
        }
    }
}


#----------------------------------------------------------------------
# Finishing definition of form
#----------------------------------------------------------------------

set cal_item_types [calendar::get_item_types -calendar_id $calendar_id]

if {[llength $cal_item_types] > 1} {
    ad_form -extend -name cal_item -form {
        {item_type_id:integer(select),optional
            {label "[_ calendar.Type_1]"}
            {options {$cal_item_types} }
            {help_text "[_ calendar.Type_Help]"}
        }
    }
}

if { ![ad_form_new_p -key cal_item_id] } {
    calendar::item::get -cal_item_id $cal_item_id -array cal_item
}

ad_form -extend -name cal_item -validate {
    {description {[string equal [set msg [ad_html_security_check $description]] ""]}
        $msg
    }
} -new_request {
    # Seamlessly create a private calendar if the user doesn't have one
    if { ![calendar::have_private_p -party_id $user_id] } {
        set calendar_id [calendar::new \
                             -owner_id $user_id \
                             -private_p "t" \
                             -calendar_name "Personal" \
                             -package_id $package_id]
    }

    set repeat_p 0

    set time_p [expr {$start_time ne ""}]

    if {$start_time ne "" && $end_time eq ""} {
        # Default end_time is one hour after start_time
        set end_time [clock format [clock add [clock scan $start_time -format {%H:%M}] 1 hour] -format {%H:%M}]
    }

    # set the calendar_id before setting item_types form element (see top of script) DAVEB
    set calendar_id [lindex $calendar_options 0 1]

} -edit_request {

    ::permission::require_permission \
        -object_id $cal_item_id \
        -privilege write \
        -party_id $user_id

    set cal_item_id            $cal_item(cal_item_id)
    set n_attachments          $cal_item(n_attachments)
    set ansi_start_date        $cal_item(start_date_ansi)
    set ansi_end_date          $cal_item(end_date_ansi)
    set start_time             $cal_item(start_time)
    set end_time               $cal_item(end_time)
    set title                  $cal_item(name)
    set description            $cal_item(description)
    set location               $cal_item(location)
    set related_link_url       $cal_item(related_link_url)
    set related_link_text      $cal_item(related_link_text)
    set redirect_to_rel_link_p $cal_item(redirect_to_rel_link_p)
    set repeat_p               $cal_item(recurrence_id)
    set item_type              $cal_item(item_type)
    set item_type_id           $cal_item(item_type_id)
    set calendar_id            $cal_item(calendar_id)
    set time_p                 $cal_item(time_p)

    if { $time_p == 0 } {
        set js "disableTime('cal_item');"
    } else {
        set js "enableTime('cal_item');"
    }
    if { $repeat_p eq "" } {
        set repeat_p 0
    } else {
        set repeat_p 1
    }
    # Make the user explicitly choose edit all or not
    # this is a usability issue, since it prevents unexpected
    # behavior. According to carlb, this is how palm os works
    # and that sounds like a reasonable interface to emulate
    # set edit_what $repeat_p
    if { !$repeat_p } {
        element set_properties cal_item edit_what -widget hidden
        element set_value cal_item edit_what this
    }

    set start_clock [clock scan $ansi_start_date -format {%Y-%m-%d %H:%M:%S}]
    set end_clock   [clock scan $ansi_end_date -format {%Y-%m-%d %H:%M:%S}]

    set date       [clock format $start_clock -format {%Y-%m-%d}]
    set start_time [clock format $start_clock -format {%H:%M}]
    set end_time   [clock format $end_clock   -format {%H:%M}]

} -on_submit {

    set start_date "$date $start_time"
    set end_date   "$date $end_time"

    if {![calendar::item::dates_valid_p -start_date $start_date -end_date $end_date]} {
         template::form::set_error cal_item start_time [_ calendar.start_time_before_end_time]
         break
    }

} -new_data {

    set start_date "$date $start_time"
    set end_date   "$date $end_time"

    if { ![calendar::personal_p -calendar_id $calendar_id] } {
        ::permission::require_permission \
            -object_id $calendar_id \
            -privilege create \
            -party_id $user_id
    }
    set cal_item_id [calendar::item::new \
                         -start_date $start_date \
                         -end_date $end_date \
                         -name $title \
                         -description $description \
                         -location $location \
                         -related_link_url $related_link_url \
                         -calendar_id $calendar_id \
                         -item_type_id $item_type_id]

    if {$repeat_p} {
        ad_returnredirect [export_vars -base cal-item-create-recurrence { return_url cal_item_id}]
    } elseif {$return_url ne "./"} {
        ad_returnredirect $return_url
    } else {
        ad_returnredirect [export_vars -base cal-item-view { cal_item_id }]
    }
    ad_script_abort

} -edit_data {

    #
    # Require write permission to write on the item.
    #
    ::permission::require_permission \
        -object_id $cal_item_id \
        -privilege write \
        -party_id $user_id

    #
    # When the calendar is not personal, also require the permission
    # to create in it.
    #
    if { ![calendar::personal_p -calendar_id $calendar_id] } {
        ::permission::require_permission \
            -object_id $calendar_id \
            -privilege create \
            -party_id $user_id
    }

    # set up the datetimes
    set start_date "$date $start_time"
    set end_date   "$date $end_time"
    set edit_all_p 0
    set edit_past_events_p 0
    if {[info exists edit_what]} {
        switch $edit_what {
            this {
                set edit_all_p 0
                set edit_past_events_p 0
            }
            all {
                set edit_all_p 1
                set edit_past_events_p 1
            }
            future {
                set edit_all_p 1
                set edit_past_events_p 0
            }
        }
    }

    # Do the edit
    calendar::item::edit \
        -cal_item_id $cal_item_id \
        -start_date $start_date \
        -end_date $end_date \
        -name $title \
        -description $description \
        -location $location \
        -related_link_url $related_link_url \
        -related_link_text $cal_item(related_link_text) \
        -redirect_to_rel_link_p $cal_item(redirect_to_rel_link_p) \
        -item_type_id $item_type_id \
        -edit_all_p $edit_all_p \
        -edit_past_events_p $edit_past_events_p \
        -calendar_id $calendar_id

    if {$return_url ne "./"  } {
        ad_returnredirect $return_url
    } else {
        ad_returnredirect [export_vars -base cal-item-view { cal_item_id }]
    }
    ad_script_abort

}

# Register JS Eventhandlers
template::add_event_listener -id cal_item:elements:time_p:0 -preventdefault=false -script {TimePChanged(this);}
template::add_event_listener -id cal_item:elements:time_p:1 -preventdefault=false -script {TimePChanged(this);}

template::add_body_script -script {
    if (document.forms["cal_item"].time_p[0].checked == true ) {
        // All day event
        disableTime("cal_item");
    } else {
        enableTime("cal_item");
    }
}



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
