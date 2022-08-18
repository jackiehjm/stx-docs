
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

An upgrade can be performed manually or using the Upgrade Orchestrator, which
automates a rolling install of an update across all of the |prod-long| hosts.
This section describes the manual upgrade procedures.

.. xbooklink For the orchestrated
   procedure, see |distcloud-doc|: :ref:`Orchestration Upgrade Overview
   <orchestration-upgrade-overview>`.

Before starting the upgrade process, ensure that the following conditions are 
met:

-   The system is patch current.

-   There are no management-affecting alarms and the :command:`system
    health-query-upgrade` check passes.

-   The new software load has been imported.

-   A valid license file has been installed.

The upgrade procedure is different for the All-in-One Simplex configuration
versus the All-in-One Duplex, and Standard configurations. For more
information, see:

.. _manual-upgrade-overview-ul-bcp-ght-cmb:

-   :ref:`Upgrading All-in-One Simplex <upgrading-all-in-one-simplex>`

-   :ref:`Upgrading All-in-One Duplex / Standard <upgrading-all-in-one-duplex-or-standard>`
