===========================
StarlingX R5.0 Installation
===========================

StarlingX provides a pre-defined set of standard
:doc:`deployment configurations </introduction/deploy_options>`. Most deployment options may
be installed in a virtual environment or on bare metal.

-----------------------------------------------------
Install StarlingX Kubernetes in a virtual environment
-----------------------------------------------------

.. toctree::
   :maxdepth: 1

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

   bare_metal/aio_simplex
   bare_metal/aio_duplex
   bare_metal/controller_storage
   bare_metal/dedicated_storage
   bare_metal/ironic
   bare_metal/rook_storage

**********
Appendixes
**********


.. _use-private-docker-registry:

Use a private Docker registry
*****************************

.. toctree::
   :maxdepth: 1

   bare_metal/bootstrapping-from-a-private-docker-registry


Install controller-0 from a PXE boot server
*******************************************

.. toctree::
   :maxdepth: 1

   bare_metal/configuring-a-pxe-boot-server
   bare_metal/accessing-pxe-boot-server-files-for-a-custom-configuration


Add and reinstall a host
************************

.. toctree::
   :maxdepth: 1

   bare_metal/adding-hosts-using-the-host-add-command


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

-------------------------------------------------
Install StarlingX Distributed Cloud on bare metal
-------------------------------------------------

.. toctree::
   :maxdepth: 1

   distributed_cloud/index

-----------------
Access Kubernetes
-----------------

.. toctree::
   :maxdepth: 1

   kubernetes_access

--------------------------
Access StarlingX OpenStack
--------------------------

.. toctree::
   :maxdepth: 1

   openstack/index

