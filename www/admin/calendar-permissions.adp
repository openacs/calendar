<!--	
	The template for assigning permission to audiences of 
	the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Jan 09, 2000
     	@cvs-id $Id$
-->

<master src="master">
<property name="title">Calendar Administration: @party_name@ </property>
<property name="context_bar"> Calendar Permissions </property>


<if @action@ eq view>
<b> Current Permissions </b>

<if @privileges:rowcount@ eq 0>
  <p>		
    <li>no privilege has been granted
  </p>
</if>

<else>
  <p>
    <multiple name=privileges>	 
      <li>@privileges.privilege@  
	[<a href="calendar-permissions?calendar_id=@calendar_id@&action=revoke&party_id=@party_id@&permission=@privileges.privilege@">            
	  revoke
	 </a>]
    </multiple>
  </p>
</else>
</if>

<if @action@ eq view or @action@ eq add>
<!-- simple UI to grand permission -->
<b> Grant Permissions </b>
<p>
<form action=calendar-permissions method=post>
<input type=hidden name=action value=grant>
<input type=hidden name=calendar_id value=@calendar_id@>

<if @action@ ne add>
  <input type=hidden name=party_id value=@party_id@>
</if>

<table>
  <tr>
    <td>
      <input type=submit value="Grant >>">
    </td>

    <td> 
      <select name=permission>

      <if @calendar_permissions:rowcount@ eq 0>
        <li>no privilege exist. contact your system admin
      </if>
 
      <else>
        <multiple name=calendar_permissions>	 
          <option value=@calendar_permissions.privilege@>@calendar_permissions.privilege@
        </multiple>
      </else>
	
      </select>
    </td>

    <td>
      <if @action@ eq add>
	to
        <if @parties:rowcount@ eq 0>
          <li> no parties exist. contact your system admin
        </if>
     
        <else>
          <select name=party_id>
            <multiple name=parties>
    	      <option value=@parties.party_id@> @parties.pretty_name@
	    </multiple>
          </select>
        </else>
      </if>	
    </td>	
  </tr>
</table>
</form>

</if>










