
.. gjf1592841770001
.. _upgrade-management-overview:

===========================
Upgrade Management Overview
===========================

You can upgrade |prod|'s |prod-dc|'s System Controller, and subclouds with a new
release of |prod| software.

.. rubric:: |context|

.. note::

    Backup all yaml files that are updated using the Redfish Platform
    Management service. For more information, see :ref:`Installing a Subcloud
    Using Redfish Platform Management Service
    <installing-a-subcloud-using-redfish-platform-management-service>`.

You can use the |CLI| to manage upgrades. The workflow for upgrades is as
follows:


.. _upgrade-management-overview-ol-uqv-p24-3mb:

#.  To upgrade the |prod-dc| system, you must first upgrade the
    System Controller. See :ref:`Upgrading the System Controller Using the CLI
    <upgrading-the-systemcontroller-using-the-cli>`.

#.  Use |prod-dc| Upgrade Orchestration to upgrade the subclouds. See
    :ref:`Distributed Upgrade Orchestration Process Using the CLI <distributed-upgrade-orchestration-process-using-the-cli>`.

#.  To handle errors during an orchestrated upgrade, see :ref:`Error
    Handling During An Orchestrated Upgrade
    <robust-error-handling-during-an-orchestrated-upgrade>`.

.. rubric:: |prereq|

For |AIO-SX| deployment configurations, the end user container images in
`registry.local` will be backed up during the upgrade process. This only
includes images other than |prod| system and application images. These images
are limited to 5 GB in total size. If the system contains more than 5 GB of
these images, the upgrade start will fail.

The following prerequisites apply to a |prod-dc| upgrade management service.

.. _upgrade-management-overview-ul-smx-y2m-cmb:

-   **Configuration Verification**: Ensure that the following configurations
    are verified before you proceed with the upgrade on the |prod-dc|
    and subclouds:


    -   Run the :command:`system application-list` command to ensure that all
        applications are running.

    -   Run the :command:`system host-list` command to list the configured
        hosts.

    -   Run the :command:`dcmanager subcloud list` command to list the
        subclouds.

    -   Run the :command:`kubectl get pods --all-namespaces` command to test
        that the authentication token validates correctly.

    -   Run the :command:`fm alarm-list` command to ensure that there are no
        unexpected or management-affecting alarms.
    
    -   Run the :command:`system health-query-upgrade` command to check the
        system health to ensure that the system meets all the upgrade prerequisites.

    -   Run the :command:`kubectl get host -n deployment` command to ensure all
        nodes in the cluster have reconciled and is set to 'true'.

    -   Ensure **controller-0** is the active controller.

-   The |AIO-SX| subclouds must use the Redfish platform management service.

.. only:: partner

    .. include:: /_includes/upgrade-management-overview.rest
