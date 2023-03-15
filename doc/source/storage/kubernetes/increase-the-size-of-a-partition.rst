
.. gnn1590581447913
.. _increase-the-size-of-a-partition:

================================
Increase the Size of a Partition
================================

You can increase the size of a partition using the :command:`system
host-disk-partition-modify` command.

.. rubric:: |context|

You can modify only the last partition on a disk (indicated by **part** in the
device path; for example, /dev/disk/by-path/pci-0000:00:0d.0-ata-2.0-part6).

You cannot decrease the size of a partition.

The syntax for the command is:

.. code-block:: none

    system host-disk-partition-modify -s <size> <host> <partition>

where:

**<size>**
    is the new partition size in MiB.

**<host>**
    is the host name or ID.

**<partition>**
    is the partition device path or UUID.

#.  For example, to change the size of a partition on compute-1 to 726 MiB, do
    the following:

    .. code-block:: none

        ~(keystone_admin)]$ system host-disk-partition-modify -s 726 compute-1 a259e898-6390-44ba-a750-e0cb1579d8e0
        +-------------+--------------------------------------------------+
        | Property    | Value                                            |
        +-------------+--------------------------------------------------+
        | device_path | /dev/disk/by-path/pci-0000:00:0d.0-ata-2.0-part6 |
        | device_node | /dev/sdb6                                        |
        | type_guid   | ba5eba11-0000-1111-2222-000000000001             |
        | type_name   | LVM Physical Volume	                             |
        | start_mib   | 512                                              |
        | end_mib     | 12545                                            |
        | size_mib    | 726                                              |
        | uuid        | a259e898-6390-44ba-a750-e0cb1579d8e0             |
        | ihost_uuid  | 3b315241-d54f-499b-8566-a6ed7d2d6b39             |
        | idisk_uuid  | fcd2f59d-c9ee-4423-9f57-e2c55d5b97dc             |
        | ipv_uuid    | None                                             |
        | status      | Modifying                                        |
        | created_at  | 2017-09-08T19:10:27.506768+00:00                 |
        | updated_at  | 2017-09-08T19:15:06.016996+00:00                 |
        +-------------+--------------------------------------------------+


