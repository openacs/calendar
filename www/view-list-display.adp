        
          <form name="frmdays" class="frm-compact">
            <table width="100%" cellspacing="0" cellpadding="0" border="0">
              <tbody><tr valign="middle">
                <td align="left">
                  <h5>@title@</h5>
                </td>
                <td align="right">
                  Events over a <input type="text" class="field" id="period_days" name="period_days" value="@period_days@" size="3" maxlength="3"> day rolling period <input class="button-sml" type="submit" value="Go">
                  @form_vars;noquote@
                </td>
              </tr>
            </tbody></table>
          </form>


<table class="table-display" border=0 cellspacing=0 cellpadding=2>
  <tr class="table-header">
  <th align=left>Day of Week</th>
  <th align="center"><a href="@start_date_url@">Start Date</a></th>
  <th align="center">Start Time</th>
  <th align="center">End Time</th>
  <th align="center"><a href="@item_type_url@">Type</a></th>
  <th align=left>Title</th></tr>

<multiple name="calendar_items">

  <group column="pretty_weekday">

  <if @calendar_items.flip@ odd>
    <tr class="row-dark">
  </if>
  <else>
    <tr class="row-light">
  </else>  

  <td class="@calendar_items.today@" align=left>@calendar_items.pretty_weekday@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.pretty_start_date@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.pretty_start_time@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.pretty_end_time@</td>
  <td class="@calendar_items.today@" align="center">@calendar_items.item_type@</td>
  <td class="@calendar_items.today@" align=left><a
  href="cal-item-view?cal_item_id=@calendar_items.item_id@">@calendar_items.name@</a>
  (@calendar_items.calendar_name@)</td>

  </tr>

  </group>
  </multiple>

</table>

