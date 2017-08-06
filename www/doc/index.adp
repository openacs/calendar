
<property name="context">{/doc/calendar {Calendar}} {OpenACS Calendar package}</property>
<property name="doc(title)">OpenACS Calendar package</property>
<master>
<h2>OpenACS Calendar package</h2>
<a href="../">OpenACS documentation</a>
<p>The OpenACS calendar package is a web-based calendar package. In
its current form it provides a UI for storing events that have a
time or that last a day, and it offers a list view, a day, week,
and month view.</p>
<p>The project plan for calendar can be found at <a href="http://openacs.org/projects/openacs/packages/calendar/">http://openacs.org/projects/openacs/packages/calendar/</a>.
The maintainer of this package is <a href="mailto:openacs-calendar\@dirkgomez.de">Dirk Gomez</a>
</p>
<h2>The Data Model</h2>
<h3>Permissions</h3>
<p>Calendar uses a lot of custom permissions. Most of them are
unused and will be removed eventually. It will then use a Unix-like
set of read, write, create, admin permissions.</p>
<h3>Calendars</h3>
<p>A calendar has a name and an owner and belongs to a package, it
also is an acs_object. This goes into the table calendars. A
calendar is created via the usual constructor - a "new"
function" - and destroyed via the usual destructor - a
"delete" function.</p>
<p>The calendar package currently uses its own little category
system: calendar item types can be created per package, they are
stored in the table cal_item_types</p>
<p>The table cal_party_prefs allows storing customization
information per calendar and per user. It is completely unused and
I couldn&#39;t find any traces of it ever having been used. A
similar table will be used in a future version of calendar to store
user options though.</p>
<h2>Code Contributors</h2>
<ul>
<li>Ben Adida - partial refactoring of the original OpenACS 4.X
calendar, integration into .LRN</li><li>Gary Jin and W. Scott Meeks from late ArsDigita - original
OpenACS 4.X calendar</li><li>Lars Pind and Paul Doerwald - pair programming during bug
bashes</li><li>Raad Al-Rawi from Cambridge University for calendar.css and a
lot of the layout.</li><li>Lilian Tong and Charles Mok for the original PostgreSQL
port</li>
</ul>
<h2>Change Log</h2>
<h3>HEAD</h3>
<ul>
<li>Notifications</li><li>Removed unused or duplicated code and database queries.</li>
</ul>
<h3>OpenACS 5.0</h3>
<ul>
<li>Separation of html and tcl, noquote</li><li>Proper use of OpenACS permissioning</li><li>A lot of unused code was removed.</li>
</ul>
<h3>Test Cases</h3>
<p>I am planning to use acs-automated-tests for subsequent releases
of calendar, I am collecting the <a href="test-cases">test
cases</a> in this document.</p>
<h3>Old Docs</h3>
<ul><li><a href="requirements">Original Requirements
Document</a></li></ul>
<hr>
<address><a href="mailto:openacs-calendar\@dirkgomez.de">Dirk
Gomez</a></address>
<!-- Created: Mon Aug 13 14:17:34 EDT 2001 --><!-- hhmts start -->Last modified: Wed Oct 26 14:02:57 CEST 2016 
<!-- hhmts end -->