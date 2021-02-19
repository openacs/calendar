ad_library {
    Automated tests.

    @author Simon Carstensen
    @creation-date 15 November 2003
    @cvs-id $Id$
}

ad_proc -private calendar::exists_p {
    calendar_id
} {
    Checks if a particular calendar exists.

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 18 February 2021

    @param calendar_id
    @return 1 if exists, 0 if doesn't
} {
    return [db_0or1row cal_exists_p {
        select 1 from calendars where calendar_id = :calendar_id
    }]
}

aa_register_case -cats api -procs {
    calendar::new
    calendar::delete
    calendar::rename
    calendar::name
    calendar::exists_p
    acs::test::user::create
} calendar_basic_api {
    Create, rename and delete a calendar

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 18 February 2021
} {
    aa_run_with_teardown -rollback -test_code {
        #
        # Create test user
        #
        set user_id [db_nextval acs_object_id_seq]
        set user_info [acs::test::user::create -user_id $user_id]
        #
        # Create calendar
        #
        set calendar_name "Test calendar"
        set calendar_id [calendar::new \
                            -owner_id $user_id \
                            -calendar_name $calendar_name]
        aa_true "Calendar exists after creation" \
            [calendar::exists_p $calendar_id]
        #
        # Rename calendar
        #
        aa_equals "Calendar name" [calendar::name $calendar_id] "$calendar_name"
        set calendar_name "Test calendar 2"
        calendar::rename -calendar_id $calendar_id -calendar_name $calendar_name
        aa_equals "Calendar name" [calendar::name $calendar_id] "$calendar_name"
        #
        # Delete calendar
        #
        calendar::delete -calendar_id $calendar_id
        aa_false "Calendar exists after deletion" \
            [calendar::exists_p $calendar_id]
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
