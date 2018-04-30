# /packages/calendar/tcl/cal-item-procs.tcl

ad_library {

    Utility functions for Calendar Applications

    @author Dirk Gomez (openacs@dirkgomez.de)
    @author Gary Jin (gjin@arsdigita.com)
    @author Ben Adida (ben@openforce.net)
    @creation-date Jan 11, 2001
    @cvs-id $Id$

}

namespace eval calendar {}
namespace eval calendar::item {}

ad_proc -private calendar::item::dates_valid_p {
    {-start_date:required}
    {-end_date:required}
} {
    A sanity check that the start time is before the end time.
} {
    return [db_string dates_valid_p_select {}]
}

ad_proc -public calendar::item::new {
    {-start_date:required}
    {-end_date:required}
    {-name:required}
    {-description:required}
    {-calendar_id ""}
    {-item_type_id ""}
    {-package_id ""}
    {-location ""}
    {-related_link_url ""}
    {-related_link_text ""}
    {-redirect_to_rel_link_p ""}
    {-cal_uid ""}
    {-ical_vars ""}
} {
    Insert a new calendar item into the database
} {
    if {$package_id eq ""} {
        set package_id [ad_conn package_id]
    }
    if {[dates_valid_p -start_date $start_date -end_date $end_date]} {
        set creation_ip [ad_conn peeraddr]
        set creation_user [ad_conn user_id]

        set activity_id [db_exec_plsql insert_activity {} ]

        #
        # In case we have a cal_uid, save it in the cal_uids table
        # together with the ical_vars.
        #
        if {$cal_uid ne ""} {
            db_dml insert_cal_uid {}
        }

        # Convert from user timezone to system timezone
        if { $start_date ne $end_date } {

            # Convert to server timezone only if it's not an all-day event
            # otherwise, keep the start and end time as 00:00

            set start_date [lc_time_conn_to_system $start_date]
            set end_date [lc_time_conn_to_system $end_date]
        }

        set timespan_id [db_exec_plsql insert_timespan {}]

        # create the cal_item
        # we are leaving the name and description fields in acs_event
        # blank to abide by the definition that an acs_event is an acs_activity
        # with added on temporal information

        # by default, the cal_item permissions
        # are going to be inherited from the calendar permissions
        set cal_item_id [db_exec_plsql cal_item_add {}]

        db_dml set_item_type_id "update cal_items set item_type_id=:item_type_id where cal_item_id=:cal_item_id"

        # removing inherited permissions
        if { $calendar_id ne "" && [calendar::personal_p -calendar_id $calendar_id] } {
            permission::set_not_inherit -object_id $cal_item_id
        }

        assign_permission  $cal_item_id  $creation_user read
        assign_permission  $cal_item_id  $creation_user write
        assign_permission  $cal_item_id  $creation_user delete
        assign_permission  $cal_item_id  $creation_user admin

        calendar::do_notifications -mode New -cal_item_id $cal_item_id
        return $cal_item_id

    } else {
        ad_return_complaint 1 [_ calendar.start_time_before_end_time]
        ad_script_abort
    }
}

ad_proc -private calendar::item::all_day_event {start_date_ansi end_date_ansi} {

    Determine, if an event is an all day event depending on the ans
    state and and dates (e.g. "2018-03-22 00:00:00" and "2018-03-23
    00:00:00". The event is a full_day event, either when the
    start_date is equal to the end data or the start_day is different
    to the end day (this might happen through external calendars).
    
} {
    return [expr {$start_date_ansi eq $end_date_ansi
                  || [lindex $start_date_ansi 0] ne [lindex $end_date_ansi 0]}]
}

ad_proc -public calendar::item::get {
    {-cal_item_id:required}
    {-array}
    {-normalize_time_to_utc 0}
} {
    Get the data for a calendar item

} {
    if {[info exists array]} {
        upvar $array row
    }
    if { [catch  {
      set attachments_enabled_p [calendar::attachments_enabled_p]
    }] } { set attachments_enabled_p 0 }

    if { $attachments_enabled_p } {
        set query_name select_item_data_with_attachment
    } else {
        set query_name select_item_data
    }

    db_1row $query_name {} -column_array row
    if {$normalize_time_to_utc} {
        set row(start_date_ansi) [lc_time_local_to_utc $row(start_date_ansi)]
        set row(end_date_ansi)   [lc_time_local_to_utc $row(end_date_ansi)]
    } else {
        set row(start_date_ansi) [lc_time_system_to_conn $row(start_date_ansi)]
        set row(end_date_ansi)   [lc_time_system_to_conn $row(end_date_ansi)]
    }
    #
    # all day events: either the start date 
    #
    if { [all_day_event $row(start_date_ansi) $row(end_date_ansi)] } {
        set row(time_p) 0
    } else {
        set row(time_p) 1
    }
    ns_log notice "calendar::item::get $row(start_date_ansi) eq $row(end_date_ansi) => $row(time_p)"
    
    # Localize
    set row(start_time) [lc_time_fmt $row(start_date_ansi) "%X"]

    # Unfortunately, SQL has weekday starting at 1 = Sunday
    set row(start_date)              [lc_time_fmt $row(start_date_ansi) "%Y-%m-%d"]
    set row(end_date)                [lc_time_fmt $row(end_date_ansi) "%Y-%m-%d"]

    set row(day_of_week)             [expr {[lc_time_fmt $row(start_date_ansi) "%w"] + 1}]
    set row(pretty_day_of_week)      [lc_time_fmt $row(start_date_ansi) "%A"]
    set row(day_of_month)            [lc_time_fmt $row(start_date_ansi) "%d"]
    set row(pretty_short_start_date) [lc_time_fmt $row(start_date_ansi) "%x"]
    set row(full_start_date)         [lc_time_fmt $row(start_date_ansi) "%x"]
    set row(full_end_date)           [lc_time_fmt $row(end_date_ansi) "%x"]

    set row(end_time) [lc_time_fmt $row(end_date_ansi) "%X"]

    return [array get row]
}

ad_proc -public calendar::item::add_recurrence {
    {-cal_item_id:required}
    {-interval_type:required}
    {-every_n:required}
    {-days_of_week ""}
    {-recur_until ""}
} {
    Adds a recurrence for a calendar item
} {
    db_transaction {
        set recurrence_id [db_exec_plsql create_recurrence {}]

        db_dml update_event {}
        db_exec_plsql insert_instances {}

        # Make sure they're all in the calendar!
        db_dml insert_cal_items {}
    }
    return $recurrence_id
}


ad_proc -public calendar::item::edit {
    {-cal_item_id:required}
    {-start_date:required}
    {-end_date:required}
    {-name:required}
    {-description:required}
    {-item_type_id ""}
    {-edit_all_p 0}
    {-edit_past_events_p 1}
    {-calendar_id ""}
    {-location ""}
    {-related_link_url ""}
    {-related_link_text ""}
    {-redirect_to_rel_link_p ""}
    {-cal_uid ""}
    {-ical_vars ""}
} {
    Edit the item

} {
    if {[dates_valid_p -start_date $start_date -end_date $end_date]} {
        if {$edit_all_p} {
            set recurrence_id [db_string select_recurrence_id {}]

            # If the recurrence id is NULL, then we stop here and just do the normal update
            if {$recurrence_id ne ""} {
                ns_log notice "recurrence_id $recurrence_id"
                calendar::item::edit_recurrence \
                    -event_id $cal_item_id \
                    -start_date $start_date \
                    -end_date $end_date \
                    -name $name \
                    -description $description \
                    -item_type_id $item_type_id \
                    -calendar_id $calendar_id \
                    -edit_past_events_p $edit_past_events_p

                return
            }
        }

        # Convert from user timezone to system timezone
        if { $start_date ne $end_date } {

            # Convert to server timezone only if it's not an all-day event
            # otherwise, keep the start and end time as 00:00

            set start_date [lc_time_conn_to_system $start_date]
            set end_date   [lc_time_conn_to_system $end_date]
        }

        db_dml update_event {}

        # update the time interval based on the timespan id

        db_1row get_interval_id {}

        db_transaction {
            #
            # If a cal_uid is given, update the attributes in the
            # cal_uid mapping table
            #
            if {$cal_uid ne ""} {
                #
                # We have to determine the activity id for the upsert
                # operation in cal_uids.
                #
                set activity_id [db_string select_activity_id {
                    select activity_id from acs_events where event_id = :cal_item_id
                }]
                #ns_log notice "======= cal_uid_upsert with activity_id $activity_id"
                db_exec_plsql cal_uid_upsert {}
            }

            # call edit procedure
            db_exec_plsql update_interval {}

            # Update the item_type_id and calendar_id
            set colspecs {}
            lappend colspecs "item_type_id = :item_type_id"
            if { $calendar_id ne "" } {
                lappend colspecs "on_which_calendar = :calendar_id"

                db_dml update_context_id {
                    update acs_objects
                    set    context_id = :calendar_id
                    where  object_id = :cal_item_id
                }
            }

            db_dml update_item_type_id [subst {
                update cal_items
                set    [join $colspecs ", "]
                where  cal_item_id= :cal_item_id
            }]

        calendar::do_notifications -mode Edited -cal_item_id $cal_item_id
        }
    } else {
        ad_return_complaint 1 [_ calendar.start_time_before_end_time]
        ad_script_abort
    }
}

ad_proc -public calendar::item::delete {
    {-cal_item_id:required}
} {
    Delete the calendar item
} {
    db_exec_plsql delete_cal_item {}
}

ad_proc calendar::item::assign_permission { cal_item_id
                                     party_id
                                     permission
                                     {revoke ""}
} {
    update the permission of the specific cal_item
    if revoke is set to revoke, then we revoke all permissions
} {
    if { $revoke ne "revoke" } {
        if { $permission ne "cal_item_read" } {
            permission::grant -object_id $cal_item_id -party_id $party_id -privilege cal_item_read
        }
        permission::grant -object_id $cal_item_id -party_id $party_id -privilege $permission
    } elseif {$revoke eq "revoke"} {
        permission::revoke -object_id $cal_item_id -party_id $party_id -privilege $permission

    }
}

ad_proc -public calendar::item::delete_recurrence {
    {-recurrence_id:required}
} {
    delete a recurrence
} {
    db_exec_plsql delete_cal_item_recurrence {}
}


ad_proc -public calendar::item::edit_recurrence {
    {-event_id:required}
    {-start_date:required}
    {-end_date:required}
    {-name:required}
    {-description:required}
    {-item_type_id ""}
    {-calendar_id ""}
    {-edit_past_events_p "t"}
} {
    edit a recurrence
} {
    set recurrence_id [db_string select_recurrence_id {}]
    set edit_past_events_p [string map {0 f 1 t} [string is true $edit_past_events_p]]
    db_transaction {
        db_exec_plsql recurrence_timespan_update {}
        # compare this event to the original one we are
        # editing DAVEB 2007-03-15
        calendar::item::get \
            -cal_item_id $event_id \
            -array orig_event

        set colspecs {}
        foreach col {name description} {
            if {$orig_event($col) ne [set $col]} {
                lappend colspecs "$col = :$col"
            }
        }
        if {[llength $colspecs]} {
            db_dml recurrence_events_update {}
        }
        set colspecs {}
        lappend colspecs {item_type_id = :item_type_id}
        if { $calendar_id ne "" } {
            lappend colspecs {on_which_calendar = :calendar_id}

            db_dml update_context_id {
            }
        }

        db_dml recurrence_items_update {}
    }
}

ad_proc -public -deprecated calendar_item_add_recurrence {
    {-cal_item_id:required}
    {-interval_type:required}
    {-every_n:required}
    {-days_of_week ""}
    {-recur_until ""}
} {
    Adds a recurrence for a calendar item

    @see calendar::item::add_recurrence
} {
    return [calendar::item::add_recurrence \
                -cal_item_id $cal_item_id \
                -interval_type $interval_type \
                -every_n $every_n \
                -days_of_week $days_of_week \
                -recur_until $recur_until
           ]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
