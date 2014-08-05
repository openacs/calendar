
ad_page_contract {

    Delete an item type
    
    @author Ben Adida (ben@openforce.net)
    
    @creation-date Mar 16, 2002
    @cvs-id $Id$
} {
    calendar_id:naturalnum,notnull
    item_type_id:naturalnum,notnull
}

# Permission check
permission::require_permission -object_id $calendar_id -privilege calendar_admin

# Delete the type
calendar::item_type_delete -calendar_id $calendar_id -item_type_id $item_type_id

ad_returnredirect "calendar-item-types?calendar_id=$calendar_id"


