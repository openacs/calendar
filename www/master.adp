<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<h2>@title@</h2>
 <if @context@ not nil>
  <%= [eval ad_context_bar $context] %>
 </if>
<hr>
<slave>
