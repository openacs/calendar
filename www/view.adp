<master>
<property name="title">#calendar.Calendars#</property>
<property name="header_stuff">
  <link href="/resources/calendar/calendar.css" rel="stylesheet" type="text/css">
</property>

<table width="95%">

  <tr>
    <td valign=top width=150>
    <include src="mini-calendar" base_url="view" view="@view@" date="@date@">
</center>
<p>
    <a href="cal-item-new?date=@date@" title="#calendar.Add_Item#"><img border=0 align="left" valign="top" src="/shared/images/add.gif" alt="#calendar.Add_Item#">#calendar.Add_Item#</a>
<p>
<if @admin_p@ eq 1>
    <a href="admin/">#calendar.lt_Calendar_Administrati#</a>
</if>
<include src="cal-options" calendar_list="@calendar_list@">	

    </td>	

    <td valign=top> 
    
<if @view@ eq "list">
<include src="view-list-display" 
start_date=@start_date@ 
end_date=@end_date@ 
date=@date@ 
period_days=@period_days@
calendar_id_list=@calendar_list@ 
sort_by=@sort_by@> 
</if>


<if @view@ eq "day">
<include src="view-one-day-display" 
date="@date@" start_hour=0 end_hour=23
calendar_id_list="@calendar_list@">
</if>

<if @view@ eq "week">
<include src="view-week-display" 
date="@date@"
calendar_id_list="@calendar_list@">
</if>


<if @view@ eq "month">
<include src="view-month-display"
date=@date@
calendar_id_list= @calendar_list@>
</if>
    </td>
  </tr>
</table>
