
.. pcs1565033493776
.. _create-or-change-the-size-of-nova-local-storage:

===================================================
Create or Change the Size of Nova-local Storage
===================================================

You must configure the storage resources on a host before you can unlock it. If
you prefer, you can use the |CLI|.

.. rubric:: |context|

You can use entire disks or disk partitions on compute hosts for use as
**nova-local** storage. You can add multiple disks or disk partitions. Once a
disk is added and configuration is persisted through a lock/unlock, the disk
can no longer be removed.

.. caution::

    If a root-disk partition on *any* compute host is used for local storage,
    then for performance reasons, *all* VMs on the system must be booted from
    Cinder volumes, and must not use ephemeral or swap disks. For more
    information, see :ref:`Storage on Compute Hosts
    <storage-on-compute-hosts>`.

.. rubric:: |proc|

#.  Lock the compute node.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock compute-0

#.  Log in to the active controller as the Keystone **admin** user.

#.  Review the available disk space and capacity.

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-list compute-0
        +--------------------------------------+--------------++--------------+
        | uuid                                 | device_node  | available_gib |  
        |                                      |              |               |  
        +--------------------------------------+--------------+---------------+
        | 5dcb3a0e-c677-4363-a030-58e245008504 | /dev/sda     | 12216         |
        | c2932691-1b46-4faf-b823-2911a9ecdb9b | /dev/sdb     | 20477         |
        +--------------------------------------+--------------+---------------+

#.  During initial set-up, add the **nova-local** local volume group.

    .. code-block:: none

        ~(keystone_admin)$ system host-lvg-add compute-0 nova-local
        +-----------------+------------------------------------------------------------+
        | Property        | Value                                                      |
        +-----------------+------------------------------------------------------------+
        | lvm_vg_name     | nova-local                                                 |
        | vg_state        | adding                                                     |
        | uuid            | 5b8f0792-25b5-4e43-8058-d274bf8fa51c                       |
        | ihost_uuid      | 327b2136-ffb6-4cd5-8fed-d2ec545302aa                       |
        | lvm_vg_access   | None                                                       |
        | lvm_max_lv      | 0                                                          |
        | lvm_cur_lv      | 0                                                          |
        | lvm_max_pv      | 0                                                          |
        | lvm_cur_pv      | 0                                                          |
        | lvm_vg_size_gb  | 0                                                          |
        | lvm_vg_total_pe | 0                                                          |
        | lvm_vg_free_pe  | 0                                                          |
        | created_at      | 2015-12-23T16:30:25.524251+00:00                           |
        | updated_at      | None                                                       |
        | parameters      | {u'instance_backing': u'lvm', u'instances_lv_size_mib': 0} |
        +-----------------+------------------------------------------------------------+
        

#.  Obtain the |UUID| of the disk or partition to use for **nova-local** storage.

    To obtain the |UUIDs| for available disks, use the :command:`system
    host-disk-list` command as shown earlier.

    To obtain the |UUIDs| for available partitions on a disk, use
    :command:`system host-disk-partition-list`.

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-partition-list compute-0 --disk <disk_uuid>

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-partition-list compute-0 --disk
        c2932691-1b46-4faf-b823-2911a9ecdb9b
        +--------------------------------------+-----------------------------+--------------+----------+----------------------+
        | uuid                                 | device_path                 | device_node  | size_gib | status               |
        |                                      |                             |              |          |                      |
        +--------------------------------------+-----------------------------+--------------+----------+----------------------+
        | 08fd8b75-a99e-4a8e-af6c-7aab2a601e68 | /dev/disk/by-path/pci-0000: |   /dev/sdb1  |   1024   | Creating (on unlock) |
        |                                      | 00:01.1-ata-1.1-part1       |              |          |                      |
        |                                      |                             |              |          |                      |
        |                                      |                             |              |          |                      |
        +--------------------------------------+-----------------------------+--------------+----------+----------------------+

#.  Create a partition to add to the volume group.

    If you plan on using an entire disk, you can skip this step.

    Do this using the :command:`host-disk-partition-add` command. The syntax is:

    .. code-block:: none

        system host-disk-partition-add [-t <partition_type>]
         <hostname_or_id> <disk_path_or_uuid>
        <partition_size_in_GiB>

    For example.

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-partition-add compute-0 \
        c2932691-1b46-4faf-b823-2911a9ecdb9b 1
        +-------------+--------------------------------------------------+
        | Property    | Value                                            |
        +-------------+--------------------------------------------------+
        | device_path | /dev/disk/by-path/pci-0000:00:01.1-ata-1.1-part1 |
        | device_node | /dev/sdb1                                        |
        | type_guid   | ba5eba11-0000-1111-2222-000000000001             |
        | type_name   | None                                             |
        | start_mib   | None                                             |
        | end_mib     | None                                             |
        | size_mib    | 1024                                             |
        | uuid        | 6a194050-2328-40af-b313-22dbfa6bab87             |
        | ihost_uuid  | 0acf8e83-e74c-486e-9df4-00ce1441a899             |
        | idisk_uuid  | c2932691-1b46-4faf-b823-2911a9ecdb9b             |
        | ipv_uuid    | None                                             |
        | status      | Creating (on unlock)                             |
        | created_at  | 2018-01-24T20:25:41.852388+00:00                 |
        | updated_at  | None                                             |
        +-------------+--------------------------------------------------+

#.  Obtain the |UUID| of the partition to use for **nova-local** storage as
    described in step
 
.. xbooklink :ref:`5 <creating-or-changing-the-size-of-nova-local-storage-uuid>`.

#.  Add a disk or partition to the **nova-local** group, using a command of the
    following form:

    .. note::
        The host must be locked

    .. code-block:: none

        ~(keystone_admin)$ system host-pv-add compute-0 nova-local <uuid>

    where <uuid> is the |UUID| of the disk or partition, obtained using
    :command:`system host-partition-list`, or of the disk, obtained using
    :command:`system host-disk-list`.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-pv-add compute-0 nova-local \
        08fd8b75-a99e-4a8e-af6c-7aab2a601e68
        +--------------------------+--------------------------------------------------+
        | Property                 | Value                                            |
        +--------------------------+--------------------------------------------------+
        | uuid                     | 8eea6ca7-5192-4ee0-bd7b-7d7fa7c637f1             |
        | pv_state                 | adding                                           |
        | pv_type                  | partition                                        |
        | disk_or_part_uuid        | 08fd8b75-a99e-4a8e-af6c-7aab2a601e68             |
        | disk_or_part_device_node | /dev/sdb1                                        |
        | disk_or_part_device_path | /dev/disk/by-path/pci-0000:00:01.1-ata-1.1-part1 |
        | lvm_pv_name              | /dev/sdb1                                        |
        | lvm_vg_name              | nova-local                                       |
        | lvm_pv_uuid              | None                                             |
        | lvm_pv_size_gib          | 0.0                                              |
        | lvm_pe_total             | 0                                                |
        | lvm_pe_alloced           | 0                                                |
        | ihost_uuid               | 0acf8e83-e74c-486e-9df4-00ce1441a899             |
        | created_at               | 2018-01-25T18:20:14.423947+00:00                 |
        | updated_at               | None                                             |
        +--------------------------+--------------------------------------------------+

    .. note::
        Multiple disks/partitions can be added to nova-local by repeating steps
        5-8, above.


