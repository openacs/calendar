# /packages/calendar/tcl/calendar-procs.tcl

ad_library {

    Utility functions for Calendar Applications

    @author Dirk Gomez (openacs@dirkgomez.de)
    @author Gary Jin (gjin@arsdigita.com)
    @author Ben Adida (ben@openforce.net)
    @creation-date Dec 14, 2000
    @cvs-id $Id$

}

namespace eval calendar {}


#------------------------------------------------
# datetime info extraction

ad_proc calendar_make_datetime {
    event_date
    {event_time ""}
} {
    given a date, and a time, construct the proper date string
    to be imported into oracle. (yyyy-mm-dd hh24:mi format)s
} {
    
    # MUST CONVERT TO ARRAYS! (ben)
    array set event_date_arr $event_date
    if {![empty_string_p $event_time]} {
        array set event_time_arr $event_time
    }
    
    # extract from even-date 
    set year   $event_date_arr(year)
    set day    $event_date_arr(day)
    set month  $event_date_arr(month)
    
    if {![empty_string_p $event_time]} {
        # extract from event_time
        set hours $event_time_arr(hours)
        set minutes $event_time_arr(minutes)
        
        # AM/PM? (ben - openacs fix)
        if {[info exists event_time_arr(ampm)]} {
            if {$event_time_arr(ampm)} {
                if {$hours < 12} {
                    incr hours 12
                }
            } else {
                # This is the case where we're dealing with AM/PM
                # The one issue we have to worry about is 12am
                if {!$event_time_arr(ampm) && $hours == 12} {
                    set hours 0
                }
            }
        }
        
        if {$hours < 10} {
            set hours "0$hours"
        }
        
    }
    
    
    if {$month < 10} {
	set month "0$month"
    }
    
    if {$day < 10} {
	set day "0$day"
    }
    
    if {[empty_string_p $event_time]} {
        return "$year-$month-$day"
    } else {
        return "$year-$month-$day $hours:$minutes"
    }
    
}


#------------------------------------------------
# figure out if user have a private calendar or not
# again, best suited to be rolled into the pl/sql

ad_proc calendar_have_private_p { 
    {-return_id 0} 
    {-calendar_id_list {}}
    party_id 
} {
    check to see if ther user have a prviate calendar
    if -return_id is 1, then proc will return the calendar_id

    @param calendar_id_list If you supply the calendar_id_list, then we'll only search 
    for a personal calendar among the calendars supplied here.
} {

    if { [llength $calendar_id_list] > 0 } {
        set result [db_string get_calendar_info_calendar_id_list {} -default 0]
    } else {
        set result [db_string get_calendar_info {} -default 0]
    }
    
    if { ![string equal $result "0"] } {

	if { [string equal $return_id "1"] } {
	    return $result
	} else {
	    return 1
	}
 
    } else {
	
	return 0
    }
}


#------------------------------------------------
# creating a new calendar

ad_proc calendar_create { owner_id
                          private_p          
                          {calendar_name ""}       
} {

    create a new calendar
    private_p is default to true since the default
    calendar is a private calendar 
} {

    # find out configuration info
    set package_id [ad_conn package_id]
    set creation_ip [ad_conn "peeraddr"]
    set creation_user [ad_conn "user_id"]
    
    # BMA:FIXME: this needs to be fixed a LOT more, but for now we patch the obvious
    if {$creation_user == 0} {
        set creation_user $owner_id
    }

    set calendar_id [db_exec_plsql create_new_calendar {
	begin
	:1 := calendar.new(
	  owner_id      => :owner_id,
	  private_p     => :private_p,
	  calendar_name => :calendar_name,
	  package_id    => :package_id,
	  creation_user => :creation_user,
	  creation_ip   => :creation_ip
	);	
	end;
    }
    ]
    
    return $calendar_id
    
}


#------------------------------------------------
# assign the permission of the calendar to a party

ad_proc calendar_assign_permissions { calendar_id
                                      party_id
                                      cal_privilege
                                      {revoke ""}                        
} {
    given a calendar_id, party_id and a permission
    this proc will assign the permission to the party
    the legal permissions are

    public, private, calendar_read, calendar_write, calendar_delete

    if the revoke is set, then the given permission will 
    be removed for the party

} {
    # default privilege is being able to read 

    # if the permission is public, oassign the magic object
    # and set permission to read

    if { [string equal $cal_privilege "public"] } {
	
        set party_id [acs_magic_object "the_public"]
	set cal_privilege "calendar_read"
    } elseif { [string equal $cal_privilege "private"] } {
	set cal_privilege "calendar_read"
    } 


    if { [empty_string_p $revoke] } {
	# grant the permissions
        permission::grant -object_id $calendar_id -party_id $party_id -privilege $cal_privilege

    } elseif { [string equal $revoke "revoke"] } {
	# revoke the permissions

        permission::revoke -object_id $calendar_id -party_id $party_id -privilege $cal_privilege

    }    

}


#------------------------------------------------
# find out the name of a calendar 
# NOTE: calendar.name()

ad_proc calendar_get_name { calendar_id } {
    
    find out the name of a calendar
} {
    
    return [db_string get_calendar_name {
	       select  calendar.name(:calendar_id)
	       from    dual
    } -default ""]

}

                          

#------------------------------------------------
# figures out if a given calendar is public or not

ad_proc calendar_public_p { calendar_id } {

    returns 't' if a given calendar is public 
    and 'f' if it is not 

} {
    set private_p [db_string check_calendar_p "select private_p from calendars where calendar_id = :calendar_id"]

    if { $private_p == "t" } {
        return "f"
    } else {
        return "t"
    }

}


ad_proc -public calendar::get_month_multirow_information {
    {-current_day:required}
    {-today_julian_date:required}
    {-first_julian_date_of_month:required}
} {
    @author Dirk Gomez (openacs@dirkgomez.de)
    @creation-date 20-July-2003
} {
    set first_day_of_week [lc_get firstdayofweek]
    set last_day_of_week [expr [expr $first_day_of_week + 6] % 7]

    if {$current_day == $today_julian_date} {
        set today_p t 
    } else {
        set today_p f
    }
    set day_number [expr $current_day - $first_julian_date_of_month +1]
    set weekday [expr [expr $current_day % 7] +1]

    set beginning_of_week_p f
    set end_of_week_p f
    if {$weekday == $last_day_of_week} {
        set end_of_week_p t
    } elseif {$weekday == $first_day_of_week} {
        set beginning_of_week_p t
    }
    return [list day_number $day_number \
                today_p $today_p \
                beginning_of_week_p $beginning_of_week_p \
                end_of_week_p $end_of_week_p]
}

ad_proc -public calendar::from_sql_datetime {
    {-sql_date:required}
    {-format:required}
} {
    
} {
    # for now, we recognize only "YYYY-MM-DD" "HH12:MIam" and "HH24:MI". 
    set date [template::util::date::create]

    switch -exact -- $format {
        {YYYY-MM-DD} {
            regexp {([0-9]*)-([0-9]*)-([0-9]*)} $sql_date all year month day

            set date [template::util::date::set_property format $date {DD MONTH YYYY}]
            set date [template::util::date::set_property year $date $year]
            set date [template::util::date::set_property month $date $month]
            set date [template::util::date::set_property day $date $day]
        }

        {HH12:MIam} {
            regexp {([0-9]*):([0-9]*) *([aApP][mM])} $sql_date all hours minutes ampm
            
            set date [template::util::date::set_property format $date {HH12:MI am}]
            set date [template::util::date::set_property hours $date $hours]
            set date [template::util::date::set_property minutes $date $minutes]                
            set date [template::util::date::set_property ampm $date [string tolower $ampm]]
        }

        {HH24:MI} {
            regexp {([0-9]*):([0-9]*)} $sql_date all hours minutes

            set date [template::util::date::set_property format $date {HH24:MI}]
            set date [template::util::date::set_property hours $date $hours]
            set date [template::util::date::set_property minutes $date $minutes]
        }

        {HH24} {
            set date [template::util::date::set_property format $date {HH24:MI}]
            set date [template::util::date::set_property hours $date $sql_date]
            set date [template::util::date::set_property minutes $date 0]
        }
        default {
            set date [template::util::date::set_property ansi $date $sql_date]
        }
    }

    return $date
}

ad_proc -public calendar::to_sql_datetime {
    {-date:required}
    {-time:required}
    {-time_p 1}
} {
    This takes two date chunks, one for date one for time,
    and combines them correctly.

    The issue here is the incoming format.
    date: ANSI SQL YYYY-MM-DD
    time: we return HH24.
} {
    # Set the time to 0 if necessary
    if {!$time_p} {
        set hours 0
        set minutes 0
    } else {
        set hours [template::util::date::get_property hours $time]
        set minutes [template::util::date::get_property minutes $time]
    }

    set year [template::util::date::get_property year $date]
    set month [template::util::date::get_property month $date]
    set day [template::util::date::get_property day $date]

    # put together the timestamp
    return "$year-$month-$day $hours:$minutes"
}

ad_proc -public calendar::calendar_list {
    {-package_id ""}
    {-user_id ""}
    {-privilege ""}
} {
    # If no user_id
    if {[empty_string_p $user_id]} {
        set user_id [ad_conn user_id]
    }

    if {[empty_string_p $package_id]} {
        set package_id [ad_conn package_id]
    }
    
    set permissions_clause {}
    if { ![empty_string_p $privilege] } {
        set permissions_clause [db_map permissions_clause]
    }

    set new_list [db_list_of_lists select_calendar_list {}]
}

ad_proc -public calendar::adjust_date {
    {-date ""}
    {-julian_date ""}
} {
    if {[empty_string_p $date]} {
        if {![empty_string_p $julian_date]} {
            set date [dt_julian_to_ansi $julian_date]
        } else {
            set date [dt_sysdate]
        }
    }

    return $date
}

ad_proc -public calendar::new {
    {-owner_id:required}
    {-private_p "f"}
    {-calendar_name:required}
    {-package_id ""}
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }
    set extra_vars [ns_set create]
    set context_id $package_id
    oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {owner_id private_p calendar_name package_id context_id}

    set calendar_id [package_instantiate_object -extra_vars $extra_vars calendar]

    return $calendar_id
}

ad_proc -public calendar::personal_p { 
    {-calendar_id:required}
    {-user_id ""}
} {
    Returns true (1) if this is the user's personal calendar, false (0) otherwise.
    
    @param user_id The user whose calendar you want to check
} {
    if { [empty_string_p $user_id] } {
        set user_id [ad_conn user_id]
    }
    calendar::get -calendar_id $calendar_id -array calendar
    if { [template::util::is_true $calendar(private_p)] && $calendar(owner_id) == $user_id } {
        return 1
    } else {
        return 0
    } 
}

ad_proc -public calendar::update { 
    {-calendar_id:required}
    {-calendar_name:required}
} {
    Edit calendar
} {
    
    # Update the calendar table
    db_dml update_calendar {
	update   calendars
	set      calendar_name = :calendar_name
	where    calendar_id = :calendar_id	
    }
}

ad_proc -public calendar::get {
    {-calendar_id:required}
    {-array:required}
} {
    Get calendar info
} {
    upvar 1 $array row
    db_1row select_calendar {} -column_array row
}
    

ad_proc -public calendar::delete {
    {-calendar_id:required}
} {
    Delete a calendar
} {
    db_exec_plsql delete_calendar {}
}

ad_proc -public calendar::get_item_types {
    {-calendar_id:required}
} {
    return the item types
} {
    return [concat [list [list {--} {}]] \
            [db_list_of_lists select_item_types {}]]
}

ad_proc -public calendar::item_type_new {
    {-calendar_id:required}
    {-item_type_id ""}
    {-type:required}
} {
    creates a new item type
} {
    if {[empty_string_p $item_type_id]} {
        set item_type_id [db_nextval cal_item_type_seq]
    }

    db_dml insert_item_type {}

    return $item_type_id
}

ad_proc -public calendar::item_type_delete {
    {-calendar_id:required}
    {-item_type_id:required}
} {
    db_transaction {
        # Remove the mappings for all events
        db_dml reset_item_types {}
        
        # Remove the item type
        db_dml delete_item_type {}
    }
}

ad_proc -public calendar::attachments_enabled_p {} {
    set package_id [site_node_apm_integration::child_package_exists_p \
        -package_key attachments
    ]
}

ad_proc -public calendar::rename {
    {-calendar_id:required}
    {-name:required}
} {
    rename a calendar
} {
    db_dml rename_calendar {}
}

ad_proc -private calendar::compare_day_items_by_current_hour {a b} {
    Compare a day item by the current hour (field 0)
} {
    set a_criterium [lindex $a 0]
    set b_criterium [lindex $b 0]
    if {$a_criterium > $b_criterium} {
        return 1
    } elseif {$a_criterium < $b_criterium} {
        return -1
    } 
    return 0
}

