  <table class="table-display" cellpadding="1" cellspacing="2">
  <tr><td>
  <table cellpadding=3 cellspacing=0 border=0 width=100% class="table-display">
    <tr class="table-header" bgcolor=lavender>
    <td class="cal-month-title-text">
    @url_previous_week;noquote@
    <img src="/shared/images/left.gif" alt="back one day" border="0">
    </a>
    <B>@dates;noquote@</B>
    @url_next_week;noquote@
    <img src="/shared/images/right.gif" alt="forward one day" border="0"
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
          <if @day_items_without_time:rowcount@ gt 0>
            <multiple name="day_items_without_time">
            <tr class="row-light">
            <td width="1%" class="cal-day-time"><img border="0" align="left" src="no-time.gif" alt="No Time"></td>
            <td class="cal-day-event-notime"><a
    href="cal-item-view?cal_item_id=@day_items_without_time.item_id@">@day_items_without_time.name@</a></td>
            </tr>
            </multiple>
          </if>
          <if @day_items_with_time:rowcount@ gt 0>
            <multiple name="day_items_with_time">
            <if @day_items_with_time.current_hour@ odd>
              <tr class="row-light">
            </if>
            <else>
              <tr class="row-dark">
            </else>

	<td width="1%" class="cal-day-time">      <a	
      href="cal-item-new?date=@current_date@&start_time=@day_items_with_time.current_hour@&end_time=">
	@day_items_with_time.current_hour@</a></td>

            <group column="current_hour">
              <if @day_items_with_time.item_id@ ne "">
                <if @day_items_with_time.name@ ne "">

                <td class="cal-day-event" rowspan="@day_items_with_time.rowspan@"  colspan="@day_items_with_time.colspan@" valign="top">
                <a
                href="cal-item-view?cal_item_id=@day_items_with_time.item_id@">@day_items_with_time.start_time@
                - @day_items_with_time.end_time@
                @day_items_with_time.name@</a><span class="text-grey-sml">@day_items_with_time.calendar_name@</span>
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
