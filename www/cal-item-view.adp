<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">Calendar Item: @cal_item.name@</property>
<property name="context_bar">Item</property>

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
    <if @cal_item.n_attachments@ gt 0><tr><th align=right>Attachments:</th><td>
<%
foreach attachment $item_attachments {
   template::adp_puts "<a href=\"[lindex $attachment 2]\">[lindex $attachment 1]</a> &nbsp;"
}
%>
</td></tr></if>
    </table>
    <p>
    <if @edit_p@ eq 1><a href="cal-item-edit?cal_item_id=@cal_item_id@&return_url=@return_url@">edit</a> | <a href="./cal-item-delete?cal_item_id=@cal_item_id@&return_url=@return_url@">delete</a> @attachment_options@
</if>
<p>
sync with Outlook: <a href="ics/@cal_item_id@.ics">single event</a> <if @cal_item.recurrence_id@ not nil>| <a href="ics/@cal_item_id@.ics?all_occurences_p=1">all events</a></if>
    </td>
  </tr>
</table>
</if>
