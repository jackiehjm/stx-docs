
.. lle1590587515952
.. _add-a-physical-volume:

=====================
Add a Physical Volume
=====================

You can add a physical volume using the :command:`system host-pv-add` command.

.. rubric:: |prereq|


.. _add-a-physical-volume-ul-zln-ssc-vlb:

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

The command syntax is:

.. code-block:: none

    system host-pv-add <hostname> <groupname> <uuid>

where:

**<hostname>**
    is the host name or ID.

**<groupname>**
    is the name of the local volume group to include the physical volume.

**<uuid>**
    is the identifier of the disk or partition to use.

You can specify the device node or the device path.

On a compute host with a single disk, you must assign a partition on
the root disk for **nova-local** storage. This is required to support
some small **nova-local** files. The host must not be used for VM local
ephemeral storage.

On a compute host with more than one disk, it is possible to create a
partition on the root disk for use as **nova-local** storage. However,
for performance reasons, you must either use a non-root disk for
**nova-local** storage, or ensure that the host is not used for VMs
with ephemeral local storage.

For example, to add a volume with the UUID
67b368ab-626a-4168-9b2a-d1d239d4f3b0 to compute-1, use the following command.

.. code-block:: none

    ~(keystone_admin)$ system host-pv-add compute-1 nova-local 67b368ab-626a-4168-9b2a-d1d239d4f3b0
    +--------------------------+--------------------------------------------------+
    | Property                 | Value                                            |
    +--------------------------+--------------------------------------------------+
    | uuid                     | 1145ac0b-5be1-416c-a080-581fa95fce77             |
    | pv_state                 | adding                                           |
    | pv_type                  | partition                                        |
    | disk_or_part_uuid        | 67b368ab-626a-4168-9b2a-d1d239d4f3b0             |
    | disk_or_part_device_node | /dev/sdb5                                        |
    | disk_or_part_device_path | /dev/disk/by-path/pci-0000:00:0d.0-ata-2.0-part5 |
    | lvm_pv_name              | /dev/sdb5                                        |
    | lvm_vg_name              | nova-local                                       |
    | lvm_pv_uuid              | None                                             |
    | lvm_pv_size              | 0                                                |
    | lvm_pe_total             | 0                                                |
    | lvm_pe_alloced           | 0                                                |
    | ihost_uuid               | 3b315241-d54f-499b-8566-a6ed7d2d6b39             |
    | created_at               | 2017-09-08T21:14:00.217360+00:00                 |
    | updated_at               | None                                             |
    +--------------------------+--------------------------------------------------+


