<table class="cal-table-display" cellpadding="1" cellspacing="2" width="99%">
<tr><td align="right" nowrap="nowrap">
<a href="@self_url@?period_days=1&@url_vars@#calendar">1</a>
<a href="@self_url@?period_days=7&@url_vars@#calendar">7</a>
<a href="@self_url@?period_days=14&@url_vars@#calendar">14</a>
<a href="@self_url@?period_days=21&@url_vars@#calendar">21</a>
<a href="@self_url@?period_days=30&@url_vars@#calendar">30</a>
<a href="@self_url@?period_days=60&@url_vars@#calendar">60</a><formtemplate
id="frmdays"></formtemplate>
</td></tr>
<tr>
	<td align="center">
		<h1>@start_month@ @start_day@ @start_year@ &ndash; @end_month@ @end_day@ @end_year@</h1>
	</td>
</tr>

<if @items:rowcount@ gt 0>
        
<tr>
    <td>

  <multiple name="items">

        <div class="list-entry-item @items.container_style_class@">

		<table class="cal-table-list" cellpadding="0" cellspacing="0" border="0" width="100%">
		<thead>
		<tr>
			<td>
			@items.weekday@, @items.start_date@ &nbsp;&nbsp;&nbsp; <if @items.start_time@ ne @items.end_time@>@items.start_time@ &ndash; @items.end_time@</if>
			</td>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td class="@items.name_style_class@">
			<strong>Event: </strong><a href="@items.event_url@">@items.event_name@</a>
            <if @show_calendar_name_p@>
            (@items.calendar_name@)
            </if>

			</td>
		</tr>
		<tr>
			<td class="@items.description_style_class@">
			<strong>Description: </strong>
            <if @items.description@ eq ""><em>none</em></if><else>@items.description@</else>

			<a href="@items.event_url@&export=print" onclick="return calOpenPrintView('@items.event_url@&export=print');"><img src="/resources/calendar/images/print-list-icon.gif" align="right" border="0"></a>
			</td>
		</tr>
		</tbody>
		</table>

        </div>

  </multiple>

    </td>
</tr>

</if>
<else>
<tr><td><i>#calendar.No_Items#</i></td></tr>
</else>

</table>
