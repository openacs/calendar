<master src="../master">
<property name="title">Calendar Item Types</property>
<property name="context_bar">@context_bar@</property>

<ul>
<%
foreach item_type $item_types {
        set item_type_id [lindex $item_type 0]
        set type [lindex $item_type 1]

        template::adp_puts "<li> \[ <a href=\"item-type-delete?calendar_id=$calendar_id&item_type_id=$item_type_id\">delete</a> \]  &nbsp; $type\n"
}
%>
<form method=POST action=item-type-new>
<INPUT TYPE=hidden name=calendar_id value=@calendar_id@>
New Type: <INPUT TYPE=text name=type size=40>
<INPUT TYPE=submit value=add>
</FORM>
</ul>
