<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">Calendar Item Delete: @item_data.name@</property>
<property name="context_bar">Delete</property>

<table>

  <tr>
    <td valign=top>
      <p>
	<if @show_cal_nav@ eq 1><include src="cal-nav"></if>
    </td>	

    <td valign=top> 
    <table>
    <tr><td colspan=2><blockquote>@item_data.description@</blockquote></td></tr>
    <tr><th align=right>Date<if @item_data.no_time_p@ eq 0> and Time</if>:</th><td><a href="./?calendar_id=@calendar_id@&view=day&show_cal_nav=@show_cal_nav@&date=@raw_start_date@">@item_data.start_date@</a><if @item_data.no_time_p@ eq 0>, from @item_data.start_time@ to @item_data.end_time@</if></td></tr>
    <tr><th align=right>Title:</th><td>@item_data.name@</td></tr>
    <tr><th align=right>Type:</th><td>@item_data.item_type@</td></tr>
    </table>
    <p>
    </td>
  </tr>
</table>

<if @item_data.recurrence_id@ not nil>
<b>This is a repeating event</b>. You may choose to:
<ul>
<li> <a href="cal-item-edit?action=delete&cal_item_id=@cal_item_id@&confirm_p=1">delete only this instance</a>
<li> <a href="cal-item-delete-all-occurrences?recurrence_id=@item_data.recurrence_id@">delete all occurrences</a>
</ul>
</if>
<else>
Are you sure you want to delete this event?
<ul>
<li> <a href="cal-item-edit?action=delete&cal_item_id=@cal_item_id@&confirm_p=1">yes, delete it</a>
<li> <a href="cal-item-view?show_cal_nav=@show_cal_nav@&cal_item_id=@cal_item_id@">no, keep it</a>
</ul>
</else>
