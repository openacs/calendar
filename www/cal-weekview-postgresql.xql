<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_weekday_info">      
      <querytext>
      
select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 'D') 
as       day_of_the_week,
         to_char(next_day(to_date(:current_date, 'yyyy-mm-dd')-7, 'SUNDAY'),'YYYY-MM-DD') 
as       sunday_of_the_week,
         to_char(next_day(to_date(:current_date, 'yyyy-mm-dd')+7, 'Saturday'),'YYYY-MM-DD') 
as       saturday_of_the_week
from     dual

      </querytext>
</fullquery>

 
</queryset>
