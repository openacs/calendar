<% ns_log notice "DAVEB 103 view-month-display.adp" %>

    <h1 class="calendar-back-forward" style="text-align:center">
      <a href="@previous_month_url@#calendar" title="#calendar.prev_month#"><img src="/resources/calendar/images/left.gif" alt="#calendar.prev_month#" ></a>
      &nbsp;@month_string@ @year@&nbsp;
    <a href="@next_month_url@#calendar" title="#calendar.next_month#"><img src="/resources/calendar/images/right.gif" alt="#calendar.next_month#" ></a>
    </h1>

<table class="cal-table-display" cellpadding="0" cellspacing="0" border="0" width="75%" summary="calendar grid display for @month_string@ @year@">
  <tr>
    <multiple name="weekday_names">
      <th width="14%" class="cal-month-day-title">
        @weekday_names.weekday_short@
      </th>
    </multiple>
  </tr>

  <tr>
    <td colspan="7">

      <table class="cal-month-table" cellpadding="0" cellspacing="0" border="0" width="100%">

        <tbody>

                <!-- tr -->

            <multiple name="items">

              <if @items.beginning_of_week_p@ true>
                <tr>
              </if>

              <if @items.outside_month_p@ true>
                <td class="cal-month-day-inactive" width="14%">&nbsp;</td>
              </if>     
              <else>
                <if @items.today_p@ true>
                  <td class="cal-month-today"  width="14%" onclick="javascript:location.href='@items.add_url@';" onkeypress="javascript:acs_KeypressGoto('@items.add_url@',event);">
                </if>
                <else>
                  <td class="cal-month-day"  width="14%" onclick="javascript:location.href='@items.add_url@';"onkeypress="javascript:acs_KeypressGoto('@items.add_url@',event);">
                </else>
                  &nbsp;<span class="screen-reader-only">[</span><a href="@items.day_url@" title="#calendar.goto_day_items_day_number#">@items.day_number@</a><span class="screen-reader-only"> ]</span>

                  <group column="day_number">
                    <if @items.event_name@ true>
                      <div class="cal-month-event @items.style_class@">
                        <a href="@items.event_url@" title="#calendar.goto_items_event_name#">
                        <if @items.time_p@ true>@items.start_time@</if>
                        @items.event_name@
                        <if @items.num_attachments@ gt 0><img src="/resources/calendar/images/attach.png" alt=""/></if>
			<if @show_calendar_name_p@>
                          <span class="cal-text-grey-sml"> [@items.calendar_name@]</span>
                        </if>
                        </a>
                      </div>
                    </if>
                  </group>

                </td>
              </else>

              <if @items.end_of_week_p@ true>
                </tr>
              </if>

            </multiple>

                <!-- /tr -->

        </tbody>
      </table>
    </td>
  </tr>
  <tr>
	<td colspan="7">
		<table width="100%">
			<tr>
				<td>
					<div class="calendar-back-forward"><a href="@previous_month_url@#calendar" title="#calendar.prev_month#"><img src="/resources/calendar/images/left.gif" alt="#acs-kernel.common_Go#" > &nbsp; #calendar.prev_month#</a></div>
				</td>
				<td align="right">
					<div class="calendar-back-forward"><a href="@next_month_url@#calendar" title="#calendar.next_month#">#calendar.next_month#&nbsp; <img src="/resources/calendar/images/right.gif" alt="#acs-kernel.common_Go#" ></a></div>
				</td>
			</tr>
		</table>
	</td>
  </tr>
</table>
