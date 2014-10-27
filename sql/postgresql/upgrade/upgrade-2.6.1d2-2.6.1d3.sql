
select define_function_args('cal_item__new','cal_item_id;null,on_which_calendar;null,name,description,html_p;null,status_summary;null,timespan_id;null,activity_id;null,recurrence_id;null,object_type;"cal_item",context_id;null,creation_date;now(),creation_user;null,creation_ip;null');
select define_function_args('cal_item__delete','cal_item_id');
select define_function_args('cal_item__delete_all','recurrence_id');
select define_function_args ('calendar__new', 'calendar_id,calendar_name,object_type;calendar,owner_id,private_p,package_id,context_id,creation_date,creation_user,creation_ip');
select define_function_args('calendar__delete','calendar_id');
