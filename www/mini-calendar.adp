<table id="at-a-glance" cellspacing="0" cellpadding="0">
  <caption>
    <if @view@ eq "month">
      <a href="@prev_year_url@" title="#calendar.prev_year#"><img src="/resources/calendar/images/left.gif" alt="#calendar.prev_year#"></a>
      @curr_date_pretty@
      <a href="@next_year_url@" title="#calendar.next_year#"><img src="/resources/calendar/images/right.gif" alt="#calendar.next_year#" ></a>
    </if>
    <else>
      <a href="@prev_month_url@#calendar" title="#calendar.prev_month#"><img src="/resources/calendar/images/left.gif" alt="#calendar.prev_month#" ></a>
      @curr_date_pretty@
      <a href="@next_month_url@#calendar" title="#calendar.next_month#"><img src="/resources/calendar/images/right.gif" alt="#calendar.next_month#" ></a>
    </else>
  </caption>

    <if @view@ eq month>
      <tbody>
       <multiple name="months">
         <tr>
         <group column="new_row_p">
         <if @months.current_month_p;literal@ true>
          <td class="months selected"><a href="@months.url@" title="#calendar.goto_months_name#">@months.name@</a></td>
         </if>
         <else>
           <td class="months"><a href="@months.url@" title="#calendar.goto_months_name#">@months.name@</a></td>
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
                <a href="@days.url@#calendar" title="#calendar.goto_days_pretty_date#">@days.day_number@</a>
              </td>
            </if>
            <else>
              <td headers="day_@days.day_num@" class="active" id="@days.id;literal@">
                <a href="@days.url@#calendar" title="#calendar.goto_days_pretty_date#">@days.day_number@</a>
              </td>
            </else>
          </if>
          <else>
            <td headers="day_@days.day_num@" class="inactive" id="@days.id;literal@">
              <a href="@days.url@#calendar" title="#calendar.goto_days_pretty_date#">@days.day_number@</a>
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

  <formtemplate id="go-to-date"></formtemplate>

