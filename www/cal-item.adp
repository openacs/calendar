<!--	
	Form for calendar item creation
	Uses widgets from acs_datetime
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->

<if @action@ eq edit or @action@ eq delete>
  <form action="cal-item-edit" method=post>
    <input type=hidden name=cal_item_id value=@cal_item_id@>	
    <input type=hidden name=return_url value=@return_url@>
</if>

<else>
  <if @action@ eq add>
    <form action="cal-item-create" method=post>
    <input type=hidden name=return_url value="@return_url@">
</if>
</else>

<table>
  <tr>
    <td valign=top align=right> 
      <b>Title</b>
    </td>

    <td valign=top align=left> 
      <input type=text size=60 name=name maxlength=60 value="@name@">	
    </td>
  </tr>

  <tr>
    <td valign=top align=right> 
      <b>Date</b>
    </td>

    <td valign=top align=left> 
        <%= [dt_widget_datetime -date_time_sep "<br>" -default @start_date@ event_date days] %>
      </else> 	
    </td>
  </tr>


  <tr>
    <td></td><td valign=top align=left>
      <INPUT CHECKED TYPE=radio name=no_time_p value=0>Use Hours Below &nbsp; &nbsp; <INPUT TYPE=radio name=no_time_p value=1>No Time
    </td>
</tr>
<tr>
    <td valign=top align=right> 
      <b>Start Time</b>
    </td>

    <td valign=top align=left> 
      <%= [dt_widget_datetime -use_am_pm 1 -show_date 0 -date_time_sep "<br>"  -default @start_time@ start_time quarters] %>
    </td>
  </tr>

  <tr>
    <td valign=top align=right> 
      <b>End Time</b>
    </td>

    <td valign=top align=left> 
      <%= [dt_widget_datetime -use_am_pm 1 -show_date 0 -date_time_sep "<br>"  -default @end_time@  end_time quarters] %>
    </td>
  </tr>

  <tr>
    <td valign=top align=right> 
      <b>Description</b>
    </td>

    <td valign=top align=left> 
      <textarea name=description rows=4 cols=60>@description@</textarea>
    </td>
  </tr>

  <if @action@ eq add or @action@ eq edit>
  <if @force_calendar_id@ not nil>
  <tr>
  <td align=right valign=top><b>Item Type</b></td>
  <td valign=top align=left>
  <SELECT name=item_type_id>
  <OPTION VALUE=""> --
<%
foreach one_item_type $cal_item_types {
        set one_item_type_id [lindex $one_item_type 0]
        set one_item_type [lindex $one_item_type 1]

        if {$one_item_type_id == $item_type_id} {
                set selected_html "SELECTED"
        } else {
                set selected_html ""
        }

        template::adp_puts "<OPTION value=$one_item_type_id $selected_html> $one_item_type\n"
}
%>
  </SELECT>
  </td>
  </if>
  </if>

  <if @action@ eq add>
    <tr>
      <if @calendars:rowcount@ eq 0>

      </if>

      <else>

        <td valign=top align=right>
	  <b> Calendar </b>
        </td>
	
	<td valign=top align=left>
          <if @force_calendar_id@ not nil>
          <b>@force_calendar_name@</b>
          <INPUT TYPE=hidden name=calendar_id value=@force_calendar_id@>
          </if>
          <else>
	  <select name=calendar_id>	
	    <option value="-1"> Private
            <multiple name=calendars>	    
 	      <option value=@calendars.calendar_id@>@calendars.calendar_name@	  
	    </multiple>
          </select> 
          </else>
	</td>

      </else>
    </tr>
  </if>

  <if @action@ eq add>
  <tr>
  <td valign=top align=right>
  <b>Repeat?</b>
  </td>
  <td>
  <INPUT TYPE=radio CHECKED name=recurrence_p value=0> No &nbsp; &nbsp; &nbsp;
  <INPUT TYPE=radio name=recurrence_p value=1> Yes
  </td>
  </tr>
  </if>

  <if @action@ eq edit>
  <tr>
  <td valign=top align=right>
  </td>
  <td>
  <if @recurrence_id@ nil>
  This event is a single, non-recurring event
  </if><else>
  This event is recurring. <a href=cal-item-recurrence?cal_item_id=@cal_item_id@>Find out more</a>.
  </else>
  </td>
  </tr>
  </if>

  <tr>
    <td valign=top colspan=2 align=left>
      <if @edit_p@ eq 1>
        <if @action@ eq add>
        <input type=submit value="Add Item <if @force_calendar_id@ not nil>to @force_calendar_name@</if>">
        </if>
        <else>
        <input type=submit value="Edit Item">
        </else>
      </if>

   <if @delete_p@ eq 1> 
      <if @action@ eq edit or @action@ eq delete>       
            <a href=cal-item-edit?action=delete&cal_item_id=@cal_item_id@&return_url=@return_url@>Delete <if @recurrence_id@ not nil>(this instance only)</if></a>
      </if>
   </if>
   </td>
  
  </tr>

  <if @admin_p@ eq 1>	
    <if @action@ eq edit>
      <tr>
        <td colspan=2>
      	  <!-- Commented out by Ben (OpenACS) - this is hardwired and isn't well thought out yet
<li> <a href="/calendar/admin/cal-item-permissions?cal_item_id=@cal_item_id@"> 
      	         Manage the audience to this calendar item
	       </a> -->
        </td>
      </tr>
    </if>
  </if>
</table>

</form>











