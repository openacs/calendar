# /packages/calendar/www/index.tcl

ad_page_contract {
    
    Main Calendar Page. 
    
    @author Gary Jin (gjin@arsdigita.com)
    @creation-date Dec 14, 2000
    @cvs-id $Id$
} {
    {view day}
    {action view}
    {date now}
    {calendar_list:multiple,optional {}}
} -properties {
    package_id:onevalue
    user_id:onevalue
    name:onevalue
    date:onevalue
    view:onevalue
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





































