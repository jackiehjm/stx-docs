
.. fkg1558616822571
.. _installing-and-provisioning-the-central-cloud:

=======================================
Install and Provision the Central Cloud
=======================================

Installing the Central Cloud is similar to installing a standalone |prod|
system.

.. rubric:: |context|

The Central Cloud supports the following deployment configurations:

-  |AIO-DX| with 0 or more Worker Nodes deployment, see
   :ref:`All-in-one (AIO) Duplex Configuration <deployment-config-options-all-in-one-duplex-configuration>`

-  Standard with dedicated internal Storage Nodes and 1 or more Worker Nodes,
   see :ref:`Worker Function Performance Profiles <worker-function-performance-profiles>`

-  Standard with dedicated external Netapp Storage backend and 1 or more Worker
   Nodes, see
   :ref:`Standard Configuration with Dedicated Storage <standard-configuration-with-dedicated-storage>`

-  Standard with Controller Storage, see
   :ref:`Standard Configuration with Controller Storage <deployment-and-configuration-options-standard-configuration-with-controller-storage>`

.. rubric:: |proc|

Complete the |prod| procedure for your deployment scenario with the
modifications noted below.

.. include:: /_includes/installing-and-provisioning-the-central-cloud.rest
   :start-after: deployment-scenario-begin
   :end-before: deployment-scenario-end

-  When creating the user configuration overrides for the Ansible bootstrap
   playbook in ``/home/sysadmin/localhost.yml``

   -   Add the ``distributed_cloud_role`` parameter (as shown below) to your
       ``/home/sysadmin/localhost.yml`` Ansible bootstrap override file to
       indicate that this cloud will play the role of the Central Cloud /
       System Controller.

   -   Restrict the range of addresses for the management network (using
       ``management_start_address`` and ``management_end_address``, as shown below)
       to exclude the IP addresses reserved for gateway routers that provide
       routing to the subclouds' management subnets.

.. only:: starlingx

   -   Also, include the container images shown below in
       ``additional_local_registry_images``, required for support of subcloud
       installs with the Redfish Platform Management Service, and subcloud
       installs using a Ceph storage backend.

.. include:: /_includes/installing-and-provisioning-the-central-cloud.rest


where <X.Y.Z> are replaced with the correct values for your environment.
