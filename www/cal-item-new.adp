<master>
<property name="title">#calendar.Calendar_Add_Item#</property>
<property name="context">#calendar.Add#</property>
<property name="focus">cal_item.title</property>
<property name="onload">TimePChanged()</property>

<link href="calendar.css" rel="stylesheet" type="text/css">

<script language="JavaScript">
    function TimePChanged() {
      var form_name = "cal_item";
      var element_name = "time_p";

      if (document.forms == null) return;
      if (document.forms[form_name] == null) return;
      if (document.forms[form_name].elements[element_name] == null) return;

      if (document.forms[form_name].elements[element_name][0].checked) {
          document.forms[form_name].elements["start_time.short_hours"].disabled = true;
          document.forms[form_name].elements["start_time.minutes"].disabled = true;
          document.forms[form_name].elements["start_time.ampm"].disabled = true;
          document.forms[form_name].elements["end_time.short_hours"].disabled = true;
          document.forms[form_name].elements["end_time.minutes"].disabled = true;
          document.forms[form_name].elements["end_time.ampm"].disabled = true;
      } else {
          document.forms[form_name].elements["start_time.short_hours"].disabled = false;
          document.forms[form_name].elements["start_time.minutes"].disabled = false;
          document.forms[form_name].elements["start_time.ampm"].disabled = false;
          document.forms[form_name].elements["end_time.short_hours"].disabled = false;
          document.forms[form_name].elements["end_time.minutes"].disabled = false;
          document.forms[form_name].elements["end_time.ampm"].disabled = false;
      }
  }
</script>

<table width="95%">

  <tr>
    <td valign=top width=150>
      <p>
      <include src="mini-calendar" base_url="view" view="day" date="@date@">
      <p>
	<include src="cal-options" calendar_list="@calendar_list@">	
    </td>	

    <td valign=top> 
    <formtemplate id="cal_item"></formtemplate>

    </td>
  </tr>
</table>
</if>

<script language="JavaScript">
  TimePChanged();
</script>

