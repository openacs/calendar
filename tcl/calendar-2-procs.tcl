
ad_library {
    A beginning of an attempt to rewrite calendar by making
    procs cleaner, etc... (ben)

    @author Ben Adida (ben@openforce)
    @creation-date 2002-03-16
}

namespace eval calendar {

    ad_proc -public get_item_types {
        {-calendar_id:required}
    } {
        return the item types
    } {
        return [db_list_of_lists select_item_types {}]
    }

    ad_proc -public item_type_new {
        {-calendar_id:required}
        {-item_type_id ""}
        {-type:required}
    } {
        creates a new item type
    } {
        if {[empty_string_p $item_type_id]} {
            set item_type_id [db_nextval cal_item_type_seq]
        }

        db_dml insert_item_type {}

        return $item_type_id
    }

    ad_proc -public item_type_delete {
        {-calendar_id:required}
        {-item_type_id:required}
    } {
        db_transaction {
            # Remove the mappings for all events
            db_dml reset_item_types {}
            
            # Remove the item type
            db_dml delete_item_type {}
        }
    }

}
