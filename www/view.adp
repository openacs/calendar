<master>
<property name="title">#calendar.Calendars#</property>
<property name="header_stuff">
  <link href="/resources/calendar/calendar.css" rel="stylesheet" type="text/css">
</property>
<if @link:rowcount@ not nil><property name="&link">link</property></if>

<include src="/packages/calendar/www/navbar" view="@view@" base_url="@ad_conn_url@" date="@date@">

  <div id="viewadp-mini-calendar">
    <if @view@ eq "list">
      <include src="mini-calendar" base_url="view" view="@view@" date="@date@" period_days="@period_days@">
    </if>
    <else>
      <include src="mini-calendar" base_url="view" view="@view@" date="@date@">
    </else>
    <p>
    <a href="@add_item_url@" title="#calendar.Add_Item#"><img border=0 align="left" src="/resources/acs-subsite/add.gif" alt="">#calendar.Add_Item#</a>
    </p>
  
    <p>
    <if @calendar_personal_p@ false>
	    @notification_chunk;noquote@
    </if>
    </p>
    <p>
    <if @admin_p@ true>
      <a href="admin/" title="#calendar.lt_Calendar_Administrati#">#calendar.lt_Calendar_Administrati#</a>
    </if>
    </p>
  
    <p>
    <include src="cal-options">	
    </p>
   </div>

  <div id="events">
    <if @view@ eq "list">
      <include src="view-list-display" start_date=@start_date@ return_url="@return_url@"
      end_date=@end_date@ date=@date@ period_days=@period_days@ sort_by=@sort_by@
      show_calendar_name_p=@show_calendar_name_p@ export=@export@> 
    </if>

    <if @view@ eq "day">
      <include src="view-one-day-display" date="@date@" start_hour=0 end_hour=23 return_url="@return_url@"
      show_calendar_name_p=@show_calendar_name_p@>
    </if>
    
    <if @view@ eq "week">
      <include src="view-week-display" date="@date@" return_url="@return_url@"
      show_calendar_name_p=@show_calendar_name_p@>
    </if>
    
    
    <if @view@ eq "month">
      <include src="view-month-display" date=@date@ return_url="@return_url@"
      show_calendar_name_p=@show_calendar_name_p@>
    </if>
   </div>
