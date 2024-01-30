# packages/calendar/tcl/test/cal-item-procs.tcl
ad_library {
    Tests for calendar::item API
}

aa_register_case \
    -cats api \
    -procs {
        calendar::item::dates_valid_p
    } \
    cal_item_start_end_date_validation {
        Test the validation of start and end date.
    } {
        set test_date {
            "" "" false

            "bogus" "" false
            "" "bogus" false
            "bogus" "bogus" false

            "201-01-0" "" false
            "" "201-01-0" false
            "201-01-0" "201-01-0" false

            "2010-15-09" "" false
            "" "2010-15-09" false
            "2010-15-09" "2010-15-09" false

            "2010-15-12" "" false
            "" "2010-15-12" false
            "2010-15-12" "2010-15-12" false

            "2010-15-12 1" "" false
            "" "2010-15-12 1" false
            "2010-15-12 1" "2010-15-12 1" false

            "2024-01-30" "" false
            "" "2024-01-30" false
            "2024-01-30" "2024-01-30" true

            "2024-01-30 08:00" "" false
            "" "2024-01-30 08:00" false
            "2024-01-30 08:00" "2024-01-30 08:00" true

            "2024-01-30 08:00" "2024-01-30 20:00" true
            "2024-01-30 08:00" "" false
            "2024-01-30 20:00" "2024-01-30 08:00" false
            "" "2024-01-30 08:00" false

            "0001-01-01 00:00" "9999-12-31 23:59" true
            "0001-01-01 00:00" "" false
            "9999-12-31 23:59" "0001-01-01 00:00" false
            "" "0001-01-01 00:00" false

            "15:00" "14:00" false
            "14:00" "15:00" false
            "" "14:00" false
            "14:00" "" false

            "2024-01-30 00:01:05" "2024-01-30 00:01:06" true
            "2024-01-30 02:01:05" "2024-01-30 00:01:06" false
        }
        foreach {start_date end_date expected} $test_date {
            aa_equals "'$start_date' -> '$end_date' validity is '$expected'" \
                [string is true [calendar::item::dates_valid_p \
                                     -start_date $start_date \
                                     -end_date $end_date]] \
                [string is true $expected]
        }
    }

aa_register_case \
    -cats api \
    -procs {
        calendar::create
        calendar::item::add_recurrence
        calendar::item::edit_recurrence
        calendar::item::delete_recurrence
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

            aa_log "Deleting recurrence"
            calendar::item::delete_recurrence -recurrence_id $recurrence_id
            aa_false "All recurring events have been deleted" [db_0or1row check [subst {
                select 1 from acs_objects where object_id in ([join $recurrence_event_ids ,])
                fetch first 1 rows only
            }]]
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
        calendar::calendar_list
        calendar::do_notifications
        calendar::notification::get_url
        calendar::have_private_p
        calendar::personal_p
        calendar::outlook::format_item
        calendar::outlook::ics_timestamp_format
    } \
    cal_item_add_delete {
    Test adding and deleting a calendar entry
} {
    try {

        set user_id [ad_conn user_id]

        # create a test calendar
        set calendar_id [calendar::create $user_id t]

        aa_true "User '$user_id' has the new calendar" {
            [string first \
                 $calendar_id \
                 [calendar::calendar_list -user_id $user_id -privilege calendar_read]] >= 0
        }

        set another_user [dict get [acs::test::user::create] user_id]

        aa_equals "User '$another_user' has no private calendars" \
            [calendar::calendar_list -user_id $another_user -privilege calendar_read] \
            [list]

        aa_equals "User '$another_user' has no public calendars" \
            [calendar::calendar_list -user_id $another_user -privilege read] \
            [list]

        aa_false "User '$another_user' has no 'calendar_read' permission on calendar '$calendar_id'" \
            [permission::permission_p -party_id $another_user -object_id $calendar_id -privilege calendar_read]
        aa_false "The public has no 'calendar_read' permission on calendar '$calendar_id'" \
            [permission::permission_p -party_id [acs_magic_object "the_public"] -object_id $calendar_id -privilege calendar_read]

        aa_log "Assign permission on user"
        permission::grant -object_id $calendar_id -party_id $another_user -privilege calendar_read

        aa_true "User '$another_user' has 'calendar_read' permission on calendar '$calendar_id'" \
            [permission::permission_p -party_id $another_user -object_id $calendar_id -privilege calendar_read]
        aa_false "The public has no 'calendar_read' permission on calendar '$calendar_id'" \
            [permission::permission_p -party_id [acs_magic_object "the_public"] -object_id $calendar_id -privilege calendar_read]

        aa_equals "User '$another_user' has no private calendars" \
            [calendar::calendar_list -user_id $another_user -privilege read] \
            [list]

        aa_equals "User '$another_user' has no public calendars" \
            [calendar::calendar_list -user_id $another_user -privilege calendar_read] \
            [list]

        aa_false "User '$another_user' has no private calendar" \
            [calendar::have_private_p -party_id $another_user]

        aa_log "Create a private test calendar belonging to the other user"
        set calendar_id_2 [calendar::create $another_user t]

        aa_log "Create a calendar item belonging to the other user"
        set ci_start_date [clock format [clock seconds] -format "%Y-%m-%d"]
        set ci_end_date [clock format [clock scan "tomorrow" -base [clock seconds]] -format "%Y-%m-%d"]
        #
        # Note: the creation_user can only be specified by altering
        # the connection information. This is not great.
        #
        set old_user [ad_conn user_id]
        ad_conn -set user_id $another_user
        set another_cal_item_id \
            [calendar::item::new \
                 -start_date $ci_start_date \
                 -end_date $ci_end_date \
                 -name Test \
                 -description {Test Desc} \
                 -calendar_id $calendar_id_2]
        ad_conn -set user_id $old_user
        foreach priv {cal_item_read read write delete admin} {
            aa_true "Other user has privilege '$priv' on the cal item '$another_cal_item_id'" \
                [permission::permission_p \
                     -party_id $another_user \
                     -object_id $another_cal_item_id \
                     -privilege $priv]
        }


        aa_true "User '$another_user' has now a private calendar" \
            [calendar::have_private_p -party_id $another_user]

        aa_true "Calendar '$calendar_id_2' is personal to '$another_user'" \
            [calendar::personal_p -calendar_id $calendar_id_2 -user_id $another_user]

        aa_false "Calendar '$calendar_id_2' is not personal to current user" \
            [calendar::personal_p -calendar_id $calendar_id_2 -user_id [ad_conn user_id]]

        aa_equals "User '$another_user' has the new calendar" \
            [calendar::have_private_p -party_id $another_user -return_id 1] \
            $calendar_id_2

        aa_true "User '$another_user' has the new calendar" {
            [string first \
                 $calendar_id_2 \
                 [calendar::calendar_list -user_id $another_user -privilege calendar_read]] >= 0
        }

        aa_log "Create a public test calendar belonging to the current user"
        set calendar_id_3 [calendar::create $user_id f]
        permission::grant -object_id $calendar_id_3 -party_id $another_user -privilege calendar_read
        aa_true "User '$another_user' has the new calendar" {
            [string first \
                 $calendar_id_3 \
                 [calendar::calendar_list -user_id $another_user -privilege calendar_read]] >= 0
        }

        aa_log "Revoking permission on user"
        permission::revoke -object_id $calendar_id_3 -party_id $another_user -privilege calendar_read

        aa_false "User '$another_user' has no 'calendar_read' permission on calendar '$calendar_id_3'" \
            [permission::permission_p -party_id $another_user -object_id $calendar_id_3 -privilege calendar_read]
        aa_false "The public has no 'calendar_read' permission on calendar '$calendar_id'" \
            [permission::permission_p -party_id [acs_magic_object "the_public"] -object_id $calendar_id_3 -privilege calendar_read]

        aa_log "Assign permission to the public"
        permission::grant -object_id $calendar_id -party_id [acs_magic_object "the_public"] -privilege calendar_read

        set cache_p [parameter::get -package_id [ad_acs_kernel_id] -parameter PermissionCacheP -default 0]
        if { $cache_p } {
            aa_log "Caching is activated, we flush it for [acs_magic_object the_public]"
            permission::cache_flush -party_id [acs_magic_object "the_public"]
        }

        aa_true "User '$another_user' has 'calendar_read' permission on calendar '$calendar_id'" \
            [permission::permission_p -party_id $another_user -object_id $calendar_id -privilege calendar_read]
        aa_true "The public has 'calendar_read' permission on calendar '$calendar_id'" \
            [permission::permission_p -party_id [acs_magic_object "the_public"] -object_id $calendar_id -privilege calendar_read]



        #
        # Creating a new calendar item will fire a notification, but
        # only if the notification object has at least 1 subscriber.
        #
        aa_log "Subscribing user '$another_user' to the calendar notification"
        notification::request::new \
            -type_id [notification::type::get_type_id \
                          -short_name calendar_notif] \
            -user_id $another_user \
            -object_id [ad_conn package_id] \
            -interval_id [notification::interval::get_id_from_name -name "instant"] \
            -delivery_method_id [notification::delivery::get_id -short_name "email"]

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

        #
        # Check that the calendar item can be exported as .ics. We use
        # an admin to avoid permission checks.
        #
        set admin_user_info [acs::test::user::create -admin]
        set admin_user_id [dict get $admin_user_info user_id]
        set cal_item_ics_url [aa_get_first_url -package_key calendar]ics/${cal_item_id}.ics
        set d [acs::test::http -user_info $admin_user_info $cal_item_ics_url]
        acs::test::reply_has_status_code $d 200
        aa_true "Content type is .ics" \
            [regexp {^application/x-msoutlook.*$} [ns_set iget [dict get $d headers] Content-type]]

        set mode_pretty [_ calendar.New]
        aa_true "Notification was generated" [db_0or1row check {
            select 1 from notifications
             where notif_subject like '%' || :mode_pretty || '%'
               and response_id = :cal_item_id
        }]

        aa_equals "The notification URL is correct" \
            [calendar::notification::get_url [ad_conn package_id]] \
            [site_node::get_url_from_object_id -object_id [ad_conn package_id]]

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
        calendar::delete -calendar_id $calendar_id_2
        calendar::delete -calendar_id $calendar_id_3
        foreach user_id [list $another_user $admin_user_id] {
            acs::test::user::delete -user_id $user_id \
                -delete_created_acs_objects
        }
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
