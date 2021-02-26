ad_library {

    Calendar Package APM callbacks library

    Procedures that deal with installing, instantiating, mounting.

    @creation-date July 2007
    @author rmorales@innova.uned.es
    @cvs-id $Id$
}

namespace eval calendar {}
namespace eval calendar::apm {}


ad_proc -private calendar::apm::package_after_upgrade {
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
                db_dml update_context {}
                db_dml remove_personal_notifications {}
            } on_error {
                ns_log Error "Error:$errmsg"
            }
        }
    }
}

ad_proc -private calendar::apm::before_uninstantiate {
    -package_id:required
} {
    Cleanup calendars from this package instance upon uninstantiation.
} {
    # get calendar ids
    set calendar_list [db_list get_calendar_ids {
        SELECT calendar_id FROM calendars
         WHERE package_id = :package_id
    }]
    # delete calendars
    foreach calendar_id $calendar_list {
        # delete all calendar items
        db_foreach get_calendar_items {
            SELECT cal_item_id FROM cal_items
             WHERE on_which_calendar = :calendar_id
        } {
            calendar::item::delete -cal_item_id $cal_item_id
        }
        # delete item types
        db_foreach get_item_types {
            SELECT item_type_id FROM cal_item_types
             WHERE calendar_id= :calendar_id
        } {
            calendar::item_type_delete -calendar_id $calendar_id -item_type_id $item_type_id
        }
        # delete calendar
        calendar::delete -calendar_id $calendar_id
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
