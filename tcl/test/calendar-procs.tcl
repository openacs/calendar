ad_library {
    Automated tests.

    @author Simon Carstensen
    @creation-date 15 November 2003
    @cvs-id $Id$
}

aa_register_case calendar_create {
    Test the calendar_create proc.
} { 

    aa_run_with_teardown \
        -rollback \
        -test_code {
            
            # Create calendar
            set calendar_id [calendar_create [ad_conn user_id] t "foo"]
            
            set success_p [db_string success_p {
                select 1 from calendars where calendar_id = :calendar_id
            } -default "0"]

            aa_equals "calendar was created succesfully" $success_p 1
        }
}

aa_register_case calendar_update {
    Test the calendar_update proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {
            
            set owner_id [ad_conn user_id]

            # Create calendar
            set calendar_id [calendar_create $owner_id f "foo"]
            calendar_update $calendar_id $owner_id "bar" "public"
            
            db_1row success_p {
                select calendar_name, private_p from calendars where calendar_id = :calendar_id
            }

            aa_equals "calendar name was succesfully updated" $calendar_name "bar"
            aa_equals "calendar name was succesfully updated" $private_p "f"
        }
}

aa_register_case calendar_get_name {
    Test the calendar_get_name proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {
            
            # Create calendar
            set calendar_id [calendar_create [ad_conn user_id] t "foo"]
            set calendar_name [calendar_get_name $calendar_id]

            aa_equals "calendar name is correct" $calendar_name "foo"
        }
}

aa_register_case calendar_public_p {
    Test the calendar_public_p proc.
} {    

    aa_run_with_teardown \
        -rollback \
        -test_code {
            
            # Create calendar
            set calendar_id [calendar_create [ad_conn user_id] f "foo"]
            set public_p [calendar_public_p $calendar_id]

            aa_equals "calendar is public" $public_p "t"
        }
}
