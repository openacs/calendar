ad_library {
    Callbacks for the search package.

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

    set combined_content "$cal_item(calendar_name)\n"
    append combined_content [ad_html_text_convert -from text/html -to text/plain -- $cal_item(description)]

    # TODO implement attachments

    return [list object_id $object_id \
                title $cal_item(name) \
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

    return "[ad_url][db_string select_cal_item_package_url {}]cal-item-view?cal_item_id=$object_id"
}

