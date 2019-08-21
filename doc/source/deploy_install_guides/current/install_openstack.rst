=================
Install OpenStack
=================

.. contents::
   :local:
   :depth: 1

These installation instructions assume that you have completed the following
OpenStack-specific configuration tasks that are required by the underlying
StarlingX Kubernetes platform:

* All nodes have been labelled appropriately for their OpenStack role(s).
* The vSwitch type has been configured.
* The nova-local volume group has been configured on any node's host, if running
  the compute function.

--------------------------------------------
Install application manifest and helm-charts
--------------------------------------------

#. Get the StarlingX OpenStack application (stx-openstack) manifest and helm-charts.
   This can be from a private StarlingX build or, as shown below, from the public
   Cengen StarlingX build off ``master`` branch:

   ::

   	wget http://mirror.starlingx.cengn.ca/mirror/starlingx/release/2.0.0/centos/outputs/helm-charts/stx-openstack-1.0-17-centos-stable-latest.tgz

#. Load the stx-openstack application's helm chart definitions into Starlingx:

   ::

   	system application-upload stx-openstack-1.0-17-centos-stable-latest.tgz

   This will:

   * Load the helm charts.
   * Internally manage helm chart override values for each chart.
   * Automatically generate system helm chart overrides for each chart based on
     the current state of the underlying StarlingX Kubernetes platform and the
     recommended StarlingX configuration of OpenStack services.

#. Apply the stx-openstack application in order to bring StarlingX OpenStack into
   service.

   ::

   	system application-apply stx-openstack

#. Wait for the activation of stx-openstack to complete.

   This can take 5-10 minutes depending on the performance of your host machine.

   Monitor progress with the command:

   ::

   	watch -n 5 system application-list

   When it completes, your OpenStack cloud is up and running.

--------------------------
Access StarlingX OpenStack
--------------------------

.. include:: virtual_aio_simplex.rst
   :start-after: incl-access-starlingx-openstack-start:
   :end-before: incl-access-starlingx-openstack-end:
