
.. mzg1592854560344
.. _manual-upgrade-overview:

=======================
Manual Upgrade Overview
=======================

|prod-long| enables you to upgrade the software across your Simplex, Duplex,
Standard, |prod-dc|, and subcloud deployments.

.. note::
    Upgrading |prod-dc| is distinct from upgrading other |prod| configurations.

.. xbooklink    For information on updating |prod-dc|, see |distcloud-doc|: :ref:`Upgrade
    Management <upgrade-management-overview>`.

An upgrade can be performed manually or by the Upgrade Orchestrator which
automates a rolling install of an update across all of the |prod-long| hosts.
This section describes the manual upgrade procedures.

.. xbooklink For the orchestrated
   procedure, see |distcloud-doc|: :ref:`Orchestration Upgrade Overview
   <orchestration-upgrade-overview>`.

Before starting the upgrades process, the system must be “patch current,” there
must be no management-affecting alarms present on the system, the new software
load must be imported, and a valid license file for the upgrade must be
installed.

The upgrade procedure is different for the All-in-One Simplex configuration
versus the All-in-One Duplex, and Standard configurations. For more
information, see:

.. _manual-upgrade-overview-ul-bcp-ght-cmb:

-   :ref:`Upgrading All-in-One Simplex <upgrading-all-in-one-simplex>`

-   :ref:`Upgrading All-in-One Duplex / Standard <upgrading-all-in-one-duplex-or-standard>`
