<master>
<property name="title">#calendar.Calendar_Item#: @cal_item.name;noquote@</property>
<property name="context">#calendar.Item#</property>
<property name="header_stuff">
  <link href="/resources/calendar/calendar.css" rel="stylesheet" type="text/css">
</property>

<table width="95%">

  <tr>
  <td valign=top width=150>
  <include src="mini-calendar" base_url="view" view="day" date="@date@">
  </td>	

  <td valign=top> 
  <table class="cal-table-display">
    <tr>
    <td colspan="2" class="cal-table-title">
    Calendar Event Details:
    </td>
    </tr>

    <tr>
    <td class="cal-table-data-title">#calendar.Title#
    </td>
    <td >@cal_item.name@</td>
    </tr>

    <tr>
    <td class="cal-table-data-title">Description:
    </td>
    <td>@cal_item.description@
    </tr>

    <tr>
    <td class="cal-table-data-title">#calendar.Date_1#
    <if @cal_item.no_time_p@ eq 0> 
    #calendar.and_Time#
    </if>
    :
    <td>
    <a
    href="./view?view=day&date=@cal_item.start_date@">@cal_item.pretty_short_start_date@</a>
    <if @cal_item.no_time_p@ eq 0>, #calendar.from# @cal_item.start_time@
    #calendar.to# @cal_item.end_time@</if>
    </td>
    </tr>

    <if @cal_item.item_type@ not nil>
      <tr>
      <td class="cal-table-data-title">
      #calendar.Type#
      </td>
      <td>
      @cal_item.item_type@
      </td>
      </tr>
    </if>
    
    <if @cal_item.n_attachments@ gt 0>
      <tr>
      <th align=right>
      #calendar.Attachments#
      </th>
      <td>

      <%
        foreach attachment $item_attachments {
        template::adp_puts "<a href=\"[lindex $attachment 2]\">[lindex $attachment 1]</a> &nbsp;"
        }
      %>
      </td>
      </tr>
    </if>

  <tr>
  <td colspan="2" class="cal-table-title">
  Actions:
  </td>
  </tr>
  <if @edit_p@ eq 1>
    <tr>
    <td class="cal-table-data-action">
    <a
    href="cal-item-new?cal_item_id=@cal_item_id@&return_url=@return_url@">#calendar.edit#</a>
    </td>
    <td>Edit this calendar event</td>
    </tr>
  </if>

  <if @delete_p@ eq 1>
    <tr>
    <td class="cal-table-data-action">
    <a
    href="./cal-item-delete?cal_item_id=@cal_item_id@&return_url=@return_url@">#calendar.delete#</a> 
    </td>
    <td>Delete this calendar event</td>
    </tr>
  </if>
 
  <tr>
  <td class="cal-table-data-action">
  <a href="ics/@cal_item_id@.ics">#calendar.single_event#</a> 
  </td>
  <td>#calendar.sync_with_Outlook#</td>
  </tr>

  <if @cal_item.recurrence_id@ not nil>
    <tr>
    <td class="cal-table-data-action">
    <a
    href="ics/@cal_item_id@.ics?all_occurences_p=1">#calendar.all_events#</a>
    </td>
    <td>Sync all events with Outlook</td>
    </tr>
  </if>
</table>
</table>
