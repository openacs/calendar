# /packages/calendar/www/cal-nav.tcl

ad_page_contract {
    
    option pages

    list all the calendars that has
    the user has  read privilege
    
    @view
    @date
    @calendar_id
    @calendar_list

    @author Gary Jin (gjin@arsdigita.com)
    @creation-date Dec 14, 2000
    @cvs-id $Id$


} {

    {view day}
    {date now}
    {calendar_id:integer "-1"}
    {calendar_list:multiple,optional {}}

} -properties {

    private_id:onevalue
    private_checked_p:onevalue

    date:onevalue
    view:onevalue
    
    calendars:multirow   
    calendar_id_list:multirow
    
}

# get a user_id
set user_id [ad_verify_and_get_user_id]


# get a list of the calendars that the user has read access to
# NOTE: this query would need to optimized. Its take a major
# performence hit when the system have a lot of objects (ie. 
# 20000+ rows of geographical data)
#
# A possbile solution for a later release would be to query out
# only objects with acs_object_type of calendar or calendar events
# and then include that as a subquery on permissions (basically 
# construct a calendar only version of the acs_object_party_privilege_map

#    select   unique(object_id) as calendar_id, 
 #            calendar.name(object_id) as calendar_name,
  #           ' ' as checked_p
   # from     acs_object_party_privilege_map 
   # where    calendar.show_p(object_id, :user_id) = 't'
   # and      calendar.readable_p(object_id, :user_id) = 't'
   # and      party_id = :user_id
   # and      acs_object_util.object_type_p(object_id, 'calendar') = 't'
   # and      calendar.private_p(object_id) = 'f'

    #union

#    select   cal_item.on_which_calendar(object_id) as calendar_id, 
#             calendar.name(cal_item.on_which_calendar(object_id)) as calendar_name,
#             ' ' as checked_p
#    from     acs_object_party_privilege_map 
#    where    privilege = 'cal_item_read'
#    and      calendar.show_p(cal_item.on_which_calendar(object_id), :user_id) = 't'
#    and      party_id = :user_id
#    and      acs_object_util.object_type_p(object_id, 'cal_item') = 't'
 #   and      calendar.private_p(cal_item.on_which_calendar(object_id)) = 'f'


db_multirow calendars get_readable_calendars {

    select   unique(calendar_id) as calendar_id,
             calendar_name,
             ' ' as checked_p
    from     calendars
    where    acs_permission.permission_p(calendar_id, :user_id, 'calendar_read') = 't'
    and      acs_permission.permission_p(calendar_id, :user_id, 'calendar_show') = 't'
    and      private_p = 'f'

    union 
    
    select  unique(on_which_calendar) as calendar_id,
            calendar.name(on_which_calendar) as calendar_name,
            ' ' as checked_p
    from    cal_items
    where   acs_permission.permission_p(cal_item_id, :user_id, 'cal_item_read') = 't'
    and     calendar.private_p(on_which_calendar) = 'f'

      
}


#-------------------------------------------------------------

# initialize the private marker
set private_checked_p ""

# get a list of the calendar_id that's currently selected
# multirow method is going to be used to send the ids to 
# the template.


if { [llength $calendar_list] == 0 } {
    # in the case when a single calendar is selected (when a user
    # clicked on the link as oppse to using the check box and hit
    # the button, then the calendar_list will be empty and we
    # use the calendar_id instead.
    
    # check for private calendar
    # if not, then do the comparison

    if { [string equal $calendar_id "-1"] } {
	set private_checked_p "checked"

    } else {

	# check the selected calendar
	for {set i 1} {$i <= [multirow size calendars] } {incr i} {
	    if { [string equal [multirow get calendars $i calendar_id] $calendar_id] } {
		multirow set calendars $i checked_p "checked"
	    }
	}
    
    }

} else {

    # we cross check the existing calendar_id
    # with the id that from the selected list.
    # if calendar_id are being selected, we 
    # set checked_p to "checked"
    #
    # this is quite ineifficent since i am looking 
    # the id through two loops. But which ever way 
    # i perform this cross check, i would have to
    # cycle through all of the ids in one set to math
    # with all the id in another set.


    foreach items $calendar_list {
	
	# check for private calendar (when id = -1)
	if { [string equal [lindex $items 0] "-1"] } {
	    set private_checked_p "checked"
	} 

	# checked the selected calendar
	for {set i 1} {$i <= [multirow size calendars]} {incr i} {

	    if { [string equal [multirow get calendars $i calendar_id] [lindex $items 0]] } {		
		multirow set calendars $i checked_p "checked"
	    }
	}
		
    }


}

return
ad_return_template






