<!--	
	The template for display a list of calendars that
        the user wants to see.
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->

<if @calendars:rowcount@ gt 1>
<ul>
<multiple name="calendars">
<li> @calendars.calendar_name@
</multiple>
</ul>
</if>
