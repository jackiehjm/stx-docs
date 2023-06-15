.. _index-install-r7-8966076f0e81:

==================================
Development StarlingX Installation
==================================

.. note::

   This installation guide is for the upcoming release of |prod|, and may not
   work due to pre-release inconsistencies between documentation and code.

   To install the most recent released verion of |prod|, see:
   https://docs.starlingx.io/r/stx.7.0/deploy_install_guides/r7_release/index-install-r7-8966076f0e81.html

StarlingX provides a pre-defined set of standard :doc:`deployment
configurations </introduction/deploy_options>`. Most deployment options may be
installed in a virtual environment or on bare metal.

-----------------------------------------------------
Install StarlingX Kubernetes in a virtual environment
-----------------------------------------------------

.. toctree::
   :maxdepth: 1

   virtual/automated_install
   virtual/aio_simplex
   virtual/aio_duplex
   virtual/controller_storage
   virtual/dedicated_storage
   virtual/rook_storage

.. toctree::
   :hidden:

   virtual/config_virtualbox_netwk
   virtual/install_virtualbox

------------------------------------------
Install StarlingX Kubernetes on bare metal
------------------------------------------

.. toctree::
   :maxdepth: 1

   bare_metal/aio_simplex_install_kubernetes
   bare_metal/aio_duplex_install_kubernetes
   bare_metal/controller_storage_install_kubernetes
   bare_metal/rook_storage_install_kubernetes
   bare_metal/dedicated_storage_install_kubernetes
   bare_metal/ironic_install

-----------------
Access Kubernetes
-----------------

.. toctree::
   :maxdepth: 1

   kubernetes_access

--------------------------------------
Install and Access StarlingX OpenStack
--------------------------------------

.. toctree::
   :maxdepth: 1

   openstack/index-install-r7-os-adc44604968c

---------------------------------------
Install Distributed Cloud on Bare metal
---------------------------------------

.. toctree::
   :maxdepth: 1

   /dist_cloud/index-dist-cloud-f5dbeb16b976


**********
Appendixes
**********


.. _use-private-docker-registry-r7:

Use a private Docker registry
*****************************

.. toctree::
   :maxdepth: 1

   bare_metal/bootstrapping-from-a-private-docker-registry

Set up a Simple DNS Server in Lab
*********************************

.. toctree::
   :maxdepth: 1

   setup-simple-dns-server-in-lab

Install controller-0 from a PXE boot server
*******************************************

.. toctree::
   :maxdepth: 1

   bare_metal/pxe-boot-controller-0-d5da025c2524


Add and reinstall a host
************************

.. toctree::
   :maxdepth: 1

   bare_metal/adding-hosts-using-the-host-add-command
   bare_metal/delete-hosts-using-the-host-delete-command-1729d2e3153b


Add hosts in bulk
,,,,,,,,,,,,,,,,,

.. toctree::
   :maxdepth: 1

   bare_metal/adding-hosts-in-bulk
   bare_metal/bulk-host-xml-file-format

Reinstall a system or a host
,,,,,,,,,,,,,,,,,,,,,,,,,,,,

.. toctree::
   :maxdepth: 1

   bare_metal/reinstalling-a-system-or-a-host
   bare_metal/reinstalling-a-system-using-an-exported-host-configuration-file
   bare_metal/exporting-host-configurations

.. toctree::
   :hidden:

   ansible_bootstrap_configs

