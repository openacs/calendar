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
namespace eval calendar::notification {}

ad_proc -deprecated calendar::make_datetime {
    event_date
    {event_time ""}
} {
    given a date, and a time, construct the proper date string
    to be imported into oracle. (yyyy-mm-dd hh24:mi format)s

    DEPRECATED: clock idioms and HTML5 feature make this date
                conversion api less useful

    @see clock
} {

    # MUST CONVERT TO ARRAYS! (ben)
    array set event_date_arr $event_date
    if {$event_time ne ""} {
        array set event_time_arr $event_time
    }

    # extract from even-date
    set year   $event_date_arr(year)
    set day    $event_date_arr(day)
    set month  $event_date_arr(month)

    if {$event_time ne ""} {
        # extract from event_time
        set hours $event_time_arr(hours)
        set minutes $event_time_arr(minutes)

        # AM/PM? (ben - OpenACS fix)
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

    if {$event_time eq ""} {
        return "$year-$month-$day"
    } else {
        return "$year-$month-$day $hours:$minutes"
    }
}

ad_proc calendar::create {
    owner_id
    private_p
    {calendar_name ""}
} {
    Create a new calendar.

    @param private_p defaults to true since the default calendar is a
                     private calendar.
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
    #removing inherited permissions
    permission::set_not_inherit -object_id $calendar_id

    return $calendar_id

}

ad_proc -deprecated calendar::assign_permissions {
    calendar_id
    party_id
    cal_privilege
    {revoke ""}
} {
    Given a calendar_id, party_id and a permission this proc will
    assign the permission to the party the legal permissions are:

    public, private, calendar_read, calendar_write, calendar_delete

    If the revoke is set, then the given permission will be removed
    for the party.

    DEPRECATED: this api is a trivial wrapper to the permission api

    @see permission::grant
    @see permission::revoke
} {
    # Default privilege is being able to read.

    # If the permission is public, assign the magic object and set
    # permission to read.

    if {$cal_privilege eq "public"} {
        set party_id [acs_magic_object "the_public"]
        set cal_privilege "calendar_read"
    } elseif {$cal_privilege eq "private"} {
        set cal_privilege "calendar_read"
    }

    if { $revoke eq "" } {
        # grant the permissions
        permission::grant -object_id $calendar_id -party_id $party_id -privilege $cal_privilege
    } elseif {$revoke eq "revoke"} {
        # revoke the permissions
        permission::revoke -object_id $calendar_id -party_id $party_id -privilege $cal_privilege
    }
}

ad_proc -public calendar::have_private_p {
    {-return_id 0}
    {-calendar_id_list {}}
    {-party_id party_id }
} {
    Check to see if the user has a private calendar.

    When the provided -return_id is 1, then proc will return the
    calendar_id

    @param calendar_id_list If you supply the calendar_id_list, then
                            we'll only search for a personal calendar
                            among the calendars supplied here.
    @param return_id when set to 1, this proc will return the
                     calendar_id

    @return boolean or the calendar_id according to 'return_id' flag.
} {
    # Check whether the user is logged in at all
    if { !$party_id } {
        return -1
    }

    if { [llength $calendar_id_list] > 0 } {
        set result [db_string get_calendar_info_calendar_id_list {} -default 0]
    } else {
        set result [db_string get_calendar_info {} -default 0]
    }

    if { $result != 0 } {
        if { $return_id == 1 } {
            return $result
        } else {
            return 1
        }
    } else {
        return 0
    }
}


ad_proc -public calendar::name { calendar_id } {
    Return a calendar's name
} {
    return [db_string get_calendar_name {} -default ""]
}


ad_proc -private calendar::get_month_multirow_information {
    {-current_day:required}
    {-today_julian_date:required}
    {-first_julian_date_of_month:required}
} {
    Builds a multirow with information about the month. Used to
    display the month calendar view.

    @author Dirk Gomez (openacs@dirkgomez.de)
    @creation-date 20-July-2003
} {
    set first_day_of_week [lc_get firstdayofweek]
    set last_day_of_week [expr {($first_day_of_week + 6) % 7}]

    if {$current_day == $today_julian_date} {
        set today_p t
    } else {
        set today_p f
    }
    set day_number [expr {$current_day - $first_julian_date_of_month +1}]
    set weekday [expr {($current_day + 1) % 7}]

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
                end_of_week_p $end_of_week_p \
                weekday $weekday]
}

ad_proc -deprecated calendar::from_sql_datetime {
    {-sql_date:required}
    {-format:required}
} {
    Converts a date in a specified format into a templating date dict.

    @param sql_date a date in one of the supported format.
    @param format one of the supported format, "YYYY-MM-DD",
                  "HH12:MIam" or "HH24:MI". When unspecified or
                  invalid, we will try to treat the date as an ansi
                  date.

    DEPRECATED: this api has been superseded by api in acs-templating.

    @see template::data::from_sql::date
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

ad_proc -deprecated calendar::to_sql_datetime {
    {-date:required}
    {-time:required}
    {-time_p 1}
} {
    This takes two date chunks, one for date one for time,
    and combines them correctly.

    The issue here is the incoming format.
    date: ANSI SQL YYYY-MM-DD
    time: we return HH24.

    DEPRECATED: this api has been superseded by api in acs-templating.

    @see template::data::to_sql::date
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
    @return a list of calendars
} {
    # If no user_id
    if {$user_id eq ""} {
        set user_id [ad_conn user_id]
    }

    if {$package_id eq ""} {
        set package_id [ad_conn package_id]
    }

    set permissions_clause {}
    if { $privilege ne "" } {
        set permissions_clause {and acs_permission.permission_p(calendar_id, :user_id, :privilege)}
    }

    set new_list [db_list_of_lists select_calendar_list [subst {
       select calendar_name,
              calendar_id,
              acs_permission.permission_p(calendar_id, :user_id, 'calendar_admin') as calendar_admin_p
       from   calendars
       where  (private_p = 'f' and package_id = :package_id $permissions_clause) or
              (private_p = 't' and owner_id = :user_id)
       order  by private_p asc, upper(calendar_name)
    }]]
}

ad_proc -deprecated calendar::adjust_date {
    {-date ""}
    {-julian_date ""}
} {
    @return the date if it is provided. Otherwise, the julian date in ANSI
            format, if provided, or the system date.

    DEPRECATED: this proc implements a trivial defaulting logic that
                can be inlined just as well.

    @see dt_sysdate
    @see dt_julian_to_ansi
} {
    if {$date eq ""} {
        if {$julian_date ne ""} {
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
    Create a new calendar

    @return the new calendar_id
} {
    if { $package_id eq "" } {
        set package_id [ad_conn package_id]
    }
    set extra_vars [ns_set create s \
                        owner_id $owner_id \
                        private_p $private_p \
                        calendar_name $calendar_name \
                        package_id $package_id \
                        context_id $package_id]

    set calendar_id [package_instantiate_object -extra_vars $extra_vars calendar]

    return $calendar_id
}

ad_proc -public calendar::personal_p {
    {-calendar_id:required}
    {-user_id ""}
} {
    @return true (1) if this is the user's personal calendar, false (0) otherwise.

    @param user_id The user whose calendar you want to check
} {
    if { $user_id eq "" } {
        set user_id [ad_conn user_id]
    }
    calendar::get -calendar_id $calendar_id -array calendar
    if { [string is true -strict $calendar(private_p)] && $calendar(owner_id) == $user_id } {
        return 1
    } else {
        return 0
    }
}

ad_proc -public calendar::get {
    {-calendar_id:required}
    {-array}
} {
    Get calendar info
} {
    if {[info exists array]} {
        upvar 1 $array row
    }
    db_1row select_calendar {} -column_array row
    return [array get row]
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
    return [list {{--} {}} {*}[db_list_of_lists select_item_types {}]]
}

ad_proc -public calendar::item_type_new {
    {-calendar_id:required}
    {-item_type_id ""}
    {-type:required}
} {
    creates a new item type
} {
    if {$item_type_id eq ""} {
        set item_type_id [db_nextval cal_item_type_seq]
    }

    db_dml insert_item_type {}

    return $item_type_id
}

ad_proc -public calendar::item_type_delete {
    {-calendar_id:required}
    {-item_type_id:required}
} {
    Delete an item type
} {
    db_transaction {
        # Remove the mappings for all events
        db_dml reset_item_types {}

        # Remove the item type
        db_dml delete_item_type {}
    }
}

ad_proc -public calendar::attachments_enabled_p {
    -package_id
} {
    @param package_id the package_id, assumed to belong to a calendar
                      package instance. When not specified, we will
                      determine the package from the connection. When
                      no package can be determined, this proc will
                      return 0.

    @return 1 if the attachments are enabled, otherwise 0.
} {
    if {![info exists package_id]} {
        if {[ns_conn isconnected]} {
            set package_id [ad_conn package_id]
        } else {
            ad_log warning "Cannot determine package_id. Returning 0"
            return 0
        }
    }

    set node_id [site_node::get_node_id_from_object_id -object_id $package_id]
    set nodes [site_node::get_children -package_key attachments -node_id $node_id]

    return [expr {[llength $nodes] > 0}]
}

ad_proc -public calendar::rename {
    {-calendar_id:required}
    {-calendar_name:required}
} {
    rename a calendar
} {
    db_dml rename_calendar {}
}

ad_proc -private calendar::compare_day_items_by_current_hour {a b} {
    Compare a day item by the current hour (field 0).
    This is needed by the one-day view for sorting.
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

ad_proc -public calendar::do_notifications {
    {-mode:required}
    {-cal_item_id:required}
} {
    Perform the notifications
} {
    # Select all the important information
    calendar::item::get -cal_item_id $cal_item_id -array cal_item

    set cal_item_id $cal_item(cal_item_id)
    set n_attachments $cal_item(n_attachments)
    set ansi_start_date $cal_item(start_date_ansi)
    set ansi_end_date $cal_item(end_date_ansi)
    set start_time $cal_item(start_time)
    set end_time $cal_item(end_time)
    set title $cal_item(name)
    set description $cal_item(description)
    set repeat_p $cal_item(recurrence_id)
    set item_type $cal_item(item_type)
    set item_type_id $cal_item(item_type_id)
    set calendar_id $cal_item(calendar_id)
    set time_p $cal_item(time_p)

    set url "[ad_url][ad_conn package_url]"

    set new_content ""
    append new_content "[_ calendar.Calendar]:  <a href=\"[ns_quotehtml $url]\">[ad_conn instance_name]</a><br>\n"
    append new_content "[_ calendar.Calendar_Item]: <a href=\"[ns_quotehtml ${url}cal-item-view?cal_item_id=$cal_item_id]\">$cal_item(name)</a><br>\n"
    append new_content "[_ calendar.Start_Time]: $cal_item(start_date_ansi) $cal_item(start_time)<br>\n"
    append new_content "[_ calendar.to]: $cal_item(end_date_ansi) $cal_item(end_time)<br>\n"

    if {$repeat_p ne "" && $repeat_p} {
        append new_content "[_ calendar.is_recurring]"
    }

    append new_content "\n<br>\n"
    append new_content $cal_item(description)

    acs_user::get -user_id $cal_item(creation_user) -array user_info
    append new_content "<br>Author: <a href=\"mailto:$user_info(email)\">$user_info(first_names) $user_info(last_name)</a><br>\n"

    # send text for now.
    set new_content [ad_html_to_text -- $new_content]

    if {[lang::message::message_exists_p en_US calendar.$mode]} {
        set mode [_ calendar.$mode]
    }

    # Do the notification for the calendar
    notification::new \
        -type_id [notification::type::get_type_id \
        -short_name calendar_notif] \
        -object_id [ad_conn package_id] \
        -response_id $cal_item(cal_item_id) \
        -notif_subject "$mode [_ calendar.Calendar_Item]: $cal_item(name)" \
        -notif_text $new_content

}


ad_proc -public calendar::notification::get_url {
    object_id
} {
    @return a full URL to the object_id
} {
    return [site_node::get_url_from_object_id -object_id $object_id]
}



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
