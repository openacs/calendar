ad_library {

    Calendar Package APM callbacks library

    Procedures that deal with installing, instantiating, mounting.

    @creation-date July 2007
    @author rmorales@innova.uned.es
    @cvs-id $Id$
}

namespace eval calendar {}
namespace eval calendar::apm {}


ad_proc -public calendar::apm::package_after_upgrade {
    -from_version_name:required
    -to_version_name:required
} {
    Upgrade script for the calendar  package
} {
    apm_upgrade_logic \
    -from_version_name $from_version_name \
    -to_version_name $to_version_name \
    -spec {
        2.1.0b7 2.1.0b8 {
            db_transaction {
                # get all personal calendars
                set to_modify [db_list to_modify "select calendar_id from calendars  
                        where calendar_name = 'Personal'"] 
                foreach obj $to_modify {
                    # set security_inherit_p to false
                    db_dml update_context "update acs_objects
                            set security_inherit_p = 'f'
                            where object_id = :obj"
                    ns_log Notice "updated calendar $obj"
                }
            } on_error {
                ns_log Error "Error:$errmsg"
            }

            db_transaction {
                # done with permissions, now we get rid of personal notifications
                set req_to_delete [db_list req_to_delete "select unique request_id  from notification_requests, calendars 
                        where calendar_name = 'Personal' and package_id = object_id
                        and type_id = (select type_id from notification_types 
                                    where short_name = 'calendar_notif')"]            
                # do the delete
                foreach req_id $req_to_delete {
                    db_dml remove_personal_notifications "delete from notification_requests where request_id = :req_id"
                    ns_log Notice "removed notification request $req_id to personal calendar" 
                }
            } on_error {
                ns_log Error "Error:$errmsg"
            }
        }
    }
}



