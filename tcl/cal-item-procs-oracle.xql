<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="calendar::item::add_recurrence.create_recurrence">
<querytext>
begin
   :1 := recurrence.new(interval_type => :interval_type,
    	every_nth_interval => :every_n,
    	days_of_week => :days_of_week,
    	recur_until => to_date(:recur_until,'YYYY-MM-DD HH24:MI'));
end;
</querytext>
</fullquery>

<fullquery name="calendar::item::add_recurrence.insert_instances">
<querytext>
begin
   acs_event.insert_instances(event_id => :cal_item_id);
end;
</querytext>
</fullquery>
<fullquery name="calendar::item::new.insert_activity">      
      <querytext>
      
	begin
	:1 := acs_activity.new (
	  name          => :name,
	  description   => :description,
	  creation_user => :creation_user,
	  creation_ip   => :creation_ip
	);
	end;
    
      </querytext>
</fullquery>
 
<fullquery name="calendar::item::new.insert_timespan">      
      <querytext>
      
	begin
	:1 := timespan.new(
	  start_date => to_date(:start_date,'YYYY-MM-DD HH24:MI'),
	  end_date   => to_date(:end_date,'YYYY-MM-DD HH24:MI')
	);
	end;
    
      </querytext>
</fullquery>
 
<fullquery name="calendar::item::new.cal_item_add">      
      <querytext>
      
	begin
	:1 := cal_item.new(
	  on_which_calendar      => :calendar_id,
          name                   => :name, 
	  activity_id            => :activity_id,
          timespan_id            => :timespan_id,
          item_type_id           => :item_type_id,
	  creation_user          => :creation_user,
	  creation_ip            => :creation_ip,
          context_id             => :calendar_id,
          package_id             => :package_id,	  
	  location               => :location,
	  related_link_url       => :related_link_url,
	  related_link_text      => :related_link_text,
	  redirect_to_rel_link_p => :redirect_to_rel_link_p
	);
	end;
    
      </querytext>
</fullquery>

<fullquery name="calendar::item::delete.delete_cal_item">      
      <querytext>
      
	begin
	  cal_item.del (
	    cal_item_id  => :cal_item_id
	  );
	end;
    
      </querytext>
</fullquery>

<fullquery name="calendar::item::edit.update_interval">      
      <querytext>
      
	begin
	  time_interval.edit (
	    interval_id  => :interval_id,
	    start_date   => to_date(:start_date,'YYYY-MM-DD HH24:MI'),
	    end_date     => to_date(:end_date,'YYYY-MM-DD HH24:MI')
	  );
	end;
    
      </querytext>
</fullquery>


<fullquery name="calendar::item::edit.cal_uid_upsert">      
  <querytext>

    begin
         cal_uid.upsert(:cal_uid, :activity_id, :ical_vars);
    end;
  </querytext>
</fullquery> 


 
<fullquery name="calendar::item::delete_recurrence.delete_cal_item_recurrence">      
      <querytext>
      
	begin
	  cal_item.delete_all (
	    recurrence_id  => :recurrence_id
	  );
	end;
    
      </querytext>
</fullquery>

<fullquery name="calendar::item::edit_recurrence.recurrence_timespan_update">
<querytext>
begin
  acs_event.recurrence_timespan_edit (
    event_id => :event_id,
    start_date => to_date(:start_date,'YYYY-MM-DD HH24:MI'),
    end_date => to_date(:end_date,'YYYY-MM-DD HH24:MI')
  );
end;
</querytext>
</fullquery>

</queryset>
