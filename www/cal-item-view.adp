<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master>
<property name="title">Calendar Item</property>
<property name="context_bar">One Item</property>

<table>

  <tr>
    <td valign=top>
      <p>
	<if @show_cal_nav@ eq 1><include src="cal-nav"></if>
    </td>	

    <td valign=top> 
    <table>
    <tr><th align=right>Date and Time:</th><td>@item_data.start_date@, from @item_data.start_time@ to @item_data.end_time@</td></tr>
    <tr><th align=right>Title:</th><td>@item_data.name@</td></tr>
    <tr><th align=right>Type:</th><td>@item_data.item_type@</td></tr>
    </table>
    <p>
    <if @edit_p@ eq 1><a href="./?action=edit&cal_item_id=@cal_item_id@&show_cal_nav=@show_cal_nav@&return_url=@return_url@">edit</a> | <a href="./cal-item-edit?action=delete&cal_item_id=@cal_item_id@&show_cal_nav=@show_cal_nav@&return_url=@return_url@">delete</a></if>
    </td>
  </tr>
</table>
</if>
