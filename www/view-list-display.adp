<if @calendar_items:rowcount@ gt 0>
        
          <form name="frmdays" class="cal-frm-compact">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
              <tbody><tr valign="middle">
                <td align="left">
                  <h5>@title@</h5>
                </td>
                <td align="right">
                  Events over a <input type="text" class="cal-field" id="period_days" name="period_days" value="@period_days@" size="3" maxlength="3"> day rolling period <input class="cal-button-sml" type="submit" value="Go">
                  @form_vars;noquote@
                </td>
              </tr>
            </tbody></table>
          </form>


<table class="cal-table-display" border=0 cellspacing=0 cellpadding=2>
  <tr class="cal-table-header">
  <th align=left>#acs-datetime.Day_of_Week#</th>
  <th align="center"><a href="@start_date_url@">#calendar.Date_1#</a></th>
  <th align="center">#calendar.Start_Time#</th>
  <th align="center">#calendar.End_Time#</th>
  <th align="center"><a href="@item_type_url@">#calendar.Type_1#</a></th>
  <th align=left>Title</th></tr>

  <multiple name="calendar_items">

  <group column="pretty_weekday">

  <if @calendar_items.flip@ odd>
    <tr class="cal-row-dark">
  </if>
  <else>
    <tr class="cal-row-light">
  </else>  

  <td class="@calendar_items.today@" align=left>@calendar_items.pretty_weekday@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.pretty_start_date@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.pretty_start_time@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.pretty_end_time@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.item_type@</td>
  <td class="@calendar_items.today@"
  align=left>@calendar_items.full_item;noquote@</a>

  <if @show_calendar_name_p@>
  (@calendar_items.calendar_name@)
  </if>
  </td>

  </tr>

  </group>
  </multiple>
</table>
</if>
<else>
<i>No Items</i>
</else>

