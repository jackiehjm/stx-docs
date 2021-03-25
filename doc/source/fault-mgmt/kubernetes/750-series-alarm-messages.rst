
.. cta1579702173704
.. _750-series-alarm-messages:

=========================
750 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: ../../_includes/x00-series-alarm-messages.rest

.. _750-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 750.001**
     - Application upload failure.
   * - Entity Instance
     - k8s\_application=<appname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - W
   * - Proposed Repair Action
     - Check the system inventory log for the cause.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 750.002**
     - Application apply failure.
   * - Entity Instance
     - k8s\_application=<appname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Proposed Repair Action
     - Retry applying the application. If the issue persists, please check the
       system inventory log for cause.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 750.003**
     - Application remove failure.
   * - Entity Instance
     - k8s\_application=<appname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Proposed Repair Action
     - Retry removing the application. If the issue persists, please the check
       system inventory log for cause.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 750.004**
     - Application apply in progress.
   * - Entity Instance
     - k8s\_application=<appname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - W
   * - Proposed Repair Action
     - No action is required.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 750.005**
     - Application update in progress.
   * - Entity Instance
     - k8s\_application=<appname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - W
   * - Proposed Repair Action
     - No action is required.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 750.006**
     - Automatic application re-apply is pending.
   * - Entity Instance
     - k8s\_application=<appname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - W
   * - Proposed Repair Action
     - Ensure all hosts are either locked or unlocked. When the system is
       stable the application will automatically be reapplied.