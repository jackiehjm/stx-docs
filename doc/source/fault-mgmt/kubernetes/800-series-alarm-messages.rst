
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

       Possible data loss. Any mds, mon or osd is unavailable in storage
       replication group.
   * - Entity Instance
     - cluster=<dist-fs-uuid>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C/M\*
   * - Proposed Repair Action
     - Check the state of the Ceph cluster with :command:`ceph -s`. If problem
       persists, contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 800.003**
     - Storage Alarm Condition: Quota/Space mismatch for the <tiername> tier.
       The sum of Ceph pool quotas does not match the tier size.
   * - Entity Instance
     - cluster=<dist-fs-uuid>.tier=<tiername>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m
   * - Proposed Repair Action
     - Update Ceph storage pool quotas to use all available tier space.

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
       Check replication group state with :command:`system host-list`. Check if
       OSDs of each storage host are up and running. Check the state of the
       Ceph OSDs with :command:`ceph osd stat` OR :command:`ceph osd tree`. If
       problem persists, contact next level of support.

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
       Check replication group state with :command:`system host-list`. Check if
       OSDs of each storage host are up and running. Check the state of the
       Ceph OSDs with :command:`ceph osd stat` AND/OR :command:`ceph osd tree`.
       If problem persists, contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 800.102**
     - Storage Alarm Condition:

       PV configuration <error/failed to apply\> on <hostname>.
       Reason: <detailed reason\>.
   * - Entity Instance
     - pv=<pv\_uuid>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C/M\*
   * - Proposed Repair Action
     - Remove failed PV and associated Storage Device then recreate them.

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
     - Increase Storage Space Allotment for Cinder on the 'lvm' backend. Try
       the following commands: :command:`vgextend <VG name> <PV name>` or
       :command:`vgextend -L +<size extension> <PV name>`. Check status with
       :command:`vgdisplay`. Consult the System Administration Manual for more
       details. If problem persists, contact next level of support.

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
     - Update backend setting to reapply configuration. Use the following
       commands to try again:
       :command:`system storage-backend-delete <storage-backend-name>` AND
       :command:`system storage-backend-add <storage-backend-name>`.
       Consult the user documentation for more details. If problem persists,
       contact next level of support.
