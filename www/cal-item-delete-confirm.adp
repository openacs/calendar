<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master>
<property name="title">Calendar Item Delete: @cal_item.name@</property>
<property name="context">Delete</property>

<table>

  <tr>
    <td valign=top>
      <p>
      @cal_nav@
    </td>	

    <td valign=top> 
    <table>
    <tr><td colspan=2><blockquote>@cal_item.description@</blockquote></td></tr>
    <tr><th align=right>Date<if @cal_item.no_time_p@ eq 0> and Time</if>:</th><td><a href="./view?view=day&date=@cal_item.start_date@">@cal_item.pretty_short_start_date@</a><if @cal_item.no_time_p@ eq 0>, from @cal_item.start_time@ to @cal_item.end_time@</if></td></tr>
    <tr><th align=right>Title:</th><td>@cal_item.name@</td></tr>
    <if @cal_item.item_type@ not nil><tr><th align=right>Type:</th><td>@cal_item.item_type@</td></tr></if>
    </table>
    <p>
<if @cal_item.recurrence_id@ not nil>
<b>This is a repeating event</b>. You may choose to:
<ul>
<li> <a href="cal-item-delete?cal_item_id=@cal_item_id@&confirm_p=1">delete only this instance</a>
<li> <a href="cal-item-delete-all-occurrences?recurrence_id=@cal_item.recurrence_id@">delete all occurrences</a>
</ul>
</if>
<else>
Are you sure you want to delete this event?
<ul>
<li> <a href="cal-item-delete?cal_item_id=@cal_item_id@&confirm_p=1">yes, delete it</a>
<li> <a href="cal-item-view?show_cal_nav=@show_cal_nav@&cal_item_id=@cal_item_id@">no, keep it</a>
</ul>
</else>
    </td>
  </tr>
</table>

