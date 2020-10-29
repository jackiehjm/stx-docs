
.. rdr1552680506097
.. _snmp-event-table:

================
SNMP Event Table
================

|prod| supports SNMP active and historical alarms, and customer logs, in an
event table.

The event table contains historical alarms \(sets and clears\) alarms and
customer logs. It does not contain active alarms. Each entry in the table
includes the following variables:

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

.. note::
    The previous SNMP Historical Alarm Table and the SNMP Customer Log Table
    are still supported but marked as deprecated in the MIB.