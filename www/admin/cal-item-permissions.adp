<!--	
	template for assigning cal_item permissions
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Jan 14, 2000
     	@cvs-id $Id$
-->

<master src="master">
<property name="title">ArsDigita Calendar Item Administration </property>
<property name="context_bar"> "Calendar Item Permissions" </property>

<if @action@ eq list>
  <table>
    <tr>
       <td>
        <p>
          <b> Audiences for item: @cal_item_name@ </b>
        </p>
	
        <if @audiences:rowcount@ eq 0>
          <p>
            <i>There are no audiences for this calendar
          </p>
        </if>

        <else>
          <p>
            <multiple name=audiences>
	      <li> 
              <a href="cal-item-permissions?cal_item_id=@cal_item_id@&party_id=@audiences.party_id@&action=view">
                @audiences.name@            
	      </a>
            </multiple>
          </p>
        </else>

        <a href="cal-item-permissions?cal_item_id=@cal_item_id@&action=add">
          Add a new Audience
        </a>	
    
      </td>
    </tr>
  </table>

</if>



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
	[<a href="cal-item-permissions?cal_item_id=@cal_item_id@&action=revoke&party_id=@party_id@&permission=@privileges.privilege@">            revoke
	 </a>]
    </multiple>
  </p>
</else>
</if>

<if @action@ eq view or @action@ eq add>
  <!-- simple UI to grand permission -->
  <b> Grant Permissions </b>

  <p>
  <form action=cal-item-permissions method=post>
    <input type=hidden name=action value=edit>
    <input type=hidden name=cal_item_id value=@cal_item_id@>
 
    <if @action@ ne add>
      <input type=hidden name=party_id value=@party_id@>
    </if>

    <table>
      <tr>
        <td>
          <input type=submit value="Grant >>">
        </td>

        <td>
          <if @cal_item_permissions:rowcount@ eq 0>
            <li>no privilege exist. contact your system admin
          </if>

          <else>
            <select name=permission>
              <multiple name=cal_item_permissions>	 
                <option value=@cal_item_permissions.privilege@>@cal_item_permissions.privilege@
              </multiple>
            </select>
          </else>
	
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










