<master>
<property name="title">#calendar.Calendars#</property>

<property name="header_stuff">
  <link href="/resources/calendar/calendar.css" rel="stylesheet" type="text/css">
</property>
  <div id="viewadp-mini-calendar">
    <include src="mini-calendar" base_url="view" view="@view@" date="@date@">

    <p>
    <a href="cal-item-new?date=@date@&view=@view@" title="#calendar.Add_Item#">
    <img border=0 align="left" valign="top" src="/resources/acs-subsite/add.gif" alt="#calendar.Add_Item#">#calendar.Add_Item#</a>
    </p>
  
    <p>
    @notification_chunk;noquote@
    </p>
    <p>
    <if @admin_p@ true>
      <a href="admin/">#calendar.lt_Calendar_Administrati#</a>
    </if>
    </p>
  
    <p>
    <include src="cal-options" calendar_list="@calendar_list;noquote@">	
    </p>
  </div>

  <div id="events">   
    <if @view@ eq "list">
      <include src="view-list-display" start_date=@start_date@ 
      end_date=@end_date@ date=@date@ period_days=@period_days@ sort_by=@sort_by@> 
    </if>
    
    
    <if @view@ eq "day">
      <include src="view-one-day-display" date="@date@" start_hour=0 end_hour=23>
    </if>
    
    <if @view@ eq "week">
      <include src="view-week-display" date="@date@">
    </if>
    
    
    <if @view@ eq "month">
      <include src="view-month-display" date=@date@>
    </if>
  </div>


