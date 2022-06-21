.. _index-sysconf-kub-78f0e1e9ca5a:

.. include:: /_includes/toc-title-sys-conf-kub.rest

.. only:: partner

   .. include:: /system_configuration/index-sysconf-d511820651f0.rst
      :start-after: kub-begin
      :end-before: kub-end

----------------------
Timezone Configuration
----------------------

.. toctree::
   :maxdepth: 2

   changing-the-timezone-configuration

------------------------
DNS Server Configuration
------------------------

.. toctree::
   :maxdepth: 2

   specifying-dns-servers-using-horizon
   specifying-dns-servers-using-the-cli


------------------------
NTP Server Configuration
------------------------

.. toctree::
   :maxdepth: 2

   configuring-ntp-servers-and-services-using-horizon
   configuring-ntp-servers-and-services-using-the-cli
   resynchronizing-a-host-to-the-ntp-server

.. _ptp-server-config-index:

------------------------
PTP Server Configuration
------------------------

.. toctree::
   :maxdepth: 2

   ptp-introduction-d981dd710bda
   ptp-limitations-64338c74b415
   configuring-ptp-service-using-the-cli
   ptp-interfaces-df73e9b43677
   instance-specific-considerations-d9d9509c79dd
   remove-ptp-configurations-4885c027dfa5
   advanced-ptp-configuration-334a08dc50fb
   ptp-instance-examples-517dce312f56
   ptp-instance-troubleshooting-7a7c576ee57a


----------------------
GNSS and SyncE Support
----------------------


.. toctree::
   :maxdepth: 2

   gnss-and-synce-support-62004dc97f3e


--------------------
OAM IP Configuration
--------------------

.. toctree::
   :maxdepth: 2

   changing-the-oam-ip-configuration-using-horizon
   changing-the-oam-ip-configuration-using-the-cli
   changing-the-mtu-of-an-oam-interface-using-horizon
   changing-the-mtu-of-an-oam-interface-using-the-cli

----------------------
collectd Configuration
----------------------

.. toctree::
   :maxdepth: 2

   configure-collectd-to-store-host-performance-data-caf7802851bc



----------------------
Application Management
----------------------

.. toctree::
   :maxdepth: 2

   system-config-helm-package-manager
   system-configuration-starlingx-application-package-manager
   application-commands-and-helm-overrides

----------------------------------------
Direct vs Switch-Based AIO Configuration
----------------------------------------

.. toctree::
   :maxdepth: 2

   converting-a-duplex-system-to-direct-connection
   converting-a-duplex-system-to-switch-based-connection

--------------------------
Customize Horizon Branding
--------------------------

.. toctree::
   :maxdepth: 2

   creating-a-custom-branding-tarball
   applying-a-custom-branding-tarball-to-newly-installed-systems
   applying-a-custom-branding-tarball-to-running-systems

-------------------------------
Customize Login Banner Branding
-------------------------------

.. toctree::
   :maxdepth: 2

   branding-the-login-banner-during-commissioning
   branding-the-login-banner-on-a-commissioned-system

------------------------
Console Keyboard Mapping
------------------------

.. toctree::
   :maxdepth: 2

   console-keyboard-mapping

------------------------
Kubernetes Configuration
------------------------

.. toctree::
   :maxdepth: 2

   kubernetes-custom-configuration-31c1fd41857d
   limit-number-of-processes-per-pod
   about-changing-external-registries-for-starlingx-installation

*************************************
Apply Registries' Auth-Secret Changes
*************************************

.. toctree::
   :maxdepth: 1

   change-the-registry-url
   validate-existing-registry-and-new-url
   create-the-registry-secrets
   update-the-registry-secrets
   verify-the-registry-secret-changes-and-secret-key-in-system-database
   add-the-ca-certificate-for-new-registry
   check-new-registry-and-reapply-application

--------------------
Customize Core Dumps
--------------------

.. toctree::
   :maxdepth: 1


   change-the-default-coredump-configuration-51ff4ce0c9ae
