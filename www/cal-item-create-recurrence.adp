<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">Calendars: Repeating Event</property>
<property name="context_bar">Repeat</property>

You are choosing to make this event recurrent, so that it appears more
than once in your calendar. The event's details are:
<p>
<b>Date:</b> @cal_item.start_date@<br>
<b>Time:</b> @cal_item.start_time@ - @cal_item.end_time@<br>
<b>Details:</b> @cal_item.description@
<p>

<FORM method=post action=cal-item-create-recurrence-2>
<INPUT TYPE=hidden name=cal_item_id value=@cal_item.cal_item_id@>
<INPUT TYPE=hidden name=return_url value="@return_url@">

Repeat every <INPUT TYPE=text name=every_n value=1 size=3>:<br>
<INPUT TYPE=radio name=interval_type value=day> day (s)<br>
<INPUT TYPE=radio name=interval_type value=week> 
<%
foreach dow {{Sunday 0} {Monday 1} {Tuesday 2} {Wednesday 3} {Thursday 4} {Friday 5} {Saturday 6}} {
        if {[lindex $dow 1] == [expr "$cal_item(day_of_week) -1"]} {
                set checked_html "CHECKED"
        } else {
                set checked_html ""
        }

        template::adp_puts "<INPUT TYPE=checkbox name=days_of_week value=[lindex $dow 1] $checked_html>[lindex $dow 0] &nbsp;"
}
%>
of the week <br>
<INPUT TYPE=radio name=interval_type value=month_by_date> day
@cal_item.day_of_month@ of the month <br>
<INPUT TYPE=radio name=interval_type value=month_by_day> same @cal_item.pretty_day_of_week@ of
the month <br>
<INPUT TYPE=radio name=interval_type value=year> year<br>
Repeat this event until: <%= [dt_widget_datetime -default [dt_systime] recur_until] %>
<p>
<INPUT TYPE=submit value="Add Recurrence">

</FORM>
