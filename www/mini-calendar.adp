<table id="at-a-glance" cellspacing="0" cellpadding="0">
  <caption>
    <if @view@ eq "month">
      <if @prev_year_url@ ne ""><a href="@prev_year_url@" title="#calendar.prev_year#"><adp:icon name="previous" text="#calendar.prev_year#"></a></if>
      @curr_date_pretty@
      <if @next_year_url@ ne ""><a href="@next_year_url@" title="#calendar.next_year#"><adp:icon name="next" text="#calendar.next_year#"></a></if>
    </if>
    <else>
      <if @prev_month_url@ ne ""><a href="@prev_month_url@#calendar" title="#calendar.prev_month#"><adp:icon name="previous" text="#calendar.prev_month#"></a></if>
      @curr_date_pretty@
      <if @next_month_url@ ne ""><a href="@next_month_url@#calendar" title="#calendar.next_month#"><adp:icon name="next" text="#calendar.next_month#"></a></if>
    </else>
  </caption>

    <if @view@ eq month>
      <tbody>
       <multiple name="months">
         <tr>
         <group column="new_row_p">
         <if @months.current_month_p;literal@ true>
          <td class="months selected"><if @months.url@ ne ""><a href="@months.url@" title="#calendar.goto_months_name#">@months.name@</a></if><else>@months.name@</else></td>
         </if>
         <else>
           <td class="months"><if @months.url@ ne ""><a href="@months.url@" title="#calendar.goto_months_name#">@months.name@</a></if><else>@months.name@</else></td>
         </else>
         </group>
         </tr>
       </multiple>
      </tbody>
    </if>
    <else>
      <thead>
        <tr class="days">
        <multiple name="days_of_week">
          <th id="day_@days_of_week.day_num@">@days_of_week.day_short@</th>
        </multiple>
        </tr>
      </thead>

      <tbody>
        <multiple name="days">
          <if @days.beginning_of_week_p;literal@ true>
            <tr>
          </if>
          <if @days.active_p;literal@ true>
            <if @days.today_p;literal@ true>
              <td headers="day_@days.day_num@" class="today" id="@days.id;literal@">
                <if @days.url@ ne ""><a href="@days.url@#calendar" title="#calendar.goto_days_pretty_date#">@days.day_number@</a></if><else>@days.day_number@</else>
              </td>
            </if>
            <else>
              <td headers="day_@days.day_num@" class="active" id="@days.id;literal@">
                <if @days.url@ ne ""><a href="@days.url@#calendar" title="#calendar.goto_days_pretty_date#">@days.day_number@</a></if><else>@days.day_number@</else>
              </td>
            </else>
          </if>
          <else>
            <td headers="day_@days.day_num@" class="inactive" id="@days.id;literal@">
              <if @days.url@ ne ""><a href="@days.url@#calendar" title="#calendar.goto_days_pretty_date#">@days.day_number@</a></if><else>@days.day_number@</else>
            </td>
          </else>
    
          <if @days.end_of_week_p;literal@ true>
            </tr>
          </if>
        </multiple>
      </tbody>
    </else>
 </table>

  <p>
  <if @today_p;literal@ true>
    #acs-datetime.Today#
  </if>
  <else>
    <a href="@today_url@" title="#calendar.goto_today#">#acs-datetime.Today#</a> 
  </else>
  #acs-datetime.is# @today@
  </p>

  <formtemplate id="@form_name@"></formtemplate>

