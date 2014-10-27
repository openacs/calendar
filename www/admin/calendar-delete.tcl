ad_page_contract {
    Delete calendar
} {
    calendar_id:naturalnum,notnull
}

# We know we have admin privs here

calendar::delete -calendar_id $calendar_id

ad_returnredirect .

