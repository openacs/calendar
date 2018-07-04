
DO $$
BEGIN
   update acs_attributes set
      datatype = 'boolean'
    where object_type = 'calendar'
      and attribute_name = 'private_p';
END$$;
