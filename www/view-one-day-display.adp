  <table class="cal-table-display" cellpadding="1" cellspacing="2">
  <tr><td>
  <table cellpadding=3 cellspacing=0 border=0 width=100% class="cal-table-display">
    <tr class="cal-table-header" bgcolor=lavender>
    <td class="cal-month-title-text">
    @url_previous_week;noquote@
    </a>
    <B>@dates;noquote@</B>
    @url_next_week;noquote@
    </a>
    </td>
    </tr>
    </table>
  </td>
  </tr>
  <table>
  <tr>
  <td>
    <tr>
      <td>
          <tr class="cal-row-light">
          <td width="1%" class="cal-day-time">@item_add_without_time;noquote@</td>
          <td><table> 
            <multiple name="day_items_without_time">
	    <tr>
            <td class="cal-day-event-notime">@day_items_without_time.full_item;noquote@</td>
            </tr>
            </multiple>
          </table></td>
          </tr>
          <if @day_items_with_time:rowcount@ gt 0>
            <multiple name="day_items_with_time">
            <if @day_items_with_time.current_hour@ odd>
              <tr class="odd">
            </if>
            <else>
              <tr class="even">
            </else>

	<td width="20%" class="cal-day-time">     
	@day_items_with_time.current_hour_link;noquote@
	</td>

            <group column="current_hour">
              <if @day_items_with_time.item_id@ ne "">
                <if @day_items_with_time.name@ ne "">

                <td class="cal-day-event" rowspan="@day_items_with_time.rowspan@"  colspan="@day_items_with_time.colspan@" valign="top">
                @day_items_with_time.full_item;noquote@
                <if @show_calendar_name_p@>
                <span
                class="cal-text-grey-sml">@day_items_with_time.calendar_name@</span>
                </if>
                </td>
                </if>
              </if>
                <else>
                  <if @day_items_with_time.rowspan@ gt 0>
                    <td class="cal-day-event" colspan="@day_items_with_time.colspan@">&nbsp;</td>
                  </if>
                  <else>
                    <if @max_items_per_hour@ eq 0>
                      <td class="cal-day-event">&nbsp;</td>
                    </if>
                  </else>
                </else>
            </group>
            </tr>
            </multiple>
          </if>
      </td>
    </tr>
  </table>
