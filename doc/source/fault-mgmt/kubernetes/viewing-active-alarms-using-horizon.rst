
.. sqv1552680735693
.. _viewing-active-alarms-using-horizon:

================================
View Active Alarms Using Horizon
================================

The |prod| Horizon Web interface provides a page for viewing active alarms.

Alarms are fault conditions that have a state; they are set and cleared by the
system as a result of monitoring and detecting a change in a fault condition.
Active alarms are alarms that are in the set condition. Active alarms typically
require user action to be cleared, for example, replacing a faulty cable, or
removing files from a nearly full filesystem, etc.

.. note::
    For data networks and worker host data interfaces, you can also use the
    Data Network Topology view to monitor active alarms.

.. xreflink For more information, see |datanet-doc|: :ref:`The Data Network Topology View <the-data-network-topology-view>`.

.. rubric:: |proc|

.. _viewing-active-alarms-using-horizon-steps-n43-ssf-pkb:

#.  Select **Admin** \> **Fault Management** \> **Active Alarms** in the left pane.

    The currently Active Alarms are displayed in a table, by default sorted by
    severity with the most critical alarms at the top. A color-coded summary
    count of active alarms is shown at the top of the active alarm tab as well.

    You can change the sorting of entries by clicking on the column titles.
    For example, to sort the table by timestamp severity, click
    **Timestamp**. The entries are re-sorted by timestamp.

    Suppressed alarms are excluded by default from the table. Suppressed alarms
    can be included or excluded in the table with the **Show Suppressed** and
    **Hide Suppressed** filter buttons at the top right of the table. The
    suppression filter buttons are only shown when one or more alarms are
    suppressed.

    The **Suppression Status** column is only shown in the table when the
    **Show Suppressed** filter button is selected.

#.  Click the Alarm ID of an alarm entry in the table to display the details
    of the alarm.