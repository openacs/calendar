# /packages/calendar/www/cal-item-edit.tcl

ad_page_contract {
    
    edit an existing calendar item
    
    @author Gary Jin (gjin@arsdigita.com)
    @creation-date Dec 14, 2000
    @cvs-id $Id$
} {
    {cal_item_id:integer}
    {view day}
    {action edit}
    {event_date:array ""}
    {start_time:array ""}
    {end_time:array ""}
    {name ""}
    {description ""}
} 

# find out the user_id 
set user_id [ad_verify_and_get_user_id]


#------------------------------------------------------
# if the action is set to delete
# we call the delete proc and return to
# to index with the passed through options

if { $action == "delete" } {

 cal_item_delete $cal_item_id

 ad_returnredirect "?[export_url_vars date action view]"

}

#------------------------------------------------------
# extract the time info 

set start_datetime [calendar_make_datetime [array get event_date] [array get start_time]]

set end_datetime [calendar_make_datetime [array get event_date] [array get end_time]]


#-----------------------------------------------------------------
# validate time interval ( start_time <= end_time )

if { [dt_interval_check $start_datetime $end_datetime] < 0 } {
    ad_return_compliant 1 "you end time can't happen before start time"
}


#------------------------------------------------------------------
# update the exsiting calendar_item
set cal_item_id [cal_item_update $cal_item_id \
                                 $start_datetime \
	                         $end_datetime \
                                 $name \
				 $description \
				 ]

# set the proper rediret value to view and date
set action "view"
set date [calendar_make_date [array get event_date]]

ad_returnredirect "?[export_url_vars date action view]"





































