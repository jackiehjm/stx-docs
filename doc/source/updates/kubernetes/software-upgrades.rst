
.. upe1593016272562
.. _software-upgrades:

=================
Software Upgrades
=================

|prod-long| upgrades enable you to move |prod| software from one release of
|prod| to the next release of |prod|.

.. contents:: |minitoc|
   :local:
   :depth: 1

|prod| software upgrade is a multi-step rolling-upgrade process, where |prod|
hosts are upgraded one at time while continuing to provide its hosting services
to its hosted applications. An upgrade can be performed manually or using
Upgrade Orchestration, which automates much of the upgrade procedure, leaving a
few manual steps to prevent operator oversight. For more information on manual
upgrades, see :ref:`Manual PLatform Components Upgrade
<manual-upgrade-overview>`. For more information on upgrade orchestration, see
:ref:`Orchestrated Platform Component Upgrade
<orchestration-upgrade-overview>`.

.. warning::
    Do NOT use information in the |updates-doc| guide for |prod-dc|
    orchestrated software upgrades. If information in this document is used for
    a |prod-dc| orchestrated upgrade, the upgrade will fail resulting
    in an outage. The |prod-dc| Upgrade Orchestrator automates a
    recursive rolling upgrade of all subclouds and all hosts within the
    subclouds.

.. xbooklink    For more information on the |prod-dc| Upgrade Orchestrator, see,
    |distcloud-doc|: :ref:`Upgrade Orchestration for Distributed Cloud
    Subclouds Using CLI
    <upgrade-orchestration-for-distributed-cloud-subclouds-using-the-cli>`.

Before starting the upgrades process:

.. _software-upgrades-ul-ant-vgq-gmb:

-   the system must be “patch current”

-   there must be no management-affecting alarms present on the system

-   the new software load must be imported, and

-   a valid license file for the new software release must be installed

The upgrade process starts by upgrading the controllers. The standby controller
is upgraded first and involves loading the standby controller with the new
release of software and migrating all the controller services' databases for
the new release of software. Activity is switched to the upgraded controller,
running in a 'compatibility' mode where all inter-node messages are using
message formats from the old release of software. Before upgrading the second
controller, is the "point-of-no-return for an in-service abort" of the upgrades
process. The second controller is loaded with the new release of software and
becomes the new Standby controller. For more information on manual upgrades,
see :ref:`Manual Platform Components Upgrade <manual-upgrade-overview>` .

If present, storage nodes are locked, upgraded and unlocked one at a time in
order to respect the redundancy model of |prod| storage nodes. Storage nodes
can be upgraded in parallel if using upgrade orchestration.

Upgrade of worker nodes is the next step in the process. When locking a worker
node the node is tainted, such that Kubernetes shuts down any pods on this
worker node and restarts the pods on another worker node. When upgrading the
worker node, the worker node network boots/installs the new software from the
active controller. After unlocking the worker node, the worker services are
running in a 'compatibility' mode where all inter-node messages are using
message formats from the old release of software. Note that the worker nodes
can only be upgraded in parallel if using upgrade orchestration.

The final step of the upgrade process is to activate and complete the upgrade.
This involves disabling 'compatibility' modes on all hosts and clearing the
Upgrade Alarm.

.. _software-upgrades-section-N1002F-N1001F-N10001:

----------------------------------
Rolling Back / Aborting an Upgrade
----------------------------------

In general, any issues encountered during an upgrade should be addressed during
the upgrade with the intention of completing the upgrade after the issues are
resolved. Issues specific to a storage or worker host can be addressed by
temporarily downgrading the host, addressing the issues and then upgrading the
host again, or in some cases by replacing the node.

In extremely rare cases, it may be necessary to abort an upgrade. This is a
last resort and should only be done if there is no other way to address the
issue within the context of the upgrade. There are two cases for doing such an
abort:

.. _software-upgrades-ul-dqp-brt-cx:

-   Before controller-0 has been upgraded \(that is, only controller-1 has been
    upgraded\): In this case the upgrade can be aborted and the system will
    remain in service during the abort, see, :ref:`Rolling Back a Software
    Upgrade Before the Second Controller Upgrade
    <rolling-back-a-software-upgrade-before-the-second-controller-upgrade>`.

-   After controller-0 has been upgraded \(that is, both controllers have been
    upgraded\): In this case the upgrade can only be aborted with a complete
    outage and a reinstall of all hosts. This would only be done as a last
    resort, if there was absolutely no other way to recover the system, see,
    :ref:`Rolling Back a Software Upgrade After the Second Controller Upgrade
    <rolling-back-a-software-upgrade-after-the-second-controller-upgrade>`.
