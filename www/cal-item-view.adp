<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">Calendar Item: @item_data.name@</property>
<property name="context_bar">One Item</property>

<table>

  <tr>
    <td valign=top>
      <p>
	<if @show_cal_nav@ eq 1><include src="cal-nav"></if>
    </td>	

    <td valign=top> 
    <table>
    <tr><td colspan=2><blockquote>@description@</blockquote></td></tr>
    <tr><th align=right>Date and Time:</th><td><a href="./?calendar_id=@calendar_id@&view=day&show_cal_nav=@show_cal_nav@&date=@raw_start_date@">@item_data.start_date@</a>, from @item_data.start_time@ to @item_data.end_time@</td></tr>
    <tr><th align=right>Title:</th><td>@item_data.name@</td></tr>
    <tr><th align=right>Type:</th><td>@item_data.item_type@</td></tr>
    </table>
    <p>
    <if @edit_p@ eq 1><a href="./?action=edit&cal_item_id=@cal_item_id@&show_cal_nav=@show_cal_nav@&return_url=@return_url@">edit</a> | <a href="./cal-item-edit?action=delete&cal_item_id=@cal_item_id@&show_cal_nav=@show_cal_nav@&return_url=@return_url@">delete</a>
<if @recurrence_id@ not nil>
| <a href="./cal-item-delete-all-occurrences?recurrence_id=@recurrence_id@&show_cal_nav=@show_cal_nav@">delete all occurrences</a>
</if>
</if>
    </td>
  </tr>
</table>
</if>
