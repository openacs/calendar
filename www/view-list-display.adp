<table class="cal-table-display" cellpadding="1" cellspacing="2" width="75%">
<tr><td align="right" nowrap="nowrap">
[&nbsp;<a href="@period_url_1@" title="#calendar.events_over_1d#">1</a>
&nbsp;|&nbsp;
<a href="@period_url_7@" title="#calendar.events_over_7d#">7</a>
&nbsp;|&nbsp;
<a href="@period_url_14@" title="#calendar.events_over_14d#">14</a>
&nbsp;|&nbsp;
<a href="@period_url_21@" title="#calendar.events_over_21d#">21</a>
&nbsp;|&nbsp;
<a href="@period_url_30@" title="#calendar.events_over_30d#">30</a>
&nbsp;|&nbsp;
<a href="@period_url_60@" title="#calendar.events_over_60d#">60</a>&nbsp;]
<formtemplate id="frmdays"></formtemplate>
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
			<strong>#calendar.Event#</strong> <a href="@items.event_url@" title="#calendar.goto_items_event_name#">@items.event_name@</a>
            <if @show_calendar_name_p@>
            (@items.calendar_name@)
            </if>

			</td>
		</tr>
		<tr>
			<td class="@items.description_style_class@">
			<strong>#calendar.Description#</strong>
            <if @items.description@ eq ""><em>none</em></if><else>@items.description;noquote@</else>

			<a href="@items.event_print_url@" onclick="return calOpenPrintView('@items.event_print_url@');" title="#calendar.Print#"><img src="/resources/calendar/images/print-list-icon.gif" align="right" border="0" alt="#calendar.Print#"></a>
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
