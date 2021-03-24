
.. hxb1590524383019
.. _list-partitions:

===============
List Partitions
===============

To list partitions, use the :command:`system host-disk-partition-list` command.

.. rubric:: |context|

The command has the following format:

.. code-block:: none

    system host-disk-partition-list [--nowrap] [--disk [disk_uuid]] <host>

<host> is the hostname or ID.

For example, run the following command to list the partitions on a compute-1
disk.

.. code-block:: none

    ~(keystone_admin)$ system host-disk-partition-list --disk 84b1ba35-addb-4fb7-9495-c47c3cb10377 compute-1
    +--------------------------------------+--------------------------------------+------------+--------------------------------------+-------------------+----------+--------+
    | uuid                                 | device_path                          | device_nod | type_guid                            | type_name         | size_gib | status |
    |                                      |                                      | e          |                                      |                   |          |        |
    +--------------------------------------+--------------------------------------+------------+--------------------------------------+-------------------+----------+--------+
    | 921c07dc-a79d-4104-a6a8-34691120514e | /dev/disk/by-path/pci-0000:04:00.0   | /dev/sda5  | ba5eba11-0000-1111-2222-000000000001 | LVM Physical      | 22.0     | In-Use |
    |                                      | -sas-0x5001e6768017d000-lun-0-part5  |            |                                      | Volume            |          |        |
    |                                      |                                      |            |                                      |                   |          |        |
    +--------------------------------------+--------------------------------------+------------+--------------------------------------+-------------------+----------+--------+


