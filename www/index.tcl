# /packages/calendar/www/index.tcl

ad_page_contract {
    
    Main Calendar Page. 
    
    @author Gary Jin (gjin@arsdigita.com)
    @creation-date Dec 14, 2000
    @cvs-id $Id$
} {
    {view day}
    {action view}
    {date ""}
    {julian_date ""}
    {calendar_list:multiple,optional {}}
    {return_url ""}
    {force_calendar_id ""}
    {show_cal_nav 1}
} -properties {
    package_id:onevalue
    user_id:onevalue
    name:onevalue
    date:onevalue
    view:onevalue
}

if {[empty_string_p $date]} {
    if {[empty_string_p $julian_date]} {
        set date now
    } else {
        set date [db_string select_from_julian "select to_date(:julian_date ,'J') from dual"]
    }
}

# find out the user_id 
set user_id [ad_verify_and_get_user_id]

db_0or1row user_name_select {
        select first_names || ' ' || last_name as name, email
        from persons, parties
        where person_id = :user_id
        and person_id = party_id
}

set package_id [ad_conn package_id]



ad_return_template 





































