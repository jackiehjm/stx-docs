==================
R3.0 Release Notes
==================

.. contents::
   :local:
   :depth: 1

---------
ISO image
---------

You can find a pre-built ISO and Docker images for StarlingX release 3.0 at
`CENGN’s StarlingX mirror
<http://mirror.starlingx.cengn.ca/mirror/starlingx/release/3.0.0/centos/>`_.

------
Branch
------

The source code for StarlingX release 3.0 is available in the r/stx.3.0 branch
in the StarlingX Git repositories.

----------
Deployment
----------

A system install is required to deploy the StarlingX release 3.0. There is no
upgrade path from previous StarlingX releases.

-----------------------------
New features and enhancements
-----------------------------

The list below provides a detailed list of features with the associated
StoryBoard entries for the features.

* Infrastructure and Cluster Monitoring

  `2005733 <https://storyboard.openstack.org/#!/story/2005733>`_

* Integrate with Openstack Train

  `2006544 <https://storyboard.openstack.org/#!/story/2006544>`_

* Integrate Distributed Cloud with containers

  `2004766 <https://storyboard.openstack.org/#!/story/2004766>`_

* Integrate Backup & Restore with containers

  `2004761 <https://storyboard.openstack.org/#!/story/2004761>`_

* Intel FPGA K8s Device Plugin Initial Integration

  `2006495 <https://storyboard.openstack.org/#!/story/2006495>`_

* Intel GPU K8s Device Plugin Integration

  `2005937 <https://storyboard.openstack.org/#!/story/2005937>`_

* Intel QAT K8s Device Plugin Integration

  `2005514 <https://storyboard.openstack.org/#!/story/2005514>`_

* Layered Build Prep

  `2006166 <https://storyboard.openstack.org/#!/story/2006166>`_

* Redfish Integration

  `2005861 <https://storyboard.openstack.org/#!/story/2005861>`_

* Support for authenticated registry for bootstrap and application apply

  `2006274 <https://storyboard.openstack.org/#!/story/2006274>`_

* Support for OpenID connet authentication parameters for bootstrap

  `2006235 <https://storyboard.openstack.org/#!/story/2006235>`_

* Support for floating and pinned workloads on worker nodes

  `2006565 <https://storyboard.openstack.org/#!/story/2006565>`_

* Support for NTP and PTP co-existence

  `2006499 <https://storyboard.openstack.org/#!/story/2006499>`_

* Time Sensitive Networking for VMs

  `2005516 <https://storyboard.openstack.org/#!/story/2005516>`_

* Upversion container components

  `2005860, <https://storyboard.openstack.org/#!/story/2005860>`_

  `2006347 <https://storyboard.openstack.org/#!/story/2006347>`_

-------------------------
Known limitations in R3.0
-------------------------

The following are known limitations in the StarlingX R3.0 release. Workarounds
are suggested where applicable. Note that these limitations are considered
temporary and will likely be resolved in a future release.

********************************
Changing Keystone admin password
********************************

After the Keystone admin password is changed, kube-system namespace registry
secrets must be manually updated.
Tracking Launchpad: https://bugs.launchpad.net/starlingx/+bug/1853017

It is recommended that the Keystone admin password not be changed unless necessary.

**Workaround:** If you must update the WRCP's Keystone admin user password in R3.0,
you must also manually update the kube-system namespace's registry secrets that
hold the admin password for image pulls:

#. Update the WRCP Keystone admin user password:

   ::

     openstack user set --password newP@ssw0rd admin

#. Update the kube-system namespace's `registry-local-secret` secret:

   ::

     kubectl -n kube-system create secret docker-registry registry-local-secret --docker-server=registry.local:9001 --docker-username=admin --docker-password=newP@ssw0rd -o yaml --dry-run=true > registry-local-secret-update.yaml
     kubectl -n kube-system replace secret registry-local-secret -f registry-local-secret-update.yaml

#. Update the kube-system namespace's `default-registry-key` secret:

   ::

     kubectl -n kube-system create secret docker-registry default-registry-key --docker-server=registry.local:9001 --docker-username=admin --docker-password=newP@ssw0rd -o yaml --dry-run=true > default-registry-key-update.yaml
     kubectl -n kube-system replace secret default-registry-key -f default-registry-key-update.yaml

In a distributed cloud deployment, the registry secrets must also be updated on
all subclouds in the system.


