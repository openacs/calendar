<if @calendars:rowcount@ gt 0>
<p>
#calendar.Calendars#:
<ul>
<multiple name="calendars">
<li> @calendars.calendar_name@
<if @calendars.calendar_admin_p@ true>
  [<a href="@base_url@calendar-item-types?calendar_id=@calendars.calendar_id@" title="#calendar.Manage_Item_Types#">#calendar.Manage_Item_Types#</a>]
</if>
</multiple>
</ul>
</if>

<p>

