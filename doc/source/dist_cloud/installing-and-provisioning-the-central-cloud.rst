
.. fkg1558616822571
.. _installing-and-provisioning-the-central-cloud:

=======================================
Install and Provision the Central Cloud
=======================================

Installing the Central Cloud is similar to installing a standalone |prod|
system.

.. rubric:: |context|

The Central Cloud supports either:

-  |AIO-DX| deployment

-  Standard with dedicated Storage Nodes deployment

-  Standard with Controller Storage deployment, or

-  Standard with Dedicated Storage Nodes deployment

A Standard System Controller with Controller Storage is not supported.

.. rubric:: |proc|

Complete the |prod| procedure for your deployment scenario with the
modifications noted above and below.

   .. include:: ../_includes/installing-and-provisioning-the-central-cloud.rest
      :start-after: deployment-scenario-begin
      :end-before: deployment-scenario-end

You will also need to make the following modifications:

-  when creating the user configuration overrides for the Ansible bootstrap
   playbook in /home/sysadmin/localhost.yml

   -   Add the parameters shown in bold below to your /home/sysadmin/localhost.yml
       Ansible bootstrap override file to indicate that this cloud will play
       the role of the Central Cloud / System Controller.

-  restrict the range of addresses for the management network (using
   management_start_address and management_end_address, as shown below) to
   exclude the IP addresses reserved for gateway routers that provide routing
   to the subclouds' management subnets.

-  Also, include the container images shown in bold below in
   additional\_local\_registry\_images, required for support of subcloud
   installs with the Redfish Platform Management Service, and subcloud installs
   using a Ceph storage backend.

.. include:: ../_includes/installing-and-provisioning-the-central-cloud.rest


where <X.Y.Z> are replaced with the correct values for your environment.
