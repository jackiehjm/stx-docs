
.. hxb1590524383019
.. _list-partitions:

===============
List Partitions
===============

To list partitions, use the :command:`system host-disk-partition-list`
command.

.. rubric:: |context|

The command has the following format:

.. code-block:: none

    system host-disk-partition-list [--nowrap] [--disk [disk_uuid]] <host>

where:

**<host>**
    is the hostname or ID.

For example, run the following command to list the partitions on a
compute-1 disk.

.. code-block:: none

    ~(keystone_admin)$ system host-disk-partition-list --disk fcd2f59d-c9ee-4423-9f57-e2c55d5b97dc compute-1
    +------...+------------------+-------------+...+----------+--------+
    | uuid    | device_path      | device_node |   | size_mib | status |
    +------...+------------------+-------------+...+----------+--------+
    | 15943...| ...ata-2.0-part1 | /dev/sdb1   |...| 1024     | In-Use |
    | 63440...| ...ata-2.0-part2 | /dev/sdb2   |...| 10240    | In-Use |
    | a4aa3...| ...ata-2.0-part3 | /dev/sdb3   |...| 10240    | In-Use |
    +------...+------------------+-------------+...+----------+--------+


