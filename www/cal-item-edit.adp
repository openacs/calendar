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

<link href="calendar.css" rel="stylesheet" type="text/css">

<table width="95%">

  <tr>
    <td valign=top width=150>
      <p>
      <include src="mini-calendar" base_url="view" view="day" date="@date@">ROEDEL
      <p>
	<include src="cal-options" calendar_list="@calendar_list@">	
    </td>	

    <td valign=top> 
    
    <formtemplate id="cal_item"></formtemplate>

    </td>
  </tr>
</table>
</if>
