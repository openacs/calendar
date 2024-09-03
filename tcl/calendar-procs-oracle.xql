<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="calendar::create.create_new_calendar">      
  <querytext>
  
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

  </querytext>
</fullquery>

<fullquery name="calendar::delete.delete_calendar">
  <querytext>
        begin
            calendar.del(:calendar_id);
        end;
  </querytext>
</fullquery>
  
</queryset>
