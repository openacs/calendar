<master>
<property name="title">#calendar.Calendars#</property>
<property name="context">#calendar.Calendar#</property>

<table width="95%">

  <tr>
    <td valign=top width=150>
      <p>
      @cal_nav;noquote@
<p>
<a href="cal-item-new?julian_date=@julian_date@" title="#calendar.Add_Item#"><img border=0 align="right" valign="top" src="/shared/images/add.gif" alt="#calendar.Add_Item#">#calendar.Add_Item#</a>
      <p>
	<include src="cal-options">	
    </td>	
    <td valign=top> 
    
<if @view@ eq "list">
<include src="view-list-display" 
start_date=@start_date@ 
end_date=@end_date@ 
date=@date@ 
calendar_id_list=@calendar_list@ 
sort_by=@sort_by@> 
</if>


<if @view@ eq "day">
<include src="view-one-day-display" 
prev_nav_template="@previous_link@"
next_nav_template="@next_link@"
item_template="@item_template@"
hour_template="@hour_template@"
date="@date@" start_hour=7 end_hour=22
calendar_id_list="@calendar_list@">
</if>

<if @view@ eq "week">
<include src="view-week-display" 
item_template="@item_template@"
date="@date@"
calendar_id_list="@calendar_list@">
</if>


<if @view@ eq "month">
<include src="view-month-display"
date=@date@
calendar_id_list= @calendar_list@
prev_month_template=@previous_link@
next_month_template=@next_link@>
</if>
    </td>
  </tr>
</table>
