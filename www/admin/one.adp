<!--	
	The template for creating the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Jan 09, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">ArsDigita Calendar Administration@title@ </property>
<property name="context_bar"> @context_bar@ </property>

<if @action@ eq view>
	Calendar detail: listing all the info about the individual calendar
</if>


<if @action@ eq delete>
<table>
<tr>
  <td>
    <include src="calendar_edit">

  </td>
</tr>
</table>
</if>



<if @action@ eq permission>
<table>
<tr>
  <td>
    <p>
      <b> Audiences for calendar: @calendar_name@ </b>
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
          <a href="calendar-permissions?calendar_id=@calendar_id@&party_id=@audiences.party_id@">
            @audiences.name@            
	  </a>
        </multiple>
      </p>
    </else>

    <a href="calendar-permissions?calendar_id=@calendar_id@&action=add">
      Add a new Audience
    </a>	
    
  </td>
</tr>
</table>
</if>



<else>
  <if @action@ eq add>
    <p>

    <b>DEVELOPER NOTE:</b>

    the calendar creation process involves the following steps:

    <ol>
      <li> create the calendar object, and change the default permission if needed
      <li> select groups and/or users who are going to the audiences of the calendar
      <li> apply group, user specific permissions as needed
    </ol>

    </p>

    <form action="calendar-create" method=post>
      <input type=hidden name=party_id value=@party_id@>

  </if>

  <if @action@ eq edit>
    <form action="calendar-edit" method=post>
      <input type=hidden name=calendar_id value=@calendar_id@>
      <input type=hidden name=party_id value=@party_id@>
  </if>

  <table>
		
    <tr>
      <td valign=top align=right>
	<b> Calendar Name </b>
      </td>

      <td valign=top align=left>
	<if @action@ eq edit>
	  <input type=text size=60 name=calendar_name maxlength=200 value="@calendar_name@">     
	</if>
	<else>
	  <if @action@ eq add>
   	    <input type=text size=60 name=calendar_name maxlength=200>     
	  </if>
	</else>
      </td>
    </tr>

    <tr>
      <td valign=top align=right>
	<b> Calendar Permissions </b>
      </td>

      <td valign=top align=left>
	<select name=calendar_permission>
	  <if @action@ eq edit>
	    <option value="@calendar_permission@" selected> @calendar_permission@
	  </if>
	  <option value="private"> private
	  <option value="public"> public
	</select>	
      </td>
    </tr>

    <tr>
      <td colspan=2 valign=top align=left>

	<ul>
	  <li><b>Public:</b> everyone have read permission, and can see the items, registered 
	          and un-reg-ed users alike.
	  <li><b>Private:</b> only those you choose to be the audience of the calendar can see the items.
	</ul>
      </td>	
    </tr>

    <tr>
      <td colspan=2 valign=top align=left>
	<input type=submit>
      </td>		
    </tr>
		
  </table>

  <p>
    <a href="one?calendar_id=@calendar_id@&action=permission"> 
      Manage Calendar Audiences
    </a>
  </p>

</form>
</else>
