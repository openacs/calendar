<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1.2</version></rdbms>

<fullquery name="calendar::outlook::adjust_timezone.adjust_timezone">
  <querytext>

    select to_char(server.utc_time - timezone__get_offset(timezone__get_id(:user_tz), server.utc_time), :format)
    from (select timezone__convert_to_utc(tz_id, :timestamp) as utc_time
          from timezones where tz= :server_tz) server;

  </querytext>
</fullquery>
 
</queryset>
