
.. xpx1579702157578
.. _500-series-alarm-messages:

=========================
500 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: ../../_includes/x00-series-alarm-messages.rest

.. _500-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 500.100**
     - TPM initialization failed on host.
   * - Entity Instance
     - tenant=<tenant-uuid>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Proposed Repair Action
     - Reinstall HTTPS certificate; if problem persists contact next level of
       support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 500.101**
     - Developer patch certificate enabled.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Proposed Repair Action
     - Reinstall system to disable developer certificate and remove untrusted
       patches.