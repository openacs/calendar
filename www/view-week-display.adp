<table CELLPADDING=0 CELLSPACING=0 BORDER=0 width="100%">

  <tr><td>
  <table cellpadding=3 cellspacing=0 border=0 width="100%" class="cal-table-display">
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
  <tr>
  <td>
  
    <table class="cal-table-display" cellpadding=0 cellspacing=0 border=0>
    <multiple name="week_items">
      <tr>
      <td valign=top class="cal-week">
      <strong>@week_items.start_date_weekday@</strong>:
      </td>

      <td width="95%" class="cal-week">
      <a
      href="@base_url@cal-item-new?date=@week_items.ansi_start_date@&start_time=&end_time=">
      <img border="0" align="right" height="16" width="16" src="/shared/images/add.gif" alt="#calendar.Add_Item#"></a><a
      href="?view=day&date=@week_items.ansi_start_date@@page_num@">@week_items.start_date@</a>
      </td>
      </tr>
    
      <tr>
        <td class="cal-week-event" colspan=3>
        <if @week_items.name@ ne "">
        <table class="cal-week-events" cellpadding=0 cellspacing=0 border=0>
        <tbody>
        <group column="day_of_week">
          <if @week_items.name@ ne "">
            <tr>
            <td>
            <if @week_items.no_time_p@ eq "t">
            <span class="cal-week-event-notime">
            </if>
            <if @week_items.no_time_p@ ne "t">
            @week_items.start_time@ -  @week_items.end_time@
            </if>
            @week_items.full_item;noquote@
            <if @week_items.no_time_p@ eq "t">
            </span>
            </if>
            <span class="cal-text-grey-sml">[@week_items.calendar_name@]</span>
            </td>
            </tr>
           </if>
        </group>
        </tbody>
        </table>
        </if>
        </td>
       </tr>
      </td>
      </tr>
    </multiple>
    </table>
    
  </td>
  </tr>
</table>
