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
    <td valign=top align=right> 
      <b>Start Time @start_time@</b>
    </td>

    <td valign=top align=left> 
      <%= [dt_widget_datetime -show_date 0 -date_time_sep "<br>"  -default @start_time@ start_time minutes] %>
    </td>
  </tr>

  <tr>
    <td valign=top align=right> 
      <b>End Time</b>
    </td>

    <td valign=top align=left> 
      <%= [dt_widget_datetime -show_date 0 -date_time_sep "<br>"  -default @end_time@  end_time minutes] %>
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

  <if @action@ eq add>
    <tr>
      <if @calendars:rowcount@ eq 0>

      </if>

      <else>

        <td valign=top align=right>
	  <b> Calendar </b>
        </td>
	
	<td valign=top align=left>
	  <select name=calendar_id>	
	    <option value="-1"> Private
            <multiple name=calendars>	    
 	      <option value=@calendars.calendar_id@>@calendars.calendar_name@	  
	    </multiple>
          </select> 
	</td>

      </else>
    </tr>
  </if>


  <tr>
    <td valign=top align=right>
      <if @edit_p@ eq 1>
        <input type=submit>
      </if>
    </td>
    </form>

   <if @delete_p@ eq 1> 
      <if @action@ eq edit or @action@ eq delete>       
        <form action="cal-item-edit" method=post>
          <input type=hidden name=action value=delete>
	  <input type=hidden name=cal_item_id value=@cal_item_id@>
	  <td valign=top align=left>
            <input type=submit value=delete>
          </td>
        </form>
      </if>
   </if>
   </td>
  
  </tr>

  <if @admin_p@ eq 1>	
    <if @action@ eq edit>
      <tr>
        <td colspan=2>
      	  <li> <a href="/calendar/admin/cal-item-permissions?cal_item_id=@cal_item_id@"> 
	         Manage the audience to this calendar item
	       </a>
        </td>
      </tr>
    </if>
  </if>
</table>












