<table class="cal-table" cellpadding="0" cellspacing="0">
  <!-- Navigation bar views-->
  <tr>
  <multiple name=views>
    <if @views.active_p@ eq t>
      <td class="cal-navbar-selected">
        <a href="@base_url@?view=@views.text@&date=@date@@page_num@" style="color: #004080; text-decoration: none;">@views.name@</a>
      </td>
    </if>
    <else>
      <td class="cal-navbar">
        <a href="@base_url@?view=@views.text@&date=@date@@page_num@">@views.name@</a>
      </td>
    </else>
  </multiple>
  </tr>
  
  <!-- Forward/back months/years -->
  <tr>
  <td colspan=5>
  <table class="cal-table-display" cellspacing="0" cellpadding="0">
    <tr>
    <td align="left" class="cal-month-title">
    <if @view@ eq month>
      @prev_year_url;noquote@
      <img border=0 src="/resources/acs-subsite/left.gif"></a>
      <td class="cal-month-title-text" colspan="2">@curr_year@</td>
      <td align="right" class="cal-month-title">
      @next_year_url;noquote@
      <img border=0 src="/resources/acs-subsite/right.gif"></a>
    </if>
    <else>
      @prev_month_url;noquote@
      <img border=0 src="/resources/acs-subsite/left.gif"></a>
      <td class="cal-month-title-text" colspan="2">@curr_month@</td>
      <td align="right" class="cal-month-title">
      @next_month_url;noquote@
      <img border=0 src="/resources/acs-subsite/right.gif"></a>
    </else>
    </td>
    </tr>
  </table>
  </td>
  </tr>
    
  
  <if @view@ eq month>
    <tr>
    <td colspan=5>
    <table class="cal-day-table" cellspacing="3" cellpadding="1">
    <tr>
    <multiple name="months">
      <if @months.new_row_p@ eq t>
        </tr><tr>
      </if>
      <if @months.current_month_p@ eq t>
        <td class="cal-month-thismonth">
        @months.name@
        </td>
      </if>
      <else>
        <td class="cal-month">
        <a href="@base_url@?view=month&date=@months.target_date@@page_num@">
        @months.name@</a>
        </td>
       </else>         
    </multiple>
    </tr>
  </if>
  <else>
    <tr>
    <td colspan=5>
    <table class="cal-day-table" cellspacing="3" cellpadding="1">
    <tr>
    <multiple name="days_of_week">
      <td class="cal-day-title">@days_of_week.day_short@</td>
    </multiple>
    </tr>
    <tr>
      <td class="cal-spacer" colspan="7">
        <img border="0" src="/resources/acs-subsite/spacer.gif">
      </td>
    </tr>

    <multiple name="days">
      <if @days.beginning_of_week_p@ eq t>
        <tr>
      </if>
  
      <if @days.greyed_p@ eq t>
        <td class="cal-day-inactive">
        <a href="@base_url@?view=@view@date=@days.ansi_date@@page_num@">
        <font color=gray>@days.day_number@</font></a>
        </td>
      </if>
      <if @days.today_p@ eq t>
        <td class="cal-day-today">
        <a href="@base_url@?view=@view@&date=@days.ansi_date@@page_num@" style="color: white; text-decoration: none;"><b>@days.day_number@</b></a>
        </td>
      </if>
      <if @days.today_p@ eq f and @days.greyed_p@ eq f>
        <td class="cal-day">
        <a href="@base_url@?view=@view@&date=@days.ansi_date@@page_num@">
        <font color=blue>@days.day_number@</font></a>
        </td>
      </if>
  
      <if @days.end_of_week_p@ eq t>
        </tr>
      </if>
    </multiple>
  </else>
  
  <tr><td align=center colspan=7>
  <table cellspacing=0 cellpadding=1 border=0>
  <tr><td></td></tr>
  </table>
  </td>
  </tr>
  </table>
  
  </td>
  </tr>
  <tr class="cal-table-header"><td align=center colspan=5>
  <table cellspacing=0 cellpadding=0 border=0>
  <tr><td nowrap>
  <font size=-2>
  
  <if @today_p@ true>
    <b>#acs-datetime.Today#</b>
  </if>
  <else>
    <a href="@today_url@"><b>#acs-datetime.Today#</b></a> 
  </else>
  
  #acs-datetime.is# <%=[dt_ansi_to_pretty]%></font></td></tr>
  <tr><td align=center><br>
  <form method=get action=@base_url@>
  <INPUT TYPE=text name=date size=10> <INPUT type=image src="/resources/acs-subsite/go.gif" alt="Go" border=0><br><font size=-2>#acs-datetime.Date_as_YYYYMMDD#</font>
  <INPUT TYPE=hidden name=view value=day>
  @form_vars;noquote@
  @page_num_formvar;noquote@
  </form>
  </td>
  </tr>
  </table>
  </td>
  </tr>
</table>
