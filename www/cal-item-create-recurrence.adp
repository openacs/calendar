<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">Calendars: Recurrence</property>
<property name="context_bar"></property>

You are choosing to make this event recurrent, so that it appears more
than once in your calendar. The event's details are:
<p>
<b>Date:</b> @start_date@<br>
<b>Time:</b> @start_time@ - @end_time@<br>
<b>Details:</b> @description@
<p>

<FORM method=post action=cal-item-create-recurrence-2>
<INPUT TYPE=hidden name=cal_item_id value=@cal_item_id@>
<INPUT TYPE=hidden name=return_url value="@return_url@">

Repeat every <INPUT TYPE=text name=every_n value=1 size=3>:<br>
<INPUT TYPE=radio name=interval_type value=day> day (s)<br>
<INPUT TYPE=radio name=interval_type value=week> @day_of_week@ (s)
of the week <br>
<INPUT TYPE=radio name=interval_type value=month_by_date> day
@day_of_month@ of the month <br>
<INPUT TYPE=radio name=interval_type value=month_by_day> same @day_of_week@ of
the month <br>
<INPUT TYPE=radio name=interval_type value=year> year<br>
Repeat this event until: <%= [dt_widget_datetime -default [dt_systime] recur_until] %>
<p>
<INPUT TYPE=submit value="Add Recurrence">

</FORM>
