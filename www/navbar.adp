<a name="calendar"></a>
<table width="100%" class="topnavbar">
  <tr>
    <td>
      <multiple name="views">
        <span<if @views.selected_p@ true> class="active"</if>>
        <a href="@views.url@" title="view calendar as @views.name@" <if @views.onclick@ ne "">onclick="@views.onclick@"</if>>
        <if @views.icon@ ne "">
          <img src="@views.icon@" class="topnavbar-icon" alt="@views.name@ icon" />
        </if>
        @views.name;noquote@</a></span>@views.spacer;noquote@
      </multiple>
    </td>
  </tr>
</table>
