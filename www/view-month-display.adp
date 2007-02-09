<% ns_log notice "DAVEB 103 view-month-display.adp" %>

<h1 align="center">@month_string@ @year@</h1>

<table class="cal-table-display" cellpadding="0" cellspacing="0" border="0" width="99%" summary="calendar grid display for @month_string@ @year@">
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

                <tr>

            <multiple name="items">

              <if @items.outside_month_p@ true>
                <td class="cal-month-day-inactive" width="14%">&nbsp;</td>
              </if>     
              <else>
                <if @items.today_p@ true>
                  <td class="cal-month-today"  width="14%" onclick="javascript:location.href='@items.add_url@';" onkeypress="javascript:location.href='@items.add_url@';">
                </if>
                <else>
                  <td class="cal-month-day"  width="14%" onclick="javascript:location.href='@items.add_url@';"onkeypress="javascript:location.href='@items.add_url@';">
                </else>
                  &nbsp;<span class="screen-reader-only">[</span><a href="@items.day_url@">@items.day_number@</a><span class="screen-reader-only"> ]</span>

                  <group column="day_number">
                    <if @items.event_name@ true>
                      <a href="@items.event_url@">
                      <div class="cal-month-event @items.style_class@">
                        <if @items.time_p@ true>@items.start_time@</if>
                        @items.event_name@
                        <if @show_calendar_name_p@>
                          <span class="cal-text-grey-sml"> [@items.calendar_name@]</span>
                        </if>
                      </div>
                      </a>
                    </if>
                  </group>

                </td>
              </else>

              <if @items.end_of_week_p@ true>
                </tr><tr>
              </if>

            </multiple>

                </tr>

        </tbody>
      </table>
    </td>
  </tr>
  <tr>
	<td colspan="7">
		<table width="100%">
			<tr>
				<td>
					<div class="calendar-back-forward"><a href="@previous_month_url@#calendar"><img src="/resources/calendar/images/left.gif" alt="last month" /> &nbsp; last month</a></div>
				</td>
				<td align="right">
					<div class="calendar-back-forward"><a href="@next_month_url@#calendar">next month &nbsp; <img src="/resources/calendar/images/right.gif" alt="next month" /></a></div>
				</td>
			</tr>
		</table>
	</td>
  </tr>
</table>
