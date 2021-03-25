
.. uof1579701912856
.. _200-series-alarm-messages:

=========================
200 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: ../../_includes/x00-series-alarm-messages.rest

.. _200-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.001**
     - <hostname> was administratively locked to take it out-of-service.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - W\*
   * - Proposed Repair Action
     - Administratively unlock Host to bring it back in-service.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.004**
     - <hostname> experienced a service-affecting failure.

       Host is being auto recovered by Reboot.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - If auto-recovery is consistently unable to recover host to the
       unlocked-enabled state contact next level of support or lock and replace
       failing host.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.005**
     - Degrade:

       <hostname> is experiencing an intermittent 'Management Network'
       communication failures that have exceeded its lower alarming threshold.

       Failure:

       <hostname> is experiencing a persistent Critical 'Management Network'
       communication failure.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\* (Degrade) or C\* (Failure)
   * - Proposed Repair Action
     - Check 'Management Network' connectivity and support for multicast
       messaging. If problem consistently occurs after that and Host is reset,
       then contact next level of support or lock and replace failing host.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.006**
     - Main Process Monitor Daemon Failure \(Major\)

       <hostname> 'Process Monitor' \(pmond\) process is not running or
       functioning properly. The system is trying to recover this process.

       Monitored Process Failure \(Critical/Major/Minor\)

       Critical: <hostname> Critical '<processname>' process has failed and
       could not be auto-recovered gracefully. Auto-recovery progression by
       host reboot is required and in progress.

       Major: <hostname> is degraded due to the failure of its '<processname>'
       process. Auto recovery of this Major process is in progress.

       Minor:

       <hostname> '<processname>' process has failed. Auto recovery of this
       Minor process is in progress.

       <hostname> '<processname>' process has failed. Manual recovery is required.

       tp4l/phc2sys process failure. Manual recovery is required.
   * - Entity Instance
     - host=<hostname>.process=<processname>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - C/M/m\*
   * - Proposed Repair Action
     - If this alarm does not automatically clear after some time and continues
       to be asserted after Host is locked and unlocked then contact next level
       of support for root cause analysis and recovery.

       If problem consistently occurs after Host is locked and unlocked then
       contact next level of support for root cause analysis and recovery.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.007**
     - Critical: \(with host degrade\):

       Host is degraded due to a 'Critical' out-of-tolerance reading from the
       '<sensorname>' sensor

       Major: \(with host degrade\)

       Host is degraded due to a 'Major' out-of-tolerance reading from the
       '<sensorname>' sensor

       Minor:

       Host is reporting a 'Minor' out-of-tolerance reading from the
       '<sensorname>' sensor
   * - Entity Instance
     - host=<hostname>.sensor=<sensorname>
   * - Degrade Affecting Severity:
     - Critical
   * - Severity:
     - C/M/m
   * - Proposed Repair Action
     - If problem consistently occurs after Host is power cycled and or reset,
       contact next level of support or lock and replace failing host.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.009**
     - Degrade:

       <hostname> is experiencing an intermittent 'Cluster-host Network'
       communication failures that have exceeded its lower alarming threshold.

       Failure:

       <hostname> is experiencing a persistent Critical 'Cluster-host Network'
       communication failure.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\* (Degrade) or C\* (Critical)
   * - Proposed Repair Action
     - Check 'Cluster-host Network' connectivity and support for multicast
       messaging. If problem consistently occurs after that and Host is reset,
       then contact next level of support or lock and replace failing host.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.010**
     - <hostname> access to board management module has failed.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - W
   * - Proposed Repair Action
     - Check Host's board management configuration and connectivity.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.011**
     - <hostname> experienced a configuration failure during initialization.
       Host is being re-configured by Reboot.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - If auto-recovery is consistently unable to recover host to the
       unlocked-enabled state contact next level of support or lock and
       replace failing host.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.012**
     - <hostname> controller function has in-service failure while compute
       services remain healthy.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Lock and then Unlock host to recover. Avoid using 'Force Lock' action
       as that will impact compute services running on this host. If lock action
       fails then contact next level of support to investigate and recover.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.013**
     - <hostname> compute service of the only available controller is not
       operational. Auto-recovery is disabled. Degrading host instead.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - Major
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Enable second controller and Switch Activity \(Swact\) over to it as
       soon as possible. Then Lock and Unlock host to recover its local compute
       service.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.014**
     - The Hardware Monitor was unable to load, configure and monitor one
       or more hardware sensors.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m
   * - Proposed Repair Action
     - Check Board Management Controller provisioning. Try reprovisioning the
       BMC. If problem persists try power cycling the host and then the entire
       server including the BMC power. If problem persists then contact next
       level of support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 200.015**
     - Unable to read one or more sensor groups from this host's board
       management controller.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Proposed Repair Action
     - Check board management connectivity and try rebooting the board
       management controller. If problem persists contact next level of
       support or lock and replace failing host.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 210.001**
     - System Backup in progress.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m\*
   * - Proposed Repair Action
     - No action required.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 250.001**
     - <hostname> Configuration is out-of-date.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Administratively lock and unlock <hostname> to update config.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 250.003**
     - Kubernetes certificates rotation failed on host <hostname>.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M/w
   * - Proposed Repair Action
     - Rotate kubernetes certificates manually.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 270.001**
     - Host <host\_name> compute services failure\[, reason = <reason\_text>\]
   * - Entity Instance
     - host=<host\_name>.services=compute
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for host services recovery to complete; if problem persists contact
       next level of support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 280.001**
     - <subcloud> is offline.
   * - Entity Instance
     - subcloud=<subcloud>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C\*
   * - Proposed Repair Action
     - Wait for subcloud to become online; if problem persists contact next
       level of support.

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 280.001**
     - <subcloud><resource> sync status is out-of-sync.
   * - Entity Instance
     - \[subcloud=<subcloud>.resource=<compute> \| <network> \| <platform>
       \| <volumev2>\]
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - If problem persists contact next level of support.