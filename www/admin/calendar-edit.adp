<!--	
	Template for calendar edit
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Jan 09, 2000
     	@cvs-id $Id$
-->


<if @action@ eq delete>

  <form action="calendar-edit" method=post>
    <input type=hidden name=calendar_id value=@calendar_id@>
    <input type=hidden name=confirm value=yes>
    <p>	
      Are you sure you want to delete this calendar. All the calendar items
      and all the permission that's associated with this calendar will be 
      deleted as well. 
    </p>	

    <input type=submit value="YES, I AM SURE!">	

  </form>
</if>
