.. _index-planning-kub-913bd621ac0f:

.. include:: /_includes/toc-title-planning-kub.rest

.. only:: partner

   .. include:: /planning/index-planning-332af0718d15.rst
      :start-after: kub-begin
      :end-before: kub-end

------------
Introduction
------------

.. toctree::
   :maxdepth: 1

   overview-of-starlingx-planning

****************
Network planning
****************

.. toctree::
   :maxdepth: 1

   network-requirements
   networks-for-a-simplex-system
   networks-for-a-duplex-system
   networks-for-a-system-with-controller-storage
   networks-for-a-system-with-dedicated-storage
   network-requirements-ip-support
   network-planning-the-pxe-boot-network
   the-cluster-host-network
   the-storage-network
   network-addressing-requirements-2fac0035b878

Internal management network
***************************

.. toctree::
   :maxdepth: 1

   the-internal-management-network
   internal-management-network-planning
   multicast-subnets-for-the-management-network

OAM network
***********

.. toctree::
   :maxdepth: 1

   about-the-oam-network
   oam-network-planning
   dns-and-ntp-servers
   network-planning-firewall-options

L2 access switches
******************

.. toctree::
   :maxdepth: 1

   l2-access-switches
   redundant-top-of-rack-switch-deployment-considerations

Ethernet interfaces
*******************

.. toctree::
   :maxdepth: 1

   about-ethernet-interfaces
   network-planning-ethernet-interface-configuration
   the-ethernet-mtu
   shared-vlan-or-multi-netted-ethernet-interfaces

****************
Storage planning
****************

.. toctree::
   :maxdepth: 1

   storage-planning-storage-resources
   storage-planning-storage-on-controller-hosts
   storage-planning-storage-on-worker-hosts
   storage-planning-storage-on-storage-hosts
   external-netapp-trident-storage

*****************
Security planning
*****************

.. toctree::
   :maxdepth: 1

   infrastructure-security
   container-security-df8a251ec03f

Security hardening Guidelines
*****************************

.. toctree::
   :maxdepth: 1

   security-hardening-intro

Recommended Security Features with a Minimal Performance Impact
---------------------------------------------------------------

.. toctree::
   :maxdepth: 1

   uefi-secure-boot

Secure System Accounts
----------------------

.. toctree::
   :maxdepth: 1

   local-linux-account-for-sysadmin
   local-and-ldap-linux-user-accounts
   starlingx-accounts
   web-administration-login-timeout
   ssh-and-console-login-timeout
   system-account-password-rules

Security Features
-----------------

.. toctree::
   :maxdepth: 1

   secure-https-external-connectivity
   security-hardening-firewall-options
   isolate-starlingx-internal-cloud-management-network

**********************************
Installation and resource planning
**********************************

.. toctree::
   :maxdepth: 1

   installation-and-resource-planning-https-access-planning
   starlingx-hardware-requirements
   verified-commercial-hardware
   starlingx-boot-sequence-considerations
   hard-drive-options
   controller-disk-configurations-for-all-in-one-systems
