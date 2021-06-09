=================
Distributed Cloud
=================

------------
Introduction
------------

.. toctree::
    :maxdepth: 1
    :caption: Contents:

    overview-of-distributed-cloud
    distributed-cloud-architecture
    shared-configurations
    regionone-and-systemcontroller-modes
    alarms-management-for-distributed-cloud

------------
Installation
------------

.. toctree::
    :maxdepth: 1
    :caption: Contents:

    installing-and-provisioning-the-central-cloud
    installing-and-provisioning-a-subcloud
    installing-a-subcloud-using-redfish-platform-management-service
    installing-a-subcloud-without-redfish-platform-management-service
    reinstalling-a-subcloud-with-redfish-platform-management-service

---------
Operation
---------

.. toctree::
    :maxdepth: 1
    :caption: Contents:

    monitoring-subclouds-using-horizon
    managing-subclouds-using-the-cli
    switching-to-a-subcloud-from-the-system-controller
    synchronization-monitoring-and-control
    cli-commands-for-dc-alarms-management
    managing-subcloud-groups
    creating-subcloud-groups
    ochestration-strategy-using-subcloud-groups
    managing-ldap-linux-user-accounts-on-the-system-controller
    changing-the-admin-password-on-distributed-cloud
    updating-docker-registry-credentials-on-a-subcloud
    migrate-an-aiosx-subcloud-to-an-aiodx-subcloud
    restoring-subclouds-from-backupdata-using-dcmanager
    rehoming-a-subcloud

----------------------
Manage Subcloud Groups
----------------------

.. toctree::
    :maxdepth: 1
    :caption: Contents:

    managing-subcloud-groups
    creating-subcloud-groups
    ochestration-strategy-using-subcloud-groups

-------------------------
Update (Patch) management
-------------------------

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   update-management-for-distributed-cloud
   reviewing-update-status-for-distributed-cloud-using-horizon
   reviewing-update-status-for-distributed-cloud-using-the-cli
   uploading-and-applying-updates-to-systemcontroller-using-horizon
   uploading-and-applying-updates-to-systemcontroller-using-the-cli

***************************************************************
Update orchestration of Central Cloud's RegionOne and subclouds
***************************************************************

.. toctree::
   :maxdepth: 1

   update-orchestration-of-central-clouds-regionone-and-subclouds
   creating-an-update-strategy-for-distributed-cloud-update-orchestration
   customizing-the-update-configuration-for-distributed-cloud-update-orchestration
   applying-the-update-strategy-for-distributed-cloud

.. toctree::
   :maxdepth: 1

   update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli

-----------------------------------
FPGA device image update management
-----------------------------------

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   device-image-update-orchestration

----------------------------------------------------------
Kubernetes Version Upgrade Distributed Cloud Orchestration
----------------------------------------------------------

.. toctree::
    :maxdepth: 1
    :caption: Contents:

    the-kubernetes-distributed-cloud-update-orchestration-process
    configuring-kubernetes-update-orchestration-on-distributed-cloud

------------------
Upgrade management
------------------

.. toctree::
    :maxdepth: 1
    :caption: Contents:

    upgrade-management-overview
    upgrading-the-systemcontroller-using-the-cli

*******************************************************************
Upgrade Orchestration for Distributed Cloud SubClouds using the CLI
*******************************************************************

.. toctree::
    :maxdepth: 1

    distributed-upgrade-orchestration-process-using-the-cli
    aborting-the-distributed-upgrade-orchestration
    configuration-for-specific-subclouds
    robust-error-handling-during-an-orchestrated-upgrade
    failure-prior-to-the-installation-of-n+1-load-on-a-subcloud
    failure-during-the-installation-or-data-migration-of-n+1-load-on-a-subcloud

--------
Appendix
--------

.. toctree::
    :maxdepth: 1
    :caption: Contents:

    distributed-cloud-ports-reference
    certificate-management-for-admin-rest-api-endpoints
