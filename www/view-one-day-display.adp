<table class="cal-table-display" cellpadding="1" cellspacing="2" width="99%">
  <tr>
    <td align="center">
      <h1>@curr_day_name@ @curr_month@ @curr_day@ @curr_year@</h1>
    </td>
  </tr>
  <tr>
    <td>
     <table id="cal-table-day" cellpadding="0" cellspacing="1" border="0" width="100%">
        <tr>
			<td style="vertical-align: top;"> <div class="day-time-1"><p><a href="@grid_first_add_url@">@grid_first_hour@</a></p></div></td>
			<td style="vertical-align: top;" class="day-event-1" width="80%" valign="top">
            <div id="day-entry-box">
            <multiple name="items">
			<a href="@items.event_url@"><div id="day-entry-@items.rownum@" class="day-entry-item @items.style_class@" title="@items.event_name@" style="top: @items.top@@hour_height_units@; height: @items.height@@hour_height_units@; @items.style@" onmouseover="showCalItem(this,'@items.height@@hour_height_units@',20);" onmouseout="showCalItem(this,'@items.height@@hour_height_units@',10);"><p title="@items.event_name@">@items.event_name@</p></div></a>
            </multiple>
			</div><!-- day-entry-box -->
            </td>
        </tr>
        <multiple name="grid">
		<tr>
            <if @grid.rownum@ even>
			<td> <div class="day-time-1"><p><a href="@grid.add_url@" title="Click to add an item starting at this time">@grid.hour@</p></a></div></td>
			<td class="day-event-1" width="80%" valign="top">
            </td>
            </if><else>
			<td> <div class="day-time-2"><p><a href="@grid.add_url@" title="Click to add an item starting at this time">@grid.hour@</a></p></div></td>
			<td class="day-event-2" width="80%" valign="top"></td>
            </else>
		</tr>
        </multiple>
     </table>
   </td>
 </tr>
</table>
