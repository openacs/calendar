<b>@title@</b><p>
<table class="table-display" border=0 cellspacing=0 cellpadding=2>
    <tr class="table-header"><th>Day of Week</th><th><a href="@start_date_url@">Date</a></th><th>Start Time</th><th>End Time</th>

<if @real_sort_by@ ne "item_type">
  <th><a href=@item_type_url@>Type</a></th>
</if>

<th>Title</th></tr>


@return_html;noquote@
</table>

