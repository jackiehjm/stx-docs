
.. bla1593031188931
.. _orchestration-upgrade-overview:

==============================
Upgrade Orchestration Overview
==============================

Upgrade Orchestration automates much of the upgrade procedure, leaving a few
manual steps for operator oversight.

.. contents:: |minitoc|
   :local:
   :depth: 1

.. note::
    Upgrading of |prod-dc| is distinct from upgrading other |prod|
    configurations.
    
.. xbooklink    For information on updating |prod-dc|, see |distcloud-doc|:
    :ref:`Upgrade Management <upgrade-management-overview>`.

.. note::

    The upgrade orchestration commands are prefixed with :command:`sw-manager`.
    To use upgrade orchestration commands, you need administrator privileges.
    You must log in to the active controller as user **sysadmin** and source the
    ``/etc/platform/openrc`` script to obtain administrator privileges. Do not use
    :command:`sudo`.

.. code-block:: none

    ~(keystone_admin)]$ sw-manager upgrade-strategy --help
    usage: sw-manager upgrade-strategy [-h]  ...
    
    optional arguments:
      -h, --help  show this help message and exit
    
    Software Upgrade Commands:
      
        create    Create a strategy
        delete    Delete a strategy
        apply     Apply a strategy
        abort     Abort a strategy
        show      Show a strategy

.. _orchestration-upgrade-overview-section-N10029-N10026-N10001:

----------------------------------
Upgrade Orchestration Requirements
----------------------------------

Upgrade orchestration can only be done on a system that meets the following
conditions:

.. _orchestration-upgrade-overview-ul-blp-gcx-ry:

-   The system is clear of alarms (with the exception of the alarm upgrade in
    progress).

-   All hosts must be unlocked, enabled, and available.

-   The system is fully redundant (two controller nodes available, at least
    one complete storage replication group available for systems with Ceph
    backend).

-   An upgrade has been started, and controller-1 has been upgraded and is
    active.

-   No orchestration strategy exists. Patch, upgrade, firmware, kubernetes,
    and kube rootca are all types of orchestration. An upgrade cannot be
    orchestrated while another orchestration is in progress.

-   Sufficient free capacity or unused worker resources must be available
    across the cluster. A rough calculation is: 
    
    ``Required spare capacity ( %) = (<Number-of-hosts-to-upgrade-in-parallel> / <total-number-of-hosts>) * 100``

.. _orchestration-upgrade-overview-section-N10081-N10026-N10001:

---------------------------------
The Upgrade Orchestration Process
---------------------------------

Upgrade orchestration can be initiated after the initial controller host has
been manual upgraded and returned to a stability state. Upgrade orchestration
automatically iterates through the remaining hosts, installing the new software
load on each one: first the other controller host, then the storage hosts, and
finally the worker hosts. During worker host upgrades, pods are automatically
moved to alternate worker hosts.

You first create an upgrade orchestration strategy, or plan, for the automated
upgrade procedure. This customizes the upgrade orchestration, using parameters
to specify:

.. _orchestration-upgrade-overview-ul-eyw-fyr-31b:

-   the host types to be upgraded

-   whether to upgrade hosts serially or in parallel

Based on these parameters, and the state of the hosts, upgrade orchestration
creates a number of stages for the overall upgrade strategy. Each stage
generally consists of moving pods, locking hosts, installing upgrades, and
unlocking hosts for a subset of the hosts on the system.

After creating the upgrade orchestration strategy, the you can either apply the
entire strategy automatically, or apply individual stages to control and monitor
their progress manually.

Update and upgrade orchestration are mutually exclusive; they perform
conflicting operations. Only a single strategy (sw-patch or sw-upgrade) is
allowed to exist at a time. If you need to update during an upgrade, you can
abort/delete the sw-upgrade strategy, and then create and apply a sw-patch
strategy before going back to the upgrade.

Some stages of the upgrade could take a significant amount of time (hours).
For example, after upgrading a storage host, re-syncing the OSD data could take
30 minutes per TB (assuming 500MB/s sync rate, which is about half of a 10G
infrastructure link).

.. _orchestration-upgrade-overview-section-N10101-N10026-N10001:

------------------------------
Upgrade Orchestration Workflow
------------------------------

The Upgrade Orchestration procedure has several major parts:

.. _orchestration-upgrade-overview-ul-r1k-wzj-wy:

-   Manually upgrade controller-1.

-   Orchestrate the automatic upgrade of the remaining controller, all the
    storage nodes, and all the worker nodes.

-   Manually complete the upgrade.
