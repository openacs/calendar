
ad_page_contract {
    
    Choose a Calendar
    
    @author Brad Duell (bduell@ncacasi.org)
    @creation-date 2002-08-06
    @cvs-id $Id$
} {
    {return_url ""}
    {date ""}
    {julian_date ""}
    {start_time ""}
    {end_time ""}
}

set user_id [ad_maybe_redirect_for_registration]

set package_id [ad_conn package_id]

set date [calendar::adjust_date -date $date -julian_date $julian_date]

set calendar_list [calendar::calendar_list]

ad_form -name cals -export {return_url} -form {
    {calendar_id:integer(select)    {label "[_ calendar.Calendar]"}
                                           {options $calendar_list}
        {value {[lindex [lindex $calendar_list 0] 1]}}
    }
    
} -on_submit {
    ad_returnredirect "$return_url&calendar_id=$calendar_id"
    ad_script_abort
}
ad_return_template
