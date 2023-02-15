
.. pti1579702342696
.. _900-series-alarm-messages:

=========================
900 Series Alarm Messages
=========================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

.. include:: /_includes/x00-series-alarm-messages.rest

.. _900-series-alarm-messages-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.001**
     - Patching operation in progress.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m\*
   * - Proposed Repair Action
     - Complete reboots of affected hosts.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.002**
     - Patch host install failure.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Undo patching operation.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.003**
     - Obsolete patch in system.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - W\*
   * - Proposed Repair Action
     - Remove and delete obsolete patches.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.004**
     - Host version mismatch.
   * - Entity Instance
     - host=<hostname>
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Reinstall host to update applied load.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.005**
     - System Upgrade in progress.
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
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.006**
     - Device image update operation in progress.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m\*
   * - Proposed Repair Action
     - Complete reboots of affected hosts.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.008**
     - Kubernetes rootca update in progress.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m
   * - Proposed Repair Action
     - Wait for kubernetes rootca procedure to complete.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.009**
     - Kubernetes root CA update aborted, certificates may not be fully updated.
   * - Entity Instance
     - host=controller
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - m
   * - Management Affecting Severity:
     - w
   * - Proposed Repair Action
     - Fully update certificates by a new root CA update.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.101**
     - Software patch auto-apply in progress.
   * - Entity Instance
     - orchestration=sw-patch
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Wait for software patch auto-apply to complete; if problem persists
       contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.102**
     - Software patch auto-apply aborting.
   * - Entity Instance
     - orchestration=sw-patch
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Wait for software patch auto-apply abort to complete; if problem
       persists contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.103**
     - Software patch auto-apply failed.
   * - Entity Instance
     - orchestration=sw-patch
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Attempt to apply software patches manually; if problem persists contact
       next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.201**
     - Software upgrade auto-apply in progress.
   * - Entity Instance
     - orchestration=sw-upgrade
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Wait for software upgrade auto-apply to complete; if problem persists
       contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.202**
     - Software upgrade auto-apply aborting.
   * - Entity Instance
     - orchestration=sw-upgrade
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Wait for software upgrade auto-apply abort to complete; if problem
       persists contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.203**
     - Software update auto-apply failed.
   * - Entity Instance
     - orchestration=sw-upgrade
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Attempt to apply software upgrade manually; if problem persists contact
       next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.301**
     - Firmware Update auto-apply in progress.
   * - Entity Instance
     - orchestration=fw-upgrade
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Wait for firmware update auto-apply to complete; if problem persists
       contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.302**
     - Firmware Update auto-apply aborting.
   * - Entity Instance
     - orchestration=fw-upgrade
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Wait for firmware update auto-apply abort to complete; if problem
       persists contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.303**
     - Firmware Update auto-apply failed.
   * - Entity Instance
     - orchestration=fw-upgrade
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Attempt to apply firmware update manually; if problem persists
       contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.501**
     - Kubernetes rootca update auto-apply in progress
   * - Entity Instance
     - orchestration=kube-rootca-update
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Management Affecting Severity:
     - w
   * - Proposed Repair Action
     - Wait for kubernetes rootca update auto-apply to complete; if problem
       persists contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.502**
     - Kubernetes rootca update auto-apply aborting.
   * - Entity Instance
     - orchestration=kube-rootca-update
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - M
   * - Management Affecting Severity:
     - w
   * - Proposed Repair Action
     - Wait for kubernetes rootca update auto-apply abort to complete; if
       problem persists contact next level of support.

-----

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: 900.503**
     - Kubernetes rootca update auto-apply failed.
   * - Entity Instance
     - orchestration=kube-rootca-update
   * - Degrade Affecting Severity:
     - None
   * - Severity:
     - C
   * - Management Affecting Severity:
     - w
   * - Proposed Repair Action
     - Attempt to apply kubernetes rootca update manually; if problem persists
       contact next level of support.