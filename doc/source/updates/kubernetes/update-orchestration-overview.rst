
.. kzb1552920557323
.. _update-orchestration-overview:

=============================
Update Orchestration Overview
=============================

Update orchestration allows an entire |prod| system to be updated with a single
operation.

.. contents:: |minitoc|
   :local:
   :depth: 1

You can configure and run update orchestration using the CLI, the Horizon Web
interface, or the ``stx-nfv`` REST API.

.. note::
    Updating of |prod-dc| is distinct from updating of other |prod|
    configurations. 
    
.. xbooklink    For information on updating |prod-dc|, see |distcloud-doc|:
    :ref:`Update Management for Distributed Cloud
    <update-management-for-distributed-cloud>`.

.. _update-orchestration-overview-section-N10031-N10023-N10001:

---------------------------------
Update Orchestration Requirements
---------------------------------

Update orchestration can only be done on a system that meets the following
conditions:

.. _update-orchestration-overview-ul-e1y-t4c-nx:

-   The system is clear of alarms (with the exception of alarms for locked
    hosts, and update applications in progress).

    .. note::
        When configuring update orchestration, you have the option to ignore
        alarms with a severity less than management-affecting severity. For
        more information, see :ref:`Configuring Update Orchestration
        <configuring-update-orchestration>`.

-   All hosts must be unlocked-enabled-available.

-   Two controller hosts must be available.

-   All storage hosts must be available.

-   When installing reboot required updates, there must be spare worker
    capacity to move hosted application pods off the worker host\(s) being
    updated such that hosted application services are not impacted.

.. _update-orchestration-overview-section-N1009D-N10023-N10001:

--------------------------------
The Update Orchestration Process
--------------------------------

Update orchestration automatically iterates through all hosts on the system and
installs the applied updates to each host: first the controller hosts, then the
storage hosts, and finally the worker hosts. During the worker host updating,
hosted application pod re-locations are managed automatically. The controller
hosts are always updated serially. The storage hosts and worker hosts can be
configured to be updated in parallel in order to reduce the overall update
installation time.

Update orchestration can install one or more applied updates at the same time.
It can also install reboot-required updates or in-service updates or both at
the same time. Update orchestration only locks and unlocks (that is, reboots)
a host to install an update if at least one reboot-required update has been
applied.

You first create an update orchestration strategy, or plan, for the automated
updating procedure. This customizes the update orchestration, using parameters
to specify:

.. _update-orchestration-overview-ul-eyw-fyr-31b:

-   the host types to be updated

-   whether to update hosts serially or in parallel

Based on these parameters, and the state of the hosts, update orchestration
creates a number of stages for the overall update strategy. Each stage
generally consists of re-locating hosted application pods, locking hosts,
installing updates, and unlocking hosts for a subset of the hosts on the
system.

After creating the update orchestration strategy, the user can either apply the
entire strategy automatically, or manually apply individual stages to control
and monitor the update progress.
