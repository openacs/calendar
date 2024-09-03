-- create a partial index on public calendars
create index if not exists calendars_package_id_pidx on calendars(package_id) where private_p = false;

