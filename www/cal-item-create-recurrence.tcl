# /packages/calendar/www/cal-item-create.tcl

ad_page_contract {

    Creation of new recurrence for cal item

    @author Ben Adida (ben@openforce.net)
    @creation-date 10 Mar 2002
    @cvs-id $Id$
} {
    cal_item_id:object_id,notnull
    {return_url:localurl "./"}
    {days_of_week:range(0|6),multiple ""}
}


auth::require_login
permission::require_permission -object_id $cal_item_id -privilege cal_item_write

calendar::item::get -cal_item_id $cal_item_id -array cal_item

set dow_string ""
foreach dow {
    {"#calendar.Sunday#" 0} {"#calendar.Monday#" 1} {"#calendar.Tuesday#" 2}
    {"#calendar.Wednesday#" 3} {"#calendar.Thursday#" 4} {"#calendar.Friday#" 5}
    {"#calendar.Saturday#" 6}
} {
    if {[lindex $dow 1] == $cal_item(day_of_week) - 1} {
        set checked_html "CHECKED"
    } else {
        set checked_html ""
    }

    set dow_string "$dow_string <INPUT TYPE=checkbox name=days_of_week value=[lindex $dow 1] $checked_html id=\"cal_item:elements:interval_type:days_of_week:[lindex $dow 1]\" >[lindex $dow 0] &nbsp;\n"
}

set recurrence_options [list \
                            [list [_ calendar.day_s] day] \
                            [list "$dow_string [_ calendar.of_the_week]" week] \
                            [list "[_ calendar.day] $cal_item(day_of_month) [_ calendar.of_the_month]" month_by_date] \
                            [list "[_ calendar.same] $cal_item(pretty_day_of_week) [_ calendar.of_the_month]" month_by_day] \
                            [list [_ calendar.year] year]]

ad_form -name cal_item  -export {return_url} -form {
    {cal_item_id:key}
    {every_n:integer(number),optional
        {label "[_ calendar.Repeat_every]"}
        {value 1}
        {html
            {size 4 min 1}
        }
    }
    {interval_type:text(radio)
        {label ""}
        {options $recurrence_options}
    }
    {recur_until:h5date
        {label "[_ calendar.lt_Repeat_this_event_unt]"}
    }
    {submit:text(submit) {label "[_ calendar.Add_Recurrence]"}}
} -validate {
    {recur_until
        {
            [calendar::item::dates_valid_p -start_date $cal_item(start_date) -end_date $recur_until]
        }
        "#calendar.start_time_before_end_time#"
    }
} -edit_data {

    calendar::item::add_recurrence \
        -cal_item_id $cal_item_id \
        -interval_type $interval_type \
        -every_n $every_n \
        -days_of_week $days_of_week \
        -recur_until $recur_until

} -edit_request {

    set recur_until $cal_item(start_date)
    set interval_type week

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -has_submit 1


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
