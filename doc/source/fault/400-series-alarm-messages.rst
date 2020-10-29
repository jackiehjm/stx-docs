
.. ots1579702138430
.. _400-series-alarm-messages:

=========================
400 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: ../_includes/x00-series-alarm-messages.rest

.. _400-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 400.003**
     - License key is not installed; a valid license key is required for
       operation.

       or

       License key has expired or is invalid; a valid license key is required
       for operation.

       or

       Evaluation license key will expire on <date>; there are <num\_days> days
       remaining in this evaluation.

       or

       Evaluation license key will expire on <date>; there is only 1 day
       remaining in this evaluation.
   * - Entity Instance:
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Contact next level of support to obtain a new license key.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 400.003**
     - Communication failure detected with peer over port <linux-ifname>.

       or

       Communication failure detected with peer over port <linux-ifname>
       within the last 30 seconds.
   * - Entity Instance:
     - host=<hostname>.network=<mgmt \| oam \| cluster-host>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.