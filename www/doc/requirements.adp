
<property name="context">{/doc/calendar {Calendar}} {Calendar Package Requirements}</property>
<property name="doc(title)">Calendar Package Requirements</property>
<master>
<h2>Calendar Package Requirements</h2>

by <a href="mailto:gjin\@arsdigita.com">Gary Jin</a>
 and <a href="mailto:smeeks\@arsdigita.com">W. Scott Meeks</a>
<h3>I. Introduction</h3>

A calendar is an aggregate of events which fall within a given time
interval, e.g., on a particular day, week, or month. The ArsDigita
Calendar application provides users with a tool which allows them
to add, view, edit and organize these events at both the personal
and party/group levels.
<h3>II. Vision Statement</h3>

The ArsDigita Calendar application is a Web based calendar system
that can be accessed through any browser. The application allows
people to keep track of events as they normally would on a paper
calendar while giving them the opportunity to share these events
with other parties. Various types of additional information related
to a calendar item, such as an URL, a map indicating a
meeting&#39;s location, et cetera, can also be managed through the
Calendar application. The Calendar application also provides
different end-user specifiable presentation formats for viewing
this information. In its current form, the Calendar application can
be integrated with other ACS components, for example, our Intranet
application and our Portals application; eventually the Calendar
application will integrate with yet further systems, for example,
PDAs.
<p>Calendar objects have been designed to allow them to be tied to
particular ACS parties where each party member can see events
associated with that particular party. Events from the various
parties of which one is a member can also be shown on a party
member&#39;s personal calendar.</p>
<p>This package could be used for any application where event
tracking is important. This would include many business,
educational, club, and other community scenarios.</p>
<h3>III. System/Application Overview</h3>

In our system, a <strong>party-specific event</strong>
 is an event
associated with a particular party, typically of the sort scheduled
by that party or of particular interest to members of that party.
For example, a reading group may wish to associate an upcoming book
signing event with their reading group party using the Calendar
application.
<p>A user&#39;s <strong>calendar</strong> is the aggregate of the
party-specific events which are associated with parties of which
the user is a member and which have been specified by this user as
desirable for calendar inclusion. Users will have the option to
suppress the inclusion of all party-specific events for a
particular party of which they wish to remain a member but the
party-specific events of which they do not wish to have appear on
their calendars. Since in our system, groups are parties and
parties can have calendars, this account of a user&#39;s calendar
generalizes to cover a party&#39;s calendar.</p>
<p>The Calendar Package is built on top of the ACS Event service
package and performs the following three high-level functions:</p>
<ul>
<li>Event Management</li><li>Calendar Views</li><li>Navigation</li>
</ul>
<strong>Event Management</strong>
 covers those aspects of the
application which pertain to events, such as adding, editing,
viewing, deleting events, and setting up recurring events. An
<strong>event</strong>
 is defined as an <strong>activity</strong>

associated with one or more time intervals. For instance,
"participating in an ACS bootcamp" is an activity, but
"participating in the ACS bootcamp during the upcoming
week" is an event. Therefore, the Event Management portion
would also needs to deal with scheduling issues associated with
adding a temporal aspect to <strong>activities</strong>
 .
<p>
<strong>Calendar Views</strong> covers those aspects of the
application which pertain to the display of calendar events for a
particular span of time.</p>
<p>
<strong>Navigation</strong> covers those aspects of the
application which pertain to ways in which the end-user can change
the timespan currently being displayed.</p>
<h3>IV. Use-cases and User-scenarios</h3>

There are three main classes of users for the Calendar:
<ul>
<li>Individuals</li><li>Groups and Parties</li><li>Administrators</li>
</ul>

The <strong>individual</strong>
 is primarily interested in having a
personal Web based calendar. The calendar needs to support the
manipulation of basic calendar event components, among these:
times, titles, and possibly descriptions. Example: Irwin Individual
wants to be able to manage his schedule from any Web browser while
travelling abroad. He should, by virtue of belonging to different
parties recognized by the system, be able to visit his calendar to
receive updates on party-specific events for these parties,
retrieve clerical information regarding his upcoming commitments,
and add local events which are specific to his travels.
<p>
<strong>Groups and Parties</strong> can have a collective
calendar that stands apart from the private individual calendar.
This would be useful to display calendar events for the public, for
whom there is no individual calendar. For example, ArsDigita can
display a schedule of upcoming bootcamps, lectures and other
approved events on a calendar on arsdigita.com. A common visitor
does not have to be registered with the site to be able to obtain
this event information through their personal calendar. To allow
this functionality, the calendars for groups and parties would need
to support all the event management and calendar views had by
individual calendars, and in addition, the role of calendar
administrator must be assigned to handle event management.</p>
<p>
<strong>Administrators for</strong> a group and party wide
calendar are given create, read, and write permissions on each
individual item on the calendar. He or she also has the privilege
to change the permissions for each of these items and also
individual&#39;s ability to interact with these items. For example,
the side-wide administrator, Joe Admin, who also has the role of
the calendar administrator realizes that the date on which one of
the ACS bootcamps is scheduled to take place this month is
incorrect. He has the permission to change it. He also can grant
Jane Bootcamp write permission on that particular event, so that
Jane can make changes on her own.</p>
<h3>V. Related Links</h3>
<ul>
<li><a href="http://www.arsdigita.com/doc/calendar/design.html">Design
Document</a></li><li><a href="http://www.arsdigita.com/doc/calendar/index.html">System
Overview</a></li><li><a href="http://6916.lcs.mit.edu/class/6916-f2000/page-7/">MIT&#39;s 6.916
course calendar</a></li><li>
<a href="http://www.imc.org/pdi/">vCalendar/iCalendar</a>
proposed standards</li><li><a href="http://www.arsdigita.com/doc/calendar/acceptance.txt">Acceptance
Tests</a></li><li><a href="http://calendar.yahoo.com/">Yahoo Calendar</a></li><li><a href="http://planner.excite.com/">Excite Planner</a></li>
</ul>
<h3>VI.A Requirements: Private Calendar</h3>
<strong>10 Private Calendar</strong>
<p><strong>10.0 User Interface</strong></p>
<p>
<strong>10.0.10</strong> The calendar page should indicate
whether or not private, public or party-specific events are to be
displayed.</p>
<p>
<strong>10.0.20</strong> The calendar should support navigation
to view different dates in a simple manner.</p>
<p>
<strong>10.0.30</strong> Links to different calendar functions
should be clear and obvious.</p>
<p>
<strong>10.0.40</strong> Each calendar item should be displayed
with its subject and time span as the basic information.</p>
<p><strong>10.10 Views</strong></p>
<p>
<strong>10.10.0</strong> Different views should be easily
selectable.</p>
<p>
<strong>10.10.0</strong> Different views should also be
indicated in a clear and noticeable location</p>
<p><strong>10.10.10 List View</strong></p>
<p>
<strong>10.10.10.10</strong> The calendar should support a view
showing selected items in a tabular list format.</p>
<p>
<strong>10.10.10.20</strong> Columns should include date, time,
and other relevant information.</p>
<p>
<strong>10.10.10.30</strong> The columns should be sortable.</p>
<p>
<strong>10.10.10.40</strong> There should be at least two lists
of items. One list should consist of items whose dates occur within
a user-specified number of days of the currently viewed date. One
list should consist of items that have been added within a
user-specified number of days of the current date.</p>
<p><strong>10.10.20 Day View</strong></p>
<p>
<strong>10.10.20.10</strong> The calendar should support a view
showing all the events for a particular day.</p>
<p>
<strong>10.10.20.20</strong> This view should show the events
arranged chronologically with a time guide along one side.</p>
<p>
<strong>10.10.20.30</strong> The range of the time guide should
be user-specifiable.</p>
<p>
<strong>10.10.20.40</strong> The user should have the option of
compressing the time guide so that only those time intervals upon
which fall selected calendar events are shown.</p>
<p>
<strong>10.10.20.50</strong> Overlapping events should be
displayed in an easy to understand fashion.</p>
<p>
<strong>10.10.20.60</strong> There should be a simple mechanism
for adding events which start at a particular hour.</p>
<p>
<strong>10.10.20.70</strong> The day view should support events
that don&#39;t have a specified start and end time, and the time
guide should include a slot for these items.</p>
<p><strong>10.10.30 Week View</strong></p>
<p>
<strong>10.10.30.10</strong> The calendar should support a view
showing all the events for a particular week.</p>
<p>
<strong>10.10.30.20</strong> The events for a particular day
should be grouped together.</p>
<p>
<strong>10.10.30.30</strong> There should be a simple mechanism
for adding an event for a particular day.</p>
<p>
<strong>10.10.30.40</strong> The currently selected day should
be highlighted or otherwise clearly indicated to the user.</p>
<p>
<strong>10.10.30.50</strong> There should some way to move to
the next and previous week from this particular view.</p>
<p><strong>10.10.40 Month View</strong></p>
<p>
<strong>10.10.40.10</strong> The calendar should support a view
showing all the items for a particular month.</p>
<p>
<strong>10.10.40.20</strong> The events for a particular day
should be grouped together.</p>
<p>
<strong>10.10.40.30</strong> There should be a simple mechanism
for adding an event for a particular day.</p>
<p>
<strong>10.10.40.40</strong> The currently selected day should
be indicated.</p>
<p>
<strong>10.10.40.50</strong> The application should display only
some of the events per day on the month calendar as oppose to every
item.</p>
<p>
<strong>10.10.40.60</strong> There should some way to move to
the next and previous week from this particular view.</p>
<p>
<strong>10.10.40.70</strong> For each day, there should be a
link to the day view for that day.</p>
<p><strong>10.10.50 Year View</strong></p>
<p>
<strong>10.10.50.10</strong> As a navigational mechanism, the
calendar should support a view that shows all months and days in a
particular year but not necessarily with any information on items
for the days displayed.</p>
<p>
<strong>10.10.50.20</strong> For each month, there should be a
link to the month view of that month.</p>
<p>
<strong>10.10.50.30</strong> For each day, there should be a
link to the day view of that day.</p>
<p><strong>10.20 Navigation</strong></p>
<p><strong>10.20.10 Navigation Widget</strong></p>
<p>
<strong>10.20.10.10</strong> The calendar should provide a
widget for collecting together related navigation links. This
should be similar to the widget provided by <a href="http://calendar.yahoo.com/">Yahoo Calendar</a> and <a href="http://planner.excite.com/">Excite Planner</a>.</p>
<p>
<strong>10.20.10.20</strong> Navigation to a different date
should maintain the same view.</p>
<p>
<strong>10.20.10.30</strong> In the list, day, and week views,
the widget should display a mini calendar of the days of the
current month. Each day should be a link except for the currently
viewed day which should not be a link and should be highlighted in
some manner.</p>
<p>
<strong>10.20.10.40</strong> In the month view, the widget
should contain a list of the months of the year. Each month should
be a link except for the month containing the currently viewed day
which should not be a link and should be highlighted in some
manner.</p>
<p>
<strong>10.20.10.50</strong> In the year view, the widget should
contain a short list of years before and after the current year.
Each year should be a link except for the year containing the
currently viewed day which should not be a link and should be
highlighted in some manner.</p>
<p>
<strong>10.20.10.60</strong> The widget should contain some
mechanism for entering an arbitrary date using a clearly defined
format, such as that employed by Yahoo Calendar.</p>
<p>
<strong>10.20.10.70</strong> The widget should clearly display
today&#39;s date along with some mechanism for navigating to that
date.</p>
<p>
<strong>10.20.10.80</strong> In the list, day, and week views
there should be a mechanism for jumping forwards or backwards by a
whole month at a time.</p>
<p>
<strong>10.20.10.90</strong> In the month and year views, there
should be a mechanism for jumping forwards or backwards by a year
at a time.</p>
<p><strong>10.20.20 View Specific Navigation</strong></p>
<p>
<strong>10.20.20.10</strong> Each view except for 'list'
should have some easy mechanism for jumping forward or backward by
the interval being viewed.</p>
<p>
<strong>10.20.20.20</strong> Selecting a day in week, month, or
year view should take you to the day view for the that day.</p>
<p>
<strong>10.20.20.30</strong> Selecting a month in year view
should take you to the month view for that month.</p>
<p><strong>10.30 Adding Events</strong></p>
<p>
<strong>10.30.10</strong> Adding an event should involve
entering information for the event in a form and then submitting
that form. Form should include title, start date and time, or an
explicit indication that the event does not have a start time.
Default values should already be entered with the correct time zone
offset in place. Non-required fields should include end time or
duration, type information, a description, to which party the event
belongs, and an indicator as to whether or not this event
recurs.</p>
<p>
<strong>10.30.20</strong> There should be a simple, clearly
labeled link for adding an event. The date should default to the
currently viewed date and the present time.</p>
<p>
<strong>10.30.30</strong> The time guide in the day view should
have links from each hour and from the slot for items with no start
time.</p>
<p>
<strong>10.30.40</strong> Selecting the 'no start time'
link should bring up the form with the date defaulting to the
currently viewed date and the 'no start time' indicator
set.</p>
<p>
<strong>10.30.50</strong> Selecting a link from a specific hour
should bring up the form with the date defaulting to the currently
viewed date, the start time to the hour selected, and the end time
to one hour later.</p>
<p>
<strong>10.30.60</strong> The week view should have a link for
each day for adding an item.</p>
<p>
<strong>10.30.70</strong> The month view should have a link for
each day for adding an item.</p>
<p>
<strong>10.30.80</strong> As in the Yahoo style calendar, there
should be a 'quick add' box on the side of their calendar
that allows user to add events quickly without having to click
through on different days and different views.</p>
<p><strong>10.40 Viewing Events</strong></p>
<p>
<strong>10.40.10</strong> Selecting an event&#39;s title from
any view should display details for that event, including links to
edit, add attachment, and delete.</p>
<p><strong>10.50 Editing Events</strong></p>
<p>
<strong>10.50.10</strong> While viewing an event, select
'Edit'. You should get a form allowing you to edit the
title, date, times, types, and description for the event.
Non-recurring items should have a "Repeat?" field but not
an "Update?" field. <em>[need to clarify what this
means]</em>
</p>
<p><strong>10.60 Adding Recurring Events</strong></p>
<p>
<strong>10.60.10</strong> If the recurring events indicator is
selected in the form for adding an item, then after submitting that
form, a second form should be presented which summarizes the date
and time of the item and provides fields to set how the item
recurs.</p>
<p>
<strong>10.60.20</strong> The form should include fields to
enter the type of interval, the number of intervals between
recurrences, and any specific information for the selected type of
interval.</p>
<p><strong>10.70 Editing Recurring Events</strong></p>
<p>
<strong>10.70.10</strong> Selecting Edit when viewing a
repeating item should add a field at the bottom of the form to
specify whether any changes should be applied to only the current
instance being edited or to all instances of this recurring
item.</p>
<p><strong>10.80 Adding Attachments to Events</strong></p>
<p>
<strong>10.80.10</strong> When viewing an item, there should be
a link to add an attachment to that item. Selecting that link
should bring up a form to add attachments of various types.</p>
<p>
<strong>10.80.20</strong> The form should include a field for
the title of the attachment.</p>
<p>
<strong>10.80.30</strong> One type of admissible attachment
supported should be an uploaded file. This type should be handled
in the standard ACS manner.</p>
<p>
<strong>10.80.40</strong> One type of admissible attachment
should be a URL.</p>
<p>
<strong>10.80.50</strong> One type of admissible attachment
should be a block of text. The form should provide a text box for
entering the text and a way to indicate if the text is plaintext or
HTML.</p>
<p>
<strong>10.80.60</strong> After adding an attachment of any
sort, the calendar should return to the view of the item which
should have a list of attachments including the attachment just
added.</p>
<p>
<strong>10.80.70</strong> For each attachment listed, there
should be displayed -- when permissions admit -- the title of the
attachment, a link to the content of the attachment, a link to
manage the attachment, and a link to edit it.</p>
<p>
<strong>10.80.80</strong> For a file attachment, the content
link should return the content of the file.</p>
<p>
<strong>10.80.90</strong> For a URL attachment, the content link
should navigate to the URL.</p>
<p>
<strong>10.80.100</strong> For a text attachment, the content
link should display the entered text.</p>
<p>
<strong>10.80.110</strong> The manage link links to the
management page of the corresponding file in the file-storage
system. <em>[file-storage or CR?]</em>
</p>
<p>
<strong>10.80.120</strong> The edit link allows direct editing
of the content of the attachment.</p>
<p><strong>10.90 Inviting other groups to view Events</strong></p>
<p>
<strong>10.90.10</strong> The application should have a link
that lets the owner of the event to invite other groups, individual
or parties to add this event to their personal calendars.</p>
<p><strong>10.100 Deleting events</strong></p>
<p>
<strong>10.100.10</strong> When viewing an item, there should be
a link to delete that item.</p>
<p>
<strong>10.100.20</strong> Selecting the delete link should
bring up a confirmation dialog.</p>
<p>
<strong>10.100.30</strong> If the item is not recurring, then
the choice button will simply be labeled 'OK'.</p>
<p>
<strong>10.100.40</strong> If the item is recurring, then in
addition to the choice buttons, there should be a selection to
indicate either the current instance only or all occurrences.</p>
<p>
<strong>10.100.50</strong> Selecting 'Cancel' should
return to the item view.</p>
<p>
<strong>10.100.60</strong> Selecting 'OK' should delete
the item in question.</p>
<p>
<strong>10.100.70</strong> If the item was recurring and
'all occurrences' had been selected, then all other
occurrences of the item should be deleted as well.</p>
<p>
<strong>10.100.80</strong> Selecting OK should return to the
view where the item was originally selected.</p>
<h3>VI.B Requirements: Party-Specific Events</h3>
<strong>20 Party-Specific Events</strong>
<p>
<strong>20.10</strong> The calendar should display a list of
calendars to which the user has access. At a minimum, this will
include the user&#39;s personal calendar and a public events
calendar. If the user belongs to parties that have party-specific
events associated with them, there should be additional links to
these party-specific events as well as the calendar of the party to
which the user belongs.</p>
<p>
<strong>20.30</strong> On the personal calendar, there should
also be a toggle for each such party that controls whether or not
events from that party appear on the personal calendar.</p>
<p>
<strong>20.40</strong> On a user&#39;s calendar, party-specific
events should indicate to which party they are specific.</p>
<p>
<strong>20.50</strong> The link for adding an event should
clearly indicate whether a party-specific item or a personal item
will be created.</p>
<h3>VI.C Requirements: Managing Party-Specific Events</h3>
<strong>30 Managing Party-Specific Events</strong>
<p>
<strong>30.10</strong> If the user has write permission to any
parties, when he chooses to add an event, the choice of which party
to associate with that event is given.</p>
<p>
<strong>30.20</strong> There should also be a page where
permissions of read, write, approve, and delete can be given to
different parties</p>
<p>
<strong>30.30</strong> There should be a link to the admin page
for the group.</p>
<p>
<strong>30.40</strong> There should be a way to delete the
calendar. This route should involve passing the user through a
confirmation dialog.</p>
<h3>VI.D Requirements: Calendar Administration</h3>
<strong>40 Calendar Administration</strong>
<p><strong>40.10 Calendar User Privilege
Administration</strong></p>
<p>
<strong>40.10.10</strong> Cal Admin must have access to pages
where permissions can be set for different parties</p>
<p>
<strong>40.10.20</strong> Cal Admin can also add new user
party/groups/person to the entire calendar</p>
<p>
<strong>40.10.30</strong> Cal Admin can also add new user
party/groups/person to individual calendar items</p>
<p><strong>40.20 Calendar Items Administration</strong></p>
<p>
<strong>40.20.10</strong> Provides the funcationality to delete,
add, edit any item on the calendar</p>
<p>
<strong>40.20.20</strong> Provides the funcatinality to allow
Calendar Administrator to change the permissions on each calendar
item.</p>
<p>
<strong>40.20.20</strong> Provides the funcatinality to allow
Calendar Administrator to change the default permissions of the
entire calendar<br>
</p>
<h3>VI.E Requirements: API</h3>
<strong>50 API</strong>
<p><strong>50.10 Calendar Events Manipulation</strong></p>
<p>
<strong>50.10.10</strong> Provide a function to add a new item
to a calendar. This function should support specifying all the
values that can be specified in the 'add item' form. It
should allow creating either a user or a party-specific item. Iit
should support specifying a mapping between the new item and an
arbitrary object in the database.</p>
<p><strong>50.20 Calendar Views</strong></p>
<p>
<strong>50.20.10</strong> Provide a function to generate the
HTML for the list view.</p>
<p>
<strong>50.20.20</strong> Provide a function to generate the
HTML for the day view.</p>
<p>
<strong>50.20.30</strong> Provide a function to generate the
HTML for the week view.</p>
<p>
<strong>50.20.40</strong> Provide a function to generate the
HTML for the month view.</p>
<p>
<strong>50.20.50</strong> Provide a function to generate the
HTML for the year view.</p>
<p>
<strong>50.20.60</strong> Provide a function to generate the
HTML for the calendar navigation.</p>
<p>
<strong>50.20.70</strong> Provide a function to generate the
HTML for the complete calendar.</p>
<h3>VII. Revision History</h3>
<table cellspacing="2" cellpadding="2" width="90%" bgcolor="#EFEFEF"><caption>
<br><table>
<tr bgcolor="#E0E0E0">
<th width="10%">Document Revision #</th><th width="50%">Action Taken, Notes</th><th>When?</th><th>By Whom?</th>
</tr><tr>
<td>0.1</td><td>Creation</td><td>2000/10/25</td><td>W. Scott Meeks</td>
</tr><tr>
<td>0.2</td><td>Emendation</td><td>2000/11/10</td><td>Gary Jin</td>
</tr><tr>
<td>0.3</td><td>Edit for Content and Consistency</td><td>2000/11/10</td><td>Joshua Finkler</td>
</tr><tr>
<td>0.4</td><td>Additional revisions and included cX-Mozilla-Status:
0009eview</td><td>2000/11/30</td><td>Gary Jin</td>
</tr><tr>
<td>0.5</td><td>Further Revisions</td><td>2000/12/02</td><td>Joshua Finkler</td>
</tr><tr>
<td>0.6</td><td>Revisions of User Cases and Scenario sections and applied
corrections.</td><td>2000/12/04</td><td>Gary Jin</td>
</tr><tr>
<td>0.7</td><td>Further Revisions</td><td>2000/12/06</td><td>Joshua Finkler and Gary Jin</td>
</tr>
</table><hr><address>
<a href="mailto:gjin\@arsdigita.com">gjin\@arsdigita.com</a>
and <a href="mailto:smeeks\@arsdigita.com">smeeks\@arsdigita.com</a>
</address>
</caption></table>
