<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_weekday_info">      
      <querytext>
      
select   to_char(to_date(:current_date, 'yyyy-mm-dd'), 'D') 
as       day_of_the_week,
         to_char(next_day(to_date(:current_date, 'yyyy-mm-dd')-7, 'SUNDAY')) 
as       sunday_of_the_week,
         to_char(next_day(to_date(:current_date, 'yyyy-mm-dd'), 'Saturday')) 
as       saturday_of_the_week
from     dual

      </querytext>
</fullquery>

 
</queryset>
