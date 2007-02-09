<table class="cal-table-display" cellpadding="1" cellspacing="2" width="99%">
<tr>
	<td align="center">
		<h1>#calendar.Week_of# @week_start_month@ @week_start_day@ @week_start_year@ &ndash; @week_end_month@ @week_end_day@ @week_end_year@</h1>
	</td>
</tr>
<tr>
	<td>
		<table cellpadding="0" cellspacing="0" border="0" class="cal-week-day-title">
		<tr>
			<td><p style="width:@time_of_day_width@@width_units@;margin:0px;">&nbsp;</p></td>
            <multiple name="days_of_week"><td width="@days_of_week.width@@width_units@"><a href="@nav_url_base@&view=day&date=@days_of_week.weekday_date@">@days_of_week.day_short@ @days_of_week.monthday@</td></multiple>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table id="cal-table-week" cellpadding="0" cellspacing="1" border="0" width="@week_width@@width_units@">
		<tr>
			<td style="vertical-align: top;" width="@time_of_day_width@@width_units@"><div class="day-time-1"><p>@grid_first_hour@</p></div></td>
			<td style="vertical-align: top;" class="week-event-1" width="@day_width_0@@width_units@">
              <div class="week-entry-box">
                <multiple name="items">
				<a href="@items.event_url@">
				<div class="week-entry-item @items.style_class@" title="@items.event_name@" style="position: absolute; top:@items.top@@hour_height_units@; left: @items.left@@width_units@; height:@items.height@@hour_height_units@;" onMouseOver="showCalItem(this,'@items.height@@hour_height_units@',20);" onMouseOut="showCalItem(this,'@items.height@@hour_height_units@',10);">
				<p title="@items.event_name@">@items.event_name@</p>
				</div>
				</a>
                </multiple>
			  </div>
            </td>
			<td class="week-event-1" width="@day_width_1@@width_units@">&nbsp;</td>
			<td class="week-event-1" width="@day_width_2@@width_units@">&nbsp;</td>
			<td class="week-event-1" width="@day_width_3@@width_units@">&nbsp;</td>
			<td class="week-event-1" width="@day_width_4@@width_units@">&nbsp;</td>
			<td class="week-event-1" width="@day_width_5@@width_units@">&nbsp;</td>
			<td class="week-event-1" width="@day_width_6@@width_units@">&nbsp;</td>
		</tr>
        <multiple name="grid">
		<tr>
            <if @grid.rownum@ odd>
			<td><div class="day-time-2"><p>@grid.hour@</p></div></td>
			<td class="week-event-2"></td>
			<td class="week-event-2"></td>
			<td class="week-event-2"></td>
			<td class="week-event-2"></td>
			<td class="week-event-2"></td>
			<td class="week-event-2"></td>
			<td class="week-event-2"></td>
            </if><else>
			<td><div class="day-time-1"><p>@grid.hour@</p></div></td>
			<td class="week-event-1"></td>
			<td class="week-event-1"></td>
			<td class="week-event-1"></td>
			<td class="week-event-1"></td>
			<td class="week-event-1"></td>
			<td class="week-event-1"></td>
			<td class="week-event-1"></td>
            </else>
		</tr>
        </multiple>
		</table>
	</td>
</tr>
<tr>
	<td>
		<table width="100%">
			<tr>
				<td>
					<div class="calendar-back-forward"><a href="@nav_url_base@&view=week&date=@last_week@#calendar""><img src="/resources/calendar/images/left.gif" alt="last week" /> &nbsp; #calendar.last_week#</a></div>
				</td>
				<td align="right">
					<div class="calendar-back-forward"><a href="@nav_url_base@&view=week&date=@next_week@#calendar">#calendar.next_week# &nbsp; <img src="/resources/calendar/images/right.gif" alt="next week" /></a></div>
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
