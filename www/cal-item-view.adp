<master>
<property name="doc(title)">#calendar.Calendar_Item#: @cal_item.name;literal@</property>
<property name="context">#calendar.Item#</property>
<property name="displayed_object_id">@cal_item_id;literal@</property>


<div id="viewadp-mini-calendar">
  <include src="mini-calendar" base_url="view" view="day" date="@date;literal@">
  <include src="cal-options">
</div>

<h1>#calendar.calendar_event_details#</h1>

<div id="viewadp-cal-table" class="margin-form margin-form-div">
  <div class="form-item-wrapper">
    <div class="form-label">
      <strong>#calendar.Title#</strong>
    </div>
    <div class="form-widget">
      @cal_item.name@
    </div>
  </div>
  <if @cal_item.description@ not nil>
    <div class="form-item-wrapper">
    <div class="form-label">
      <strong>#calendar.Description#:</strong>
    </div>
    <div class="form-widget">
      @cal_item.description;noquote@
    </div>
  </div>
  </if>
  <if @cal_item.related_link_url@ not nil>
    <div class="form-item-wrapper">
      <div class="form-label">
        <strong>#calendar.RelatedLink#:</strong>
      </div>
      <div class="form-widget">
        <a href="@cal_item.related_link_url@" title="@cal_item.related_link_text@">
        <if @cal_item.related_link_text@ nil>
          @cal_item.related_link_url@
        </if><else>
          @cal_item.related_link_text@
        </else>
        </a>
      </div>
    </div>
  </if>
  <div class="form-item-wrapper">
    <div class="form-label">
      <strong>#calendar.Sharing#:</strong>
    </div>
    <div class="form-widget">
      @cal_item.calendar_name@
    </div>
  </div>
  <div class="form-item-wrapper">
    <div class="form-label">
      <strong>#calendar.Date_1#<if @cal_item.no_time_p;literal@ false> #calendar.and_Time#</if>:</strong>
    </div>
    <div class="form-widget">
      <a href="@goto_date_url@" title="#calendar.goto_cal_item_start_date#">@cal_item.pretty_short_start_date@</a>
      <if @cal_item.no_time_p;literal@ false>, #calendar.from# @cal_item.start_time@ #calendar.to# @cal_item.end_time@</if>
    </div>
  </div>

  <if @cal_item.location@ not nil>
    <div class="form-item-wrapper">
      <div class="form-label"><strong>#calendar.Location#:</strong></div>
      <div class="form-widget">
        @cal_item.location@
      </div>
    </div>
  </if>

  <if @cal_item.item_type@ not nil>
    <div class="form-item-wrapper">
      <div class="form-label">
        <strong>#calendar.Type#</strong>
      </div>
      <div class="form-widget">
        @cal_item.item_type@
      </div>
    </div>
  </if>

  <if @cal_item.n_attachments@ gt 0>
    <div class="form-item-wrapper">
      <div class="form-label">
        <strong>#calendar.Attachments#</strong>
      </div>
      <div class="form-widget">
        <ul>
          <multiple name="attachments">
              <li><adp:icon name="paperclip" text="attachment">
                <a href="@attachments.href@"\">@attachments.label@</a>
                &nbsp;[<a href="@attachments.detach_url@">#attachments.remove#</a>]
              </li>
          </multiple>
        </ul>
      </div>
    </div>
  </if>

  <div class="form-button">
    <if @write_p;literal@ true>
      <a href="@cal_item_new_url@" title="#calendar.edit#" class="button">#calendar.edit#</a>
      <a href="@cal_item_delete_url@" title="#calendar.delete#" class="button">#calendar.delete#</a>
        @attachment_options;noquote@
      <a href="ics/@cal_item_id@.ics" title="#calendar.sync_with_Outlook#" class="button">#calendar.sync_with_Outlook#</a>
      <if @cal_item.recurrence_id@ not nil>(<a href="ics/@cal_item_id@.ics?all_occurrences_p=1" title="#calendar.all_events#">#calendar.all_events#</a>)</if>
    </if>
  </div>

</div>
