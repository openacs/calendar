
ad_library {
    A beginning of an attempt to rewrite calendar by making
    procs cleaner, etc... (ben)

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-03-16
}

namespace eval calendar {

    ad_proc -public get_month_multirow_information {
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

    ad_proc -public from_sql_datetime {
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

    ad_proc -public to_sql_datetime {
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

    ad_proc -public calendar_list {
        {-package_id ""}
        {-user_id ""}
    } {
        # If no user_id
        if {[empty_string_p $user_id]} {
            set user_id [ad_conn user_id]
        }

        if {[empty_string_p $package_id]} {
            set package_id [ad_conn package_id]
        }
        set new_list [db_list_of_lists select_calendar_list {}]
    }

    ad_proc -public adjust_date {
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

    ad_proc -public new {
        {-owner_id:required}
        {-private_p "f"}
        {-calendar_name:required}
        {-package_id:required}
    } {
        set extra_vars [ns_set create]
        oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {owner_id private_p calendar_name package_id}

        set calendar_id [package_instantiate_object -extra_vars $extra_vars calendar]

        return $calendar_id
    }

    ad_proc -public get_item_types {
        {-calendar_id:required}
    } {
        return the item types
    } {
        return [concat [list [list {--} {}]] \
                [db_list_of_lists select_item_types {}]]
    }

    ad_proc -public item_type_new {
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

    ad_proc -public item_type_delete {
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

    ad_proc -public attachments_enabled_p {} {
        set package_id [site_node_apm_integration::child_package_exists_p \
            -package_key attachments
        ]
    }

    ad_proc -public rename {
        {-calendar_id:required}
        {-name:required}
    } {
        rename a calendar
    } {
        db_dml rename_calendar {}
    }

    ad_proc -private compare_day_items_by_current_hour {a b} {
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

}
