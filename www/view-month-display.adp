<table CELLPADDING=0 CELLSPACING=0 width="100%">
  <tr>
    <td class="cla-no-border" colspan=7>

      <table width="100%" cellpadding=0 cellspacing=0 border=0 class="cal-table-display">
        <tr class="cal-table-header" bgcolor=lavender>
          <td class="cal-month-title-text">
            @prev_month_url;noquote@
            <b>@month_string@ @year@</b>
            @next_month_url;noquote@
          </td>
        </tr>
      </table>

    </td>
  </tr>
  <tr>
    <td>

      <table class="cal-month-table" cellpadding="2" cellspacing="2" border="5">
        <tbody>
          <tr>

            <multiple name="weekday_names">
              <td width="14%" class="cal-month-day-title">
                @weekday_names.weekday_short@
              </td>
            </multiple>

          </tr>
          <tr>

            <multiple name="days_of_a_month">
              <if @days_of_a_month.beginning_of_week_p@ eq "t">
                <tr>
              </if>

              <if @days_of_a_month.outside_month_p@ eq "t">
                <td class="cal-month-day-inactive">&nbsp;</td>
              </if>     
              <else>
                <if @days_of_a_month.today_p@ eq "t">
                  <td class="cal-month-today">
                </if>
                <else>
                  <td class="cal-month-day">
                </else>

                  <a
                  href="@base_url@cal-item-new?date=@days_of_a_month.ansi_start_date@&start_time=&end_time=">
                  <img border="0" align="right" height="16" width="16" src="/shared/images/add.gif" alt="#calendar.Add_Item#"></a>
                  <a href="?view=day&date=@days_of_a_month.ansi_start_date@@page_num@">@days_of_a_month.day_number@</a>

                  <group column="ansi_start_date">
                    <if @days_of_a_month.item_id@ ne "">
                      <div class="cal-month-event">@days_of_a_month.ansi_start_time@
                        <a
                        href=cal-item-view?cal_item_id=@days_of_a_month.item_id@>@days_of_a_month.full_item;noquote@</a>
                        <span class="cal-text-grey-sml"> [@days_of_a_month.calendar_name@]</span>
                      </div>
                    </if>
                  </group>

                </td>
              </else>
              <if @days_of_a_month.end_of_week_p@ eq "t">
                </tr>
              </if>
            </multiple>

          </tr>
        </tbody>
      </table>
    </td>
  </tr>
</table>
