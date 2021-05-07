
.. wuh1552927822054
.. _reinstalling-a-system-using-an-exported-host-configuration-file:

============================================================
Reinstall a System Using an Exported Host Configuration File
============================================================

You can reinstall a system using the host configuration file that is generated
using the :command:`host-bulk-export` command.

.. rubric:: |prereq|

For the following procedure, **controller-0** must be the active controller.

.. rubric:: |proc|

#.  Create a host configuration file using the :command:`system
    host-bulk-export` command, as described in :ref:`Exporting Host
    Configurations <exporting-host-configurations>`.

#.  Copy the host configuration file to a USB drive or somewhere off the
    controller hard disk.

#.  Edit the host configuration file as needed, for example to specify power-on
    or |BMC| information.

#.  Delete all the hosts except **controller-0** from the inventory.

#.  Reinstall the |prod| software on **controller-0**, which must be the active
    controller.

#.  Run :command:`Ansible Bootstrap playbook`.

#.  Follow the instructions for using the :command:`system host-bulk-add`
    command, as detailed in :ref:`Adding Hosts in Bulk <adding-hosts-in-bulk>`.

.. rubric:: |postreq|

After adding the host, you must provision it according to the requirements of
the personality. 

.. xbooklink For more information, see :ref:`Installing, Configuring, and
   Unlocking Nodes <installing-configuring-and-unlocking-nodes>`, for your system,
   and follow the *Configure* steps for the appropriate node personality.
