<!--	
	Displays the basic UI for the calendar
	
	@author Gary Jin (gjin@arsidigta.com)
     	@creation-date Dec 14, 2000
     	@cvs-id $Id$
-->


<master src="master">
<property name="title">Calendar for @name@</property>
<property name="context_bar"></property>

<table>

  <tr>
    <td valign=top>
      <p>
	<include src="cal-nav">
      <p>
	<include src="cal-options">	
    </td>	

    <td valign=top> 

      <if @action@ eq add or @action@ eq edit>
        <include src="cal-item">  
      </if>
	
      <else>	
        <if @view@ eq list>
          <include src="cal-listview">
        </if>

        <if @view@ eq day>
          <include src="cal-dayview">
        </if>

        <if @view@ eq month>
          <include src="cal-monthview">
        </if>	

        <if @view@ eq week>
          <include src="cal-weekview">
        </if>	
      </else>
    </td>
  </tr>
</table>
</if>
