<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master>
<property name="title">Calendar Administration for User # @user_id@</property>
<property name="context">@context_bar@</property>


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
Create a new calendar
</a>
</p>


<p>
<a href="calendar-preferences">
Edit your Calendar Preferences
</a>
</p>




