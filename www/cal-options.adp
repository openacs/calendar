<!--	
	The template for display a list of calendars that
        the user wants to see.
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->
<if @empty_p@ eq 0>
<table>

  <tr>
    <td colspan=2> 
      <b>Calendar Views:</b>
    </td>
  </tr>

  <if @calendars:rowcount@ eq 0>
    <tr>
      <td colspan=2> 
         No Other Calendars 
      </td>
    </tr>
  </if>

<else>


  <form method=post action="">
    <input type=hidden name=view value=@view@>
    <input type=hidden name=date value=@date@>


  <tr>
    <td>
      <input type=checkbox name=calendar_list value="-1" @private_checked_p@>	
    </td>

    <td>
      <a href="?view=@view@&date=@date@">
        Private
      </a>
    </td>
  </tr>

  <multiple name=calendars>
    <tr>
	<td> 
           <input type=checkbox name=calendar_list value="@calendars.calendar_id@" @calendars.checked_p@>
        </td>

        <td align=left>
           <a href="?view=@view@&date=@date@&calendar_id=@calendars.calendar_id@">
	     @calendars.calendar_name@            
           </a>
        </td>      
    </tr>
  </multiple>

  <tr>
    <td colspan=2>
      <input type=submit value="Toggle Calendars Viewed">
    </td>	
  </tr>
 </form>

</else>

  <tr>
    <td colspan=2>
      <a href="admin" > Manage Your Calendars </a>
    </td>
   </tr>

</table>
</if>
<else>
</else>
