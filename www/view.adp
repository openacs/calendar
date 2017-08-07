<master>
<property name="doc(title)">#calendar.Calendars#</property>

<include src="/packages/calendar/www/navbar" view="@view;literal@" base_url="@ad_conn_url;literal@" date="@date;literal@">

  <div id="viewadp-mini-calendar">
    <if @view@ eq "list">
      <include src="mini-calendar" base_url="view" view="@view;literal@" date="@date;literal@" period_days="@period_days;literal@">
    </if>
    <else>
      <include src="mini-calendar" base_url="view" view="@view;literal@" date="@date;literal@">
    </else>
    <p>
    <a href="@add_item_url@" title="#calendar.Add_Item#" class="button">#calendar.Add_Item#</a>
    <if @admin_p;literal@ true>
      <a href="admin/" title="#calendar.lt_Calendar_Administrati#" class="button">#calendar.lt_Calendar_Administrati#</a>
    </if>
    </p>
  
    <if @calendar_personal_p;literal@ false>
       <p><include src="/packages/notifications/lib/notification-widget" type="calendar_notif"
	 	   object_id="@package_id;literal@"
	 	   pretty_name="@instance_name@" >
    </if>
  
    <include src="cal-options">	
   </div>

  <div id="viewadp-cal-table">
    <if @view@ eq "list">
      <include src="view-list-display"
        portlet_p="0"
        start_date="@start_date;literal@"
        return_url="@return_url;literal@"
        end_date="@end_date;literal@"
        date="@date;literal@"
        period_days="@period_days;literal@"
        sort_by="@sort_by;literal@"
        show_calendar_name_p="@show_calendar_name_p;literal@"
        export="@export;literal@"> 
    </if>

    <if @view@ eq "day">
      <include src="view-one-day-display"
        date="@date;literal@" 
        start_display_hour="7"
        end_display_hour="22"
        return_url="@return_url;literal@"
        calendar_url=""
        show_calendar_name_p="@show_calendar_name_p;literal@">
    </if>
    
    <if @view@ eq "week">
      <include src="view-week-display"
        date="@date;literal@"
        return_url="@return_url;literal@"
        calendar_url=""
        show_calendar_name_p="@show_calendar_name_p;literal@">
    </if>
    
    
    <if @view@ eq "month">
      <include src="view-month-display"
        date="@date;literal@"
        return_url="@return_url;literal@"
        calendar_url=""
        show_calendar_name_p="@show_calendar_name_p;literal@">
    </if>
   </div>
