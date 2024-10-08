<master>
<if @ad_form_mode@ eq display>
  <property name="doc(title)">#calendar.Calendar_Edit_Item#</property>
  <property name="context">#calendar.Edit#</property>
</if>
<else>
  <property name="doc(title)">#calendar.Calendar_Add_Item#</property>
  <property name="context">#calendar.Add#</property>
</else>
<property name="focus">cal_item.title</property>

<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    function disableTime(form_name) {
            document.forms[form_name].elements["start_time"].disabled = true;
            document.forms[form_name].elements["end_time"].disabled = true;
    }
    function enableTime(form_name) {
            document.forms[form_name].elements["start_time"].disabled = false;
            document.forms[form_name].elements["end_time"].disabled = false;
    }
</script>

  <div id="viewadp-mini-calendar">
    <include src="mini-calendar" base_url="view" view="@view;literal@" date="@ansi_date;literal@">
    <include src="cal-options">	
  </div>
        
  <div id="viewadp-cal-table">   
    <formtemplate id="cal_item"></formtemplate>
  </div>
