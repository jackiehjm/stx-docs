
.. nen1590589232375
.. _view-details-for-a-physical-volume:

==================================
View details for a Physical Volume
==================================

You can view details for a physical volume using the
:command:`system-host-pv-show` command.

.. rubric:: |context|

The syntax of the command is:

.. code-block:: none

    system host-pv-show <hostname> <uuid>

where:

**<hostname>**
    is the name or ID of the host.

**<uuid>**
    is the uuid of the physical volume.

For example, to view details for a physical volume on compute-1, do the
following:

.. code-block:: none

    ~(keystone_admin)$ system host-pv-show compute-1 9f93c549-e26c-4d4c-af71-fb84e3fcae63


