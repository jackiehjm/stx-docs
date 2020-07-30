============================
Prepare Host and Environment
============================

This section describes how to prepare the physical host and virtual environment
for a **StarlingX R5.0 virtual Standard with Controller Storage** deployment
configuration.

.. contents::
   :local:
   :depth: 1

------------------------------------
Physical host requirements and setup
------------------------------------

.. include:: physical_host_req.txt

---------------------------------------
Prepare virtual environment and servers
---------------------------------------

.. note::

    The following commands for host, virtual environment setup, and host
    power-on use KVM / virsh for virtual machine and VM management
    technology. For an alternative virtualization environment, see:
    :doc:`Install StarlingX in VirtualBox <install_virtualbox>`.

#. Prepare virtual environment.

   Set up virtual platform networks for virtual deployment:

   ::

     bash setup_network.sh

#. Prepare virtual servers.

   Create the XML definitions for the virtual servers required by this
   configuration option. This will create the XML virtual server definition for:

   * controllerstorage-controller-0
   * controllerstorage-controller-1
   * controllerstorage-worker-0
   * controllerstorage-worker-1

   The following command will start/virtually power on:

   * The 'controllerstorage-controller-0' virtual server
   * The X-based graphical virt-manager application

   ::

     bash setup_configuration.sh -c controllerstorage -i ./bootimage.iso

   If there is no X-server present errors will occur and the X-based GUI for the
   virt-manager application will not start. The virt-manager GUI is not absolutely
   required and you can safely ignore errors and continue.