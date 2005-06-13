<?xml version="1.0"?>
  <queryset>
  
  <fullquery name="calendar::rename.rename_calendar">
    <querytext>		
	update calendars
	set calendar_name = :calendar_name
	where calendar_id = :calendar_id
    </querytext>
  </fullquery>
  
  <fullquery name="calendar::have_private_p.get_calendar_info">
    <querytext>
	select calendar_id
	from calendars
	where owner_id = :party_id
	and private_p = 't'
    </querytext>
  </fullquery>
  
  <fullquery name="calendar::have_private_p.get_calendar_info_calendar_id_list">
    <querytext>
    	select    calendar_id
	from      calendars
	where     owner_id = :party_id
	and       private_p = 't'
	and       calendar_id in ([join $calendar_id_list ", "])
    </querytext>
  </fullquery>
 
  <fullquery name="calendar::get_item_types.select_item_types">
    <querytext>
	select type, item_type_id from cal_item_types
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

  <fullquery name="calendar::name.get_calendar_name">      
    <querytext>
    select calendar_name
      from    calendars
      where   calendar_id = :calendar_id;
    </querytext>
  </fullquery>

  <fullquery name="calendar::get.select_calendar">      
    <querytext>
	select  calendar_id,
	        calendar_name,
                private_p,
                owner_id,
                package_id
	from    calendars
	where   calendar_id = :calendar_id
    </querytext>
  </fullquery>

  <fullquery name="callback::MergeShowUserInfo::impl::calendar.get_calendars">
    <querytext>	
	select calendar_name
	from calendars
	where owner_id = :user_id
    </querytext>
  </fullquery>	

  <fullquery name="callback::MergePackageUser::impl::calendar.get_from_calendars">
    <querytext>	
	select calendar_id,package_id
	from calendars
	where owner_id = :from_user_id
    </querytext>
  </fullquery>	
  
  <fullquery name="callback::MergePackageUser::impl::calendar.get_repeated_pkgs">
    <querytext>	
      select count(*)
      from calendars
      where owner_id = :to_user_id
      and package_id = :l_pkg_id
    </querytext>
  </fullquery>	

  <fullquery name="callback::MergePackageUser::impl::calendar.calendars_upd">
    <querytext>	
      update calendars
      set owner_id = :to_user_id
      where owner_id = :from_user_id
      and calendar_id = :l_cal_id
    </querytext>
  </fullquery>	

  <fullquery name="callback::MergePackageUser::impl::calendar.gettocalid">
    <querytext>	
      select calendar_id 
      from calendars 
      where package_id = :l_pkg_id 
      and owner_id = :to_user_id
    </querytext>
  </fullquery>	

  <fullquery name="callback::MergePackageUser::impl::calendar.calendar_items_upd">
    <querytext>	
      update cal_items 
      set on_which_calendar = :to_cal_id
      where on_which_calendar = :l_cal_id
    </querytext>
  </fullquery>	

  <fullquery name="callback::MergePackageUser::impl::calendar.del_from_cal">
    <querytext>	
      delete
      from calendars
      where calendar_id = :l_cal_id
    </querytext>
  </fullquery>	
  </queryset>
	