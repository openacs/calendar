<table cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td class="cal-month-title-text" colspan="7">
      @prev_month_url;noquote@
      @month_string@ @year@
      @next_month_url;noquote@
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
              <if @days_of_a_month.beginning_of_week_p@ true>
                <tr>
              </if>

              <if @days_of_a_month.outside_month_p@ true>
                <td class="cal-month-day-inactive">&nbsp;</td>
              </if>     
              <else>
                <if @days_of_a_month.today_p@ true>
                  <td class="cal-month-today" onclick="javascript:location.href='@days_of_a_month.url@';">
                </if>
                <else>
                  <td class="cal-month-day" onclick="javascript:location.href='@days_of_a_month.url@';">
                </else>

                  <a href="?view=day&date=@days_of_a_month.ansi_start_date@@page_num@">@days_of_a_month.day_number@</a>

                  <group column="ansi_start_date">
                    <if @days_of_a_month.calendar_item@ ne "">
                      <div class="cal-month-event">
                        <if @days_of_a_month.time_p@ true>@days_of_a_month.ansi_start_time@</if>
                        <a href=@days_of_a_month.item_url@>@days_of_a_month.calendar_item;noquote@</a>
                        <span class="cal-text-grey-sml"> [@days_of_a_month.calendar_name@]</span>
                      </div>
                    </if>
                  </group>

                </td>
              </else>
              <if @days_of_a_month.end_of_week_p@ true>
                </tr>
              </if>
            </multiple>

          </tr>
        </tbody>
      </table>
    </td>
  </tr>
</table>




