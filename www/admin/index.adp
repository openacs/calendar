<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">ArsDigita Calendar Administration for User # @user_id@</property>
<property name="context_bar">@context_bar@</property>


<p>
Your are in the following group: <br>
@data@
</p>

<if @calendars:rowcount@ eq 0>
  <p>
    <i>You have no party wide calendars</i>
  </p>
</if>

<else>
  <p>
  You can manage the following calendars
  <table>
   <multiple name=calendars>
     <tr>
	<td valign=top>
	  <li>[<a href="one?calendar_id=@calendars.calendar_id@&action=edit"> 
             @calendars.calendar_name@ 
           </a>]          	
	</td>
     </tr>	
   </multiple>
  </table>
  </p>
</else>

<p>
<a href="one?party_id=@user_id@&action=add">
create a new calendar
</a>
</p>


<p>
<a href="one?party_id=@user_id@&action=add">
Edit your Calendar Preferences
</a>
</p>




