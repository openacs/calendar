ad_page_contract {
    
    List all the calendars for which the user has the read privilege
    the user has  read privilege
    
    @author Dirk Gomez (openacs@dirkgomez.de)
    @authorr Gary Jin (gjin@arsdigita.com)
    @author Ben Adida (ben@openforce.net)
    @creation-date Dec 14, 2000, May 29th, 2002
    @cvs-id $Id$

} {
}

set user_id [ad_conn user_id]

multirow create calendars calendar_name calendar_id calendar_admin_p
foreach calendar $calendar_list {
    multirow append calendars [lindex $calendar 0] [lindex $calendar 1] [lindex $calendar 2]
}

ad_return_template
