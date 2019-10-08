ad_library {

    Callback hooks for the calendar package

}

namespace eval calendar {}
namespace eval calendar::item {}

ad_proc -public -callback calendar::item::before_delete {
    {-cal_item_id:required}
} {
    Puts extra logics before calendar item deletion.
} -

ad_proc -public -callback calendar::item::after_edit {
    {-cal_item_id:required}
} {
    Puts extra logics after calendar edit.
} -

