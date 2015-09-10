# /packages/calendar/www/admin/calendar-create.tcl

ad_page_contract {
    
    generation of new group calendar
    when a party_wide calendar is generated
    the default permission is that this calendar is 
    
    @author Gary Jin (gjin@arsdigita.com)
    
    @party_id  key to owner id
    @calendar_name  the name of the calendar
    @calendar_permission the permissions of the calendar

    @creation-date Dec 14, 2000
    @cvs-id $Id$
} {
    {party_id:naturalnum,notnull}
    {calendar_name:notnull}
    {calendar_permission "private"}
}

# Needs to perform check on if the calendar_name is already being used
# whether or not this is a need should be further thought about

# create the calendar
set calendar_id [calendar::create $party_id "f" $calendar_name]

# GN: "permission" is here a misnomer, should be called "privilege",
# but it is used in several page contracts of this package.
#
# If the permission is public, we assign it right now.
# If the permission is private, we would have to wait until
# the user selects an audience.

if {$calendar_permission eq "public"} {

    # assign the permission to the calendar
    calendar::assign_permissions $calendar_id $party_id $calendar_permission
    ad_returnredirect  "one?action=permission&calendar_id=$calendar_id"

} elseif {$calendar_permission eq "private"} {

    # This would be a special case where they'd have to select their audience first
    ad_returnredirect  "one?action=permission&calendar_id=$calendar_id&calendar_permission=private"
}







# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
