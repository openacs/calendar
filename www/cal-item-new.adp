<master>
<if @ad_form_mode@ eq display>
  <property name="title">#calendar.Calendar_Edit_Item#</property>
  <property name="context">#calendar.Edit#</property>
  <property name="focus">cal_item.title</property>
</if>
<else>
  <property name="title">#calendar.Calendar_Add_Item#</property>
  <property name="context">#calendar.Add#</property>
  <property name="focus">cal_item.title</property>
</else>
<property name="onload">TimePChanged()</property>
<property name="header_stuff">
  <link href="/resources/calendar/calendar.css" rel="stylesheet" type="text/css">
</property>


<script language="JavaScript">
    function TimePChanged(elm) {
      var form_name = "cal_item";

      if (elm == null) return;
      if (document.forms == null) return;
      if (document.forms[form_name] == null) return;

      if (elm.value == 0) {
          <multiple name="time_format_elms">
            document.forms[form_name].elements["start_time.@time_format_elms.name@"].disabled = true;
            document.forms[form_name].elements["end_time.@time_format_elms.name@"].disabled = true;
          </multiple>
      } else {
          <multiple name="time_format_elms">
            document.forms[form_name].elements["start_time.@time_format_elms.name@"].disabled = false;
            document.forms[form_name].elements["end_time.@time_format_elms.name@"].disabled = false;
          </multiple>
      }
  }
</script>

<table width="95%">

  <tr>
    <td valign=top width=150>
      <p>
      <include src="mini-calendar" base_url="view" view="day" date="@ansi_date@">
      <p>
	<include src="cal-options" calendar_list="@calendar_list;noquote@">	
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

