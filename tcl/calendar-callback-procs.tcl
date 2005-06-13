ad_library {
    Callbacks for site-wide packages.

    @author Dirk Gomez <openacs@dirkgomez.de>
    @creation-date 2005-06-12
    @cvs-id $Id$
}

##################
# Search callbacks
##################


ad_proc -public -callback search::datasource -impl cal_item {} {

    @author openacs@dirkgomez.de
    @creation_date 2005-06-13

    returns a datasource for the search package
    this is the content that will be indexed by the full text
    search engine.

} {
    calendar::item::get -cal_item_id $object_id -array cal_item

    set combined_content $cal_item(calendar_name)
    append combined_content [ad_html_text_convert -from text/html -to text/plain -- $cal_item(description)]

    # TODO implement attachments

    return [list object_id $cal_item_id \
                title $cal_item(title) \
                content $combined_content \
                keywords {} \
                storage_type text \
                mime text/plain ]
}

ad_proc -public -callback search::url -impl cal_item {} {

    @author openacs@dirkgomez.de
    @creation_date 2005-06-13

    returns a url for a calendar item to the search package

} {
    calendar::item::get -cal_item_id $object_id -array cal_item

    return "[ad_url][db_string select_cal_item_package_url {}]cal-item-view?cal_item_id=$cal_item_id"
}

ad_proc -public -callback search::datasource -impl calendar {} {
    Datasource for the FtsContentProvider contract for the calendar object.

    @author Dirk Gomez openacs@dirkgomez.de
    @creation_date 2004-04-01
} {
    if {![db_0or1row datasource {
        select
          calendar_id as object_id,
          calendar_name as title,
          '' as content,
          'text/plain' as mime,
          'text' as storage_type,
          '' as keywords
        from cal_item
        where cal_item_id = :object_id
    } -column_array datasource]} {
        return {object_id {} name {} charter {} mime {} storage_type {}}
    }
    return [array get datasource]
}

ad_proc -public -callback search::url -impl calendar {} {
    url method for the FtsContentProvider contract

    @author Dirk Gomez openacs@dirkgomez.de
    @creation_date 2004-04-01
} {
    return "[ad_url][db_string select_calendar_package_url {}]"
}
