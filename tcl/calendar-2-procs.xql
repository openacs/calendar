<?xml version="1.0"?>
<queryset>

<fullquery name="calendar::get_item_types.select_item_types">
<querytext>
select item_type_id, type from cal_item_types
where calendar_id= :calendar_id
</querytext>
</fullquery>

<fullquery name="calendar::item_type_new.insert_item_type">
<querytext>
insert into cal_item_types
(item_type_id, calendar_id, type)
values
(:item_type_id, :calendar_id, :type)
</querytext>
</fullquery>

<fullquery name="calendar::item_type_delete.reset_item_types">
<querytext>
update cal_items
set item_type_id= NULL
where item_type_id = :item_type_id
and on_which_calendar= :calendar_id
</querytext>
</fullquery>
 
<fullquery name="calendar::item_type_delete.delete_item_type">
<querytext>
delete from cal_item_types where item_type_id= :item_type_id
and calendar_id= :calendar_id
</querytext>
</fullquery>

</queryset>