# /packages/calendar/tcl/cal-item-procs.tcl

ad_library {

    Utility functions for Calendar Applications

    @author Gary Jin (gjin@arsdigita.com)
    @creation-date Jan 11, 2001
    @cvs-id $Id$

}


#------------------------------------------------
# update the permissions of the calendar
ad_proc cal_assign_item_permission { cal_item_id 
                                     party_id
                                     permission 
                                     {revoke ""}
} {
    update the permission of the specific cal_item
    if revoke is set to revoke, then we revoke all permissions
} {
    
    # adding permission

    if { ![string equal $revoke "revoke"] } {

	# we make the assumation that permission cal_read is 
	# by default granted to all users who needs write, delete
	# and invite permission

	if { ![string equal $permission "cal_item_read"] } {

	    # grant read permission first

	    db_exec_plsql 1_grant_calendar_permissions_to_items {
		begin
		acs_permission.grant_permission (
		  object_id       =>      :cal_item_id,
		  grantee_id      =>      :party_id,
		  privilege       =>      'cal_item_read'
		);
		end;
	    }
	    
	}
	
	# grant other permission

	db_exec_plsql 2_grant_calendar_permissions_to_items {
	    begin
	    acs_permission.grant_permission (
	      object_id       =>      :cal_item_id,
	      grantee_id      =>      :party_id,
	      privilege       =>      :permission
	    );
	    end;
	}

	
    } elseif { [string equal $revoke "revoke"] } {
	
	# revoke the permissions

	db_exec_plsql 3_grant_calendar_permissions_to_items {
	    begin
	    acs_permission.revoke_permission (
	      object_id       =>      :cal_item_id,
	      grantee_id      =>      :party_id,
	      privilege       =>      :permission
	    );
	    end;
	}


    }
}

#------------------------------------------------
# adding a new calendar item
ad_proc cal_item_create { start_date
                          end_date
                          name
                          description
                          on_which_calendar
                          creation_ip
                          creation_user
{item_type_id ""}
} {

  create a new cal_item
  for this version, i am omitting recurrence

} {


    # find out the activity_id
    set activity_id [db_exec_plsql insert_activity {
	begin
	:1 := acs_activity.new (
	  name          => :name,
	  description   => :description,
	  creation_user => :creation_user,
	  creation_ip   => :creation_ip
	);
	end;
    }
    ]

    # set the date_format
    set date_format "YYYY-MM-DD HH24:MI"

    # find out the timespan_id
    set timespan_id [db_exec_plsql insert_timespan {
	begin
	:1 := timespan.new(
	  start_date => to_date(:start_date,:date_format),
	  end_date   => to_date(:end_date,:date_format)
	);
	end;
    }
    ]

    # create the cal_item
    # we are leaving the name and description fields in acs_event
    # blank to abide by the definition that an acs_event is an acs_activity
    # with added on temperoal information

    set cal_item_id [db_exec_plsql cal_item_add {
	begin
	:1 := cal_item.new(
	  on_which_calendar  => :on_which_calendar,
	  activity_id        => :activity_id,
          timespan_id        => :timespan_id,
        item_type_id        => :item_type_id,
	  creation_user      => :creation_user,
	  creation_ip        => :creation_ip
	);
	end;
    }
    ]

    # getting the permissions out 
    # all this is because cal-item is not a child 
    # of the calendar. 
    
    # by default, the cal_item permissions 
    # are going to be inherited from the calendar permissions
    #
    # i.e.: party with calendar_admin can create, read, write, delete
    #       all items on the calendar, but a party with only calendar_read
    #       cannot added items to the specific calendar
    #
    # NOTE: this default permissions can be circumvented by assign item
    #       specific permission on a party basis

    # the stuff in pl/sql layer didn't work
    # NOTE: need to fold the following back in into pl/sql.

    # Fix by Ben to prevent possible deadlock
    # FIXME: this should all be moved into on PL/SQL statement (ben)

    set permissions_to_add [db_list_of_lists get_permissions_to_items {
	select          grantee_id,
                  	privilege
	from            acs_permissions
	where           object_id = :on_which_calendar
    }]

    foreach perm $permissions_to_add {
        set grantee_id [lindex $perm 0]
        set privilege [lindex $perm 1]

	# setting the permission

	db_exec_plsql 4_grant_calendar_permissions_to_items {
	    begin
  	      acs_permission.grant_permission (
                object_id       =>      :cal_item_id,
                grantee_id      =>      :grantee_id,
                privilege       =>      :privilege
              );
	    end;
	}

    }
    
    # grant default read, write, delete permissions. 
    # should roll into pl/sql

#    db_exec_plsql grant_cal_item_permissions {
	#begin
	#acs_permission.grant_permission (
	#  object_id       =>      :cal_item_id,
	#  grantee_id      =>      :grantee_id,
	#  privilege       =>      'cal_item_invite'
	#);
	#end;
   # }

    return $cal_item_id

}


#------------------------------------------------
# update an existing calendar item
ad_proc cal_item_update { cal_item_id
                          start_date
                          end_date
                          name
                          description
{item_type_id ""}
} {

    updating  a new cal_item
    for this version, i am omitting recurrence

} {
    
    # set the date_format
    set date_format "YYYY-MM-DD HH24:MI"

    # first update the acs_activities
    
    db_dml update_activity ""

    # update the time interval based on the timespan id

    db_1row get_interval_id ""

    db_transaction {
        # call edit procedure
        db_exec_plsql update_interval "
	begin
        time_interval.edit (
        interval_id  => :interval_id,
        start_date   => to_date(:start_date,:date_format),
        end_date     => to_date(:end_date,:date_format)
        );
	end;
        "
    
        # Update the item_type_id
        db_dml update_item_type_id "update cal_items
        set item_type_id= :item_type_id
        where cal_item_id= :cal_item_id"
    }
}


#------------------------------------------------
# delete an exiting cal_item
ad_proc cal_item_delete { cal_item_id } {

    delete an existing cal_item given a cal_item_id

} {

    # call delete procedure
    db_exec_plsql delete_cal_item "
	begin
	  cal_item.delete (
	    cal_item_id  => :cal_item_id
	  );
	end;
    "    
}



ad_proc -public calendar_item_add_recurrence {
    {-cal_item_id:required}
    {-interval_type:required}
    {-every_n:required}
    {-days_of_week ""}
    {-recur_until ""}
} {
    Adds a recurrence for a calendar item
} {
    # We do things in a transaction
    db_transaction {
        # Create the recurrence
        set recurrence_id [db_exec_plsql create_recurrence "
            begin
            :1 := recurrence.new(interval_type => :interval_type,
            every_nth_interval => :every_n,
            days_of_week => :days_of_week,
            recur_until => :recur_until);
            end;
        "]
        
        # Update the events table
        db_dml update_event "update acs_events set recurrence_id= :recurrence_id where event_id= :cal_item_id"

        # Insert instances
        db_exec_plsql insert_instances "
        begin
        acs_event.insert_instances(event_id => :cal_item_id);
        end;
        "
        
        # Make sure they're all in the calendar!
        db_dml insert_cal_items "
        insert into cal_items (cal_item_id, on_which_calendar)
        select event_id, (select on_which_calendar as calendar_id from cal_items where cal_item_id = :cal_item_id) from acs_events where recurrence_id= :recurrence_id and event_id <> :cal_item_id"
    }
}
        
        
