<!--	
	The template for user preferences
	

	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->
<master src="master">
<property name="title">Calendar Administration: @party_name@ </property>
<property name="context"> "Calendar Preferences" </property>


<table>

  <tr>
    <td width=400 colspan=2 align=center> 
      <b> Select Calendars </b>
    </td>
  </tr>

  <tr>
    <td width=400 colspan=3 align=left> 
      <b> Note </b> The following is a  list of calendars that is accessible to you. 
      This list will show up on your calendar as an option for you to see events between
      these calendars. You can select which calendar you want to keep on that list.
    </td>
  </tr>

  <if @calendars:rowcount@ eq 0>
    <tr>
      <td colspan=3> 
         No Calendars 
      </td>
    </tr>
  </if>

  <else>


    <form method=post action="calendar-preferences">
      <input type=hidden name=action value=edit>
     	  
      <multiple name=calendars>
           
        <tr>
           <td align=center> 
	     <if @calendars.show_p@ eq f>
               <input type=checkbox name=calendar_hide_list value="@calendars.calendar_id@" checked>
               <input type=hidden name=calendar_old_list value="@calendars.calendar_id@">	
	     </if>
           
             <else>
		 <input type=checkbox name=calendar_hide_list value="@calendars.calendar_id@">
             </else>
          </td>

          <td align=left>             
	    @calendars.calendar_name@ 
          </td>      
        </tr>
      </multiple>

      <tr>
      <td colspan=2>
        <input type=submit value="Hide Checked Calendars">
      </td>	
    </tr>
   </form>

 </else>

</table>































