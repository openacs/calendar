
ad_library {
    A beginning of an attempt to rewrite calendar by making
    procs cleaner, etc... (ben)

    @author Ben Adida (ben@openforce)
    @creation-date 2002-06-02
}

namespace eval calendar::item {

    ad_proc -public new {
        {-start_date:required}
        {-end_date:required}
        {-name:required}
        {-description:required}
        {-calendar_id:required}
        {-item_type_id ""}
    } {
        # For now we call the old nasty version
        return [cal_item_create $start_date $end_date $name $description $calendar_id [ad_conn peeraddr] [ad_conn user_id] $item_type_id]
    }

    ad_proc -public get {
        {-cal_item_id:required}
        {-array:required}
    } {
        Get the data for a calendar item
    } {
        upvar $array row

        db_1row select_item_data {} -column_array row
    }
        
    ad_proc -public edit {
        {-cal_item_id:required}
        {-start_date:required}
        {-end_date:required}
        {-name:required}
        {-description:required}
        {-item_type_id ""}
        {-edit_all_p 0}
    } {
        Edit the item
    } {
        cal_item_update $cal_item_id $start_date $end_date $name $description $item_type_id $edit_all_p
    }

    ad_proc -public delete {
        {-cal_item_id:required}
    } {
        delete the item
    } {
        cal_item_delete $cal_item_id
    }
    
}
