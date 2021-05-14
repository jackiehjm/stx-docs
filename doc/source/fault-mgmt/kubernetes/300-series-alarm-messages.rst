
.. zwe1579701930425
.. _300-series-alarm-messages:

=========================
300 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the
overall health of the system.

.. include:: ../../_includes/x00-series-alarm-messages.rest

.. _300-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 300.001**
     - 'Data' Port failed.
   * - Entity Instance
     - host=<hostname>.port=<port-uuid>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 300.002**
     - 'Data' Interface degraded.

       or

       'Data' Interface failed.
   * - Entity Instance
     - host=<hostname>.interface=<if-uuid>
   * - Degrade Affecting Severity:
     - Critical
   * - Severity:
     - C/M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.