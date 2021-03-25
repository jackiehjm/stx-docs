
.. rdr1552680506097
.. _snmp-event-table:

================
SNMP Event Table
================

|prod| supports the Event table from the Wind River Alarm MIB via :abbr:`SNMP
(Simple Network Management Protocol)`.

The Event table contains a historic list of all alarm events (SETs and CLEARs)
and customer log events.

Each entry in the table includes the following variables:

.. _snmp-event-table-ul-y1w-4lk-qq:

-   <UUID>

-   <EventID>

-   <State>

-   <EntityInstanceID>

-   <DateAndTime>

-   <EventSeverity>

-   <ReasonText>

-   <EventType>

-   <ProbableCause>

-   <ProposedRepairAction>

-   <ServiceAffecting>

-   <SuppressionAllowed>

An external SNMP Manager can examine the Event table contents by doing an SNMP
Walk of the table.

For example, below is the output for a simple :command:`snmpwalk` CLI tool.

.. code-block:: none

   $ snmpwalk -v2c -c public udp:10.10.10.2:161 WRS-ALARM-MIB::wrsEventTable

    WRS-ALARM-MIB::wrsEventIndex.1 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 1
    WRS-ALARM-MIB::wrsEventIndex.2 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 2
    WRS-ALARM-MIB::wrsEventIndex.3 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 3
    WRS-ALARM-MIB::wrsEventIndex.4 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 4
    WRS-ALARM-MIB::wrsEventIndex.5 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 5
    ...
    WRS-ALARM-MIB::wrsEventUuid.1 = STRING:
    WRS-ALARM-MIB::wrsEventUuid.2 = STRING: a8711827-ca55-420e-bac5-d5ad6598275
    WRS-ALARM-MIB::wrsEventUuid.3 = STRING: a8711827-ca55-420e-bac5-d5ad6598275
    WRS-ALARM-MIB::wrsEventUuid.4 = STRING: a8711827-ca55-420e-bac5-d5ad6598275
    WRS-ALARM-MIB::wrsEventUuid.5 = STRING: a8711827-ca55-420e-bac5-d5ad6598275
    ...
    WRS-ALARM-MIB::wrsEventEventId.1 = STRING: "200.022"
    WRS-ALARM-MIB::wrsEventEventId.2 = STRING: "750.004"
    WRS-ALARM-MIB::wrsEventEventId.3 = STRING: "750.004"
    WRS-ALARM-MIB::wrsEventEventId.4 = STRING: "750.004"
    WRS-ALARM-MIB::wrsEventEventId.5 = STRING: "750.004"
    ...
    WRS-ALARM-MIB::wrsEventState.1 = INTEGER: log(3)
    WRS-ALARM-MIB::wrsEventState.2 = INTEGER: set(1)
    WRS-ALARM-MIB::wrsEventState.3 = INTEGER: clear(0)
    WRS-ALARM-MIB::wrsEventState.4 = INTEGER: set(1)
    WRS-ALARM-MIB::wrsEventState.5 = INTEGER: clear(0)
    ...
    WRS-ALARM-MIB::wrsEventEntityInstanceId.1 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.host=controller-0.status=online
    WRS-ALARM-MIB::wrsEventEntityInstanceId.2 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.k8s_application=nginx-ingress-controller
    WRS-ALARM-MIB::wrsEventEntityInstanceId.3 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.k8s_application=nginx-ingress-controller
    WRS-ALARM-MIB::wrsEventEntityInstanceId.4 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.k8s_application=cert-manager
    WRS-ALARM-MIB::wrsEventEntityInstanceId.5 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.k8s_application=cert-manager
    ...
    WRS-ALARM-MIB::wrsEventDateAndTime.1 = STRING: 2020-11-7,21:31:32.0,+0:0
    WRS-ALARM-MIB::wrsEventDateAndTime.2 = STRING: 2020-11-7,21:34:33.0,+0:0
    WRS-ALARM-MIB::wrsEventDateAndTime.3 = STRING: 2020-11-7,21:41:24.0,+0:0
    WRS-ALARM-MIB::wrsEventDateAndTime.4 = STRING: 2020-11-7,21:41:45.0,+0:0
    WRS-ALARM-MIB::wrsEventDateAndTime.5 = STRING: 2020-11-7,21:43:4.0,+0:0
    ...
    WRS-ALARM-MIB::wrsEventSeverity.1 = INTEGER: not-applicable(0)
    WRS-ALARM-MIB::wrsEventSeverity.2 = INTEGER: warning(1)
    WRS-ALARM-MIB::wrsEventSeverity.3 = INTEGER: warning(1)
    WRS-ALARM-MIB::wrsEventSeverity.4 = INTEGER: warning(1)
    WRS-ALARM-MIB::wrsEventSeverity.5 = INTEGER: warning(1)
    ...
    WRS-ALARM-MIB::wrsEventReasonText.1 = STRING: controller-0 is now 'online'
    WRS-ALARM-MIB::wrsEventReasonText.2 = STRING: Application Apply In Progress
    WRS-ALARM-MIB::wrsEventReasonText.3 = STRING: Application Apply In Progress
    WRS-ALARM-MIB::wrsEventReasonText.4 = STRING: Application Apply In Progress
    WRS-ALARM-MIB::wrsEventReasonText.5 = STRING: Application Apply In Progress
    ...
    WRS-ALARM-MIB::wrsEventEventType.1 = INTEGER: other(0)
    WRS-ALARM-MIB::wrsEventEventType.2 = INTEGER: other(0)
    WRS-ALARM-MIB::wrsEventEventType.3 = INTEGER: other(0)
    WRS-ALARM-MIB::wrsEventEventType.4 = INTEGER: other(0)
    WRS-ALARM-MIB::wrsEventEventType.5 = INTEGER: other(0)
    ...
    WRS-ALARM-MIB::wrsEventProbableCause.1 = INTEGER: not-applicable(0)
    WRS-ALARM-MIB::wrsEventProbableCause.2 = INTEGER: not-applicable(0)
    WRS-ALARM-MIB::wrsEventProbableCause.3 = INTEGER: not-applicable(0)
    WRS-ALARM-MIB::wrsEventProbableCause.4 = INTEGER: not-applicable(0)
    WRS-ALARM-MIB::wrsEventProbableCause.5 = INTEGER: not-applicable(0)
    ...
    WRS-ALARM-MIB::wrsEventProposedRepairAction.1 = STRING:
    WRS-ALARM-MIB::wrsEventProposedRepairAction.2 = STRING: No action required.
    WRS-ALARM-MIB::wrsEventProposedRepairAction.3 = STRING: No action required.
    WRS-ALARM-MIB::wrsEventProposedRepairAction.4 = STRING: No action required.
    WRS-ALARM-MIB::wrsEventProposedRepairAction.5 = STRING: No action required.
    ...
    WRS-ALARM-MIB::wrsEventServiceAffecting.1 = INTEGER: false(0)
    WRS-ALARM-MIB::wrsEventServiceAffecting.2 = INTEGER: true(1)
    WRS-ALARM-MIB::wrsEventServiceAffecting.3 = INTEGER: true(1)
    WRS-ALARM-MIB::wrsEventServiceAffecting.4 = INTEGER: true(1)
    WRS-ALARM-MIB::wrsEventServiceAffecting.5 = INTEGER: true(1)
    ...
    WRS-ALARM-MIB::wrsEventSuppressionAllowed.1 = INTEGER: false(0)
    WRS-ALARM-MIB::wrsEventSuppressionAllowed.2 = INTEGER: false(0)
    WRS-ALARM-MIB::wrsEventSuppressionAllowed.3 = INTEGER: false(0)
    WRS-ALARM-MIB::wrsEventSuppressionAllowed.4 = INTEGER: false(0)
    WRS-ALARM-MIB::wrsEventSuppressionAllowed.5 = INTEGER: false(0)
