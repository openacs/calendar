  <master>
    <property name="title">#calendar.Calendar_Item_Delete#: @cal_item.name;noquote@</property>
    <property name="context">#calendar.Delete#</property>
    <property name="header_stuff">
      <link href="/resources/calendar/calendar.css" rel="stylesheet" type="text/css">
    </property>
    <if @link:rowcount@ not nil><property name="&link">link</property></if>

    <table>

      <tr>
        <td valign=top>
          <include src="mini-calendar" base_url="view" view="day" date="@date@">
        </td>	

        <td valign=top> 
          <table>
            <tr>
              <th align=right>#calendar.Title#</th>
              <td>@cal_item.name@</td>
            </tr>
            <if @cal_item.item_type@ not nil>
              <tr>
                <th align=right>#calendar.Type#</th>
                <td>@cal_item.item_type@</td>
              </tr>
            </if>
            <tr>
              <th align=right>
                #calendar.Date_1#<if @cal_item.no_time_p@ eq 0> #calendar.and_Time#</if>:
              </th>
              <td>
                <a href="./view?view=day&date=@cal_item.start_date@">@cal_item.pretty_short_start_date@</a>
                <if @cal_item.no_time_p@ eq 0>, #calendar.from# @cal_item.start_time@ #calendar.to# @cal_item.end_time@</if>
              </td>
            </tr>
            <tr>
              <th align=right>#calendar.Description#</th>
              <td>@cal_item.description@</td>
            </tr>
          </table>
          <if @cal_item.recurrence_id@ not nil>
            <p><b>#calendar.lt_This_is_a_repeating_e#</b>#calendar._You_may_choose_to#</p>
            <ul>
              <li> <a href="cal-item-delete?cal_item_id=@cal_item_id@&confirm_p=1">#calendar.lt_delete_only_this_inst#</a></li>
              <li> <a href="cal-item-delete-all-occurrences?recurrence_id=@cal_item.recurrence_id@">#calendar.lt_delete_all_occurrence#</a></li>
            </ul>
          </if>
          <else>
            <p align=center>#calendar.lt_Are_you_sure_you_want_1#</p>
            <p align=center>
              <a href="cal-item-delete?cal_item_id=@cal_item_id@&confirm_p=1" title="#calendar.yes_delete_it#" class="button">#calendar.yes_delete_it#</a>
              <a href="cal-item-view?cal_item_id=@cal_item_id@" title="#calendar.no_keep_it#" class="button">#calendar.no_keep_it#</a>
            </p>
          </else>
        </td>
      </tr>
    </table>
