====================
System Configuration
====================

--------------------
StarlingX Kubernetes
--------------------

**************************
System Management Overview
**************************

.. toctree::
   :maxdepth: 2

   system-configuration-management-overview

**********************
Timezone Configuration
**********************

.. toctree::
   :maxdepth: 2

   changing-the-timezone-configuration

************************
DNS Server Configuration
************************

.. toctree::
   :maxdepth: 2

   specifying-dns-servers-using-horizon
   specifying-dns-servers-using-the-cli


************************
NTP Server Configuration
************************

.. toctree::
   :maxdepth: 2

   configuring-ntp-servers-and-services-using-horizon
   configuring-ntp-servers-and-services-using-the-cli
   resynchronizing-a-host-to-the-ntp-server

************************
PTP Server Configuration
************************

.. toctree::
   :maxdepth: 2

   configuring-ptp-service-using-horizon
   configuring-ptp-service-using-the-cli

********************
OAM IP Configuration
********************

.. toctree::
   :maxdepth: 2

   changing-the-oam-ip-configuration-using-horizon
   changing-the-oam-ip-configuration-using-the-cli
   modifying-oam-firewall-rules
   changing-the-mtu-of-an-oam-interface-using-horizon
   changing-the-mtu-of-an-oam-interface-using-the-cli

**********************
Application Management
**********************

.. toctree::
   :maxdepth: 2

   system-config-helm-package-manager
   system-configuration-starlingx-application-package-manager
   application-commands-and-helm-overrides

****************************************
Direct vs Switch-Based AIO Configuration
****************************************

.. toctree::
   :maxdepth: 2

   converting-a-duplex-system-to-direct-connection
   converting-a-duplex-system-to-switch-based-connection

**************************
Customize Horizon Branding
**************************

.. toctree::
   :maxdepth: 2

   creating-a-custom-branding-tarball
   applying-a-custom-branding-tarball-to-newly-installed-systems
   applying-a-custom-branding-tarball-to-running-systems

*******************************
Customize Login Banner Branding
*******************************

.. toctree::
   :maxdepth: 2

   branding-the-login-banner-during-commissioning
   branding-the-login-banner-on-a-commissioned-system

************************
Console Keyboard Mapping
************************

.. toctree::
   :maxdepth: 2

   console-keyboard-mapping


-------------------
StarlingX OpenStack
-------------------

*******************************************************
Configure OpenStack Services Using Helm Chart Overrides
*******************************************************

.. toctree::
   :maxdepth: 1

   system-configuration-overview
   creating-optional-telemetry-services
   configuring-a-live-migration-completion-timeout-in-nova
   configuring-a-pci-alias-in-nova
   configuring-the-rpc-response-timeout-in-cinder
   enabling-the-qos-extension-for-neutron
   enabling-the-trunk-extension-for-neutron
   using-helm-overrides-to-enable-internal-dns
   adding-configuration-rpc-response-max-timeout-in-neutron-conf
   assigning-a-dedicated-vlan-id-to-a-target-project-network
