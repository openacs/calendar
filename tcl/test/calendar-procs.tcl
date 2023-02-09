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

aa_register_case -cats {
    api smoke
} -procs {
    calendar::attachments_enabled_p
    site_node_apm_integration::child_package_exists_p
    site_node_apm_integration::get_child_package_id
} attachments_enabled {
    Checks the attachment detection api
} {
    set old_package_id [ad_conn package_id]

    aa_run_with_teardown -rollback -test_code {
        set safe_name [db_string q {select max(name) || 'z' from site_nodes}]
        set package_id [site_node::instantiate_and_mount -package_key calendar -node_name $safe_name]

        ad_conn -set package_id $package_id

        aa_false "No attachments on the new calendar instance" [calendar::attachments_enabled_p]

        set node [site_node::get_from_object_id -object_id $package_id]
        set node_id [dict get $node node_id]

        site_node::instantiate_and_mount -package_key attachments -parent_node_id $node_id

        aa_true "Attachments are available" [calendar::attachments_enabled_p]

        ad_conn -set package_id $old_package_id
    } -teardown_code {
        ad_conn -set package_id $old_package_id
    }
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
