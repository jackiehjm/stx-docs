
.. eiq1590580042262
.. _add-a-partition:

===============
Add a Partition
===============

You can add a partition using the :command:`system host-disk-partition-add`
command.

The syntax for the command is:

.. code-block:: none

    system host-disk-partition-add <host> <disk> <size>

where:

**<host>**
    is the host name or ID.

**<disk>**
    is the disk path or |UUID|.

**<size>**
    is the partition size in MiB.

.. rubric:: |proc|

For example, to set up a 512 MiB partition on compute-1, do the following:

.. code-block:: none

    ~(keystone_admin)$ system host-disk-partition-add  compute-1 fcd2f59d-c9ee-4423-9f57-e2c55d5b97dc 512
    +-------------+--------------------------------------------------+
    | Property    | Value                                            |
    +-------------+--------------------------------------------------+
    | device_path | /dev/disk/by-path/pci-0000:00:0d.0-ata-2.0-part6 |
    | device_node | /dev/sdb6                                        |
    | type_guid   | ba5eba11-0000-1111-2222-000000000001             |
    | type_name   | None                                             |
    | start_mib   | None                                             |
    | end_mib     | None                                             |
    | size_mib    | 512                                              |
    | uuid        | a259e898-6390-44ba-a750-e0cb1579d8e0             |
    | ihost_uuid  | 3b315241-d54f-499b-8566-a6ed7d2d6b39             |
    | idisk_uuid  | fcd2f59d-c9ee-4423-9f57-e2c55d5b97dc             |
    | ipv_uuid    | None                                             |
    | status      | Creating                                         |
    | created_at  | 2017-09-08T19:10:27.506768+00:00                 |
    | updated_at  | None                                             |
    +-------------+--------------------------------------------------+


