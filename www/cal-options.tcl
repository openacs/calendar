# /packages/calendar/www/cal-nav.tcl

ad_page_contract {
    
    option pages

    list all the calendars that has
    the user has  read privilege
    
    @view
    @date
    @calendar_id
    @calendar_list

    @author Gary Jin (gjin@arsdigita.com), Ben Adida (ben@openforce)
    @creation-date Dec 14, 2000, May 29th, 2002
    @cvs-id $Id$


} {
}

# get a user_id
set user_id [ad_verify_and_get_user_id]

set calendar_list [calendar::calendar_list]

set calendar_list_sql "[join $calendar_list ","]"

db_multirow calendars select_calendars "
    select calendar_id, calendar_name
    from calendars
    where calendar_id in ($calendar_list_sql)
"

ad_return_template
