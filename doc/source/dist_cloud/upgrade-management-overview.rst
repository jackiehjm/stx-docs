
.. gjf1592841770001
.. _upgrade-management-overview:

===========================
Upgrade Management Overview
===========================

You can upgrade |prod|'s |prod-dc|'s SystemController, and subclouds with a new
release of |prod| software.

.. rubric:: |context|

.. note::

    Backup all yaml files that are updated using the Redfish Platform
    Management service. For more information, see, :ref:`Installing a Subcloud
    Using Redfish Platform Management Service
    <installing-a-subcloud-using-redfish-platform-management-service>`.

You can use the |CLI| to manage upgrades. The workflow for upgrades is as
follows:


.. _upgrade-management-overview-ol-uqv-p24-3mb:

#.  To upgrade the |prod-dc| system, you must first upgrade the
    SystemController. See, :ref:`Upgrading the SystemController Using the CLI
    <upgrading-the-systemcontroller-using-the-cli>`.

#.  Use |prod-dc| Upgrade Orchestration to upgrade the subclouds. See,
    :ref:`Distributed Upgrade Orchestration Process Using the CLI <distributed-upgrade-orchestration-process-using-the-cli>`.

#.  To handle errors during an orchestrated upgrade, see :ref:`Robust Error
    Handling During An Orchestrated Upgrade
    <robust-error-handling-during-an-orchestrated-upgrade>`.

.. rubric:: |prereq|

The following prerequisites apply to a |prod-dc| upgrade management service.

.. _upgrade-management-overview-ul-smx-y2m-cmb:

-   **Configuration Verification**: Ensure that the following configurations
    are verified before you proceed with the upgrade on the |prod-dc|
    and subclouds:


    -   Run the :command:`system application-list` command to ensure that all
        applications are running

    -   Run the :command:`system host-list` command to list the configured
        hosts

    -   Run the :command:`dcmanager subcloud list` command to list the
        subclouds

    -   Run the :command:`kubectl get pods --all-namespaces` command to test
        that the authentication token validates correctly

    -   Run the :command:`fm alarm-list` command to check the system health to
        ensure that there are no unexpected alarms

    -   Run the :command:`kubectl get host -n deployment` command to ensure all
        nodes in the cluster have reconciled and is set to 'true'

    -   Ensure **controller-0** is the active controller

-   The subclouds must all be |AIO-DX|, and using the Redfish
    platform management service.

-   **Remove Non GA Applications**:


    -   Use the following command to remove the analytics application on the
        subclouds:

        -   :command:`system application-remove wra-analytics`

        -   :command:`system application-delete wra-analytics`


    -   Remove any non-GA applications such as Wind River Analytics, and
        |prefix|-openstack, from the |prod-dc| system, if they exist.

-   **Increase Scratch File System Size**:

    -   Check the size of scratch partition on both the system controller and
        subclouds using the :command:`system host-fs-list` command.

        .. note::
            Increase in scratch filesystem size is also required on each
            subcloud.

    -   All controller nodes and subclouds should have a minimum of 16G scratch
        file system. The process of importing a new load for upgrade will
        temporarily use up to 11G of scratch disk space. Use the :command:`system
        host-fs-modify` command to increase scratch size on **each controller
        node** and subcloud controllers as needed in preparation for software
        upgrade. For example, run the following commands:

        .. code-block:: none

            ~(keystone_admin)]$  system host-fs-modify controller-0 scratch=16

        Run the :command:`fm alarm-list` command to check the system health to
        ensure that there are no unexpected alarms

-   For orchestrated subcloud upgrades the install-values for each subcloud
    that was used for deployment must be saved and restored to the SystemController
    after the SystemController upgrade.

-   Run the :command:`kubectl -n kube-system get secret` command on the
    SystemController before upgrading subclouds, as the docker **rvmc** image on
    orchestrated subcloud upgrade tries to copy the :command:`kube-system
    default-registry-key`.

.. only:: partner

    .. include:: ../_includes/upgrade-management-overview.rest
