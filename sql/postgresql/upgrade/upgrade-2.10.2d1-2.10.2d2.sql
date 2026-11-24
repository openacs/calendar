-- Add the input name to the legacy signature without dropping the function.
do $$
declare
    function_oid oid := to_regprocedure('calendar__delete(integer)');
    definition text;
begin
    select pg_get_functiondef(oid) into definition
      from pg_proc
     where oid = function_oid and proargnames is null;

    if found then
        execute regexp_replace(definition, '([(])integer([)])', '(arg_calendar_id integer)');
    end if;
end;
$$;
