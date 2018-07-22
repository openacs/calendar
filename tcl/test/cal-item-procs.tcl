# packages/calendar/tcl/test/cal-item-procs.tcl
ad_library {
    Tests for calendar::item API
}

aa_register_case \
    -cats api \
    -procs {
        calendar::create
        calendar::item::add_recurrence
        calendar::item::edit
        calendar::item::get
        calendar::item::new
    } \
    cal_item_edit_recurrence {
    Test editing a recurring calendar item/event
} {
    aa_run_with_teardown \
        -rollback \
        -test_code {
            # create a test calendar
            set calendar_id [calendar::create [ad_conn user_id] t]

            # create a recurring calendar item
            set ci_start_date [clock format [clock seconds] -format "%Y-%m-%d"]
            set ci_end_date [clock format [clock scan "tomorrow" -base [clock seconds]] -format "%Y-%m-%d"]
            set recur_until [clock format [clock scan "10 days" -base [clock seconds]] -format "%Y-%m-%d"]
            set ci_name "name"
            set ci_description "description"
            set cal_item_id \
                [calendar::item::new \
                     -start_date $ci_start_date \
                     -end_date $ci_end_date \
                     -name $ci_name \
                     -description $ci_description \
                     -calendar_id $calendar_id]

            calendar::item::get \
                -cal_item_id $cal_item_id -array cal_item
            aa_equals "Name is correct"  $ci_name $cal_item(name)
            aa_equals "Description is correct"  $ci_description $cal_item(description)
            # edit the time of the event
            set recurrence_id \
                [calendar::item::add_recurrence \
                     -cal_item_id $cal_item_id \
                     -interval_type "day" \
                     -every_n 1 \
                     -days_of_week "" \
                     -recur_until $recur_until]

            aa_log "Recurrence_id = '${recurrence_id}'"

            # compare recurrent events
            set passed 1
            set recurrence_event_ids [list]
            set name ""
            set recurrence_event_ids [db_list q {
                select cal_item_id as cal_item_id from acs_events, cal_items
                where cal_item_id=event_id and recurrence_id=:recurrence_id
            }]
            foreach event_id $recurrence_event_ids {
                 calendar::item::get -cal_item_id $event_id -array cal_item
                set passed [expr {$passed && $ci_name eq $cal_item(name)}]
                # for some reason the description is not set

                set passed [expr {$passed && $ci_description eq $cal_item(description)}]
                lappend recurrence_event_ids $event_id
            }
            aa_true "Name correct on all recurrences" $passed
            # aa_log $recurrence_event_ids
            # update time only
            set ci_start_date [clock format [clock scan "1 month" -base [clock scan $ci_start_date]] -format "%Y-%m-%d"]
            set ci_end_date [clock format [clock scan "1 month" -base [clock scan $ci_end_date]] -format "%Y-%m-%d"]

            calendar::item::edit \
                -cal_item_id $cal_item_id \
                -start_date $ci_start_date \
                -end_date $ci_end_date \
                -name $ci_name \
                -description $ci_description \
                -edit_all_p t

            set passed 1

            foreach event_id $recurrence_event_ids {
                 calendar::item::get -cal_item_id $event_id -array cal_item
                set passed [expr {$passed && $ci_name eq $cal_item(name)}]
                # for some reason the description is not set
                set passed [expr {$passed && $ci_description eq $cal_item(description)}]
            }
            aa_true "Name correct on all recurrences 2" $passed

            # Update name to be unique per instance
            # aa_log "Recurrence event_ids $recurrence_event_ids"
            foreach event_id $recurrence_event_ids {
                calendar::item::get -cal_item_id $event_id -array cal_item
                set new_names($event_id) "name $event_id"
                calendar::item::edit \
                    -cal_item_id $event_id \
                    -start_date $cal_item(start_date) \
                    -end_date $cal_item(end_date) \
                    -name $new_names($event_id) \
                    -description $cal_item(description)
            }
            set passed 1

            foreach event_id $recurrence_event_ids {
                calendar::item::get -cal_item_id $event_id -array cal_item
                set passed [expr {$passed && $new_names($event_id) eq $cal_item(name)}]
                set passed [expr {$passed && $ci_description eq $cal_item(description)}]
            }
            aa_true "New individual names are correct" $passed

            # don't edit name!
            calendar::item::get -cal_item_id $cal_item_id -array cal_item
            calendar::item::edit \
                -cal_item_id $cal_item_id \
                -start_date $ci_start_date \
                -end_date $ci_end_date \
                -name $cal_item(name) \
                -description $cal_item(description) \
                -edit_all_p t

            set passed 1
            foreach event_id $recurrence_event_ids {
                 calendar::item::get -cal_item_id $event_id -array cal_item
                set passed [expr {$passed && $new_names($event_id) eq $cal_item(name)}]
                set passed [expr {$passed && $ci_description eq $cal_item(description)}]
            }
            aa_true "Edited item and New individual names are correct" $passed

            calendar::item::edit \
                -cal_item_id $cal_item_id \
                -start_date $ci_start_date \
                -end_date $ci_end_date \
                -name "New Name" \
                -description $cal_item(description) \
                -edit_all_p t

            set passed 1
            foreach event_id $recurrence_event_ids {
                 calendar::item::get -cal_item_id $event_id -array cal_item
                set passed [expr {$passed && "New Name" eq $cal_item(name)}]
                set passed [expr {$passed && $ci_description eq $cal_item(description)}]
            }
            aa_true "Edited item name and New individual names are updated" $passed
        }
}


aa_register_case \
    -cats {api} \
    -procs {
        calendar::create
        calendar::delete
        calendar::item::add_recurrence
        calendar::item::delete
        calendar::item::get
        calendar::item::new
    } \
    cal_item_add_delete {
    Test adding and deleting a calendar entry
} {
    try {

        # create a test calendar
        set calendar_id [calendar::create [ad_conn user_id] t]

        #
        # create a simple calendar item without recurrence
        #
        set ci_start_date [clock format [clock seconds] -format "%Y-%m-%d"]
        set ci_end_date [clock format [clock scan "tomorrow" -base [clock seconds]] -format "%Y-%m-%d"]
        set ci_name "name"
        set ci_description "description"
        set cal_item_id \
            [calendar::item::new \
                 -start_date $ci_start_date \
                 -end_date $ci_end_date \
                 -name $ci_name \
                 -description $ci_description \
                 -calendar_id $calendar_id]

        calendar::item::get \
            -cal_item_id $cal_item_id \
            -array cal_item
        aa_equals "Name is correct" $ci_name $cal_item(name)
        aa_equals "Description is correct" $ci_description $cal_item(description)

        set activity_id [db_string get_activity_id {
            select activity_id from acs_events where event_id = :cal_item_id
        } -default ""]
        aa_true "activity_id ($activity_id) is not empty" {$activity_id ne ""}

        calendar::item::delete \
            -cal_item_id $cal_item_id

        aa_log "deleted item calendar item $cal_item_id"

        set activity_id [db_string get_activity_id {
            select activity_id from acs_activities where activity_id = :activity_id
        } -default ""]
        aa_true "activity_id ($activity_id) is gone" {$activity_id eq ""}

        #
        # Create now a recurring calendar item
        #
        aa_log "create a recurreinig calendar item"

        set ci_start_date [clock format [clock seconds] -format "%Y-%m-%d"]
        set ci_end_date [clock format [clock scan "tomorrow" -base [clock seconds]] -format "%Y-%m-%d"]
        set recur_until [clock format [clock scan "10 days" -base [clock seconds]] -format "%Y-%m-%d"]
        set ci_name "name"
        set ci_description "description"
        set cal_item_id \
            [calendar::item::new \
                 -start_date $ci_start_date \
                 -end_date $ci_end_date \
                 -name $ci_name \
                 -description $ci_description \
                 -calendar_id $calendar_id]
        #
        # Add a recurrence
        #
        set recurrence_id \
            [calendar::item::add_recurrence \
                 -cal_item_id $cal_item_id \
                 -interval_type "day" \
                 -every_n 1 \
                 -days_of_week "" \
                 -recur_until $recur_until]

        aa_log "calendar item $cal_item_id, recurrence_id = '${recurrence_id}'"

        set activity_id [db_string get_activity_id {
            select activity_id from acs_events where event_id = :cal_item_id
        } -default ""]
        aa_true "activity_id ($activity_id) is not empty" {$activity_id ne ""}
        aa_true "recurrence_id ($recurrence_id) is not empty" {$recurrence_id ne ""}

        calendar::item::get \
            -cal_item_id $cal_item_id \
            -array cal_item
        aa_equals "item::get returns the same recurrence_id" $cal_item(recurrence_id) $recurrence_id

        set cal_item_ids [db_list get_event_ids {
            select event_id from acs_events where activity_id = :activity_id
        }]
        aa_true "cal_item_ids ($cal_item_ids) of recurring event" {[llength $cal_item_ids] == 11}

        calendar::item::delete -cal_item_id $cal_item_id
        aa_log "deleted item calendar item $cal_item_id"

        set cal_item_ids [db_list get_event_ids {
            select event_id from acs_events where activity_id = :activity_id
        }]
        aa_true "cal_item_ids ($cal_item_ids) of recurring event" {[llength $cal_item_ids] == 10}

        set activity_id [db_string get_activity_id {
            select activity_id from acs_activities where activity_id = :activity_id
        } -default ""]
        aa_false "activity_id ($activity_id) is gone" {$activity_id eq ""}

        set recurrence_id [db_string get_activity_id {
            select recurrence_id from recurrences where recurrence_id = :recurrence_id
        } -default ""]
        aa_false "recurrence_id ($recurrence_id) is gone" {$recurrence_id eq ""}

        #
        # Now delete all remaining cal items
        #
        foreach cid $cal_item_ids {
            calendar::item::delete -cal_item_id $cid
        }
        set cal_item_ids [db_list get_event_ids {
            select event_id from acs_events where activity_id = :activity_id
        }]
        aa_true "cal_item_ids ($cal_item_ids) of recurring event" {[llength $cal_item_ids] == 0}

        #
        # ... and check, if the activity and recurrence was deleted
        #
        set activity_id [db_string get_activity_id {
            select activity_id from acs_activities where activity_id = :activity_id
        } -default ""]
        aa_true "activity_id ($activity_id) is gone" {$activity_id eq ""}

        set recurrence_id [db_string get_activity_id {
            select recurrence_id from recurrences where recurrence_id = :recurrence_id
        } -default ""]
        aa_true "recurrence_id ($recurrence_id) is gone" {$recurrence_id eq ""}

    } on error {errorMsg} {
        aa_true "Error msg: $errorMsg" 0
    } finally {
        #
        # Finally, clean up the calendar
        #
        calendar::delete -calendar_id $calendar_id
    }

    #
    # .. and check, if the calendar is gone.
    #
    set n_calendar_id [db_string get_calendar_id {
            select calendar_id from calendars where calendar_id = :calendar_id
    } -default ""]

    aa_true "calendar_id ($n_calendar_id) is gone" {$n_calendar_id eq ""}

}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
