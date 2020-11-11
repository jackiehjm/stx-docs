
.. yrq1552337051689
.. _fault-management-overview:

=========================
Fault Management Overview
=========================

An admin user can view |prod-long| fault management alarms and logs in order
to monitor and respond to fault conditions.

See :ref:`Alarm Messages <100-series-alarm-messages>` for the list of
alarms and :ref:`Customer Log Messages
<200-series-maintenance-customer-log-messages>`
for the list of customer logs reported by |prod|.

You can access active and historical alarms, and customer logs using the CLI,
GUI, REST APIs and :abbr:`SNMP (Simple Network Management Protocol)`.

To use the CLI, see
:ref:`Viewing Active Alarms Using the CLI
<viewing-active-alarms-using-the-cli>`
and :ref:`Viewing the Event Log Using the CLI
<viewing-the-event-log-using-the-cli>`.

Using the GUI, you can obtain fault management information in a number of
places.

.. _fault-management-overview-ul-nqw-hbp-mx:

-   The Fault Management pages, available from
    **Admin** \> **Fault Management** in the left-hand pane, provide access to
    the following:

    -   The Global Alarm Banner in the page header of all screens provides the
        active alarm counts for all alarm severities, see
        :ref:`The Global Alarm Banner <the-global-alarm-banner>`.

    -   **Admin** \> **Fault Management** \> **Active Alarms**—Alarms that are
        currently set, and require user action to clear them. For more
        information about active alarms, see
        :ref:`Viewing Active Alarms Using the CLI
        <viewing-active-alarms-using-the-cli>`
        and :ref:`Deleting an Alarm Using the CLI
        <deleting-an-alarm-using-the-cli>`.

    -   **Admin** \> **Fault Management** \> **Events**—The event log
        consolidates historical alarms that have occurred in the past, that
        is, both set and clear events of active alarms, as well as customer
        logs.

        For more about the event log, which includes historical alarms and
        customer logs, see
        :ref:`Viewing the Event Log Using Horizon
        <viewing-the-event-log-using-horizon>`.

    -   **Admin** \> **Fault Management** \> **Events Suppression**—Individual
        events can be put into a suppressed state or an unsuppressed state. A
        suppressed alarm is excluded from the Active Alarm and Events displays.
        All alarms are unsuppressed by default. An event can be suppressed or
        unsuppressed using the Horizon Web interface, the CLI, or REST APIs.

-   The Data Network Topology view provides real-time alarm information for
    data networks and associated worker hosts and data/pci-passthru/pci-sriov
    interfaces.

.. xreflink For more information, see |datanet-doc|: :ref:`The Data Network Topology View <the-data-network-topology-view>`.

To use SNMP, see :ref:`SNMP Overview <snmp-overview>`.