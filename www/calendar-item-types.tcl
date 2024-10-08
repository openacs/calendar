ad_page_contract {

    Manage the calendar item types

    @author Ben Adida (ben@openforce.net)

    @creation-date Mar 16, 2002
    @cvs-id $Id$
} {
    calendar_id:naturalnum,notnull
}

# Permission check
permission::require_permission -object_id $calendar_id -privilege calendar_admin

# List the item types and allow addition of a new one
set item_types [calendar::get_item_types -calendar_id $calendar_id]
set doc(title) [_ calendar.Manage_Item_Types]
set context [list $doc(title)]

ad_form -name add-new-item-type -action item-type-new -has_submit 1 -form {
    {calendar_id:text(hidden)
        {value $calendar_id}
    }
    {type:text,nospell
        {label "[_ calendar.New_Type]"}
        {html {size 100}}
    }
    {btn_ok:text(submit)
        {label "[_ calendar.add]"}
    }
}


template::list::create \
    -name item_types \
    -multirow item_types \
    -no_data "" \
    -elements {
        col1 {
            label "[_ calendar.Calendar_Item_Types]"
        }
        col2 {
            label "[_ acs-kernel.common_Actions]"
            link_url_col col2_url
        }
    }

multirow create item_types col1 col2 col2_url

foreach item_type $item_types {
    lassign $item_type type item_type_id
    if {$item_type_id eq ""} {
        continue
    }
    multirow append item_types "$type" "[_ acs-kernel.common_Delete]" [export_vars -base "item-type-delete" {calendar_id item_type_id}]
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
