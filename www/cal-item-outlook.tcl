# /packages/calendar/www/cal-item.tcl

ad_page_contract {
    
    Output an item as ics for Outlook
    
    @author Ben Adida (ben@openforce)
    @creation-date May 28, 2002
    @cvs-id $Id$
} {
    cal_item_id:integer
}

set ics_stuff [calendar::outlook::format_item -cal_item_id $cal_item_id]

ns_return 200 application/x-msoutlook $ics_stuff
