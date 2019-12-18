============================
Prepare Host and Environment
============================

This section describes how to prepare the physical host and virtual environment
for a **StarlingX R4.0 virtual All-in-one Duplex** deployment configuration.

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

The following steps explain how to prepare the virtual environment and servers
on a physical host for a StarlingX R4.0 virtual All-in-one Duplex deployment
configuration.

#. Prepare virtual environment.

   Set up the virtual platform networks for virtual deployment:

   ::

     bash setup_network.sh

#. Prepare virtual servers.

   Create the XML definitions for the virtual servers required by this
   configuration option. This will create the XML virtual server definition for:

   * duplex-controller-0
   * duplex-controller-1

   The following command will start/virtually power on:

   * The 'duplex-controller-0' virtual server
   * The X-based graphical virt-manager application

   ::

     bash setup_configuration.sh -c duplex -i ./bootimage.iso

   If there is no X-server present errors will occur and the X-based GUI for the
   virt-manager application will not start. The virt-manager GUI is not absolutely
   required and you can safely ignore errors and continue.

