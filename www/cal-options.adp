<if @calendars:rowcount@ gt 0>
<p>
<ul>
<multiple name="calendars">
<li> @calendars.calendar_name@
<if @calendars.calendar_admin_p@ true>
  <br>
  <font size=-2>[<ahref="@base_url@calendar-item-types?calendar_id=@calendars.calendar_id@">
		  #calendar-portlet.Manage_Item_Types#</a>]</font>
</if>
</multiple>
</ul>
</if>

<p>

