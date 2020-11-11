
.. ubf1552680722858
.. _viewing-the-event-log-using-horizon:

================================
View the Event Log Using Horizon
================================

The |prod| Horizon Web interface provides a convenient way to work with
historical alarms, and customer logs.

.. rubric:: |context|

The event log consolidates historical alarms events, that is, the sets and
clears of alarms that have occurred in the past, and customer logs.

Customer logs capture important system events and provide useful information
to the administrator for the purposes of overall fault management. Customer
log events do not have a state and do not typically require administrator
actions, for example, they may be reporting a failed login attempt or the fact
that a container was evacuated to another host.

Customer logs and historical alarms' set and clear actions are held in a
buffer, with older entries discarded as needed to release logging space.

.. rubric:: |proc|

#.  Select **Admin** \> **Fault Management** \> **Events** in the left pane.

    The Events window appears. By default, the Events screen shows all events,
    including both historical set/clear alarms and logs, with the most recent
    events at the top.

#.  Use the filter selections from the search field to select the information
    you want to view.

    Use the **All Events**, **Alarm Events** and **Log Events** filter buttons
    to select all events, only historical alarms set/clear events or only
    customer log events to be displayed. By default, all events are displayed.
    Suppressed events are by default excluded from the table. Suppressed events
    can be included or excluded in the table with the **Show Suppressed and Hide
    Suppressed** filter buttons at the top right of table. The suppression filter
    buttons are only shown when one or more events are suppressed.

    The **Suppression Status** column is only shown in the table when
    **Show Suppressed** filter button is selected.

    .. image:: figures/psa1567524091300.png

    You can sort the entries by clicking on the column titles. For example, to
    sort the view of the entries by severity, click **Severity**; the entries
    are resorted and grouped by severity.

#.  Click the arrow to the left of an event entry in the table for an expanded
    view of event details.