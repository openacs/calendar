
# /packages/calendar/www/cal-item-create.tcl

ad_page_contract {
    
    Creation of new recurrence for cal item
    
    @author Ben Adida (ben@openforce.net)
    @creation-date 10 Mar 2002
    @cvs-id $Id$
} {
    cal_item_id
} 

# Verify permission
ad_require_permission $cal_item_id cal_item_write

# Select basic information about the event
db_1row get_item_data { 
    select   to_char(start_date,'HH24:MI')as start_time,
    to_char(start_date, 'MM/DD/YYYY') as start_date,
    to_char(end_date, 'HH24:MI') as end_time,
    nvl(a. name, e.name) as name,
    nvl(e.description, a.description) as description,
    calendar_name,
    to_char(start_date, 'Day') as day_of_week,
    to_char(start_date, 'DD') as day_of_month
    from     acs_activities a, acs_events e, timespans s, time_intervals t, calendars c, cal_items ci
    where    e.timespan_id = s.timespan_id
    and      s.interval_id = t.interval_id
    and      e.activity_id = a.activity_id
    and      e.event_id = :cal_item_id
    and      ci.cal_item_id= :cal_item_id
    and      ci.on_which_calendar= c.calendar_id
}

# Select information about which day of the week it is, etc...
