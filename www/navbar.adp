<a name="calendar"></a>
<table width="100%" class="topnavbar">
  <tr>
    <td>
      <multiple name="views">
        <span<if @views.selected_p;literal@ true> class="active"</if>>
        <a href="@views.url@" title="#calendar.select_views_name#" class="cal-icons @views.text@-view">
        @views.name;noquote@</a></span>@views.spacer;noquote@
      </multiple>
    </td>
  </tr>
</table>

