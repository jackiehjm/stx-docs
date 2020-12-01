
.. cdw1590589749382
.. _delete-a-physical-volume:

========================
Delete a Physical Volume
========================

You can delete a physical volume using the :command:`system-host-pv-delete`
command.

.. rubric:: |prereq|


.. _deleting-a-physical-volume-ul-zln-ssc-vlb:

-   You must lock a host before you can modify its settings.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock <hostname>

-   A suitable local volume group must exist on the host. For more
    information, see :ref:`Work with Physical Volumes
    <work-with-physical-volumes>`.

-   An unused disk or partition must be available on the host. For more
    information about partitions, see :ref:`Work with Disk Partitions
    <work-with-disk-partitions>`.


.. rubric:: |context|

The syntax of the command is:

.. code-block:: none

    system host-pv-delete <hostname> <uuid>

where:

**<hostname>**
    is the name or ID of the host.

**<uuid>**
    is the uuid of the physical volume.

For example, to delete a physical volume from compute-1, use the following
command.

.. code-block:: none

    ~(keystone_admin)$ system host-pv-delete compute-1 9f93c549-e26c-4d4c-af71-fb84e3fcae63


