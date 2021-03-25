
.. rst1448309104743
.. _rst1448309104743:

========================
SNMP Active Alarms Table
========================

|prod| supports the :abbr:`SNMP (Simple Network Management Protocol)` Active
alarm table from the Wind River Alarm MIB via SNMP.

The active alarm table contains a list of all active or set alarms in the
system. Each entry in the table includes the following variables:

-   <UUID>

-   <AlarmID>

-   <EntityInstanceID>

-   <DateAndTime>

-   <AlarmSeverity>

-   <ReasonText>

-   <EventType>

-   <ProbableCause>

-   <ProposedRepairAction>

-   <ServiceAffecting>

-   <SuppressionAllowed>

An external SNMP Manager can examine the Active Alarm table contents by doing
an SNMP Walk of the table.

For example, below is the output for a simple **snmpwalk** CLI tool showing a
table with three rows (i.e. three active alarms).

.. code-block:: none

   $ snmpwalk -v2c -c public udp:10.10.10.2:161 WRS-ALARM-MIB::wrsAlarmActiveTable

   WRS-ALARM-MIB::wrsAlarmActiveIndex.1 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 1
   WRS-ALARM-MIB::wrsAlarmActiveIndex.2 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 2
   WRS-ALARM-MIB::wrsAlarmActiveIndex.3 = Wrong Type (should be Gauge32 or Unsigned32): INTEGER: 3
   WRS-ALARM-MIB::wrsAlarmActiveUuid.1 = STRING: 742c2d64-df2e-4feb-8607-1ae6de11f15
   WRS-ALARM-MIB::wrsAlarmActiveUuid.2 = STRING: 742c2d64-df2e-4feb-8607-1ae6de11f15
   WRS-ALARM-MIB::wrsAlarmActiveUuid.3 = STRING: 742c2d64-df2e-4feb-8607-1ae6de11f15
   WRS-ALARM-MIB::wrsAlarmActiveAlarmId.1 = STRING: "100.114"
   WRS-ALARM-MIB::wrsAlarmActiveAlarmId.2 = STRING: "100.114"
   WRS-ALARM-MIB::wrsAlarmActiveAlarmId.3 = STRING: "100.114"
   WRS-ALARM-MIB::wrsAlarmActiveEntityInstanceId.1 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.host=controller-0.ntp
   WRS-ALARM-MIB::wrsAlarmActiveEntityInstanceId.2 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.host=controller-0.ntp=162.159.200.123
   WRS-ALARM-MIB::wrsAlarmActiveEntityInstanceId.3 = STRING: system=7dd633ba-96f9-47ef-8531-983e4ca89fa3.host=controller-0.ntp=213.199.225.40
   WRS-ALARM-MIB::wrsAlarmActiveDateAndTime.1 = STRING: 2020-11-11,13:8:4.0,+0:0
   WRS-ALARM-MIB::wrsAlarmActiveDateAndTime.2 = STRING: 2020-11-13,13:13:53.0,+0:0
   WRS-ALARM-MIB::wrsAlarmActiveDateAndTime.3 = STRING: 2020-11-13,13:13:53.0,+0:0
   WRS-ALARM-MIB::wrsAlarmActiveAlarmSeverity.1 = INTEGER: major(3)
   WRS-ALARM-MIB::wrsAlarmActiveAlarmSeverity.2 = INTEGER: minor(2)
   WRS-ALARM-MIB::wrsAlarmActiveAlarmSeverity.3 = INTEGER: minor(2)
   WRS-ALARM-MIB::wrsAlarmActiveReasonText.1 = STRING: NTP configuration does not contain any valid or reachable NTP servers.
   WRS-ALARM-MIB::wrsAlarmActiveReasonText.2 = STRING: NTP address 162.159.200.123 is not a valid or a reachable NTP server.
   WRS-ALARM-MIB::wrsAlarmActiveReasonText.3 = STRING: NTP address 213.199.225.40 is not a valid or a reachable NTP server.
   WRS-ALARM-MIB::wrsAlarmActiveEventType.1 = INTEGER: operationalViolation(7)
   WRS-ALARM-MIB::wrsAlarmActiveEventType.2 = INTEGER: operationalViolation(7)
   WRS-ALARM-MIB::wrsAlarmActiveEventType.3 = INTEGER: operationalViolation(7)
   WRS-ALARM-MIB::wrsAlarmActiveProbableCause.1 = INTEGER: threshold-crossed(50)
   WRS-ALARM-MIB::wrsAlarmActiveProbableCause.2 = INTEGER: threshold-crossed(50)
   WRS-ALARM-MIB::wrsAlarmActiveProbableCause.3 = INTEGER: threshold-crossed(50)
   WRS-ALARM-MIB::wrsAlarmActiveProposedRepairAction.1 = STRING: Monitor and if condition persists, contact next level of support.
   WRS-ALARM-MIB::wrsAlarmActiveProposedRepairAction.2 = STRING: Monitor and if condition persists, contact next level of support.
   WRS-ALARM-MIB::wrsAlarmActiveProposedRepairAction.3 = STRING: Monitor and if condition persists, contact next level of support.
   WRS-ALARM-MIB::wrsAlarmActiveServiceAffecting.1 = INTEGER: false(0)
   WRS-ALARM-MIB::wrsAlarmActiveServiceAffecting.2 = INTEGER: false(0)
   WRS-ALARM-MIB::wrsAlarmActiveServiceAffecting.3 = INTEGER: false(0)
   WRS-ALARM-MIB::wrsAlarmActiveSuppressionAllowed.1 = INTEGER: true(1)
   WRS-ALARM-MIB::wrsAlarmActiveSuppressionAllowed.2 = INTEGER: true(1)
   WRS-ALARM-MIB::wrsAlarmActiveSuppressionAllowed.3 = INTEGER: true(1)
