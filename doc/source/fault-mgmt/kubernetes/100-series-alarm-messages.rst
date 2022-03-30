
.. jsy1579701868527
.. _100-series-alarm-messages:

=========================
100 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: /_includes/x00-series-alarm-messages.rest

.. _100-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.101**
     - Platform CPU threshold exceeded; threshold x%, actual y%.
       CRITICAL @ 95%

       MAJOR @ 90%
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - Critical
   * - Severity:
     - C/M\*
   * - Proposed Repair Action
     - Monitor and if condition persists, contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.103**
     - Memory threshold exceeded; threshold x%, actual y% .

       CRITICAL @ 90%

       MAJOR @ 80%
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - Critical
   * - Severity:
     - C/M
   * - Proposed Repair Action
     - Monitor and if condition persists, contact next level of support; may
       require additional memory on Host.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.104**
     - host=<hostname>.filesystem=<mount-dir>
       File System threshold exceeded; threshold x%, actual y%.

       CRITICAL @ 90%

       MAJOR @ 80%

       OR

       host=<hostname>.volumegroup=<volumegroup-name>
       Monitor and if condition persists, consider adding additional
       physical volumes to the volume group.
   * - Entity Instance
     - host=<hostname>.filesystem=<mount-dir>

       OR

       host=<hostname>.volumegroup=<volumegroup-name>
   * - Degrade Affecting Severity:
     - Critical
   * - Severity:
     - C\*/M
   * - Proposed Repair Action
     - Reduce usage or resize filesystem.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.105**
     - <fs\_name\> filesystem is not added on both controllers and/or does not
       have the same size: <hostname\>.
   * - Entity Instance
     - fs\_name=<image-conversion>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C/M\*
   * - Proposed Repair Action
     - Add image-conversion filesystem on both controllers.

       Consult the System Administration Manual for more details.

       If problem persists, contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.106**
     - 'OAM' Port failed.
   * - Entity Instance
     - host=<hostname>.port=<port-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.107**
     - 'OAM' Interface degraded.

       or

       'OAM' Interface failed.
   * - Entity Instance
     - host=<hostname>.interface=<if-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - C or M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.108**
     - 'MGMT' Port failed.
   * - Entity Instance
     - host=<hostname>.port=<port-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.109**
     - 'MGMT' Interface degraded.

       or

       'MGMT' Interface failed.
   * - Entity Instance
     - host=<hostname>.interface=<if-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - C or M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.110**
     - 'CLUSTER-HOST' Port failed.
   * - Entity Instance
     - host=<hostname>.port=<port-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - C or M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.111**
     - 'CLUSTER-HOST' Interface degraded.

       OR

       'CLUSTER-HOST' Interface failed.
   * - Entity Instance
     - host=<hostname>.interface=<if-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - C or M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.112**
     - 'DATA-VRS' Port down.
   * - Entity Instance
     - host=<hostname>.port=<port-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - M
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.113**
     - 'DATA-VRS' Interface degraded.

       or

       'DATA-VRS' Interface down.
   * - Entity Instance
     - host=<hostname>.interface=<if-name>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - C or M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent
       equipment.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.114**
     - NTP configuration does not contain any valid or reachable NTP servers.
       The alarm is raised regardless of NTP enabled/disabled status.

       NTP address <IP address> is not a valid or a reachable NTP server.

       Connectivity to external PTP Clock Synchronization is lost.
   * - Entity Instance
     - host=<hostname>.ntp

       host=<hostname>.ntp=<IP address>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M or m
   * - Proposed Repair Action
     - Monitor and if condition persists, contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.118**
     - Controller cannot establish connection with remote logging server.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m
   * - Proposed Repair Action
     - Ensure Remote Log Server IP is reachable from Controller through OAM
       interface; otherwise contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 100.119**
     - <hostname> does not support the provisioned PTP mode

       OR

       <hostname> PTP clocking is out-of-tolerance

       OR

       <hostname> is not locked to remote PTP Grand Master

       OR

       <hostname> GNSS signal loss state:<state>

       OR

       <hostname> 1PPS signal loss state:<state>
   * - Entity Instance
     - host=<hostname>.ptp OR host=<hostname>.ptp=no-lock

       OR

       host=<hostname>.ptp=<interface>.unsupported=hardware-timestamping

       OR

       host=<hostname>.ptp=<interface>.unsupported=software-timestamping

       OR

       host=<hostname>.ptp=<interface>.unsupported=legacy-timestamping

       OR

       host=<hostname>.ptp=out-of-tolerance

       OR

       host=<hostname>.instance=<instance>.ptp=out-of-tolerance

       OR

       host=<hostname>.interface=<interface>.ptp=signal-loss
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M or m
   * - Proposed Repair Action
     - Monitor and, if condition persists, contact next level of support.
