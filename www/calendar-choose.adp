<master>
<property name="title">#calendar.lt_Calendar_Choose_Calen#</property>
<property name="context">#calendar.Choose#</property>
<property name="header_stuff">
  <link href="/resources/calendar/calendar.css" rel="stylesheet" type="text/css">
</property>

<table width="95%">

  <tr>
    <td valign=top width=150>
      <p>
      <include src="mini-calendar" base_url="view" view="day" date="@date@">
     <p>
	<include src="cal-options" calendar_list="@calendar_list@">	
    </td>	

    <td valign=top> 
    
    <formtemplate id="cals"></formtemplate>

    </td>
  </tr>
</table>
</if>

