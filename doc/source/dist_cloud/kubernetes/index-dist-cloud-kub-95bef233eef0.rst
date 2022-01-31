.. _index-dist-cloud-kub-95bef233eef0:


.. include:: /_includes/toc-title-dc-kub.rest

.. only:: partner

   .. include:: /dist_cloud/index-dist-cloud-f5dbeb16b976.rst
      :start-after: kub-begin
      :end-before: kub-end

------------
Introduction
------------

.. toctree::
    :maxdepth: 1

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

    installing-and-provisioning-the-central-cloud
    installing-and-provisioning-a-subcloud
    installing-a-subcloud-using-redfish-platform-management-service
    installing-a-subcloud-without-redfish-platform-management-service
    reinstalling-a-subcloud-with-redfish-platform-management-service
    subcloud-deployment-with-local-installation-4982449058d5

---------
Operation
---------

.. toctree::
    :maxdepth: 1

    monitoring-subclouds-using-horizon
    managing-subclouds-using-the-cli
    switching-to-a-subcloud-from-the-system-controller
    synchronization-monitoring-and-control
    cli-commands-for-dc-alarms-management
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

    managing-subcloud-groups
    creating-subcloud-groups
    create-subcloud-groups-using-the-horizon-web-interface-69d357303531
    edit-subcloud-groups-85232c3a7d33
    delete-subcloud-groups-22a7c65e66d7
    ochestration-strategy-using-subcloud-groups

-------------------------
Update (Patch) management
-------------------------

.. toctree::
   :maxdepth: 1

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

   device-image-update-orchestration

--------------------------------------------------------------------
Configure Kubernetes Version Upgrade Distributed Cloud Orchestration
--------------------------------------------------------------------

.. toctree::
    :maxdepth: 1

    the-kubernetes-distributed-cloud-update-orchestration-process
    configuring-kubernetes-update-orchestration-on-distributed-cloud

---------------------------------------------------------
Kubernetes Root CA Update Distributed Cloud Orchestration
---------------------------------------------------------

.. toctree::
    :maxdepth: 1

    orchestration-commands-for-dcmanager-4947f9fb9588

------------------
Upgrade management
------------------

.. toctree::
    :maxdepth: 1

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

    distributed-cloud-ports-reference
    certificate-management-for-admin-rest-api-endpoints

