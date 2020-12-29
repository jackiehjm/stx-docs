.. Planning file, created by
   sphinx-quickstart on Thu Sep  3 15:14:59 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

========
Planning
========

----------
Kubernetes
----------

************
Introduction
************

.. toctree::
   :maxdepth: 1

   kubernetes/overview-of-starlingx-planning

****************
Network planning
****************

.. toctree::
   :maxdepth: 1

   kubernetes/network-requirements
   kubernetes/networks-for-a-simplex-system
   kubernetes/networks-for-a-duplex-system
   kubernetes/networks-for-a-system-with-controller-storage
   kubernetes/networks-for-a-system-with-dedicated-storage
   kubernetes/network-requirements-ip-support
   kubernetes/network-planning-the-pxe-boot-network
   kubernetes/the-cluster-host-network
   kubernetes/the-storage-network

Internal management network
***************************

.. toctree::
   :maxdepth: 1

   kubernetes/the-internal-management-network
   kubernetes/internal-management-network-planning
   kubernetes/multicast-subnets-for-the-management-network

OAM network
***********

.. toctree::
   :maxdepth: 1

   kubernetes/about-the-oam-network
   kubernetes/oam-network-planning
   kubernetes/dns-and-ntp-servers
   kubernetes/network-planning-firewall-options

L2 access switches
******************

.. toctree::
   :maxdepth: 1

   kubernetes/l2-access-switches
   kubernetes/redundant-top-of-rack-switch-deployment-considerations

Ethernet interfaces
*******************

.. toctree::
   :maxdepth: 1

   kubernetes/about-ethernet-interfaces
   kubernetes/network-planning-ethernet-interface-configuration
   kubernetes/the-ethernet-mtu
   kubernetes/shared-vlan-or-multi-netted-ethernet-interfaces

****************
Storage planning
****************

.. toctree::
   :maxdepth: 1

   kubernetes/storage-planning-storage-resources
   kubernetes/storage-planning-storage-on-controller-hosts
   kubernetes/storage-planning-storage-on-worker-hosts
   kubernetes/storage-planning-storage-on-storage-hosts
   kubernetes/external-netapp-trident-storage

*****************
Security planning
*****************

.. toctree::
   :maxdepth: 1

   kubernetes/security-planning-uefi-secure-boot-planning
   kubernetes/tpm-planning

**********************************
Installation and resource planning
**********************************

.. toctree::
   :maxdepth: 1

   kubernetes/installation-and-resource-planning-https-access-planning
   kubernetes/starlingx-hardware-requirements
   kubernetes/verified-commercial-hardware
   kubernetes/starlingx-boot-sequence-considerations
   kubernetes/hard-drive-options
   kubernetes/controller-disk-configurations-for-all-in-one-systems

---------
OpenStack
---------

Coming soon.