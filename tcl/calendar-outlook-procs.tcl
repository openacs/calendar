
ad_library {
    Utility functions for syncing Calendar with Outlook
    
    taken from SloanSpace v1, hacked for OpenACS by Ben.

    @author wtem@olywa.net
    @author ben@openforce.biz
}

# wtem@olywa.net, 2001-06-12
# adding support for synching a single event with msoutlook

# 1. make sure the server config file 
# (in this case an .ini file) has the .ics extension mapped to msoutlook
# i.e. .ics=application/x-msoutlook

# 2. define a proc to pull an event from the database and put it in ics formatt
# and any helper procs necessary

# 3. register the proc to all requests for .ics

namespace eval calendar::outlook {
   
    ad_proc ics_timestamp_format {
        {-timestamp:required}
    } {
        the timestamp must be in the format YYYY-MM-DD HH24:MI:SS
    } {
        regsub { } $timestamp {T} timestamp
        regsub -all -- {-} $timestamp {} timestamp
        regsub -all {:} $timestamp {} timestamp
        
        append timestamp "Z"
        return $timestamp
    }

    ad_proc cal_outlook_gmt_sql {{hours 0} {dash ""}} {formats the hours to substract or add to make the date_time be in gmt} {
        # east of gmt is notated as "-",
        # in order to get gmt (to store the date_time for outlook)
        # we need to have the hour equal gmt at the same time as the client
        # i.e. if its noon gmt, then its 4am in pst
        # 
        if ![empty_string_p $dash] {
            set date_time_math "- $hours/24"
        } else {
            set date_time_math "+ $hours/24"
        }

        return $date_time_math
    }

    ad_proc -public format_item {
        {-cal_item_id:required}
        {-all_occurences_p:boolean 0}
        {-client_timezone 0}
    } {
        the cal_item_id is obvious.
        If we want all occurrences, we set all_occurences_p to true.
        
        The client timezone helps to make things right. 
        It is the number offset from GMT.
    } {
        set date_format "YYYY-MM-DD HH24:MI:SS"

        # Select the item information
        db_1row select_calendar_item {}

        # If necessary, select recurrence information

        # Here we have some fields
        # start_time end_time title description
        
        # For now we don't do recurrence

        set DTSTART [ics_timestamp_format -timestamp $start_date]
        set DTEND [ics_timestamp_format -timestamp $end_date]

        # Put it together
        set ics_event "BEGIN:VCALENDAR\r\nPRODID:-//OpenACS//OpenACS 4.5 MIMEDIR//EN\r\nVERSION:2.0\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nDTSTART:$DTSTART\r\nDTEND:$DTEND\r\n"

        regexp {^([0-9]*)T} $DTSTART all creation_date
        set DESCRIPTION $description
        set title $name

        append ics_event "LOCATION:Not Listed\r\nTRANSP:OPAQUE\r\nSEQUENCE:0\r\nUID:$cal_item_id\r\nDTSTAMP:$creation_date\r\nDESCRIPTION:$DESCRIPTION\r\nSUMMARY:$title\r\nPRIORITY:5\r\nCLASS:PUBLIC\r\n"

        append ics_event "END:VEVENT\r\nEND:VCALENDAR\r\n"

        return $ics_event
    }
        

    ad_proc cal_output_outlook_event {} "the proc to deliver outlook formatted calendar events, registered to .ics" {
        # grab the event_id
        ad_page_contract {
            converts data to .ics format for msoutlook
            
            @param item_id
            @param all_occurences_p
            @parem client_timezone
            @author Walter McGinnis (wtem@olywa.net), Don Baccus (dhogaza@pacifier.com)
            @creation-date 2001-06-13
            @cvs-id $Id$
            
        } {
            item_id:integer
            {all_occurences_p:boolean 0}
            client_timezone
        }

        set logged_in_user_id [ad_verify_and_get_user_id]

        # determine what the difference between the user's client timezone is
        # and gmt
        # then set up the math for oracle to do when selecting date_time
        # a note on client_timezone:
        # it is minutes difference from gmt
        # either negative or positive
        # east of gmt is negative
        # positive values don't return a "+" before them, 
        # so we only have to look for "-"
        # the funny thing is that we want to substract positive values 
        # and add positive ones

        regexp -- {(-)*([0-9]+)} $client_timezone match dash digits 
        
        # there is an old Mac OS time_date issue
        # where the time is offset up to 1440 
        # rather than having a neg. value for timezones east of gmt
        # if this is the case we reset the variables accordingly as a workaround

        # i think this correct, but it may be the problem
        if {$digits >= 720} {
            set digits [expr 1440 - $digits] 
            set dash "-"
        }

        set hours [expr $digits / 60]
        
        # this sets up the sql for creating gmt times for the event's date_times
        
        # grap applicable data and translate calendar data to outlook format
        
        ## THIS NEEDS TO CHANGE
        db_1row cal_get_outlook_event "select
        to_char(i.start_date [cal_outlook_gmt_sql $hours $dash], 'YYYYMMDD-HH24MISS') as dtstart,
        to_char(i.end_date [cal_outlook_gmt_sql $hours $dash], 'YYYYMMDD-HH24MISS') as dtend,
        to_char(i.start_date + 1 [cal_outlook_gmt_sql $hours $dash], 'YYYYMMDD') as dtstart_plus_one,
        to_char(trunc(i.start_date) [cal_outlook_gmt_sql $hours $dash], 'YYYYMMDD-HH24MISS') as dtstart_midnight,
        to_char(trunc(i.start_date) + 1 [cal_outlook_gmt_sql $hours $dash], 'YYYYMMDD-HH24MISS') as dtstart_plus_one_midnight,
        nvl(to_char(ii.creation_date [cal_outlook_gmt_sql $hours $dash], 'YYYYMMDD'), to_char(i.creation_date, 'YYYYMMDD')) as creation_date,
        nvl(i.title, ii.title) as title,
        nvl(i.related_link_url, ii.related_link_url) as related_link_url,
        i.description as child_description,
        ii.description as parent_description,
        ii.html_p as parent_html_p, 
        i.html_p as child_html_p,
        ii.interval_type, ii.every_nth_interval, ii.days_of_week,
        to_char(ii.repeat_until [cal_outlook_gmt_sql $hours $dash], 'YYYYMMDD') as repeat_until
        from cal_items i, cal_items ii
        where i.item_id = :item_id
        and i.parent_id = ii.item_id(+)
        "
        
        # resolve parent and child description, html_p
        if {[string equal $parent_html_p "t"] && ![empty_string_p $parent_description]} {
            set parent_description [ad_html_to_text $parent_description]
        }

        if {[string equal $child_html_p "t"] && ![empty_string_p $child_description]} {
            set child_description [ad_html_to_text $child_description]
        } 

        # make sure that whitespace isn't being mistaken as a non-empty-string
        set parent_description [string trim $parent_description]
        set child_description [string trim $child_description]

        set description ""
        if {![empty_string_p $parent_description] && ![string equal $parent_description $child_description] && ![empty_string_p $child_description]} {
            # both are set, just combine them
            set description "$parent_description
            $child_description" 
        } elseif {![empty_string_p $parent_description] && [empty_string_p $child_description]} {
            set description $parent_description
        } else {
            set description $child_description
        }

        if ![empty_string_p [string trim $related_link_url]] {
            set DESCRIPTION "$description
            $related_link_url"
        } else {
            set DESCRIPTION $description
        }

        # format date_times

        if { [empty_string_p $dtend] } {

            #DRB: If it's a recurring event we need to kludge around the fact
            #that we're not generating full timezone information by passing the
            #a DATETIME to Outlook for "no time specified" events.  OpenACS 4
            #should fix this, read RFC2445 for information.  With proper timezone
            #information, the DATE form should be used.  This current hack, done
            #for Sloan, only works for folks who are in the same timezone as the
            #server.

            if { $all_occurences_p && ![empty_string_p $interval_type] } {
                set DTSTART ":[cal_ics_date_time_format $dtstart_midnight]"
                set DTEND ":[cal_ics_date_time_format $dtstart_plus_one_midnight]"
            } else {
                set DTSTART ";VALUE=DATE:[string range $dtstart 0 7]"
                set DTEND ";VALUE=DATE:[string range $dtstart_plus_one 0 7]"
            }
        } else {
            set DTSTART ":[cal_ics_date_time_format $dtstart]"
            set DTEND ":[cal_ics_date_time_format $dtend]"
        }
        
        # making the CLASS=Public for now, but perhaps it should default to private
        # this is ugly, but it might help get this working

        # DRB: removed the ORGANIZER:MAILTO: line as Outlook would complain when
        # importing a file containing the line if it weren't already open.  When open
        # Outlook would import the file just fine - presumably there are two separate
        # paths within Outlook to handle the two cases.

        set ics_event "
        BEGIN:VCALENDAR\r\nPRODID:-//ArsDigita//ACES 3.4 MIMEDIR//EN\r\nVERSION:2.0\r\nMETHOD:PUBLISH\r\nBEGIN:VEVENT\r\nDTSTART$DTSTART\r\n"

        if { [info exists DTEND] } {
            append ics_event "DTEND$DTEND\r\n"
        }

        if { $all_occurences_p && ![empty_string_p $interval_type] } {

            set recur_rule "RRULE:FREQ="

            switch -glob $interval_type {
                day { append recur_rule "DAILY" }
                week { append recur_rule "WEEKLY" }
                *month* { append recur_rule "MONTHLY"}
                year { append recur_rule "YEARLY"}
            }

            if { $interval_type == "week" && ![empty_string_p $days_of_week] } {

                #DRB: Standard indicates ordinal week days are OK, but Outlook
                #only takes two-letter abbreviation form.

                append recur_rule ";BYDAY="
                set week_list [list "SU" "MO" "TU" "WE" "TH" "FR" "SA" "SU"]
                set sep ""
                set day_list [split $days_of_week " "]
                foreach day $day_list {
                    append recur_rule "$sep[lindex $week_list $day]"
                    set sep ","
                }
            }

            if { ![empty_string_p $every_nth_interval] } {
                append recur_rule ";INTERVAL=$every_nth_interval"
            }

            if { ![empty_string_p $repeat_until] } {
                #DRB: this should work with a DATE: type but doesn't with Outlook at least.
                append recur_rule ";UNTIL=$repeat_until"
                append recur_rule "T000000Z"
            }

            append ics_event "$recur_rule\r\n"
        }

        append ics_event "LOCATION:Not Listed\r\nTRANSP:OPAQUE\r\nSEQUENCE:0\r\nUID:$item_id\r\nDTSTAMP:$creation_date\r\nDESCRIPTION:$DESCRIPTION\r\nSUMMARY:$title\r\nPRIORITY:5\r\nCLASS:PUBLIC\r\n"

        db_foreach cal_item_db_row_map_fs_select "
        select /*+ RULE */ c.on_what_id as file_id, 
        fs.file_title as file_title,
        fs.parent_id as parent_id,
        fs2.file_title as parent_title,
        fsvl.version_id as version_id,
        fsvl.client_file_name,
        fsvl.n_bytes,
        fsvl.url,
        lower(fsvl.file_type) as file_type
        from cal_item_db_row_map c, fs_files fs, 
        fs_versions_latest fsvl, fs_files fs2
        where fs2.file_id(+) = fs.parent_id
        and fs2.deleted_p = 'f'
        and c.item_id=:item_id
        and c.on_what_id=fs.file_id
        and fs.file_id=fsvl.file_id
        and c.on_which_table='FS_FILES'
        and (ad_general_permissions.user_has_row_permission_p ( :logged_in_user_id, 'read', fsvl.version_id, 'FS_VERSIONS' ) = 't'
        or fs.owner_id = :logged_in_user_id)
        and fs.deleted_p='f'
        " {
            if { [empty_string_p $n_bytes] } {
                append ics_event "ATTACH:$url\r\n"
            } else {
                regsub -all {[^-_.0-9a-zA-Z]+} $client_file_name "_" pretty_file_name
                append ics_event "ATTACH:[ad_parameter SystemURL]/file-storage/download/$version_id/$pretty_file_name\r\n"
            }
        }

        #append ics_event "LOCATION:Not Listed\r\nTRANSP:OPAQUE\r\nSEQUENCE:0\r\nUID:040000008200E00074C5B7101A82E00800000000502D2C0B6B82C0010000000000000000100 00000C738CA6EDDB4DD46850DE477678FF368\r\nDTSTAMP:$creation_date\r\nDESCRIPTION:$DESCRIPTION\r\nSUMMARY:$title\r\nPRIORITY:5\r\nCLASS:PUBLIC\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n"
        append ics_event "END:VEVENT\r\nEND:VCALENDAR\r\n"
        ns_return 200 application/x-msoutlook $ics_event
    }

    # ad_register_proc GET /*.ics cal_output_outlook_event
    # ad_register_proc POST /*.ics cal_output_outlook_event

}
