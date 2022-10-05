
.. rww1579702317136
.. _800-series-alarm-messages:

=========================
800 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: /_includes/x00-series-alarm-messages.rest

.. _800-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 800.001**
     - Storage Alarm Condition:

       1 mons down, quorum 1,2 controller-1,storage-0
   * - Entity Instance
     - cluster=<dist-fs-uuid>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C/M\*
   * - Proposed Repair Action
     - If problem persists, contact next level of support.


-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 800.010**
     - Potential data loss. No available OSDs in storage replication group.
   * - Entity Instance
     - cluster=<dist-fs-uuid>.peergroup=<group-x>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Ensure storage hosts from replication group are unlocked and available.
       Check if OSDs of each storage host are up and running. If problem
       persists contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 800.011**
     - Loss of replication in peergroup.
   * - Entity Instance
     - cluster=<dist-fs-uuid>.peergroup=<group-x>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Ensure storage hosts from replication group are unlocked and available.
       Check if OSDs of each storage host are up and running. If problem
       persists contact next level of support.


-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 800.103**
     - Storage Alarm Condition:

       \[ Metadata usage for LVM thin pool <VG name>/<Pool name> exceeded
       threshold and automatic extension failed.

       Metadata usage for LVM thin pool <VG name>/<Pool name> exceeded
       threshold \]; threshold x%, actual y%.
   * - Entity Instance
     -  <hostname>.lvmthinpool=<VG name>/<Pool name>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Increase Storage Space Allotment for Cinder on the 'lvm' backend.
       Consult the user documentation for more details. If problem persists,
       contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 800.104**
     - Storage Alarm Condition:

       <storage-backend-name> configuration failed to apply on host: <host-uuid>.
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Update backend setting to reapply configuration. Consult the user
       documentation for more details. If problem persists, contact next level
       of support.